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
    let project = Project(self.options.common.projectName)
    project.languages = self.options.common.languages
    
    let projectFolderPath = Config.currentPath.appending(self.options.common.outputFolder).appending(project.filename)

    let serializer = try createSerializer(rootPath: projectFolderPath)
    
    if try serializer.fileExists(at: projectFolderPath) {
      if !self.options.overwrite {
        logi("Project '\(project.name)' already exists at '\(projectFolderPath)'")
        return
      }
      try serializer.removeFile(at: projectFolderPath)
    }
    
    let builder = ProjectBuilder(project: project, serializer: serializer)
    logi("Creating project '\(project.name)' at '\(projectFolderPath)'")

    do {
      try serializer.initialize()
      defer { try! serializer.finalize() }
      try builder.create(at: projectFolderPath)
    } catch let error {
      loge("error while create project: \(error.localizedDescription)")
      throw ExitCode.failure
    }
  }
  
  func createSerializer(rootPath: FilePath) throws -> some StorageWrappable {
    var serializerOptions: FileSystemWrapper.Options = []
    
    if self.options.overwrite {
      serializerOptions.insert(.overwrite)
    }

    let serializer = try FileSystemWrapper(rootPath: rootPath, options: serializerOptions)
    return serializer
  }
  
}
