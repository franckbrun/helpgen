//
//  StringExtension.swift
//  helpgen
//
//  Created by Franck Brun on 28/06/2022.
//

import Foundation

extension String {
  func deletingPrefix(_ prefix: String) -> String {
    guard self.hasPrefix(prefix) else { return self }
    return String(self.dropFirst(prefix.count))
  }
  
  func trimmed() -> String {
    let components = self.split(separator: "\n")
    return components
      .map({ $0.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) })
      .joined(separator: " ")
  }
  
  func unescaped() -> String {
    lazy var replacements:[(of: String, with: String)] = [
      (of: "\\0", with: ""),
      (of: "\\\\", with: "\\"),
      (of: "\\t", with: "\t"),
      (of: "\\n", with: "\n"),
      (of: "\\r", with: "\r"),
      (of: "\\\"", with: "\""),
      (of: "\\'", with: "\'"),
    ]
    var formattedString = self
    for replacement in replacements {
      formattedString = formattedString.replacingOccurrences(of: replacement.of, with: replacement.with)
    }
    return formattedString
  }
  
  func hasValidDigit() -> Bool {
    guard !isEmpty else {
      return false
    }
    
    return CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: self))
  }
  
}
