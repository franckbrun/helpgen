//
//  CreatePkgInfoFileBuildStep.swift
//  helpgen
//
//  Created by Franck Brun on 27/06/2022.
//

import Foundation
import System

class CreatePkgInfoFileBuildStep<S: StorageWrapper>: BuildStep {
  
  let storage: S
  
  init(storage: S) {
    self.storage = storage
  }
  
  func exec() throws {
    try storage.createFile(at: FilePath("\(Constants.ContainerPathString)/PkgInfo"), contents: "BNDLhbwr")
  }
  
}
