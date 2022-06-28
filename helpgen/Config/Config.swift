//
//  Config.swift
//  helpgen
//
//  Created by Franck Brun on 27/06/2022.
//

import Foundation
import SystemPackage

struct Config {
  
  static var currentPath: FilePath {
    return FilePath(FileManager.default.currentDirectoryPath)
  }
  
}
