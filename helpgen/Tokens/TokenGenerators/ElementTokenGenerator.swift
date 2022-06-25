//
// ElementTokenGenerator.swift
//  helpgen
//
//  Created by Franck Brun on 23/06/2022.
//

import Foundation

class ElementTokenGenerator: TokenGenerator {
  
  let expression = "^\\/(?<elementName>[a-zA-Z][a-zA-Z0-9_]*)"
  
  override func tokenise(str: String) -> Token? {
    if let matches = matches(expression: self.expression, str: str), matches.count > 0 {
      let match = matches[0]
      if let matchRange = Range(match.range, in: str), let range = Range(match.range(withName: "elementName"), in: str) {
        let element = String(str[matchRange.lowerBound..<matchRange.upperBound])
        let elementName = String(str[range.lowerBound..<range.upperBound])
        return Token(.element, value: elementName, element: element)
      }
    }
    return nil
  }
}
