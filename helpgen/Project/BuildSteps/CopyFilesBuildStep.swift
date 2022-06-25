//
//  CopyFilesBuildStep.swift
//  helpgen
//
//  Created by Franck Brun on 25/06/2022.
//

import Foundation

class CopyFilesBuildStep: BuildStep {
  
  let project: Project
  
  init(project: Project) {
    self.project = project
  }
  
  func exec() throws {
    throw GenericError.notImplemented(#function)
  }
  
}
