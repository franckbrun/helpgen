//
//  ApplyGlobalPropertiesStep.swift
//  helpgen
//
//  Created by Franck Brun on 24/06/2022.
//

import Foundation

protocol SourcePropertiesQueryable {
  
  func globalProperties() -> PropertiesNode?
  func sourceProperties() -> PropertiesNode?
  
}

class ApplyGlobalPropertiesStep<T: SourcePropertiesQueryable>: BuildStep {
  
  let project: Project
  let source: T
  
  init(project: Project, source: T) {
    self.project = project
    self.source = source
  }
  
  func exec() throws {
    if let sourceProperties = source.globalProperties() {
      for node in sourceProperties.properties {
        project.properties[node.property.name] = node.property.value
      }
    }
  }
  
}
