//
//  Generator.swift
//  helpgen
//
//  Created by Franck Brun on 24/06/2022.
//

import Foundation

class Generator<S: SourceFile, T: ValueTransformable> : Generatable {
  
  let project: Project
  let source: S
  let valueTransformer: T
  
  init(project: Project, sourceFile: S, valueTransformer: T) {
    self.project = project
    self.source = sourceFile
    self.valueTransformer = valueTransformer
    internalInit()
  }
  
  func internalInit() {
    
  }
  
  func generate() throws -> Any? {
    throw GenericError.notImplemented(#function)
  }
  
}
