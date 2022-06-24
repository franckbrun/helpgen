//
//  helpgen_tests.swift
//  helpgen-tests
//
//  Created by Franck Brun on 23/06/2022.
//

import XCTest

class HelpSourcesLexerTest: XCTestCase {
  
  override func setUpWithError() throws {
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDownWithError() throws {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }
  
  func testHelpSourceLexer_simple() throws {
    let lexer = HelpSourceLexer()

    // MARK: Empty file
    
    var content =
"""
"""
    var tokens = lexer.tokenise(input: content)
    var expectedTokens = [
      Token.end()
    ]
    XCTAssert(tokens == expectedTokens)

    // MARK: Empty properties file
    
    content =
"""
---
---
"""
    tokens = lexer.tokenise(input: content)
    expectedTokens = [
      Token.propertiesSection(),
      Token.whiteSpace("\n"),
      Token.propertiesSection(),
      Token.end()
    ]
    
    XCTAssert(tokens == expectedTokens)
  }

  func testHelpSourceLexer_properties() {
    let lexer = HelpSourceLexer()

    var content = ""
    var tokens = [Token]()
    var expectedTokens = [Token]()
    
    // MARK: one property
    
    content =
"""
---
property:value
---
"""
    tokens = lexer.tokenise(input: content)
    expectedTokens = [
      Token.propertiesSection(),
      Token.whiteSpace("\n"),
      Token.property("property"),
      Token.value("value"),
      Token.whiteSpace("\n"),
      Token.propertiesSection(),
      Token.end()
    ]
    
    XCTAssert(tokens == expectedTokens)
    
    // MARK: multiples properties
    
    content =
"""
---
property1:value1
property2:value2
---
"""
    tokens = lexer.tokenise(input: content)
    expectedTokens = [
      Token.propertiesSection(),
      Token.whiteSpace("\n"),
      Token.property("property1"),
      Token.value("value1"),
      Token.whiteSpace("\n"),
      Token.property("property2"),
      Token.value("value2"),
      Token.whiteSpace("\n"),
      Token.propertiesSection(),
      Token.end()
    ]
    
    XCTAssert(tokens == expectedTokens)

  }
  
  func testHelpSourceLexer_elements() {
    let lexer = HelpSourceLexer()

    var content = ""
    var tokens = [Token]()
    var expectedTokens = [Token]()
    
    content =
"""
/i name:test_i property01:value_01
"""
    tokens = lexer.tokenise(input: content)
    expectedTokens = [
      Token.element("i"),
      Token.whiteSpace(" "),
      Token.property("name"),
      Token.value("test_i"),
      Token.whiteSpace(" "),
      Token.property("property01"),
      Token.value("value_01"),
      Token.end()
    ]
    
    XCTAssert(tokens == expectedTokens)
    
  }
  
  func testHelpSourceLexer_complte_wo_whitespaces() {
    let lexer = HelpSourceLexer(options: [.discardWhiteSpace])

    var content = ""
    var tokens = [Token]()
    var expectedTokens = [Token]()
    
    content =
"""
---
property1:value1
property2:value2
---
/i name:test_i property1:value_1
/p name:paragraph


/g
"""
    tokens = lexer.tokenise(input: content)
    expectedTokens = [
      Token.propertiesSection(),
      Token.property("property1"),
      Token.value("value1"),
      Token.property("property2"),
      Token.value("value2"),
      Token.propertiesSection(),
      Token.element("i"),
      Token.property("name"),
      Token.value("test_i"),
      Token.property("property1"),
      Token.value("value_1"),
      Token.element("p"),
      Token.property("name"),
      Token.value("paragraph"),
      Token.element("g"),
      Token.end()
    ]
    
    XCTAssert(tokens == expectedTokens)
    
  }

}
