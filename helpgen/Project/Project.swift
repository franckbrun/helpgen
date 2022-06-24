//
//  Project.swift
//  helpgen
//
//  Created by Franck Brun on 23/06/2022.
//

import Foundation
import SystemPackage

class Project {

  // Project name
  var name: String

  // List of langages
  var languages = [String]()
  
  // Globals project properties
  var properties = [String : String]()
  
  var helpSourceFiles = [HelpSourceFile]()
  
  var outputFolder: FilePath?
  
  init(_ name: String) {
    self.name = name
  }
    
}

extension Project {

  /// Include all sources files in project
  func includeFiles(in path: FilePath) {
    let enumerator = FileManager.default.enumerator(atPath: path.string)
    
    while let file = enumerator?.nextObject() as? String {
      self.helpSourceFiles.append(HelpSourceFile(path: path.appending(file)))
    }
  }

}

extension Project {
  
  enum BuildError: Error {
    case generalError
  }
  
  func build(at: FilePath) throws {
    let output = FilePath(".")
    
    if at.isEmpty {
      
    }
    
    for file in self.helpSourceFiles {
      try ParseHelpSourceFileStep(file).exec()
      try ApplyGlobalPropertiesStep(project: self, source: file).exec()
    }
       
    for file in self.helpSourceFiles {
      try GenerateHelpFileStep(project: self, helpSourceFile: file, output: output).exec()
    }
  }

}
