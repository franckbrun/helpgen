//
//  PropertiesReplacer.swift
//  helpgen
//
//  Created by Franck Brun on 25/06/2022.
//

import Foundation

class PropertiesReplacer<S: LocalizedPropertyQueryable>: StringReplacer<S> {
  
  let regExprCache = RegExprCache.shared
  
  var searchRegExpr: String {
    "%\\{\(RegExprConstant.propertyNameRegExpr)\(RegExprConstant.propertyValueRegExpr)\\}%"
  }
  
  override func replace(in sourceStr: String) throws -> String? {
    if let matches = regExprCache.matches(expression: self.searchRegExpr, str: sourceStr) {
      logd(matches.debugDescription)

      var hasChanges = false
      var str = sourceStr
      
      for match in matches.reversed() {
        if let value = try value(for: match, in: str) {
          if let range = Range(match.range, in: str) {
            str.replaceSubrange(range.lowerBound..<range.upperBound, with: value)
            hasChanges = true
          }
        }
      }
      return hasChanges ? str : nil
    }
    return nil
  }
  
  func value(for match: NSTextCheckingResult, in str: String) throws -> String? {
    if let propertyName = match.string(withRangeName: RegExprConstant.propertyNameKey, in: str),
       let propertyValue = match.string(withRangeName: RegExprConstant.propertyValueKey, in: str) {

      return value(for: Property(name: propertyName, value: propertyValue))
    }
    return nil
  }
  
  /// search property value for type ("property:<name>")
  func value(for property: Property) -> String? {
    guard property.name == Constants.PropertyKey else {
      return nil
    }
    
    // Search property in source properties
    return self.source.property(named: property.value, language: project.currentLanguage)?.value
  }
  
}

