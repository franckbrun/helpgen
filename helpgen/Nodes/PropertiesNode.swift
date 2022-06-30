//
//  PropertiesNode.swift
//  helpgen
//
//  Created by Franck Brun on 24/06/2022.
//

import Foundation

struct PropertiesNode: ArrayNode {

  var nodes = [PropertyNode]()
  
}

extension PropertiesNode: PropertyQueryable {
  
  func property(named propertyName: String) -> Property? {
    return nodes.find(propertyName: propertyName)
  }
}
