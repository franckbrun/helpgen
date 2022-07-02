//
//  CopyAssetsBuildStep.swift
//  helpgen
//
//  Created by Franck Brun on 25/06/2022.
//

import Foundation
import System

class CopyAssetsBuildStep<S: StorageWrappable>: BuildStep {
  
  let filemanager = FileManager()
  let project: Project
  let storage: S
  
  init(project: Project, storage: S) {
    self.project = project
    self.storage = storage
  }
  
  func exec() throws {
    var sourceAssetsFolder = ""
    
    // Source folder
    if let property = self.project.property(named: Constants.ProjectAssetsFolderPropertyKey) {
      if self.project.currentLanguage.isEmpty {
        sourceAssetsFolder = property.value
        if sourceAssetsFolder.isEmpty {
          logi("no common assets")
          return
        }
      } else if property.hasLocalization(forLanguage: self.project.currentLanguage) {
        sourceAssetsFolder = property.value(forLanguage: self.project.currentLanguage)
      } else {
        logi("no specific assets for language '\(self.project.currentLanguage)'")
        return
      }
    }
    
    let sourceFolder = self.project.inputFolder.appending(sourceAssetsFolder)
    
    // Destination folder
    var destinationFolder = FilePath(Constants.ResourcesPathString)
    if !self.project.currentLanguage.isEmpty {
      destinationFolder = destinationFolder.appending("\(self.project.currentLanguage).\(Constants.LanguageProjectExtension)")
    }
    destinationFolder = destinationFolder.appending(Constants.AssetsPathString)
    
    // Copy files
    let files = listFiles(in: sourceFolder)
    if !files.isEmpty {
      try copy(files: files, from: sourceFolder, to: destinationFolder)
    }
  }
  
  func copy(files: [FilePath], from sourcePath: FilePath, to destinationPath: FilePath) throws {
    for file in files {
      let sourceFilename = sourcePath.appending(file.components)
      let destinationFilename = destinationPath.appending(file.components)
      let destinationFolder = destinationFilename.removingLastComponent()
      
      try storage.createFolder(at: destinationFolder, withIntermediateDirectories: true)
      try storage.copyFile(at: sourceFilename, to: destinationFilename)
    }
  }
  
  func listFiles(in folderPath: FilePath) -> [FilePath] {
    var files = [FilePath]()
    
    let url = URL(fileURLWithPath: folderPath.string)
    let resourceKeys = Set<URLResourceKey>([.nameKey, .pathKey, .isDirectoryKey])
    let enumerator = FileManager.default.enumerator(at: url,
                                                    includingPropertiesForKeys: Array(resourceKeys),
                                                    options: [.skipsHiddenFiles])
    guard let enumerator = enumerator else {
      return files
    }
    
    for case let fileURL as URL in enumerator {
      guard let resourceValues = try? fileURL.resourceValues(forKeys: resourceKeys),
            let isDirectory = resourceValues.isDirectory,
            let name = resourceValues.name,
            let path = resourceValues.path
      else {
        continue
      }
      
      if isDirectory {
        if name.hasPrefix("_") {
          enumerator.skipDescendants()
        }
      } else {
        var filePath = FilePath(path)
        _ = filePath.removePrefix(folderPath)
        files.append(filePath)
      }
    }
    
    return files
  }
  
}
