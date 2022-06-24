//
//  WhiteSpacesListTokenGenerator.swift
//  helpgen
//
//  Created by Franck Brun on 23/06/2022.
//

import Foundation

class WhiteSpacesListTokenGenerator: TokenGenerator {
  
  let expression = "[ \t\n]*"
  
  override func tokenise(str: String) -> Token? {
    if let match = match(expression: self.expression, str: str) {
      var token = Token(.whiteSpace, element: match)
      token.isDiscardable = self.discardable
      return token
    }    
    return nil
  }

}
