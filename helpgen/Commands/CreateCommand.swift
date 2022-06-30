//
//  CreateCommand.swift
//  helpgen
//
//  Created by Franck Brun on 25/06/2022.
//

import Foundation
import SystemPackage
import ArgumentParser

struct CreateCommand: ParsableCommand {
  
  static var configuration = CommandConfiguration(commandName: "create")

  struct Options: ParsableArguments {
    @OptionGroup
    var common: CommonOptions
    
    @Flag(help: "Overwrite output if exists")
    var overwrite = false
  }

  @OptionGroup var options: Options
  
  func run() throws {
    
    // Create project
    let project = Project(self.options.common.projectName)
    project.languages = self.options.common.languages
        
    let projectFolderPath = Config.currentPath.appending(self.options.common.outputFolder).appending(project.filename)

    let storage = try createStorage(rootPath: projectFolderPath)
    
    if try storage.fileExists(at: projectFolderPath) {
      if !self.options.overwrite {
        logi("Project '\(project.name)' already exists at '\(projectFolderPath)'")
        return
      }
      try storage.removeFile(at: projectFolderPath)
    }
    
    let builder = ProjectBuilder(project: project, storage: storage)
    logi("Creating project '\(project.name)' at '\(projectFolderPath)'")

    do {
      try storage.initialize()
      defer { try! storage.finalize() }
      try builder.create(at: projectFolderPath)
    } catch let error {
      loge("error while create project: \(error.localizedDescription)")
      throw ExitCode.failure
    }
  }
  
  func createStorage(rootPath: FilePath) throws -> some StorageWrappable {
    var storageOptions: FileSystemWrapper.Options = []
    
    if self.options.overwrite {
      storageOptions.insert(.overwrite)
    }

    let storage = try FileSystemWrapper(rootPath: rootPath, options: storageOptions)
    return storage
  }
  
}
