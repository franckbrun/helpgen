//
//  FileSerializer.swift
//  helpgen
//
//  Created by Franck Brun on 26/06/2022.
//

import Foundation
import SystemPackage

class FileSerializer: Serializable {

  let fileManager = FileManager()
  
  func createFolder(at path: FilePath, withIntermediateDirectories: Bool = true) throws {
    try fileManager.createDirectory(atPath: path.string, withIntermediateDirectories: withIntermediateDirectories)
  }
  
  func createFile(at path: FilePath, contents: Data?) throws {
    throw GenericError.notImplemented(#function)
  }
  
  func fileExists(at path: FilePath, isDirectory: inout Bool) throws -> Bool {
    var isDir: ObjCBool = false
    let exists = fileManager.fileExists(atPath: path.string, isDirectory: &isDir)
    isDirectory = isDir.boolValue
    return exists
  }

}
