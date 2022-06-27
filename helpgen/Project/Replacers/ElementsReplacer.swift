//
//  ElementsReplacer.swift
//  helpgen
//
//  Created by Franck Brun on 26/06/2022.
//

import Foundation

enum ElementReplacerError: Error {
  case missingElementType
  case unknownElementType(String)
}

/// Element are specified with %{elementName:<element properties query>}%
/// elementsexprt ::= elementtypeexpr ':' (propertyQuery)
/// elementtypeexpr ::= element | elements | text | image
/// properties query ::= (propertyName=propertyvalue)
/// propertyName ::= type | name | lang
/// if text or image, type is not used
class ElementsReplacer<S: LocalizedPropertyQueryable & ElementQueryable, T: ValueTransformable>: PropertiesReplacer<S, T> {

  let multiplesElements = "elements"
  
  override var searchRegExpr: String {
    "%\\{\(RegExprConstant.elementQueryRegExpr)\\}%"
  }
  
  override func value(for match: NSTextCheckingResult, in str: String) throws -> String? {
    
    // Element type key
    guard let elementTypeNamed = match.string(withRangeName: RegExprConstant.ElementTypeKey, in: str) else {
      throw ElementReplacerError.missingElementType
    }
    
    var elementType: ElementType?
    var elementName: String?
    var language = self.project.currentLanguage

    // Element type
    if elementTypeNamed != multiplesElements {
      elementType = ElementType(rawValue: elementTypeNamed)
      if elementType == nil {
        throw ElementReplacerError.unknownElementType(elementTypeNamed)
      }
    }
    
    // Other properties
    if let propertiesString = match.string(withRangeName: RegExprConstant.PropertiesNameKey, in: str) {
      let properties = Property.parseList(from: propertiesString)
      if let nameProperty = properties.find(propertyName: Constants.NamePropertyKey) {
        elementName = nameProperty.value
      }
      if let languageProperty = properties.find(propertyName: Constants.LanguagePropertyKey) {
        language = languageProperty.value
      }
    }
    
    let elements = source.element(type: elementType, name: elementName, language: language)
    
    var replacementString = ""
    
    for element in elements {
      if let value = try self.valueTransformer.transform(element: element) {
        replacementString.append(value)
      }
    }
    
    return replacementString.isEmpty ? nil : replacementString
  }
}
