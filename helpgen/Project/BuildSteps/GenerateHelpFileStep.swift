//
//  GenerateHelpFileStep.swift
//  helpgen
//
//  Created by Franck Brun on 24/06/2022.
//

import Foundation
import SystemPackage

enum GenerateHelpFileError: Error {
  case undefinedContents
  case undefinedOutputFilename
}

class GenerateHelpFileStep<S: StorageWrappable>: BuildStep {
  
  let project: Project
  let helpSourceFile: HelpSourceFile
  let storage: S
  
  init(project: Project, helpSourceFile: HelpSourceFile, storage: S) {
    self.project = project
    self.helpSourceFile = helpSourceFile
    self.storage = storage
  }
  
  func exec() throws {
    let valueTransformer = HTMLValueTransform(project: self.project)
    let generator = HTMLHelpGenerator(project: self.project, sourceFile: self.helpSourceFile, valueTransformer: valueTransformer)
    if let contents = try generator.generate() as? String {
      guard let data = contents.data(using: .utf8)  else {
        throw GenerateHelpFileError.undefinedContents
      }
      
      let path = try outputFilePath(for: helpSourceFile)
      logd("write file \(path.string)")
      try storage.write(to: path, contents: data)
    }
  }
  
  func outputFilePath(for sourceFile: HelpSourceFile) throws -> FilePath {
    
    var rootFilePath = FilePath(Constants.ResourcesPathString)
    let lang = project.currentLanguage
    
    if !lang.isEmpty {
      if let folder = FilePath.Component("\(lang).\(Constants.LanguageProjectExtension)") {
        rootFilePath.append(folder)
      } else {
        throw GenericError.internalError
      }
    }

    var filename = ""
    if let property = sourceFile.property(named: Constants.OutputFilenameKey) {
      filename = property.value(forLanguage: lang)
    } else if let defaultOutputFilename = sourceFile.defaultOutputFilename {
      filename = defaultOutputFilename
    }

    if !filename.isEmpty, let filenameComponent = FilePath.Component(filename) {
      rootFilePath.append(filenameComponent)
      return rootFilePath
    } else {
      throw GenericError.internalError
    }
  }
  
}
