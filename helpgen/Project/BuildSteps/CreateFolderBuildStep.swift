//
//  CreateFolderBuildStep.swift
//  helpgen
//
//  Created by Franck Brun on 25/06/2022.
//

import Foundation
import SystemPackage

enum CreateFolderError: Error {
  case fileExists
  case notADirectory
}

class CreateFolderBuildStep: BuildStep {
  
  struct Options: OptionSet {
    var rawValue: Int
    
    static let throwIfExists = Options(rawValue: 1 << 0)
  }
  
  let folderPath: FilePath
  
  var options: Options
  
  init(_ folderPath: FilePath, options: Options = []) {
    self.folderPath = folderPath
    self.options = options
  }
  
  func exec() throws {
    
    let fm = FileManager()
        
    var isDirectory: ObjCBool = false
    if fm.fileExists(atPath: folderPath.string, isDirectory: &isDirectory) {
      if !isDirectory.boolValue {
        throw CreateFolderError.notADirectory
      }
      if options.contains(.throwIfExists) {
        throw CreateFolderError.fileExists
      }
    }
    
    try fm.createDirectory(atPath: folderPath.string, withIntermediateDirectories: true)    
  }
  
}
