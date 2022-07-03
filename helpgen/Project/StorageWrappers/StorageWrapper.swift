//
//  StorageWrapper.swift
//  helpgen
//
//  Created by Franck Brun on 26/06/2022.
//

import Foundation
import System

enum StorageError: Error {
  case alreadyExists
}

protocol StorageWrapper {
  
  func initialize() throws
  
  func finalize() throws
  
  func createFolder(at path: FilePath, withIntermediateDirectories: Bool) throws
  
  func createFile(at path: FilePath, contents: String) throws
  
  func fileExists(at path: FilePath, isDirectory: inout Bool) throws -> Bool
  
  func fileExists(at path: FilePath) throws -> Bool
  
  func write(to path: FilePath, contents: Data) throws
  
  func removeFile(at path: FilePath) throws
  
  func copyFile(at path: FilePath, to destPath: FilePath) throws
  
}
