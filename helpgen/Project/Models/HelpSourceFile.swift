//
//  HelpSourceFile.swift
//  helpgen
//
//  Created by Franck Brun on 24/06/2022.
//

import Foundation
import SystemPackage

class HelpSourceFile: SourceFile {
  
  let fileType: FileType
  
  let filePath: FilePath
  
  var node: HelpSourceNode?
   
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
  
  func property(named propertyName: String, language lang: String) -> String? {
    // TODO: Take language in account
    if let node = self.node, let propertiesNode = node.properties {
      let property = propertiesNode.properties.first { $0.name == propertyName }
      return property?.value
    }
    return nil
  }
    
}

extension HelpSourceFile: ElementQueryable {
  
  func element(type: ElementType, name: String, language: String) -> [ElementNode] {
    guard let node = node else {
      return []
    }
    
    let filteredElements = node.elements.filter { element in
      
      if element.type != type {
        return false
      }

      if name != "*" {
        guard let elementName = element.property(named: Constants.NamePropertyKey) else {
          return false
        }
        if elementName != name {
          return false
        }
      }
      
      if !language.isEmpty {
        guard let elementLangage = element.property(named: Constants.LanguagePropertyKey) else {
          return false
        }
        if elementLangage != language {
          return false
        }
      }
      
      return true
    }
    
    return filteredElements
  }
  
}
