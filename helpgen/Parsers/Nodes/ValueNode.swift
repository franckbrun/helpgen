//
//  ValueNode.swift
//  helpgen
//
//  Created by Franck Brun on 27/06/2022.
//

import Foundation

struct ValueNode: ExprNode {

  let value: Value
  
}

extension ValueNode: Equatable {}
