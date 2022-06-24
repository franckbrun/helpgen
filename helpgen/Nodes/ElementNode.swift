//
//  ElementNode.swift
//  helpgen
//
//  Created by Franck Brun on 23/06/2022.
//

import Foundation

enum ElementType: String {
  case text
  case image
}

struct ElementNode: ExprNode {
  let type: ElementType
  var propertiesNode = PropertiesNode()
  
  var description: String {
    return "ElementNode{type:\(type.rawValue), properties:\(propertiesNode)}"
  }
}
