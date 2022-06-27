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
    subcommands: [Build.self, Create.self],
    defaultSubcommand: Build.self)
  
  struct Options: ParsableArguments {
    @Flag(name:[.customShort("v"), .long], help: "Verbose")
    var verbose = false {
      didSet {
        Logger.currentLevel = .verbose
      }
    }
  }
  
  @OptionGroup var options: Options
}
