//
//  HelpSourceCompiler.swift
//  helpgen
//
//  Created by Franck Brun on 03/07/2022.
//

import Foundation

enum CompilerError: Error {
  case unknownElementType(String)
}

extension CompilerError: LocalizedError {
  public var errorDescription: String? {
    switch self {
    case .unknownElementType(let elementTypeNamed):
      return "unknown element '\(elementTypeNamed)'"
    }
  }
}


class HelpSourceCompiler {
  
  let helpSourceFile: HelpSourceFile
  
  init(helpSourceFile: HelpSourceFile) {
    self.helpSourceFile = helpSourceFile
  }
  
  func compile() throws -> HelpSourceObject {
    let contents = try String(contentsOfFile: helpSourceFile.filePath.string)
    let lexer = HelpSourceLexer(options: [.discardWhiteSpace, .discardComments])
    var tokens = lexer.tokenise(input: contents)
    tokens = try HelpSourceMacroProcessor(tokens, basePath: self.helpSourceFile.filePath.removingLastComponent()).processMacro()
    let parser = HelpSourceParser(tokens)
    let node = try parser.parse()
    return try compile(node: node)
  }
  
  func compile(node: HelpSourceNode) throws -> HelpSourceObject {
    let properties = node.properties?.compactMap({ propertyNode in
      Property.from(propertyNode: propertyNode)
    })
    
    let elements = try node.elements?.compactMap({ elementNode in
      try Element.from(elementNode: elementNode)
    })
    
    return HelpSourceObject(properties: properties, elements: elements)
  }
  
}

extension String {
  
  static func from(valueNode node: ValueNode) -> String {
    return node.value
  }
  
}

extension Value {
  
  static func from(valueNode node: ValueNode) -> Value {
    return Value(value: node.value)
  }
  
}

extension PropertyLocalization {
  
  static func from(propertyLocalizationNode node: PropertyLocalisationNode) -> PropertyLocalization? {
    return PropertyLocalization(lang: node.localization, value: String.from(valueNode: node.value))
  }
  
}

extension Property {
  
  static func from(propertyNode node: PropertyNode) -> Property? {
    let propertyName = node.name
    let propertyValue = String.from(valueNode: node.value)
    let propertylocalizations = node.localization?.compactMap({ propertyLocalisationNode in
      return PropertyLocalization.from(propertyLocalizationNode: propertyLocalisationNode)
    })
    
    return Property(name: propertyName, value: propertyValue, localizedValues: propertylocalizations)
  }
  
}

extension Element {
  
  static func from(elementNode: ElementNode) throws -> Element? {
    guard let elementType = ElementType(rawValue: elementNode.elementTypeName) else {
      throw CompilerError.unknownElementType(elementNode.elementTypeName)
    }
    let values = elementNode.values?.compactMap({ valueNode in
      Value.from(valueNode: valueNode)
    })
    var properties = elementNode.properties?.compactMap({ propertyNode in
      Property.from(propertyNode:propertyNode)
    })
    
    var features = ElementFeatures()
    if let explicitProperty = properties?.find(propertyName: Constants.ExplicitPropertyKey),
       let boolValue = Bool(explicitProperty.value),
       boolValue {
      features.insert(.explicit)
      properties?.removeAll(where: { $0 == explicitProperty })
    }
    
    var elementName: String?
    if let nameProperty = properties?.find(propertyName: Constants.NamePropertyKey) {
      elementName = nameProperty.value
      properties?.removeAll(where: { $0 == nameProperty })
    }
        
    return Element(type: elementType, features: features, name: elementName, values: values, properties: properties)
  }
  
}
