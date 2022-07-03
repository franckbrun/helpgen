//
//  HelpSourceCompiler.swift
//  helpgen
//
//  Created by Franck Brun on 03/07/2022.
//

import Foundation

class HelpSourceCompiler {
  
  let helpSourceFile: HelpSourceFile
  
  init(helpSourceFile: HelpSourceFile) {
    self.helpSourceFile = helpSourceFile
  }
  
  func compile() throws -> HelpSourceObject {
    let contents = try String(contentsOfFile: helpSourceFile.filePath.string)
    let lexer = HelpSourceLexer(options: [.discardWhiteSpace, .discardComments])
    let tokens = lexer.tokenise(input: contents)
    let parser = HelpSourceParser(tokens)
    let node = try parser.parse()
    return try compile(node: node)
  }
  
  func compile(node: HelpSourceNode) throws -> HelpSourceObject {
    // TODO:
    return HelpSourceObject(properties: nil, elements: nil)
  }
  
}

extension String {
  
  static func from(value: Value) -> String {
    return value.value
  }
  
}

extension Property {
  
  static func from(propertyNode: PropertyNode) -> Property? {
    return nil
  }
  
}

extension Element {
  
  static func from(elementNode: ElementNode) -> Element? {
    return nil
  }
  
}
