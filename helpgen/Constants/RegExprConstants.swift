//
//  RegExprConstants.swift
//  helpgen
//
//  Created by Franck Brun on 25/06/2022.
//

import Foundation

struct RegExprConstant {
  
  static let propertyNameRegExpr = "(?<propertyName>[a-zA-Z_][a-zA-Z0-9_.]*):"
  static let propertyQueryRegExpr = "(?<propertyName>[a-zA-Z_][a-zA-Z0-9_.]*)(?::(?<properties>.*))*"
  static let propertyNameKey = "propertyName"
  static let propertyValueKey = "propertyValue"

  static let elementQueryRegExpr = "(?<elementType>elements|element|text|image)(?::(?<properties>.*))*"
  static let ElementTypeKey = "elementType"
  static let PropertiesNameKey = "properties"
  
  static let QueryPropertiesRegExpr = "([^=,]+)=([^\0]+?)(?=,[^,]+=|$)"
  static let PropertiesRegExpr = "([^:,]+):([^\0]+?)(?=,[^,]+:|$)"
}

