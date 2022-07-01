//
//  FileType.swift
//  helpgen
//
//  Created by Franck Brun on 25/06/2022.
//

import Foundation
import System

enum FileType: String {
  case undefined
  case helpSource
  
  static func fileType(for path: FilePath) -> FileType {
    switch path.extension {
    case "helpsource", "hs":
      return .helpSource
    default:
      return .undefined
    }
  }
}
