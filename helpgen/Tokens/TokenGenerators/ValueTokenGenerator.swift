//
//  ValueTokenGenerator.swift
//  helpgen
//
//  Created by Franck Brun on 23/06/2022.
//

import Foundation

class ValueTokenGenerator: TokenGenerator {
  
  let expression = "^(?<value>[a-zA-Z0-9_\\-\\/]*)"
  
  override func tokenise(str: String) -> Token? {
    if let matches = matches(expression: self.expression, str: str), matches.count > 0 {
      let match = matches[0]
      if let matchRange = Range(match.range, in: str), let range = Range(match.range(withName: "value"), in: str) {
        let element = String(str[matchRange.lowerBound..<matchRange.upperBound])
        let value = String(str[range.lowerBound..<range.upperBound])
        if element.isEmpty {
          return nil
        }
        return Token(.value, value: value, element: element)
      }
    }
    return nil
  }
}
