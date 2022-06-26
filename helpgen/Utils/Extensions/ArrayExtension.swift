//
//  ArrayExtension.swift
//  helpgen
//
//  Created by Franck Brun on 26/06/2022.
//

import Foundation

extension Array where Array.Element == Property {
  
  func find(propertyName name: String) -> Property? {
    for element in self {
      if element.name == name {
        return element
      }
    }
    return nil
  }
  
}

extension Array where Array.Element == PropertyNode {
  
  func find(propertyName name: String) -> Property? {
    for node in self {
      if node.property.name == name {
        return node.property
      }
    }
    return nil
  }
  
}
