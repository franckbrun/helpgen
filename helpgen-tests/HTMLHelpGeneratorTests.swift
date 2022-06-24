//
//  HTMLHelpGeneratorTests.swift
//  helpgen-tests
//
//  Created by Franck Brun on 24/06/2022.
//

import XCTest
import SystemPackage

class HTMLHelpGeneratorTests: XCTestCase {
  
  override func setUpWithError() throws {
  }
  
  override func tearDownWithError() throws {
  }
  
  func testGenerator() throws {
    Logger.currentLevel = .all
    
    let project = Project("test_project")
    let sourceFile = HelpSourceFile(path: FilePath("test.helpsource"))
    let generator = HTMLHelpGenerator<HelpSourceFile>(project: project, sourceFile: sourceFile)

    do {
      let result = try generator.generate()
      
    } catch let error {
      XCTFail(error.localizedDescription)
    }
  }
  
}
