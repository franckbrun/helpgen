//
//  BuildCommand.swift
//  helpgen
//
//  Created by Franck Brun on 23/06/2022.
//

import Foundation
import System
import ArgumentParser

struct BuildCommand: ParsableCommand {
  
  static var configuration = CommandConfiguration(commandName: "build")

  struct Options: ParsableArguments {
    @OptionGroup
    var common: CommonOptions
    
    @Option(name: [.customShort("i"), .long], help: "Input folder")
    var inputFolder: String
    
    @Flag(inversion: .prefixedNo)
    var index = true
  }
  
  @OptionGroup var options: Options
  
  func run() throws {
    
    if self.options.common.dryRun {
      print(self.options)
      return
    }
    
    // Create project
    let project = Project(self.options.common.projectName)
    
    // Languages
    project.languages = OptionsHelper.languages(from: self.options.common.languages)

    // Add inputs files from input folder
    project.inputFolder = FilePath(self.options.inputFolder)

    let projectFolderPath = Config.currentPath.pushing(FilePath(self.options.common.outputFolder)).appending(project.filename)

    let storage = try StorageHelper.createStorage(rootPath: projectFolderPath, overwrite: self.options.common.overwrite)

    let builder = ProjectBuilder(project: project, storage: storage)
    logi("Builing project '\(project.name)' at '\(projectFolderPath)'...")

    do {
      try storage.initialize()
      defer { try! storage.finalize() }
      try builder.build(at: projectFolderPath)
    } catch StorageError.alreadyExists {
      logi("Project already exists at '\(projectFolderPath)'")
      throw ExitCode.failure
    } catch let error {
      loge("error while builing project: \(error.localizedDescription)")
      throw ExitCode.failure
    }
  }
    
}


