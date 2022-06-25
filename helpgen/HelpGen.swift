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
    abstract: "Apple Help Book Genegator",
    version: "0.1",
    subcommands: [Build.self, Create.self],
    defaultSubcommand: Build.self)  
}
