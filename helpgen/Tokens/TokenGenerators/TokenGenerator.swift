//
//  TokenGenerator.swift
//  helpgen
//
//  Created by Franck Brun on 23/06/2022.
//

import Foundation

class TokenGenerator {
  
  static var expressions = [String : NSRegularExpression]()
  
  var discardable: Bool
  
  init (discardable: Bool = false) {
    self.discardable = discardable
  }
  
  func tokenise(str: String) -> Token? {
    return nil
  }

  func regexpr(for expression: String) -> NSRegularExpression? {
    let regexpr: NSRegularExpression
    if let r = TokenGenerator.expressions[expression] {
      regexpr = r
    } else {
      do {
        regexpr = try NSRegularExpression(pattern: "^\(expression)")
        TokenGenerator.expressions[expression] = regexpr
      } catch let error {
        loge("invalid expression: \(error.localizedDescription)")
        return nil
      }
    }
    return regexpr
  }
  
  func match(expression: String, str: String) -> String? {
    guard let regexpr = regexpr(for: expression) else {
      return nil
    }
    let range = regexpr.rangeOfFirstMatch(in: str, options: [], range: NSRange(str.startIndex..<str.endIndex, in: str))
    if range.location != NSNotFound && range.length > 0 {
      if let r = Range(range, in: str) {
        return String(str[r.lowerBound..<r.upperBound])
      }
    }
    
    return nil
  }
  
  func matches(expression: String, str: String) -> [NSTextCheckingResult]? {
    guard let regexpr = regexpr(for: expression) else {
      return nil
    }
    return regexpr.matches(in: str, options: [], range: NSRange(str.startIndex..<str.endIndex, in: str))
  }
  
}
