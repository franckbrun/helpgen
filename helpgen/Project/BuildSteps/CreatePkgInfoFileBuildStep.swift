//
//  CreatePkgInfoFileBuildStep.swift
//  helpgen
//
//  Created by Franck Brun on 27/06/2022.
//

import Foundation
import SystemPackage

class CreatePkgInfoFileBuildStep<S: StorageWrappable>: BuildStep {
  
  let storage: S
  
  init(storage: S) {
    self.storage = storage
  }
  
  func exec() throws {
    try storage.createFile(at: FilePath("Contents/PkgInfo"), contents: "BNDLhbwr")
  }
  
}
