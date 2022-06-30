//
//  ProjectBuilder.swift
//  helpgen
//
//  Created by Franck Brun on 27/06/2022.
//

import Foundation
import SystemPackage

class ProjectBuilder<S: StorageWrappable> {
  
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

    var buildSteps: [BuildStep] = [
      CreateFolderBuildStep(FilePath(Constants.ResourcesPathString), options: [], storage: self.storage),
      CreatePkgInfoFileBuildStep(storage: self.storage),
      CreateHelpBookPlistBuildStep(project: self.project, storage: self.storage),
    ]
    
    for lang in self.project.languages {
      // TODO: Check language
      let langFolderPath = FilePath("\(Constants.ResourcesPathString)/\(lang).\(Constants.LanguageProjectExtension)")
      buildSteps.append(CreateFolderBuildStep(langFolderPath, options: [], storage: self.storage))
    }
    
    try execute(buildSteps: buildSteps)
  }
  
}

extension ProjectBuilder {
  
  enum BuildError: Error {
    case generalError
  }
  
  func build(at projectFolderPath: FilePath) throws {
    try parseSourceFiles()
    try buildHelpFilesForAllLanguages()
  }

  func parseSourceFiles() throws {
    var buildSteps = [BuildStep]()
    
    for helpFile in self.project.helpSourceFiles {
      let fileBuildSteps: [BuildStep] = [
        ParseHelpSourceFileStep(helpFile),
        ApplyGlobalPropertiesStep(project: self.project, source: helpFile)
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
    } else {
      try buildHelpFiles()
    }
  }
  
  func buildHelpFiles() throws {
    for helpSourceFile in self.project.helpSourceFiles {
      try GenerateHelpFileStep(project: self.project, helpSourceFile: helpSourceFile, storage: self.storage).exec()
    }
  }
  
}
