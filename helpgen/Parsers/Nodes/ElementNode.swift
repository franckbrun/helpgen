//
//  ElementNode.swift
//  helpgen
//
//  Created by Franck Brun on 23/06/2022.
//

import Foundation

struct ElementNode: ExprNode {

  let elementTypeName: String
  let values: [ValueNode]?
  let properties: [PropertyNode]?
  
}
