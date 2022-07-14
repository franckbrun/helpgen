//
//  lexer.swift
//  helpgen
//
//  Created by Franck Brun on 23/06/2022.
//

import Foundation

class Lexer {

  var tokenGenerators = [TokenGenerator]()
  
  func tokenise(input: String) throws -> [Token] {
    var tokens = [Token]()
    var content = input
    
    while !content.isEmpty {
      var match = false
      
      for tokenGenerator in self.tokenGenerators {
        if let tokenInfo = try tokenGenerator.tokenise(str: content) {
          if !tokenInfo.isDiscardable {
            tokens.append(tokenInfo)
          }
          let index = content.index(content.startIndex, offsetBy: tokenInfo.element.count)
          content = String(content[index...])
          match = true
          found(token: tokenInfo)
          break
        }
      }
      
      if !match {
        let index = content.index(content.startIndex, offsetBy: 1)
        let element = String(content[content.startIndex])
        let tokenInfo = Token(.other, element: element)
        tokens.append(tokenInfo)
        content = String(content[index...])
        found(token: tokenInfo)
      }    
    }
    
    let endToken = Token.end()
    if canAppend(token: endToken) {
      tokens.append(endToken)
    }
    
    return tokens
  }
  
  func canAppend(token: Token) -> Bool {
    return true
  }
  
  func found(token: Token) {
    
  }
  
  func clear() {
    self.tokenGenerators.removeAll()
  }
  
  func add(_ tokenGenerator: TokenGenerator) {
    self.tokenGenerators.append(tokenGenerator)
  }
  
}
