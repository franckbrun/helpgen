//
//  TemplateLexer.swift
//  helpgen
//
//  Created by Franck Brun on 14/07/2022.
//

import Foundation

// Template lexer search expression of type {{ macro_name expression }}
// These expression are evaluated and can modify the template.

class TemplateLexer: Lexer {
  
  let expression = #"((?<!\\)(\{{2}(?<macro>.*?)(?<!\\)\}{2}))"#
  
  let regExprCache = RegExprCache.shared
  
  override func tokenise(input: String) throws -> [Token] {
    var tokens = [Token]()
    
    if let matches = regExprCache.matches(expression: self.expression, str: input), matches.count > 0 {
      for match in matches {
        
      }
    } else {
      logd("no macros found")
    }
    
    return tokens
  }
  
}
