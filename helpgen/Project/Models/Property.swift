//
//  Property.swift
//  helpgen
//
//  Created by Franck Brun on 26/06/2022.
//

import Foundation

struct Property {
  let name: String
  let value: String
}

extension Property: Equatable, Hashable, Codable {}

extension Property {
  
  static func parseList(from str: String) -> [Property] {
    let regexpr = RegExprCache.shared
    var properties = [Property]()
    
    if let matches = regexpr.matches(expression: RegExprConstant.PropertiesNameKey, str: str) {
      for match in matches {
        if let propertyName = match.string(withRangeAt: 1, in: str),
           let propertyValue = match.string(withRangeAt: 2, in: str) {
          
          properties.append(Property(name: propertyName, value: propertyValue))
        }
      }
    }
    
    return properties
  }
  
}
