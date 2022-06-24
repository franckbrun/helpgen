//
//  Build.swift
//  helpgen
//
//  Created by Franck Brun on 23/06/2022.
//

import Foundation
import SystemPackage
import ArgumentParser

enum BuildError: Error {
  case unknownFileFormat
}

struct Build: ParsableCommand {
  
  struct Options: ParsableArguments {
    @Flag(help: "Verbose")
    var verbose = false {
      didSet {
        Logger.currentLevel = .verbose
      }
    }
    
    @Argument(help: "Source folder")
    var sourceFolder: String
    
    @Argument(help: "Output folder")
    var outputFolder: String = ""

  }
  
  @OptionGroup var options: Options
  
  func run() throws {
    let path = FilePath(FileManager.default.currentDirectoryPath).appending(self.options.sourceFolder)
    
    var isDirectory: ObjCBool = false
    if FileManager.default.fileExists(atPath: path.string, isDirectory: &isDirectory) && !isDirectory.boolValue {
      loge("\(path) is not a directory")
      throw ExitCode.failure
    }
    
    logi("Current source path is \(path)")
    
    let project = Project(path.lastComponent?.string ?? "")
    
    project.includeFiles(in: path)
        
    do {
      try project.build(at: FilePath(self.options.outputFolder))
    } catch let error {
      loge("error while building: \(error.localizedDescription)")
      throw ExitCode.failure
    }
  }
}


