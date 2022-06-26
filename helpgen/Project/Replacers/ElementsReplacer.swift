//
//  ElementsReplacer.swift
//  helpgen
//
//  Created by Franck Brun on 26/06/2022.
//

import Foundation

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
  
  override func value(for match: NSTextCheckingResult, in str: String) -> String? {
    
    // parse properties !
    
    
    return nil
  }
}
