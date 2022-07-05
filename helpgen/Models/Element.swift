//
//  Element.swift
//  helpgen
//
//  Created by Franck Brun on 27/06/2022.
//

import Foundation

struct ElementFeatures: OptionSet, Equatable {
  var rawValue: Int
  
  static let explicit = ElementFeatures(rawValue: 1 << 0)
  
}

enum ElementType: String, CaseIterable {
  case text
  case image
  case anchor
  case link
  case helplink
  case video
  case separator
}

struct Element {
  let type: ElementType
  let features: ElementFeatures
  let name: String?
  var values: [Value]?
  var properties: [Property]?
}

extension Element: Equatable {}

extension Element: PropertyQueryable {
  
  func property(named propertyName: String) -> Property? {
    return self.properties?.find(propertyName: propertyName)
  }
    
}

extension Element {

  func value(forNamedProterty name: String) -> String? {
    return self.property(named: name)?.value
  }

  func bool(forNamedProterty name: String) -> Bool? {
    if let value = value(forNamedProterty: name) {
      return Bool(value)
    }
    return nil
  }
  
}
