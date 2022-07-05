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
      return try anchor(with: element)
    case .link:
      return try link(with: element)
    case .helplink:
      return try helpLink(with: element)
    case .video:
      return try video(with: element)
    case .separator:
      return try separator(with: element)
    default:
      return nil
    }
  }
  
  func paragraphTag(with element: Element) throws -> String {
    let p = SwiftSoup.Element(Tag("p"), "")
    let joinsedValue = element.values?.compactMap({$0.value}).joined(separator: " ") ?? ""
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
  
  func anchor(with element: Element) throws -> String {
    let attributes = SwiftSoup.Attributes()
    
    if let nameProperty = element.property(named: "anchor_name") {
      try attributes.put("name", nameProperty.value)
    }

    let a = SwiftSoup.Element(Tag("a"), "", attributes)
    
    let joinedValues = element.values?.compactMap({$0.value}).joined(separator: " ") ?? ""
    try a.text(joinedValues)
    
    return try a.outerHtml()
  }

  func link(with element: Element) throws -> String {
    let attributes = SwiftSoup.Attributes()

    let a = SwiftSoup.Element(Tag("a"), "", attributes)

    let joinedValues = element.values?.compactMap({$0.value}).joined(separator: " ") ?? ""
    try a.text(joinedValues)
    
    return try a.outerHtml()
  }

  func helpLink(with element: Element) throws -> String {
    var anchor_name = ""
    var book_id = ""
    
    if let nameProperty = element.property(named: "anchor_name") {
      anchor_name = nameProperty.value
    }
    
    if let bookIdProperty = element.property(named: "book_id") {
      book_id = bookIdProperty.value
    } else {
      if let bundleIdentifierProperty = project.property(named: Constants.ProjectBundleIdentifierPropertyKey) {
        book_id = bundleIdentifierProperty.value
      }
    }

    let attributes = SwiftSoup.Attributes()
    try attributes.put("href", "help:anchor=\(anchor_name) bookID=\(book_id)")

    let a = SwiftSoup.Element(Tag("a"), "", attributes)

    let joinedValues = element.values?.compactMap({$0.value}).joined(separator: " ") ?? ""
    try a.text(joinedValues)
    
    return try a.outerHtml()
  }
  
  func video(with element: Element) throws -> String {
    let videoAttributes = SwiftSoup.Attributes()
    try ["controls", "autoplay", "loop"].forEach {
      if let boolValue = element.bool(forNamedProterty: $0), boolValue {
        try videoAttributes.put($0, true)
      }
    }
    
    let sourceAttributes = SwiftSoup.Attributes()
    if let source = element.value(forNamedProterty: "src") {
      try sourceAttributes.put("src", source)
    }
    if let type = element.value(forNamedProterty: "type") {
      try sourceAttributes.put("type", type)
    }
    
    let video = SwiftSoup.Element(Tag("video"), "", videoAttributes)
    try video.appendChild(SwiftSoup.Element(Tag("source"), "", sourceAttributes))
    return try video.outerHtml()
  }

  func separator(with element: Element) throws -> String {
    let separator = SwiftSoup.Element(Tag("hr"), "")
    return try separator.outerHtml()
  }
}
