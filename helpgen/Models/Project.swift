//
//  Project.swift
//  helpgen
//
//  Created by Franck Brun on 23/06/2022.
//

import Foundation
import System

class Project {

  private var _projectName: String = ""

  // Project name
  var name: String {
    get {
      if _projectName.isEmpty {
        if let propertyProjectName = property(named: Constants.NamePropertyKey) {
          return propertyProjectName.value
        }
      }
      return _projectName
    }
    set {
      _projectName = newValue
    }
  }

  // Project filename
  var filename: String {
    "\(self.name).\(Constants.HelpFileExtension)"
  }
  
  // List of langages
  var languages = [String]()
  
  /// Current langage for the current build
  /// empty = no specific language
  var currentLanguage = ""
  
  // Globals project properties
  var properties = [String: Property]()
  
  var helpSourceFiles = [HelpSourceFile]()
  
  var inputFolder = FilePath(".")
  
  var outputFolder: FilePath?

  struct Options: OptionSet {
    var rawValue: Int
    
    static let createIndex = Options(rawValue: 1 << 0)
  }

  var options = Options()
  
  init(_ name: String, options: Options = []) {
    self.name = name
    self.options = options
  }
    
}

extension Project: PropertyQueryable {
  
  func property(named propertyName: String) -> Property? {
    return properties[propertyName]
  }
  
}

extension Project {
  
  func template<S: SourceFile & PropertyQueryable>(for source: S) throws -> String? {
    // TODO: Check template of source
    if let property = source.property(named: Constants.TemplatePropertyKey) {
      logd("found template propery : \(property)")
      var path = FilePath(property.value(forLanguage: self.currentLanguage))
      if !path.isAbsolute {
        path = Config.currentPath.appending(path.components)
      }
      
      return try String(contentsOfFile: path.string)
    }
    
    switch source.fileType {
    case .helpSource:
      return defaultHTMLTemplate()
    default:
      return nil;
    }
  }
  
  func defaultHTMLTemplate() -> String {
    return
"""
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8">
    <title>%{page.title}%</title>
  </head>
  <body>
    <div>
      %{elements:*}%
    </div>
  </body>
</html>
"""
  }
  
}
