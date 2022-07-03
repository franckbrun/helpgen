//
//  StorageHelper.swift
//  helpgen
//
//  Created by Franck Brun on 02/07/2022.
//

import Foundation
import System

final class StorageHelper {
  
  static func createStorage(rootPath: FilePath, overwrite: Bool = false) throws -> some StorageWrapper {
    var storageOptions: FileSystemWrapper.Options = []
    
    if overwrite {
      storageOptions.insert(.overwrite)
    }

    let storage = try FileSystemWrapper(rootPath: rootPath, options: storageOptions)
    return storage
  }
  
}
