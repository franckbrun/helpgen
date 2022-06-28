//
//  BuildCommand.swift
//  helpgen
//
//  Created by Franck Brun on 23/06/2022.
//

import Foundation
import SystemPackage
import ArgumentParser

struct BuildCommand: ParsableCommand {
  
  static var configuration = CommandConfiguration(commandName: "build")

  struct Options: ParsableArguments {
    @OptionGroup
    var common: CommonOptions
    
    @Option(name: [.customShort("i"), .long], help: "Input folders")
    var inputFolders: [String]
  }
  
  @OptionGroup var options: Options
  
  func run() throws {
    // Create project folder if not exists
    try runCreateCommand()
    
    // Create project
    let project = Project(self.options.common.projectName)
  
    // Add inputs files
    for input in self.options.inputFolders {
      project.includeFiles(in: FilePath(input))
    }
    
    let projectFolderPath = Config.currentPath.appending(self.options.common.outputFolder).appending(project.filename)

    let storage = try FileSystemWrapper(rootPath: projectFolderPath)
    
    let builder = ProjectBuilder(project: project, storage: storage)
    logi("Builing project '\(project.name)' at '\(projectFolderPath)'...")

    do {
      try storage.initialize()
      defer { try! storage.finalize() }
      try builder.build(at: projectFolderPath)
    } catch let error {
      loge("error while builing project: \(error.localizedDescription)")
      throw ExitCode.failure
    }
  }
  
  func runCreateCommand() throws {
    var args: [String] = [
      "-p", self.options.common.projectName,
      "-o", self.options.common.outputFolder
    ]
    
    for lang in self.options.common.languages {
      args.append(contentsOf: ["-l", lang])
    }
    
    args.append("--overwrite")
    
    let command = try CreateCommand.parse(args)
    try command.run()
  }
  
}


