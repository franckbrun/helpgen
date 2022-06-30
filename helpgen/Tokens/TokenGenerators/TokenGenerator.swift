//
//  TokenGenerator.swift
//  helpgen
//
//  Created by Franck Brun on 23/06/2022.
//

import Foundation

class TokenGenerator: RegExprMatchable {
  
  let regExprCache = RegExprCache.shared
  
  var discardable: Bool
  
  init (discardable: Bool = false) {
    self.discardable = discardable
  }
  
  func tokenise(str: String) -> Token? {
    return nil
  }

  func match(expression: String, str: String) -> String? {
    return regExprCache.match(expression: expression, str: str)
  }
  
  func matches(expression: String, str: String) -> [NSTextCheckingResult]? {
    if let matches = regExprCache.matches(expression: expression, str: str) {
      return matches.count > 0 ? matches : nil
    }
    return nil
  }
  
}
