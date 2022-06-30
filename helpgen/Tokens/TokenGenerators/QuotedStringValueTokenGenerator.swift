//
//  QuotedStringValueTokenGenerator.swift
//  helpgen
//
//  Created by Franck Brun on 30/06/2022.
//

import Foundation

class QuotedStringValueTokenGenerator: ValueTokenGenerator {
  
  let expressions = [
    /// Quoted string expression
    #"^"(?<value>(?:[^"\\]|\\.)*)""#,

    /// Single quote quoted string expression
    #"^'(?<value>(?:[^'\\]|\\.)*)'"#,
  ]
  
  override func tokenise(str: String) -> Token? {
    
    for expression in self.expressions {
      if let matches = matches(expression: expression, str: str), matches.count > 0 {
        if let token = valueTokenFor(match: matches[0], in: str) {
          return token
        }
      }
    }
        
    return nil
  }
    
}
