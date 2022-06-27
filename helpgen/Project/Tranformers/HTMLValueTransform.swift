//
//  HTMLValueTransform.swift
//  helpgen
//
//  Created by Franck Brun on 27/06/2022.
//

import Foundation

class HTMLValueTransform: ValueTransformable {
  
  let project: Project
  
  init(project: Project) {
    self.project = project
  }
  
  /// Only return value of property
  func tranform(property: Property) throws -> String? {
    return property.value
  }
  
  /// Return HTML tag for the element
  func transform(element: Element) throws -> String? {
//    switch element.type {
//    }
    return nil
  }
  
}
