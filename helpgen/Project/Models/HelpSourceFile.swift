//
//  HelpSourceFile.swift
//  helpgen
//
//  Created by Franck Brun on 24/06/2022.
//

import Foundation
import SystemPackage

class HelpSourceFile: SourceFile {
  
  let filePath: FilePath
  
  var node: HelpSourceNode?
   
  init(path: FilePath) {
    self.filePath = path
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

extension HelpSourceFile: PropertyQueryable {
  
  subscript(propertyName: String) -> String? {
    if let node = self.node, let propertiesNode = node.properties {
      let property = propertiesNode.properties.first { $0.name == propertyName }
      return property?.value
    }
    return nil
  }
  
}
