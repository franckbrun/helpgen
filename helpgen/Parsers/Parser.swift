//
//  Parser.swift
//  helpgen
//
//  Created by Franck Brun on 23/06/2022.
//

import Foundation

enum ParserError: Error {
  case indexOutOfRange
  case unexpectedToken(Token)
  case unexpectedEnd
}

extension ParserError: LocalizedError {
  public var errorDescription: String? {
    switch self {
    case .indexOutOfRange:
      return "index out of range"
    case .unexpectedToken(let token):
      return "unexpected token \(token)"
    case .unexpectedEnd:
      return "unexpected end"
    }
  }
}

class Parser {
  
  var tokens: [Token]
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
    return self.tokens[index]
  }
  
  @discardableResult
  func prevToken(_ number: Int = 1) throws -> Token {
    if index - number < 0 {
      throw ParserError.indexOutOfRange
    }
    index -= number
    return self.tokens[index]
  }
  
  func peekToken() throws -> Token {
    if index >= tokens.count {
      throw ParserError.unexpectedEnd
    }
    return self.tokens[index]
  }
  
  func removeToken(_ number: Int = 1) throws {
    for _ in 0..<number {
      tokens.remove(at: self.index)
    }
  }
  
  func insertTokens(_ tokens: [Token]) throws {
    self.tokens.insert(contentsOf: tokens, at: self.index)
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
