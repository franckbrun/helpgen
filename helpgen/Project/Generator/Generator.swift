//
//  Generator.swift
//  helpgen
//
//  Created by Franck Brun on 24/06/2022.
//

import Foundation

class Generator<S: SourceFile> : Generatable {
  
  let project: Project
  let source: S
  
  init(project: Project, sourceFile: S) {
    self.project = project
    self.source = sourceFile
    internalInit()
  }
  
  func internalInit() {
    
  }
  
  func generate() throws -> Any? {
    throw GenericError.notImplemented(#function)
  }
  
}
