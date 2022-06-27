//
//  HelpSourceParser.swift
//  helpgen
//
//  Created by Franck Brun on 23/06/2022.
//

import Foundation

class HelpSourceParser: Parser {

  /// primary
  ///   ::= propertiessectionexpr
  ///   ::= elementexpr
  func parse() throws -> HelpSourceNode {
    var node = HelpSourceNode()
    
    var token = try peekToken()
    while token != Token.end() {
      switch token.type {
      case .propertiesSection:
        node.properties = try parsePropertiesSection()
      case .element:
        node.elements.append(try parseElement())
      default:
        throw ParserError.unexceptedToken(token)
      }
      token = try peekToken()
    }
    
    return node
  }
  
  /// propertiesSection ::= --- properties ---
  func parsePropertiesSection() throws -> PropertiesNode {

    // Eat start of properties section token
    try expected(tokenType: .propertiesSection)
    try nextToken()

    let propertiesNode = try parseProperties()

    // Eat end of properties section
    try expected(tokenType: .propertiesSection)
    try nextToken()
    
    return propertiesNode
  }

  /// properties := (property)*
  func parseProperties() throws -> PropertiesNode {
    var token = try expected(tokenType: .property)

    var propertiesNode = PropertiesNode()

    repeat {
      guard token.type == .property else {
        break
      }
      let property = try parseProperty()
      propertiesNode.properties.append(property)
      token = try peekToken()
    } while true
    
    return propertiesNode
  }
  
  /// property ::= propertyName: propertyValue
  func parseProperty() throws -> PropertyNode {
    var token = try expected(tokenType: .property)
    let propertyName = token.value
    try nextToken()

    token = try expected(tokenType: .value)
    let propertyValue = token.value
    try nextToken()

    return PropertyNode(property: Property(name: propertyName, value: propertyValue))
  }
  
  func parseValue() throws -> ValueNode {
    let token = try expected(tokenType: .value)
    let value = token.value
    try nextToken()
    return ValueNode(value: value)
  }
  
  /// element ::= /name properties """value"""
  func parseElement() throws -> ElementNode {
    var token = try expected(tokenType: .element)
    guard let elementType = ElementType(rawValue: token.value) else {
      throw ParserError.unknownElementType(token)
    }
    token = try nextToken()
    
    var properties = [Property]()
    
    if token.type == .property {
      properties = try parseProperties().properties.map { $0.property }
    }

    let elementNode = ElementNode(element: Element(type: elementType, properties: properties))

    return elementNode
  }
  
}
