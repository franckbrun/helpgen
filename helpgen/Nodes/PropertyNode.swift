//
//  PropertyNode.swift
//  helpgen
//
//  Created by Franck Brun on 23/06/2022.
//

import Foundation

struct PropertyNode: ExprNode {
  let name: String
  let value: String
  
  var description: String {
    return "PropertyNode{name:\(name), value:\(value)}"
  }
}
