//
//  ApplyGlobalPropertiesStep.swift
//  helpgen
//
//  Created by Franck Brun on 24/06/2022.
//

import Foundation

protocol SourcePropertiesQueryable {
  
  func projectProperties() -> [Property]?
  func sourceProperties() -> [Property]?
  
}

class ApplyGlobalPropertiesStep<T: SourcePropertiesQueryable>: BuildStep {
  
  let project: Project
  let source: T
  
  init(project: Project, source: T) {
    self.project = project
    self.source = source
  }
  
  func exec() throws {
    if let properties = source.projectProperties() {
      for property in properties {
        project.properties[property.name] = property
      }
    }
  }
  
}
