//
//  HelpSourceParser.swift
//  helpgen
//
//  Created by Franck Brun on 23/06/2022.
//

import Foundation

class HelpSourceParser: CommonParser {

  /// primary
  ///   ::= propertiessectionexpr
  ///   ::= elementexpr
  func parse() throws -> HelpSourceNode {
    
    var properties: [PropertyNode]?
    var elements: [ElementNode]?
    
    var token = try peekToken()
    while token != Token.end() {
      switch token.type {
      case .propertiesSection:
        properties = try parsePropertiesSection()
      case .element:
        if elements == nil {
          elements = [ElementNode]()
        }
            
        elements?.append(try parseElement())
      default:
        throw ParserError.unexpectedToken(token)
      }
      token = try peekToken()
    }
    
    return HelpSourceNode(properties: properties, elements: elements)
  }
  
}
