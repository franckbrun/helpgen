//
//  ParseHelpSourceFileStep.swift
//  helpgen
//
//  Created by Franck Brun on 24/06/2022.
//

import Foundation

class ParseHelpSourceFileStep: BuildStep {
  
  let helpSourceFile: HelpSourceFile
  
  init(_ helpSourceFile: HelpSourceFile) {
    self.helpSourceFile = helpSourceFile
  }
  
  func exec() throws {
    let contents = String(decoding: self.helpSourceFile.filePath)
    let lexer = HelpSourceLexer(options: [.discardWhiteSpace])
    let tokens = lexer.tokenise(input: contents)
    let parser = HelpSourceParser(tokens)
    self.helpSourceFile.node = try parser.parse()
  }
  
}
