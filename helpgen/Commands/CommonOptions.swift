//
//  CommonOptions.swift
//  helpgen
//
//  Created by Franck Brun on 27/06/2022.
//

import Foundation
import ArgumentParser

struct CommonOptions: ParsableArguments {
  @Option(name: [.customShort("p"), .long], help: "Project name")
  var projectName: String

  @Option(name: [.customShort("o"), .long], help: "Output folder")
  var outputFolder: String = "."
  
  @Option(name: [.customShort("l"), .long], help: "Langage(s)")
  var languages = [String]()
}
