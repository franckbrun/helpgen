//
//  Parser.swift
//  helpgen
//
//  Created by Franck Brun on 23/06/2022.
//

import Foundation

enum ParserError: Error {
  case unexpectedToken(Token)
  case unexpectedEnd
}

extension ParserError: LocalizedError {
  public var errorDescription: String? {
    switch self {
    case .unexpectedToken(let token):
      return "unexpected token \(token)"
    case .unexpectedEnd:
      return "unexpected end"
    }
  }
}

class Parser {
  
  let tokens: [Token]
  var index = 0
  
  init(_  tokens: [Token]) {
    self.tokens = tokens
  }
  
  @discardableResult
  func nextToken() throws -> Token {
    if index + 1 >= tokens.count {
      throw ParserError.unexpectedEnd
    }
    index += 1
    let token = self.tokens[index]
    return token
  }
  
  func peekToken() throws -> Token {
    if index >= tokens.count {
      throw ParserError.unexpectedEnd
    }
    return self.tokens[index]
  }
  
  @discardableResult
  func expected(tokenType type:TokenType) throws -> Token {
    let currentToken = try peekToken()
    guard currentToken.type == type else {
      throw ParserError.unexpectedToken(currentToken)
    }
    return currentToken
  }
}
