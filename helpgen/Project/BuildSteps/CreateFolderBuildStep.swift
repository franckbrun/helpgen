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

struct CreateFolderBuildOptions: OptionSet {
  var rawValue: Int
  
  static let throwIfExists = CreateFolderBuildOptions(rawValue: 1 << 0)
}

class CreateFolderBuildStep<S: StorageWrappable>: BuildStep {
    
  let folderPath: FilePath
  
  var options: CreateFolderBuildOptions
  
  let serializer: S
  
  init(_ folderPath: FilePath, options: CreateFolderBuildOptions = [], serializer: S) {
    self.folderPath = folderPath
    self.options = options
    self.serializer = serializer
  }
  
  func exec() throws {
    var isDir = false
    let exists = try serializer.fileExists(at: folderPath, isDirectory: &isDir)
    if exists {
      if !isDir {
        throw CreateFolderError.notADirectory
      }
      if options.contains(.throwIfExists) {
        throw CreateFolderError.fileExists
      }
    }
    
    try serializer.createFolder(at: folderPath, withIntermediateDirectories: true)
  }
  
}
