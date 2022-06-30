//
//  CommentTokenGenerator.swift
//  helpgen
//
//  Created by Franck Brun on 28/06/2022.
//

import Foundation

class CommentTokenGenerator: TokenGenerator {
  
  let expression = "^#(?<comment>.*)"
  
  override func tokenise(str: String) -> Token? {
    if let matches = matches(expression: self.expression, str: str) {
      let match = matches[0]
      
      let comment = match.string(withRangeName: "comment", in: str)
      let value = match.string(withRangeAt: 0, in: str)

      var token = Token(.comment, value: comment ?? "", element: value ?? "")
      token.isDiscardable = self.discardable
      return token

    }
    return nil
  }

}
