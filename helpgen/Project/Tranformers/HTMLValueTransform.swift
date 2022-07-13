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
    case .title:
      return try title(with: element)
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
    case .note:
      return try note(with: element)
//    default:
//      return nil
    }
  }
  
  func paragraphTag(with element: Element) throws -> String {
    let attributes = SwiftSoup.Attributes()
    let tag = findTag(for: element.value(forNamedProterty: "heading"))
    
    try appendId(from: element, in: attributes)

    let p = SwiftSoup.Element(Tag(tag), "", attributes)
    let joinedValue = element.values?.compactMap({$0.value}).joined(separator: " ") ?? ""
    try p.text(joinedValue)
    return try p.outerHtml()
  }
    
  func title(with element: Element) throws -> String {
    let divAttributes = SwiftSoup.Attributes()

    try appendId(from: element, in: divAttributes)

    let div = SwiftSoup.Element(Tag("div"), "", divAttributes)
    
    if let imagesrcProperty = element.property(named: "image") {
      let imageAttributes = SwiftSoup.Attributes()
      try imageAttributes.put("src", imagesrcProperty.value)
      try appendSize(from: element, in: imageAttributes)
      let image = SwiftSoup.Element(Tag("img"), "", imageAttributes)
      try div.appendChild(image)
    }

    let joinedValue = element.values?.compactMap({$0.value}).joined(separator: " ") ?? ""
    if !joinedValue.isEmpty {
      let tag = findTag(for: element.value(forNamedProterty: "heading"))
      let text = SwiftSoup.Element(Tag(tag), "")
      try text.text(joinedValue)
      try div.appendChild(text)
    }
    
    return try div.outerHtml()
  }
  
  func imageTag(with element: Element) throws -> String {
    let attributes = SwiftSoup.Attributes()
    
    if let sourceProperty = element.property(named: HTMLConstants.ImageSourceAttribute) {
      try attributes.put("src", sourceProperty.value)
    }
    
    try appendSize(from: element, in: attributes)
    try appendId(from: element, in: attributes)
            
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
    
    try appendSize(from: element, in: videoAttributes)
    
    let video = SwiftSoup.Element(Tag("video"), "", videoAttributes)
    try video.appendChild(SwiftSoup.Element(Tag("source"), "", sourceAttributes))
    return try video.outerHtml()
  }

  func separator(with element: Element) throws -> String {
    let separator = SwiftSoup.Element(Tag("hr"), "")
    return try separator.outerHtml()
  }
  
  func note(with element: Element) throws -> String {
    let attributes = SwiftSoup.Attributes()
    
    if let typeValue = element.value(forNamedProterty: "type") {
      try attributes.put("class", typeValue)
    }
    
    let div = SwiftSoup.Element(Tag("div"), "", attributes)
    let joinedValues = element.values?.compactMap({$0.value}).joined(separator: " ") ?? ""
    try div.text(joinedValues)

    return try div.outerHtml()
  }
  
  // MARK: Utilities
  
  private func findTag(for headingValue: String?) -> String {
    var tag = "p"
    
    guard let headingValue = headingValue, !headingValue.isEmpty else {
      return tag
    }
    
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

  private func appendSize<S: PropertyQueryable>(from source: S, in attributes: SwiftSoup.Attributes) throws {
    var width = ""
    var height = ""
    
    if let sizeProperty = source.property(named: "size") {
      let sizeValue = sizeProperty.value
      if sizeValue.contains("x") {
        let components = sizeValue.split(separator: "x")
        if components.count != 2 {
          throw HTMLValueTransformError.malformedValue(sizeValue)
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
    } else {
      if let widthProperty = source.property(named: "width") {
        width = widthProperty.value
      }
      if let heightProperty = source.property(named: "height") {
        height = heightProperty.value
      }
    }
  }
  
  private func appendId<S: PropertyQueryable & NameIdentifiable>(from source: S, in attributes: SwiftSoup.Attributes) throws {
    var id = ""
    if let name = source.name {
      id = name
    } else if let idProperty = source.property(named: "id") {
      id = idProperty.value
    } else if let nameProperty = source.property(named: "name") {
      id = nameProperty.value
    }
    if !id.isEmpty {
      try attributes.put("id", id)
    }
  }
  
  // MARK: - Transform actions
  
  func transform(action: Action) throws -> String? {
    switch action.type {
    case .link:
      return try link(with: action)
    case .openApp:
      return nil
    case .openPrefPane:
      return nil
    case .style:
      return try style(with: action)
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
  
  func style(with action: Action) throws -> String {
    let spanAttributes = SwiftSoup.Attributes()

    let properties = Property.parseList(from: action.params)
    if !properties.isEmpty {
      if let nameProperty = properties.find(propertyName: Constants.NamePropertyKey) {
        try spanAttributes.put("id", nameProperty.value)
      }
    }
    
    let span = SwiftSoup.Element(Tag("span"), "", spanAttributes)
    try span.text(action.text)
    
    return try span.outerHtml()
  }
  
}
