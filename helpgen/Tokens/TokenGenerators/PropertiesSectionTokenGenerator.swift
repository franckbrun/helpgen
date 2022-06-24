//
//  PropertiesSectionTokenGenerator.swift
//  helpgen
//
//  Created by Franck Brun on 23/06/2022.
//

import Foundation

class PropertiesSectionTokenGenerator : TokenGenerator {
  
  let expression = "---"
  
  override func tokenise(str: String) -> Token? {
    if let match = match(expression: self.expression, str: str) {
      return Token(.propertiesSection, element: match)
    }
    return nil
  }
}
