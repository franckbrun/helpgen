//
//  HTMLHelpGeneratorTests.swift
//  helpgen-tests
//
//  Created by Franck Brun on 24/06/2022.
//

import XCTest
import SystemPackage

class MockSourceFile: SourceFile, PropertyQueryable {
  var filePath = FilePath("MockSourceFile")
  
  var fileType = FileType.helpSource
  
  subscript(propertyName: String) -> String? {
    switch propertyName {
    case "title":
      return "The Title of the page"
    case "apple_title":
      return "Apple Title"
    default:
      return nil
    }
  }
}

class HTMLHelpGeneratorTests: XCTestCase {
  
  override func setUpWithError() throws {
  }
  
  override func tearDownWithError() throws {
  }
  
  func testGenerator() throws {
    Logger.currentLevel = .all
    
    let project = Project("test_project")
    let source = MockSourceFile()
    let generator = HTMLHelpGenerator<MockSourceFile>(project: project, sourceFile: source)

    do {
      if let result = try generator.generate() {
        print(result)
      } else {
        XCTFail("empty result")
      }
    } catch let error {
      XCTFail(error.localizedDescription)
    }
  }
  
}
