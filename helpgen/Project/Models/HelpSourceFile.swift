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
  
  func property(named propertyName: String, language lang: String) -> Property? {
    // TODO: Take language in account
    return self.node?.properties?.property(named: propertyName)
  }
    
}

extension HelpSourceFile: ElementQueryable {
  
  func element(type: ElementType, name: String, language: String) -> [ElementNode] {
    guard let node = node else {
      return []
    }
    
    let filteredElements = node.elements.filter { element in
      
      if ![ElementType.elements, element.type].contains(type) {
        return false
      }

      if !name.isEmpty {
        guard let elementName = element.property(named: Constants.NamePropertyKey)?.value else {
          return false
        }
        if elementName != name {
          return false
        }
      }
      
      if !language.isEmpty {
        guard let elementLangage = element.property(named: Constants.LanguagePropertyKey)?.value else {
          return true
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
