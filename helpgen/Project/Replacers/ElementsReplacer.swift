//
//  ElementsReplacer.swift
//  helpgen
//
//  Created by Franck Brun on 26/06/2022.
//

import Foundation

enum PlaceHolderElementType: String {
  case element    // Single Element
  case elements   // All elements that reponds to criteria
}

enum ElementReplacerError: Error {
  case missingElementType
  case unknownElementType(String)
}

extension ElementReplacerError: LocalizedError {
  var errorDescription: String? {
    switch self {
    case .missingElementType:
      return "missing element type"
    case .unknownElementType(let name):
      return "unknown element type '\(name)'"
    }
  }
}

/// Element are specified with %{elementName:<element properties query>}%
/// elementsexprt ::= elementtypeexpr ':' (propertyQuery)
/// elementtypeexpr ::= element | elements | text | image
/// properties query ::= (propertyName=propertyvalue)
/// propertyName ::= type | name | lang
/// if text or image, type is not used
class ElementsReplacer<S: PropertyQueryable & ElementQueryable, T: ValueTransformable>: PropertiesReplacer<S, T> {

  let multiplesElements = "elements"
  let singleElement = "element"
  
  override var searchRegExpr: String {
    "%\\{\(RegExprConstant.elementQueryRegExpr)\\}%"
  }
  
  override func value(for match: NSTextCheckingResult, in str: String) throws -> String? {
    
    // Element type key
    guard let elementTypeNamed = match.string(withRangeName: RegExprConstant.ElementTypeKey, in: str) else {
      throw ElementReplacerError.missingElementType
    }
    
    var placeholderElementType: PlaceHolderElementType?
    var elementType: ElementType?
    var elementName: String?
    var language = self.project.currentLanguage
    var searchElementType = false

    if let elementType = PlaceHolderElementType(rawValue: elementTypeNamed) {
      placeholderElementType = elementType
      searchElementType = true
    } else {
      elementType = ElementType(rawValue: elementTypeNamed)
      if elementType == nil {
        throw ElementReplacerError.unknownElementType(elementTypeNamed)
      }
    }
    
    // Other properties
    if let propertiesString = match.string(withRangeName: RegExprConstant.PropertiesNameKey, in: str) {
      let properties = Property.parseList(from: propertiesString)
      
      if searchElementType, let elementTypeProperty = properties.find(propertyName: Constants.TypePropertyKey) {
        elementType = ElementType(rawValue: elementTypeProperty.value)
        if elementType == nil {
          throw ElementReplacerError.unknownElementType(elementTypeNamed)
        }
      }
      
      if let nameProperty = properties.find(propertyName: Constants.NamePropertyKey) {
        elementName = nameProperty.value
      }
      if let languageProperty = properties.find(propertyName: Constants.LanguagePropertyKey) {
        language = languageProperty.value
      }
    }
    
    let elements = source.element(type: elementType, name: elementName, language: language, limit: (placeholderElementType == .element) ? 1 : 0)
    
    var replacementString = ""
    
    for element in elements {
      if let value = try self.valueTransformer.transform(element: element) {
        replacementString.append(value)
      }
    }
    
    return replacementString.isEmpty ? nil : replacementString
  }
}
