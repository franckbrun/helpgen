//
//  ElementNode.swift
//  helpgen
//
//  Created by Franck Brun on 23/06/2022.
//

import Foundation

struct ElementNode: ExprNode {

  let element: Element
  
}

extension ElementNode: PropertyQueryable {
  
  func property(named propertyName: String) -> Property? {
    return self.element.property(named: propertyName)
  }
  
}
