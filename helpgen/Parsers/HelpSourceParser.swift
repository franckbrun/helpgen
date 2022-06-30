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
    
    var elementsNode = ElementsNode()
    
    var token = try peekToken()
    while token != Token.end() {
      switch token.type {
      case .propertiesSection:
        node.properties = try parsePropertiesSection()
      case .element:
        elementsNode.nodes.append(try parseElement())
      default:
        throw ParserError.unexceptedToken(token)
      }
      token = try peekToken()
    }

    if elementsNode.nodes.count > 0 {
      node.elements = elementsNode
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
      propertiesNode.nodes.append(property)
      token = try peekToken()
    } while true
    
    return propertiesNode
  }
  
  /// values := (value)*
  func parseValues() throws -> ValuesNode {
    var token = try expected(tokenType: .value)

    var valuesNode = ValuesNode()

    repeat {
      guard token.type == .value else {
        break
      }
      let value = try parseValue()
      valuesNode.nodes.append(value)
      token = try peekToken()
    } while true
    
    return valuesNode
  }
  
  /// property ::= propertyName: propertyValue
  func parseProperty() throws -> PropertyNode {
    var token = try expected(tokenType: .property)
    let propertyName = token.value
    try nextToken()

    token = try expected(tokenType: .value)
    let propertyValue = token.value
    try nextToken()

    var loc = [String: String]()
    
    token = try peekToken()
    if token.type == .propertyLocalization {
      repeat {
        guard token.type == .propertyLocalization else {
          break
        }
        
        token = try expected(tokenType: .propertyLocalization)
        let lang = token.value
        try nextToken()

        token = try expected(tokenType: .value)
        let locValue = token.value
        try nextToken()
        
        loc[lang] = locValue
        
        token = try peekToken()
      } while true
    }
    
    return PropertyNode(property: Property(name: propertyName, value: propertyValue, localizedValues: loc))
  }
  
  func parseValue() throws -> ValueNode {
    let token = try expected(tokenType: .value)
    let value = Value(value: token.value)
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
      properties = try parseProperties().nodes.map { $0.property }
      token = try peekToken()
    }

    var values = [Value]()
    
    if token.type == .value {
      values = try parseValues().nodes.map { $0.value }
      token = try peekToken()
    }
        
    let elementNode = ElementNode(element: Element(type: elementType, values: values, properties: properties))

    return elementNode
  }
  
}
