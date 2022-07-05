//
//  Property.swift
//  helpgen
//
//  Created by Franck Brun on 26/06/2022.
//

import Foundation

struct PropertyLocalization {
  let lang: String
  let value: String
}

extension PropertyLocalization: Equatable, Hashable, Codable {}

struct Property {
  let name: String
  let value: String
    
  var localizedValues: [PropertyLocalization]?
}

extension Property: Equatable, Hashable, Codable {
  
  static func ==(lhs: Property, rhs: Property) -> Bool {
    return lhs.name == rhs.name && lhs.value == rhs.value
  }
  
}

extension Property {
  
  static func parseQuery(from str: String) -> [Property] {
    let regexpr = RegExprCache.shared
    var properties = [Property]()
    
    if let matches = regexpr.matches(expression: RegExprConstant.QueryPropertiesRegExpr, str: str) {
      for match in matches {
        if let propertyName = match.string(withRangeAt: 1, in: str),
           let propertyValue = match.string(withRangeAt: 2, in: str) {
          
          properties.append(Property(name: propertyName, value: propertyValue))
        }
      }
    }
    
    return properties
  }

  static func parseList(from str: String) -> [Property] {
    let regexpr = RegExprCache.shared
    var properties = [Property]()
    
    if let matches = regexpr.matches(expression: RegExprConstant.PropertiesRegExpr, str: str) {
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

extension Property {
  
  /// Return localized value of the property or default value if not found
  func value(forLanguage lang: String) -> String {
    return self.localizedValues?.find(propertyLoc: lang)?.value ?? value
  }
 
  /// Returns a new property with a value for the specific lqanguage
  func clone(forLanguage lang: String) -> Property {
    return Property(name: self.name, value: value(forLanguage: lang))
  }
  
  func hasLocalization(forLanguage lang: String) -> Bool {
    return self.localizedValues?.find(propertyLoc: lang) != nil
  }
  
}
