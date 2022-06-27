//
//  CreatePkgInfoFileBuildStep.swift
//  helpgen
//
//  Created by Franck Brun on 27/06/2022.
//

import Foundation
import SystemPackage

class CreatePkgInfoFileBuildStep<S: Serializable>: BuildStep {
  
  let serializer: S
  
  init(serializer: S) {
    self.serializer = serializer
  }
  
  func exec() throws {
    try serializer.createFile(at: FilePath("Contents/PkgInfo"), contents: "BNDLhbwr")
  }
  
}
