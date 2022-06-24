//
//  HelpSourceLexer.swift
//  helpgen
//
//  Created by Franck Brun on 23/06/2022.
//

import Foundation

class HelpSourceLexer: Lexer {
  
  struct Options: OptionSet {
    let rawValue: Int
    
    static let discardWhiteSpace = HelpSourceLexer.Options(rawValue: 1 << 0)
  }
  
  var options: Options = []
  
  init(options: Options = []) {
    self.options = options
    super.init()
    setInitialLexer()
  }

  func setInitialLexer() {
    add(WhiteSpacesListTokenGenerator(discardable: options.contains(.discardWhiteSpace)))
    add(PropertiesSectionTokenGenerator())
    add(PropertyTokenGenerator())
    add(ElementTokenGenerator())
    add(ValueTokenGenerator())
  }
}
