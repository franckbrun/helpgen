//
//  HelpGen.swift
//  helpgen
//
//  Created by Franck Brun on 23/06/2022.
//

import Foundation
import ArgumentParser

@main
struct HelpGen: ParsableCommand {
  static var configuration = CommandConfiguration(
    abstract: "Apple Help Book builder",
    version: "0.1",
    subcommands: [BuildCommand.self, CreateCommand.self],
    defaultSubcommand: BuildCommand.self)
  
  @Flag(name:[.short, .long], help: "Verbose")
  var verbose = false {
    didSet {
      Logger.currentLevel = .verbose
    }
  }
}
