//
//  Element.swift
//  helpgen
//
//  Created by Franck Brun on 27/06/2022.
//

import Foundation

enum ElementType: String, CaseIterable {
  case text
  case image
  case anchor
}

struct Element {
  let type: ElementType
  var properties = [Property]()
}

extension Element: Equatable {}

extension Element: PropertyQueryable {
  
  func property(named propertyName: String) -> Property? {
    return self.properties.find(propertyName: propertyName)
  }
  
}
