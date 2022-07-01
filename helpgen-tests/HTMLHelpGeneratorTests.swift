//
//  HTMLHelpGeneratorTests.swift
//  helpgen-tests
//
//  Created by Franck Brun on 24/06/2022.
//

import XCTest
import System

class MockSourceFile: SourceFile, PropertyQueryable, ElementQueryable {
  var filePath = FilePath("MockSourceFile")
  
  var fileType = FileType.helpSource
  
  func property(named propertyName: String) -> Property? {
    switch propertyName {
    case "title":
      return Property(name:"title", value:"The Title of the page")
    case "apple_title":
      return Property(name:"apple_title", value:"Apple Title")
    default:
      return nil
    }
  }
  
  func element(type: ElementType?, name: String?, language: String?, limit: Int = 0) -> [Element] {
    return [Element]()
  }
  
}

class NullStorage: StorageWrappable {
  func initialize() throws {
  }
  
  func finalize() throws {
  }
  
  func createFolder(at path: FilePath, withIntermediateDirectories: Bool) throws {
  }
  
  func createFile(at path: FilePath, contents: String) throws {
  }
  
  func fileExists(at path: FilePath, isDirectory: inout Bool) throws -> Bool {
    false
  }
  
  func fileExists(at path: FilePath) throws -> Bool {
    false
  }
  
  func write(to path: FilePath, contents: Data) throws {
  }
  
  func removeFile(at path: FilePath) throws {
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
    let valueTransformer = HTMLValueTransform(project: project)
    let generator = HTMLHelpGenerator(project: project, sourceFile: source, valueTransformer: valueTransformer)

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
