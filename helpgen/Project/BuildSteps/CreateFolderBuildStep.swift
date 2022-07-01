//
//  CreateFolderBuildStep.swift
//  helpgen
//
//  Created by Franck Brun on 25/06/2022.
//

import Foundation
import System

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
  
  let storage: S
  
  init(_ folderPath: FilePath, options: CreateFolderBuildOptions = [], storage: S) {
    self.folderPath = folderPath
    self.options = options
    self.storage = storage
  }
  
  func exec() throws {
    var isDir = false
    let exists = try storage.fileExists(at: folderPath, isDirectory: &isDir)
    if exists {
      if !isDir {
        throw CreateFolderError.notADirectory
      }
      if options.contains(.throwIfExists) {
        throw CreateFolderError.fileExists
      }
    }
    
    try storage.createFolder(at: folderPath, withIntermediateDirectories: true)
  }
  
}
