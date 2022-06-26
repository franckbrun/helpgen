//
//  Serializable.swift
//  helpgen
//
//  Created by Franck Brun on 26/06/2022.
//

import Foundation
import SystemPackage

protocol Serializable {
  
  func createFolder(at path: FilePath, withIntermediateDirectories: Bool) throws
  
  func createFile(at path: FilePath, contents: Data?) throws
  
  func fileExists(at path: FilePath, idDirectory: inout Bool) throws -> Bool
  
}
