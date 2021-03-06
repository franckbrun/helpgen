//
//  Token.swift
//  helpgen
//
//  Created by Franck Brun on 23/06/2022.
//

import Foundation

enum TokenType {
  case whiteSpace
  case propertiesSection
  case property
  case propertyLocalization
  case value
  case element
  case comment
  case macro
  case other
  case identifier
  case `operator`
  case parenthesis
  case end
}

extension TokenType: Equatable { }

struct Token {
  let type: TokenType
  let value: String
  let element: String
  
  var isDiscardable = false
  
  init(_ type: TokenType, value: String, element: String, discardable: Bool = false) {
    self.type = type
    self.value = value
    self.element = element
  }
  
  init(_ type: TokenType, element: String) {
    self.init(type, value: "", element: element)
  }
  
  init(_ type: TokenType) {
    self.init(type, value: "", element: "")
  }
}

extension Token: Equatable {}

extension Token {

  static func propertiesSection() -> Token {
    return Token(.propertiesSection, element: "---")
  }

  static func property(_ name: String) -> Token {
    return Token(.property, value: name, element: "\(name):")
  }

  static func propertyLocalization(_ name: String) -> Token {
    return Token(.property, value: name, element: "@\(name):")
  }

  static func value(_ value: String) -> Token {
    return Token(.value, value: value, element: "\(value)")
  }

  static func element(_ name: String) -> Token {
    return Token(.element, value: name, element: "/\(name)")
  }

  static func whiteSpace(_ element: String) -> Token {
    return Token(.whiteSpace, element: element)
  }

  static func equal() -> Token {
    return Token(.operator, element: "=")
  }

  static func colon() -> Token {
    return Token(.operator, element: ":")
  }

  static func end() -> Token {
    return Token(.end, element: "")
  }
  
  static func comment(_ value: String) -> Token {
    return Token(.comment, value: value, element: "# \(value)")
  }
  
  static func macro(_ value: String) -> Token {
    return Token(.comment, value: value, element: "!\(value)")
  }

}
