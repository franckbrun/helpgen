//
//  MacroTokenGenerator.swift
//  helpgen
//
//  Created by Franck Brun on 13/07/2022.
//

import Foundation

class MacroTokenGenerator: TokenGenerator {
  
  let expression = "^!(?<macroName>[a-zA-Z][a-zA-Z0-9_]*)"
  
  override func tokenise(str: String) -> Token? {
    if let matches = matches(expression: self.expression, str: str), matches.count > 0 {
      let match = matches[0]
      if let matchRange = Range(match.range, in: str), let range = Range(match.range(withName: "macroName"), in: str) {
        let element = String(str[matchRange.lowerBound..<matchRange.upperBound])
        let name = String(str[range.lowerBound..<range.upperBound])
        return Token(.macro, value: name, element: element)
      }
    }
    return nil
  }
  
}
