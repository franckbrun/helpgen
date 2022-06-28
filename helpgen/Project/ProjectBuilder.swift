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
      CreateFolderBuildStep(FilePath("Contents"), options: [], storage: self.storage)
    ]
    
    if self.project.languages.count > 0 {
      buildSteps.append(CreateFolderBuildStep(FilePath("Contents/Resources"), options: [], storage: self.storage))
    }
    
    for lang in self.project.languages {
      // TODO: Check language
      let langFolderPath = FilePath("Contents/Resources/\(lang).\(Constants.LanguageProjectExtension)")
      buildSteps.append(CreateFolderBuildStep(langFolderPath, options: [], storage: self.storage))
    }
    
    let filesBuildSteps: [BuildStep] = [
      CreatePkgInfoFileBuildStep(storage: self.storage),
      CreateHelpBookPlistBuildStep(project: self.project, storage: self.storage)
    ]
    
    buildSteps.append(contentsOf: filesBuildSteps)
          
    try execute(buildSteps: buildSteps)
  }
  
}

extension ProjectBuilder {
  
  enum BuildError: Error {
    case generalError
  }
  
  func build(at projectFolderPath: FilePath) throws {

    var buildSteps = [BuildStep]()
    
    let sourceFiles = self.project.helpSourceFiles.sorted(by: { $0.filePath.string > $1.filePath.string })
    
    for file in sourceFiles {
      buildSteps.append(contentsOf: [
        ParseHelpSourceFileStep(file),
        ApplyGlobalPropertiesStep(project: self.project, source: file)
      ] as [BuildStep])
    }
    
    for file in self.project.helpSourceFiles {
      buildSteps.append(GenerateHelpFileStep(project: self.project, helpSourceFile: file, storage: self.storage))
    }
    
    try execute(buildSteps: buildSteps)
  }

}
