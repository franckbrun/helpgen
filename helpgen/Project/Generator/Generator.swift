//
//  Generator.swift
//  helpgen
//
//  Created by Franck Brun on 24/06/2022.
//

import Foundation

enum GeneratorError : Error {
  case notImplemented(String)
}

class Generator<S: SourceFile> : Generatable {
  
  let project: Project
  let sourceFile: S
  
  init(project: Project, sourceFile: S) {
    self.project = project
    self.sourceFile = sourceFile
  }
  
  func generate() throws -> Result<Any?, Error> {
    throw GeneratorError.notImplemented(#function)
  }
  
}
