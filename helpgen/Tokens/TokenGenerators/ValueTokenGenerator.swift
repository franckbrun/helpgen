//
//  ValueTokenGenerator.swift
//  helpgen
//
//  Created by Franck Brun on 23/06/2022.
//

import Foundation

class ValueTokenGenerator: TokenGenerator {
  
  let expression = #"^(?<value>[^\s]*)"#
  
  override func tokenise(str: String) -> Token? {
    if let matches = matches(expression: expression, str: str) {
      if let token = valueTokenFor(match: matches[0], in: str) {
        return token
      }
    }
    return nil
  }
  
  func valueTokenFor(match: NSTextCheckingResult, in str: String) -> Token? {
    if let matchRange = Range(match.range, in: str), let range = Range(match.range(withName: "value"), in: str) {
      let element = String(str[matchRange.lowerBound..<matchRange.upperBound])
      let value = String(str[range.lowerBound..<range.upperBound])
      if element.isEmpty {
        return nil
      }
      let transformedValue = value.trimmed().unescaped()
      return Token(.value, value: transformedValue, element: element)
    }
    return nil
  }
  
}
