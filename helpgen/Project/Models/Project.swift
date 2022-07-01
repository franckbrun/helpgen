//
//  Project.swift
//  helpgen
//
//  Created by Franck Brun on 23/06/2022.
//

import Foundation
import SystemPackage

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
  
  var outputFolder: FilePath?
  
  init(_ name: String) {
    self.name = name
  }
    
}

extension Project: PropertyQueryable {
  
  func property(named propertyName: String) -> Property? {
    return properties[propertyName]
  }
  
}

extension Project {

  /// Include all sources files in project
  func includeFiles(in path: FilePath) {
    let url = URL(fileURLWithPath: path.string)
    let resourceKeys = Set<URLResourceKey>([.nameKey, .isDirectoryKey])
    let enumerator = FileManager.default.enumerator(at: url,
                                                    includingPropertiesForKeys: Array(resourceKeys),
                                                    options: [.skipsHiddenFiles, .skipsSubdirectoryDescendants])
    guard let enumerator = enumerator else {
      return
    }

    for case let fileURL as URL in enumerator {
      guard let resourceValues = try? fileURL.resourceValues(forKeys: resourceKeys),
            let isDirectory = resourceValues.isDirectory,
            let name = resourceValues.name
      else {
        continue
      }

      if isDirectory {
        if name.hasPrefix("_") {
          enumerator.skipDescendants()
        }
      } else {
        self.helpSourceFiles.append(HelpSourceFile(path: path.appending(name)))
      }      
    }
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
    <title>%{page.title}%</title>
    <meta name="AppleTitle" content="%{page.apple_title}%">
  </head>
  <body>
    <a name="%{apple_anchor}%"></a>
    <div>
      %{elements:*}%
    </div>
  </body>
</html>
"""
  }
  
}
