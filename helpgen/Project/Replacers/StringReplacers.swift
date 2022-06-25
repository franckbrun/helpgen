//
//  StringReplacers.swift
//  helpgen
//
//  Created by Franck Brun on 25/06/2022.
//

import Foundation

protocol StringReplacers {
  associatedtype S: Any
  
  var replacers: [StringReplacer<S>] { get }
  
  func changeValue(in str: String) throws -> String?
  
}

extension StringReplacers {
  
  func changeValue(in str: String) throws -> String? {
    // FIXME: find something other
    var hasChanges = false
    var formattedString = str
    for replacer in replacers {
      if let newValue = try replacer.replace(in: formattedString) {
        formattedString = newValue
        hasChanges = true
      }
    }
    return hasChanges ? formattedString : nil
  }

}
