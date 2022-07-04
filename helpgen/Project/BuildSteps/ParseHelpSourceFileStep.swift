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
    let compiler = HelpSourceCompiler(helpSourceFile: self.helpSourceFile)
    let object = try compiler.compile()
    helpSourceFile.object = object
  }
  
}
