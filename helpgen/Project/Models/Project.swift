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
  
  /// Current langage for the current build
  /// nil = no specific language
  var currentLanguage: String?
  
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
  
  func template<S: SourceFile & LocalizedPropertyQueryable>(for source: S) -> String? {
    // TODO: Check template of source
    if let templateFilename = source.property(named: Constants.TemplatePropertyKey, language: self.currentLanguage) {
      logd("found template filename : \(templateFilename)")
      // TODO: Load template
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
    <a name="%apple_anchor%"></a>
    <div>%{element:*}%</div>
  </body>
</html>
"""
  }
  
}
