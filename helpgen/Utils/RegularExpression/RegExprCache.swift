//
//  RegExprCache.swift
//  helpgen
//
//  Created by Franck Brun on 25/06/2022.
//

import Foundation

class RegExprCache: RegExprMatchable {
  
  static var shared = RegExprCache()
  
  var expressions = [String : NSRegularExpression]()
  
  private init() {}
  
  func regexpr(for expression: String) -> NSRegularExpression? {
    let regexpr: NSRegularExpression
    if let r = expressions[expression] {
      regexpr = r
    } else {
      do {
        regexpr = try NSRegularExpression(pattern: expression)
        expressions[expression] = regexpr
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
