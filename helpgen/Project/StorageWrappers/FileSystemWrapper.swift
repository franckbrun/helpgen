//
//  FileSystemWrapper.swift
//  helpgen
//
//  Created by Franck Brun on 26/06/2022.
//

import Foundation
import System

class FileSystemWrapper: StorageWrappable {

  let fileManager = FileManager()
  
  let rootPath: FilePath
  
  struct Options: OptionSet {
    var rawValue: Int
    
    static let overwrite = Options(rawValue: 1 << 0)
  }
  
  var options: Options
  
  init(rootPath: FilePath, options: Options = []) throws {
    self.rootPath = rootPath
    self.options = options
  }
  
  func initialize() throws {
    try fileManager.createDirectory(atPath: self.rootPath.string, withIntermediateDirectories: true)
  }
  
  func finalize() throws {
  }
  
  func createFolder(at path: FilePath, withIntermediateDirectories: Bool = true) throws {
    let finalPath = rootPath.pushing(path)
    try fileManager.createDirectory(atPath: finalPath.string, withIntermediateDirectories: withIntermediateDirectories)
  }
  
  func createFile(at path: FilePath, contents: String) throws {
    guard let data = contents.data(using: .utf8) else {
      throw GenericError.stringConversionError
    }
    try write(to: path, contents: data)
  }
  
  func fileExists(at path: FilePath, isDirectory: inout Bool) throws -> Bool {
    let finalPath = rootPath.pushing(path)
    var isDir: ObjCBool = false
    let exists = fileManager.fileExists(atPath: finalPath.string, isDirectory: &isDir)
    isDirectory = isDir.boolValue
    return exists
  }

  func fileExists(at path: FilePath) throws -> Bool {
    var isDir = false
    return try fileExists(at: path, isDirectory: &isDir)
  }
  
  func write(to path: FilePath, contents: Data) throws {
    let finalPath = rootPath.pushing(path)
    let url = URL(fileURLWithPath: finalPath.string)
    try contents.write(to: url, options: [.atomic])
  }

  func removeFile(at path: FilePath) throws {
    let finalPath = rootPath.pushing(path)
    try self.fileManager.removeItem(atPath: finalPath.string)
  }
  
}
