//
//  ElementNode.swift
//  helpgen
//
//  Created by Franck Brun on 23/06/2022.
//

import Foundation

enum ElementType: String, CaseIterable {
  case elements
  case text
  case image
  case anchor
}

struct ElementNode: ExprNode {
  let type: ElementType
  var propertiesNode = PropertiesNode()
  
  var description: String {
    return "ElementNode{type:\(type.rawValue), properties:\(propertiesNode)}"
  }
}
