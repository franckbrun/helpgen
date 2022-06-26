//
//  NSTextCheckingResultExtension.swift
//  helpgen
//
//  Created by Franck Brun on 25/06/2022.
//

import Foundation

extension NSTextCheckingResult {
  
  func string(withRangeName rangeName: String, in str: String) -> String? {
    if let range = Range(range(withName: rangeName), in: str) {
      return String(str[range.lowerBound..<range.upperBound])
    }
    return nil
  }
  
  func string(withRangeAt rangeNum: Int, in str: String) -> String? {
    if let range = Range(range(at: rangeNum), in: str) {
      return String(str[range.lowerBound..<range.upperBound])
    }
    return nil
  }
  
}
