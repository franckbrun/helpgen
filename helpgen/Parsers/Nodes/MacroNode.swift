//
//  MacroNode.swift
//  helpgen
//
//  Created by Franck Brun on 13/07/2022.
//

import Foundation

struct MacroNode: ExprNode {
  let name: String
  let value: ValueNode
}

