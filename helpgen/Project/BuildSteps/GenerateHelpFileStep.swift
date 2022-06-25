//
//  GenerateHelpFileStep.swift
//  helpgen
//
//  Created by Franck Brun on 24/06/2022.
//

import Foundation
import SystemPackage

class GenerateHelpFileStep: BuildStep {
  
  let project: Project
  let helpSourceFile: HelpSourceFile
  let output: FilePath
  
  init(project: Project, helpSourceFile: HelpSourceFile, output: FilePath) {
    self.project = project
    self.helpSourceFile = helpSourceFile
    self.output = output
  }
  
  func exec() throws {
    let generator = HTMLHelpGenerator<HelpSourceFile>(project: self.project, sourceFile: self.helpSourceFile)
    if let contents = try generator.generate() as? String {
      //try contents.write(toFile: output.string, atomically: true, encoding: .utf8)
    }
  }
  
}
