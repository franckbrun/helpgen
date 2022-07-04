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
        throw ParserError.unexceptedToken(token)
      }
      token = try peekToken()
    }
    
    return HelpSourceNode(properties: properties, elements: elements)
  }
  
  /// propertiesSection ::= --- properties ---
  func parsePropertiesSection() throws -> [PropertyNode] {

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
  func parseProperties() throws -> [PropertyNode] {
    var token = try expected(tokenType: .property)

    var propertiesNode = [PropertyNode]()

    repeat {
      guard token.type == .property else {
        break
      }
      let property = try parseProperty()
      propertiesNode.append(property)
      token = try peekToken()
    } while true
    
    return propertiesNode
  }
  
  /// values := (value)*
  func parseValues() throws -> [ValueNode] {
    var token = try expected(tokenType: .value)

    var valuesNode = [ValueNode]()

    repeat {
      guard token.type == .value else {
        break
      }
      let value = try parseValue()
      valuesNode.append(value)
      token = try peekToken()
    } while true
    
    return valuesNode
  }
  
  func parsePropertyLocalization() throws -> PropertyLocalisationNode {
    let token = try expected(tokenType: .propertyLocalization)
    let localization = token.value
    try nextToken()

    let valueNode = try parseValue()

    return PropertyLocalisationNode(localization: localization, value: valueNode)
  }
  
  /// property ::= propertyName: propertyValue
  func parseProperty() throws -> PropertyNode {
    var token = try expected(tokenType: .property)
    let propertyName = token.value
    try nextToken()

    let valueNode = try parseValue()

    var loc: [PropertyLocalisationNode]?
    
    token = try peekToken()
    if token.type == .propertyLocalization {
      repeat {
        guard token.type == .propertyLocalization else {
          break
        }
        
        let node = try parsePropertyLocalization()
        if loc == nil {
          loc = [PropertyLocalisationNode]()
        }
        loc?.append(node)
                
        token = try peekToken()
      } while true
    }
    
    return PropertyNode(name: propertyName, value: valueNode, localization: loc)
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
    let elementTypeName = token.value
    token = try nextToken()
    
    var properties: [PropertyNode]?
    
    if token.type == .property {
      properties = try parseProperties()
      token = try peekToken()
    }

    var values: [ValueNode]?
    
    if token.type == .value {
      values = try parseValues()
      token = try peekToken()
    }
        
    let elementNode = ElementNode(elementTypeName: elementTypeName, values: values, properties: properties)

    return elementNode
  }
  
}
