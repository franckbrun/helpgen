//
//  HelpSourceParserTests.swift
//  helpgen-tests
//
//  Created by Franck Brun on 24/06/2022.
//

import XCTest

class HelpSourceParserTests: XCTestCase {
  
  override func setUpWithError() throws {
  }
  
  override func tearDownWithError() throws {
  }
  
  func testEmpty() throws {
    
    let tokens = [Token.end()]
    let parser = HelpSourceParser(tokens)
    let expectedNode = HelpSourceNode(properties: nil, elements: [])
    
    do {
      let node = try parser.parse()
      XCTAssert(node == expectedNode)
    } catch {
      XCTFail()
    }
    
  }

  func testProperties() throws {
    
    let tokens = [
      Token.propertiesSection(),
      Token.property("property"),
      Token.value("value"),
      Token.propertiesSection(),
      Token.end()
    ]
    let parser = HelpSourceParser(tokens)
    let expectedNode = HelpSourceNode(properties:
                                        PropertiesNode(properties: [
                                        PropertyNode(name: "property", value: "value")
                                        ]),
                                      elements: [])
    
    do {
      let node = try parser.parse()
      XCTAssert(node == expectedNode)
    } catch let error {
      XCTFail(error.localizedDescription)
    }

  }
//  func testPerformanceExample() throws {
//    // This is an example of a performance test case.
//    self.measure {
//      // Put the code you want to measure the time of here.
//    }
//  }
  
}
