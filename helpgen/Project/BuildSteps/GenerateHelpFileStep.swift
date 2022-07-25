//
//  GenerateHelpFileStep.swift
//  helpgen
//
//  Created by Franck Brun on 24/06/2022.
//

import Foundation
import System

enum GenerateHelpFileError: Error {
  case undefinedContents
  case undefinedOutputFilename
}

class GenerateHelpFileStep<S: StorageWrapper>: BuildStep {
  
  let project: Project
  let helpSourceFile: HelpSourceFile
  let storage: S
  
  init(project: Project, helpSourceFile: HelpSourceFile, storage: S) {
    self.project = project
    self.helpSourceFile = helpSourceFile
    self.storage = storage
  }
  
  func exec() throws {
    if let pageLangProperty = helpSourceFile.property(named: Constants.LanguagePropertyKey) {
      let languages = pageLangProperty.value.split(separator: ",").map { String($0) } 
      guard languages.contains(self.project.currentLanguage) else {
        logd("file '\(helpSourceFile.filePath.string)' only for '\(pageLangProperty.value)'")
        return
      }
    }
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
      rootFilePath.extension = "html"
      return rootFilePath
    } else {
      throw GenericError.internalError
    }
  }
  
}
