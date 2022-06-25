//
//  RegExprConstants.swift
//  helpgen
//
//  Created by Franck Brun on 25/06/2022.
//

import Foundation

struct RegExprConstant {
  
  static let propertyName = "(?<propertyName>[a-zA-Z_][a-zA-Z0-9_.]*):"
  static let propertyNameKey = "propertyName"

  static let propertyValue = "(?<propertyValue>[a-z0-9_]*)"
  static let propertyValueKey = "propertyValue"

}
