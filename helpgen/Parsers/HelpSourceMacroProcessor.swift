//
//  HelpSourceMacroProcessor.swift
//  helpgen
//
//  Created by Franck Brun on 13/07/2022.
//

import Foundation
import System

enum MacroParserError: Error {
  case unknownMacro(String)
}

extension MacroParserError: LocalizedError {
  var errorDescription: String? {
    switch self {
    case .unknownMacro(let name):
      return "unknown macro name '\(name)'"
    }
  }
}

enum MacroName: String {
  case include
}

class HelpSourceMacroProcessor: CommonParser {
  
  let basePath: FilePath
  
  init(_ tokens: [Token], basePath: FilePath) {
    self.basePath = basePath
    super.init(tokens)
  }
  
  func processMacro() throws -> [Token] {
    
    var token = try peekToken()
    while token != Token.end() {
      switch token.type {
      case .macro:
        let macroNode = try parseMacro()
        try apply(macro: try Macro.from(macroNode: macroNode))
      default:
        break
      }
      token = try nextToken()
    }
    
    return self.tokens
  }

  private func apply(macro: Macro) throws {
    if macro.name == .include {
      let filename = self.basePath.appending(FilePath(macro.value).components)
      let tokens = try tokens(from: filename)
      // Macro has two tokens replace them with content of helpsourcefile
      try prevToken(2)
      try removeToken(2)
      try insertTokens(tokens)
    }
  }
  
  private func tokens(from file: FilePath) throws -> [Token] {
    let contents = try String(contentsOfFile: file.string)
    let lexer = HelpSourceLexer(options: [.discardWhiteSpace, .discardComments, .noEndToken])
    let tokens = lexer.tokenise(input: contents)
    return tokens
  }
  
}

extension Macro {
  static func from(macroNode: MacroNode) throws -> Macro {
    guard let macroName = MacroName(rawValue: macroNode.name) else {
      throw MacroParserError.unknownMacro(macroNode.name)
    }
    let value = macroNode.value.value
    return Macro(name: macroName, value: value)
  }
}
