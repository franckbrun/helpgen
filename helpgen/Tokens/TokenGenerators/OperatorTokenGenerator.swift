//
//  OperatorTokenGenerator.swift
//  helpgen
//
//  Created by Franck Brun on 23/06/2022.
//

import Foundation

class OperatorTokenGenerator: TokenGenerator {
  
  //let expression = "[+\\-\\*=\\/]{1}"
  let expression = "[=:]{1}"
  
  lazy var tokens: [String : Token] = {
    return [
      "=" : Token.equal(),
      ":" : Token.colon(),
    ]
  }()
  
  override func tokenise(str: String) -> Token? {
    if let match = match(expression: self.expression, str: str) {
      if let token = tokens[match] {
        return token
      }
      return Token(.other, element: match)
    }
    return nil
  }
}
