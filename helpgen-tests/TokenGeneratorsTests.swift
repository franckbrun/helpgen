//
//  TokenGeneratorsTests.swift
//  helpgen-tests
//
//  Created by Franck Brun on 30/06/2022.
//

import XCTest

class TokenGeneratorsTests: XCTestCase {
  
  override func setUpWithError() throws {
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDownWithError() throws {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }
  
  func testValueTokenGenerator() throws {
    let generator = ValueTokenGenerator()
    
  }
  
  func testCommentGenerator() throws {
    let generator = CommentTokenGenerator()
    
    let str_1 = "#comment"
    
    let token = generator.tokenise(str: str_1)
    XCTAssert(token == Token(.comment, value: "comment", element: str_1, discardable: true))
    
  }
  
}
