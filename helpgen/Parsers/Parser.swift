//
//  Parser.swift
//  helpgen
//
//  Created by Franck Brun on 23/06/2022.
//

import Foundation

enum ParserError: Error {
  case unexceptedToken(Token)
  case unexceptedEnd
  case unknownElementType(Token)
  case notImplemented(String)
}

extension ParserError: LocalizedError {
  public var errorDescription: String? {
    switch self {
    case .unexceptedToken(let token):
      return "unexcepted token \(token)"
    case .unexceptedEnd:
      return "unexcepted end"
    case .unknownElementType(let token):
      return "unknownElementType in \(token)"
    case .notImplemented(let method):
      return "\(method) is not implemented"
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
      throw ParserError.unexceptedEnd
    }
    index += 1
    let token = self.tokens[index]
    return token
  }
  
  func peekToken() throws -> Token {
    if index >= tokens.count {
      throw ParserError.unexceptedEnd
    }
    return self.tokens[index]
  }
  
  @discardableResult
  func expected(tokenType type:TokenType) throws -> Token {
    let currentToken = try peekToken()
    guard currentToken.type == type else {
      throw ParserError.unexceptedToken(currentToken)
    }
    return currentToken
  }
}
