//
//  StringReplacer.swift
//  helpgen
//
//  Created by Franck Brun on 25/06/2022.
//

import Foundation

class StringReplacer<S: Any>: StringReplacable {

  let project: Project
  let source: S
 
  init(project: Project, source: S) {
    self.project = project
    self.source = source
    internalInit()
  }
  
  func internalInit() {    
  }
  
  func replace(in sourceStr: String) throws -> String? {
    throw GenericError.notImplemented(#function)
  }
  
}
