//
//  NSTextCheckingResultExtension.swift
//  helpgen
//
//  Created by Franck Brun on 25/06/2022.
//

import Foundation

extension NSTextCheckingResult {
  
  func string(for rangeNamed: String, in str: String) -> String? {
    if let range = Range(range(withName: rangeNamed), in: str) {
      return String(str[range.lowerBound..<range.upperBound])
    }
    return nil
  }
  
}
