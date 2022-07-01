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

  func projectProperties() -> [Property]? {
    return node?.properties?.nodes.compactMap { node in
      let projectPropertyPrefix = "\(Constants.ProjectPropertyNameRadix)."
      if node.property.name.hasPrefix(projectPropertyPrefix) {
        let propertyName = node.property.name.deletingPrefix(projectPropertyPrefix)
        return Property(name: propertyName, value: node.property.value)
      }
      return nil
    }
  }
  
  func sourceProperties() -> [Property]? {
    return node?.properties?.nodes.compactMap { node in
      if !node.property.name.hasPrefix("\(Constants.ProjectPropertyNameRadix).") {
        let pagePropertyPrefix = "\(Constants.PagePropertyNameRadix)."
        var propertyName = node.property.name
        if propertyName.hasPrefix(pagePropertyPrefix) {
          propertyName = propertyName.deletingPrefix(pagePropertyPrefix)
        }
        return Property(name: propertyName, value: node.property.value)
      }
      return nil
    }
  }

}

extension HelpSourceFile: PropertyQueryable {
  
  func property(named propertyName: String) -> Property? {
    return self.node?.properties?.property(named: propertyName)
  }
    
}

extension HelpSourceFile: ElementQueryable {
  
  func element(type: ElementType?, name: String?, language: String?, limit: Int = 0) -> [Element] {
    guard let elementsNode = self.node?.elements?.nodes else {
      return []
    }
    
    var elements = [Element]()
    
    for elementNode in elementsNode {
      
      if let queryedElementType = type, elementNode.element.type != queryedElementType {
        continue
      }

      if let queryedElementName = name {
        guard let elementName = elementNode.property(named: Constants.NamePropertyKey)?.value else {
          continue
        }
        if elementName != queryedElementName {
          continue
        }
      }
      
      if let queryedElementLanguage = language {
        guard let elementLangage = elementNode.property(named: Constants.LanguagePropertyKey)?.value else {
          continue
        }
        if elementLangage != queryedElementLanguage {
          continue
        }
      }

      elements.append(elementNode.element)
      if limit > 0, elements.count >= limit {
        break
      }
      
    }
        
    return elements
  }
  
}
