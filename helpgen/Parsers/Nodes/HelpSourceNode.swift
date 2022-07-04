//
//  HelpSourceNode.swift
//  helpgen
//
//  Created by Franck Brun on 24/06/2022.
//

import Foundation

struct HelpSourceNode: ExprNode {
  var properties: [PropertyNode]?
  var elements: [ElementNode]?
  
  var description: String {
    return "HelpSourceNode{properties:\(properties?.description ?? "-"), elements:\(elements?.description ?? "-")}"
  }
}
