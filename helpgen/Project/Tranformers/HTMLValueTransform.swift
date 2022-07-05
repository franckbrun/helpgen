//
//  HTMLValueTransform.swift
//  helpgen
//
//  Created by Franck Brun on 27/06/2022.
//

import Foundation
import SwiftSoup

enum HTMLValueTransformError: Error {
  case malformedValue(Any)
}

extension HTMLValueTransformError: LocalizedError {
  var errorDescription: String? {
    switch self {
    case .malformedValue(let object):
      return "malformed element '\(object)'"
    }
  }
}

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
    var tag = "p"
    if let headingValue = element.value(forNamedProterty: "heading") {
      tag = findTag(for: headingValue)
    }
    let p = SwiftSoup.Element(Tag(tag), "")
    let joinsedValue = element.values?.compactMap({$0.value}).joined(separator: " ") ?? ""
    try p.text(joinsedValue)
    return try p.outerHtml()
  }
    
  func imageTag(with element: Element) throws -> String {
    let attributes = SwiftSoup.Attributes()
    
    if let sourceProperty = element.property(named: HTMLConstants.ImageSourceAttribute) {
      try attributes.put("src", sourceProperty.value)
    }
    
    if let sizeValue = element.value(forNamedProterty: "size") {
      var width = ""
      var height = ""
      if sizeValue.contains("x") {
        let components = sizeValue.split(separator: "x")
        if components.count != 2 {
          throw HTMLValueTransformError.malformedValue(element)
        }
        width = String(components[0])
        height = String(components[1])
      } else {
        width = sizeValue
        height = sizeValue
      }
      
      if width.hasValidDigit() {
        try attributes.put("width", width)
      }
      if height.hasValidDigit() {
        try attributes.put("height", width)
      }
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
    var href = ""
    
    if let bundleId = element.value(forNamedProterty: "open_app") {
      href = "x-help-action://openApp?bundleId=\(bundleId)"
    } else if let prefPaneId = element.value(forNamedProterty: "open_pref_pane") {
      href = "x-help-action://openPrefPane?bundleId=\(prefPaneId)"
    } else if let hrefValue = element.value(forNamedProterty: "href") {
      href = hrefValue
    }
    
    let attributes = SwiftSoup.Attributes()
    if !href.isEmpty {
      try attributes.put("href", href)
    }
    
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
    
    let p = SwiftSoup.Element(Tag("p"), "")
    try p.appendChild(a)
    
    return try p.outerHtml()
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
  
  // MARK: Utilities
  
  private func findTag(for headingValue: String) -> String {
    var tag = "p"
    
    lazy var headingValues: [([String], String)] = [
      (["title1", "t1"], "h1"),
      (["title2", "t2"], "h2"),
      (["title3", "t3"], "h3"),
      (["title4", "t4"], "h4"),
      (["title5", "t5"], "h5"),
      (["title6", "t6"], "h6"),
    ]

    for (propertyValues, tagValue) in headingValues {
      if propertyValues.contains(headingValue) {
        tag = tagValue
        break
      }
    }

    return tag
  }

  // MARK: - Transform actions
  
  func transform(action: Action) throws -> String? {
    switch action.type {
    case .link:
      return try link(with: action)
    case .open:
      return nil
    }
  }

  func link(with action: Action) throws -> String {
    var href = ""
    let properties = Property.parseList(from: action.params)
    if properties.count > 0 {
      var anchor_name = ""
      var book_id = ""
      
      if let nameProperty = properties.find(propertyName: "anchor_name") {
        anchor_name = nameProperty.value
      }
      
      if let bookIdProperty = properties.find(propertyName: "book_id") {
        book_id = bookIdProperty.value
      } else {
        if let bundleIdentifierProperty = project.property(named: Constants.ProjectBundleIdentifierPropertyKey) {
          book_id = bundleIdentifierProperty.value
        }
      }
      
      if anchor_name.isEmpty {
        throw HTMLValueTransformError.malformedValue(action)
      }
      
      href = "help:anchor=\(anchor_name) bookID=\(book_id)"
    } else {
      guard let url = URL(string: action.params) else {
        throw HTMLValueTransformError.malformedValue(action)
      }
      href = url.absoluteURL.absoluteString
    }
    
    let attributes = SwiftSoup.Attributes()
    if !href.isEmpty {
      try attributes.put("href", href)
    }

    let a = SwiftSoup.Element(Tag("a"), "", attributes)
    try a.text(action.text)
    
    return try a.outerHtml()
  }
  
}
