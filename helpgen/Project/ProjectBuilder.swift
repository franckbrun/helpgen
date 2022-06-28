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
  let serializer: S
  
  init(project: Project, serializer: S) {
    self.project = project
    self.serializer = serializer
  }
  
}

extension ProjectBuilder {
  
  func create(at projectFolderPath: FilePath) throws {

    var buildSteps: [BuildStep] = [
      CreateFolderBuildStep(FilePath("Contents"), options: [], serializer: self.serializer)
    ]
    
    if self.project.languages.count > 0 {
      buildSteps.append(CreateFolderBuildStep(FilePath("Contents/Resources"), options: [], serializer: self.serializer))
    }
    
    for lang in self.project.languages {
      // TODO: Check language
      let langFolderPath = FilePath("Contents/Resources/\(lang).\(Constants.LanguageProjectExtension)")
      buildSteps.append(CreateFolderBuildStep(langFolderPath, options: [], serializer: self.serializer))
    }
    
    let filesBuildSteps: [BuildStep] = [
      CreatePkgInfoFileBuildStep(serializer: self.serializer),
      CreateHelpBookPlistBuildStep(project: self.project, serializer: self.serializer)
    ]
    
    buildSteps.append(contentsOf: filesBuildSteps)
    
    
    for buildStep in buildSteps {
      try buildStep.exec()
    }
  }
  
}

extension ProjectBuilder {
  
  enum BuildError: Error {
    case generalError
  }
  
  func build(at: FilePath) throws {
//    let output = FilePath(".")
//    
//    if at.isEmpty {
//      
//    }
//    
//    for file in self.project.helpSourceFiles {
//      try ParseHelpSourceFileStep(file).exec()
//      try ApplyGlobalPropertiesStep(project: self.project, source: file).exec()
//    }
//    
//    for file in self.project.helpSourceFiles {
//      try GenerateHelpFileStep(project: self.project, helpSourceFile: file, output: output, serializer: self.serializer).exec()
//    }
  }

}
