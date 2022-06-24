//
//  PropertyTokenGenerator.swift
//  helpgen
//
//  Created by Franck Brun on 23/06/2022.
//

import Foundation

class PropertyTokenGenerator: TokenGenerator {
  
  let expression = "(?<propertyName>[a-zA-Z_][a-zA-Z0-9_]*):"
  
  override func tokenise(str: String) -> Token? {
    if let matches = matches(expression: self.expression, str: str), matches.count > 0 {
      let match = matches[0]
      if let matchRange = Range(match.range, in: str), let range = Range(match.range(withName: "propertyName"), in: str) {
        let element = String(str[matchRange.lowerBound..<matchRange.upperBound])
        let propertyName = String(str[range.lowerBound..<range.upperBound])
        return Token(.property, value: propertyName, element: element)
      }
    }
    return nil
  }
}
