//
//  ProjectBuilder.swift
//  helpgen
//
//  Created by Franck Brun on 27/06/2022.
//

import Foundation
import System

class ProjectBuilder<S: StorageWrapper> {
  
  let project: Project
  let storage: S
  
  init(project: Project, storage: S) {
    self.project = project
    self.storage = storage
  }
  
  func execute(buildSteps: [BuildStep]) throws {
    for buildStep in buildSteps {
      try buildStep.exec()
    }
  }
  
}

extension ProjectBuilder {
  
  func create(at projectFolderPath: FilePath) throws {
    try createFolders()
    try createFiles()
  }
  
}

extension ProjectBuilder {
  
  enum BuildError: Error {
    case generalError
  }
  
  func build(at projectFolderPath: FilePath) throws {
    includeFiles()
    try createFolders(overwrite: true)
    try parseSourceFiles()
    try createFiles()
    try buildHelpFilesForAllLanguages()
    try copyAssets()
  }
  
}

extension ProjectBuilder {
  
  /// Include all sources files in project
  func includeFiles() {
    let url = URL(fileURLWithPath: self.project.inputFolder.string)
    let resourceKeys = Set<URLResourceKey>([.nameKey, .isDirectoryKey])
    let enumerator = FileManager.default.enumerator(at: url,
                                                    includingPropertiesForKeys: Array(resourceKeys),
                                                    options: [.skipsHiddenFiles, .skipsSubdirectoryDescendants])
    guard let enumerator = enumerator else {
      return
    }

    for case let fileURL as URL in enumerator {
      guard let resourceValues = try? fileURL.resourceValues(forKeys: resourceKeys),
            let isDirectory = resourceValues.isDirectory,
            let name = resourceValues.name
      else {
        continue
      }

      if isDirectory {
        if name.hasPrefix("_") {
          enumerator.skipDescendants()
        }
      } else {
        project.helpSourceFiles.append(HelpSourceFile(path: self.project.inputFolder.appending(name)))
      }
    }
  }
  
  func createFolders(overwrite: Bool = false) throws {
    let createFoldersOptions: CreateFolderBuildOptions = overwrite ? [] : [.throwIfExists]
    var buildSteps: [BuildStep] = [
      CreateFolderBuildStep(FilePath(Constants.ResourcesPathString),
                            options: createFoldersOptions,
                            storage: self.storage)
    ]
    
    for lang in self.project.languages {
      // TODO: Check language
      let langFolderPath = FilePath("\(Constants.ResourcesPathString)/\(lang).\(Constants.LanguageProjectExtension)")
      buildSteps.append(CreateFolderBuildStep(langFolderPath, options: [], storage: self.storage))
    }
    try execute(buildSteps: buildSteps)
  }
  
  func createFiles() throws {
    let buildSteps: [BuildStep] = [
      CreatePkgInfoFileBuildStep(storage: self.storage),
      CreateHelpBookPlistBuildStep(project: self.project, storage: self.storage),
    ]
            
    try execute(buildSteps: buildSteps)
  }
  
  func parseSourceFiles() throws {
    var buildSteps = [BuildStep]()
    
    for helpFile in self.project.helpSourceFiles {
      let fileBuildSteps: [BuildStep] = [
        ParseHelpSourceFileStep(helpFile),
        GetProjectPropertiesStep(project: self.project, source: helpFile)
      ]
      
      buildSteps.append(contentsOf: fileBuildSteps)
    }

    try execute(buildSteps: buildSteps)
  }
  
  func buildHelpFilesForAllLanguages() throws {
    if project.languages.count > 0 {
      for lang in project.languages {
        project.currentLanguage = lang
        try buildHelpFiles()
      }
      project.currentLanguage = ""
    } else {
      try buildHelpFiles()
    }
  }
  
  func buildHelpFiles() throws {
    for helpSourceFile in self.project.helpSourceFiles {
      if let outputProperty = helpSourceFile.property(named: Constants.OutputKey) {
        if let output = Bool(outputProperty.value(forLanguage: self.project.currentLanguage)), !output {
          logi("no output file '\(helpSourceFile.filePath.string)'")
          continue
        }
      }
      try GenerateHelpFileStep(project: self.project, helpSourceFile: helpSourceFile, storage: self.storage).exec()
    }
  }

  func copyAssets() throws {
    // Common assets
    self.project.currentLanguage = ""
    try CopyAssetsBuildStep(project: self.project, storage: self.storage).exec()
    
    // Specific assets
    for lang in self.project.languages {
      project.currentLanguage = lang
      try CopyAssetsBuildStep(project: self.project, storage: self.storage).exec()
    }
  }
  
}
