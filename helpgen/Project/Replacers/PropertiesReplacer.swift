//
//  PropertiesReplacer.swift
//  helpgen
//
//  Created by Franck Brun on 25/06/2022.
//

import Foundation

class PropertiesReplacer<S: PropertyQueryable>: StringReplacer<S> {
  
  let regExprCache = RegExprCache.shared
  
  let propertyNameValue = "property"
  
  let propertyRegExpr = "%\\{\(RegExprConstant.propertyName)\(RegExprConstant.propertyValue)\\}%"
  
  override func replace(in sourceStr: String) throws -> String? {
    if let matches = regExprCache.matches(expression: propertyRegExpr, str: sourceStr) {
      logd(matches.debugDescription)

      var hasChanges = false
      var str = sourceStr
      
      for match in matches.reversed() {
        if let propertyKey = match.string(for: RegExprConstant.propertyNameKey, in: sourceStr),
           propertyKey == propertyNameValue,
           let propertyName = match.string(for: RegExprConstant.propertyValueKey, in: sourceStr) {

          // Search property in source properties
          if let value = self.source.property(named: propertyName, language: project.currentLanguage) {
            if let range = Range(match.range, in: str) {
              str.replaceSubrange(range.lowerBound..<range.upperBound, with: value)
              hasChanges = true
            }
          }
          
        }
      }
      return hasChanges ? str : nil
    }
    return nil
  }
  
}

