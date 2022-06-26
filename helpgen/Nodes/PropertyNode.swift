//
//  PropertyNode.swift
//  helpgen
//
//  Created by Franck Brun on 23/06/2022.
//

import Foundation

struct PropertyNode: ExprNode {
  let property: Property
  
  var description: String {
    return "PropertyNode{name:\(property.name), value:\(property.value)}"
  }
}
