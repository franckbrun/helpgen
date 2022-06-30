//
//  ExprNode.swift
//  helpgen
//
//  Created by Franck Brun on 23/06/2022.
//

import Foundation

protocol ExprNode: CustomStringConvertible, Equatable {
  
}

protocol ArrayNode: ExprNode {
  associatedtype Node: ExprNode
  
  var nodes: [Node] { get }
  
}

extension ExprNode {
  
  var description: String {
    let mirror = Mirror(reflecting: self)
    return mirror.description    
  }
}
