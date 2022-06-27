//
//  HelpSourceFile.swift
//  helpgen
//
//  Created by Franck Brun on 24/06/2022.
//

import Foundation
import SystemPackage

class HelpSourceFile: SourceFile {
  
  let id = UUID().uuidString
  
  let fileType: FileType
  
  let filePath: FilePath
  
  var node: HelpSourceNode?
     
  var defaultOutputFilename: String? {
    return self.filePath.lastComponent?.string
  }
  
  init(path: FilePath) {
    self.filePath = path
    self.fileType = FileType.fileType(for: path)
  }
  
  convenience init(path: FilePath, node: HelpSourceNode) {
    self.init(path: path)
    self.node = node
  }
  
}

extension HelpSourceFile: SourcePropertiesQueryable {

  func globalProperties() -> PropertiesNode? {
    return nil
  }
  
  func sourceProperties() -> PropertiesNode? {
    return node?.properties
  }

}

extension HelpSourceFile: LocalizedPropertyQueryable {
  
  func property(named propertyName: String, language lang: String?) -> Property? {
    // TODO: Take language in account
    return self.node?.properties?.property(named: propertyName)
  }
    
}

extension HelpSourceFile: ElementQueryable {
  
  func element(type: ElementType?, name: String?, language: String?) -> [Element] {
    guard let node = node else {
      return []
    }
    
    let filteredElements = node.elements.filter { elementNode in
      
      if let queryedElementType = type, elementNode.element.type != queryedElementType {
        return false
      }

      if let queryedElementName = name {
        guard let elementName = elementNode.property(named: Constants.NamePropertyKey)?.value else {
          return false
        }
        if elementName != queryedElementName {
          return false
        }
      }
      
      if let queryedElementLanguage = language {
        guard let elementLangage = elementNode.property(named: Constants.LanguagePropertyKey)?.value else {
          return true
        }
        if elementLangage != queryedElementLanguage {
          return false
        }
      }
      
      return true
    }
    
    return filteredElements.map { $0.element }
  }
  
}
