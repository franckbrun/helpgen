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
  
  func execute(buildSteps: [BuildStep]) throws {
    for buildStep in buildSteps {
      try buildStep.exec()
    }
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
      buildSteps.append(GenerateHelpFileStep(project: self.project, helpSourceFile: file, serializer: self.serializer))
    }
    
    try execute(buildSteps: buildSteps)
  }

}
