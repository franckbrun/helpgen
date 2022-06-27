//
//  EscapedString.swift
//  helpgen
//
//  Created by Franck Brun on 27/06/2022.
//

import Foundation

@propertyWrapper struct EscapedString {
  private(set) var string: String
  
  var wrappedValue: String {
    get {
      return self.string.escaped()
    }
    set {
      self.string = newValue
    }
  }
  
  init(_ string: String) {
    self.string = string
  }
  
}

extension String {
  func escaped() -> String {
    // TODO: Implement escaped string !
    return self
  }
}
