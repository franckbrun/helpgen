//
//  HTMLHelpGeneratorTests.swift
//  helpgen-tests
//
//  Created by Franck Brun on 24/06/2022.
//

import XCTest
import SystemPackage

class MockSourceFile: SourceFile, LocalizedPropertyQueryable, ElementQueryable {
  var filePath = FilePath("MockSourceFile")
  
  var fileType = FileType.helpSource
  
  func property(named propertyName: String, language lang: String) -> Property? {
    switch propertyName {
    case "title":
      return Property(name:"title", value:"The Title of the page")
    case "apple_title":
      return Property(name:"apple_title", value:"Apple Title")
    default:
      return nil
    }
  }
  
  func element(type: ElementType, name: String, language: String) -> [ElementNode] {
    return [ElementNode]()
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