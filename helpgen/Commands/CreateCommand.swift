//
//  CreateCommand.swift
//  helpgen
//
//  Created by Franck Brun on 25/06/2022.
//

import Foundation
import System
import ArgumentParser

struct CreateCommand: ParsableCommand {
  
  static var configuration = CommandConfiguration(commandName: "create")

  struct Options: ParsableArguments {
    @OptionGroup
    var common: CommonOptions    
  }

  @OptionGroup var options: Options
  
  func run() throws {
    
    // Create project
    let project = Project(self.options.common.projectName)
    
    // Languages
    project.languages = OptionsHelper.languages(from: self.options.common.languages)
        
    let projectFolderPath = Config.currentPath.pushing(FilePath(self.options.common.outputFolder)).appending(project.filename)

    let storage = try StorageHelper.createStorage(rootPath: projectFolderPath, overwrite: self.options.common.overwrite)
        
    let builder = ProjectBuilder(project: project, storage: storage)
    logi("Creating project '\(project.name)' at '\(projectFolderPath)'")

    do {
      try storage.initialize()
      defer { try! storage.finalize() }
      try builder.create(at: projectFolderPath)
    } catch StorageError.alreadyExists {
      logi("Project already exists at '\(projectFolderPath)'")
      throw ExitCode.failure
    } catch let error {
      loge("error while create project: \(error.localizedDescription)")
      throw ExitCode.failure
    }
  }

}
