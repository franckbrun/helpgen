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
    static let discardComments = HelpSourceLexer.Options(rawValue: 1 << 1)
  }
  
  var options: Options = []
  
  init(options: Options = []) {
    self.options = options
    super.init()
    setInitialLexer()
  }

  func setInitialLexer() {
    primaryClassExceptedTokens()
  }
  
  override func found(token: Token) {
    
  }
    
  func primaryClassExceptedTokens() {
    clear()
    add(WhiteSpacesListTokenGenerator(discardable: options.contains(.discardWhiteSpace)))
    add(PropertiesSectionTokenGenerator())
    add(PropertyTokenGenerator())
    add(ElementTokenGenerator())
    add(RawStringValueTokenGenerator())
    add(CommentTokenGenerator(discardable: options.contains(.discardComments)))
    add(QuotedStringValueTokenGenerator())
    add(ValueTokenGenerator())
  }
}
