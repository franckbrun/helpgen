//
//  HTMLValueTransform.swift
//  helpgen
//
//  Created by Franck Brun on 27/06/2022.
//

import Foundation
import SwiftSoup

struct HTMLConstants {
  static let ImageTag = "img"
  static let ImageSourceAttribute = "src"
}

class HTMLValueTransform: ValueTransformable {
  
  let project: Project
  
  init(project: Project) {
    self.project = project
  }
  
  /// Returns property's value
  func tranform(property: Property) throws -> String? {
    return property.value
  }
  
  /// Return HTML tag for the element
  func transform(element: Element) throws -> String? {
    switch element.type {
    case .text:
      return try paragraphTag(with: element)
    case .image:
      return try imageTag(with: element)
    case .anchor:
      fallthrough
    default:
      return nil
    }
  }
  
  func paragraphTag(with element: Element) throws -> String {
    let p = SwiftSoup.Element(Tag("p"), "")
    let joinsedValue = element.values.compactMap({$0.value}).joined(separator: " ")
    try p.text(joinsedValue)
    return try p.outerHtml()
  }
  
  func imageTag(with element: Element) throws -> String {
    let attributes = SwiftSoup.Attributes()
    
    if let sourceProperty = element.property(named: HTMLConstants.ImageSourceAttribute) {
      try attributes.put("src", sourceProperty.value)
    }
    
    let img = SwiftSoup.Element(Tag("img"), "", attributes)
    return try img.outerHtml()
  }
  
}
