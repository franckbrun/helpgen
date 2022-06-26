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
class ElementsReplacer<S: LocalizedPropertyQueryable & ElementQueryable>: PropertiesReplacer<S> {

  override var searchRegExpr: String {
    "%\\{\(RegExprConstant.elementQueryRegExpr)\\}%"
  }
  
  override func value(for match: NSTextCheckingResult, in str: String) throws -> String? {
    
    // Search Element type
    guard let elementTypeNamed = match.string(withRangeName: RegExprConstant.ElementTypeKey, in: str) else {
      throw ElementReplacerError.missingElementType
    }
    
    guard let elemenType = ElementType(rawValue: elementTypeNamed) else {
      throw ElementReplacerError.unknownElementType(elementTypeNamed)
    }
    
    var elementName = Constants.AllElementsKey
    var language = self.project.currentLanguage
    
    if let propertiesString = match.string(withRangeName: RegExprConstant.PropertiesNameKey, in: str) {
      let properties = Property.parseList(from: propertiesString)
      if let nameProperty = properties.find(propertyName: Constants.NamePropertyKey) {
        elementName = nameProperty.value
      }
      if let languageProperty = properties.find(propertyName: Constants.LanguagePropertyKey) {
        language = languageProperty.value
      }
    }
    
    let elements = source.element(type: elemenType, name: elementName, language: language)
    
    
    
    return nil
  }
}
