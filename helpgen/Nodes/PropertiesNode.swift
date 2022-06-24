//
//  PropertiesNode.swift
//  helpgen
//
//  Created by Franck Brun on 24/06/2022.
//

import Foundation

struct PropertiesNode: ExprNode {
  var properties = [PropertyNode]()
  
  var description: String {
    return "PropertiesNode{properties:\(properties)}"
  }
}
