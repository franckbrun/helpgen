//
//  HTMLHelpGenerator.swift
//  helpgen
//
//  Created by Franck Brun on 24/06/2022.
//

import Foundation
import SwiftSoup

enum HTMLHelpError: Error {
  case general
  case emptyTemplateFile
}

class HTMLHelpGenerator<S: SourceFile & PropertyQueryable & ElementQueryable, T: ValueTransformable> : Generator<S, T>, StringReplacers {

  var replacers = [StringReplacer<S>]()
  
  override func internalInit() {
    self.replacers.append(contentsOf: [
      DOMStringReplacer(project: project, source: source, valueTransformer: valueTransformer),
    ])
  }
  
  override func generate() throws -> Any?  {
    guard let templateContents = try project.template(for: source) else {
      throw HTMLHelpError.emptyTemplateFile
    }
    var result = try changeValue(in: templateContents) ?? templateContents
    result = try addMeta(in: result)
    return result
  }
  
  func addMeta(in html: String) throws -> String {
    let document = try SwiftSoup.parse(html)
    
    var children = [Node]()
    
    if let descriptionProperty = self.source.property(named: Constants.DescriptionPropertyKey) {
      let value = descriptionProperty.value(forLanguage: self.project.currentLanguage)
      if !value.isEmpty {
        let attributes = SwiftSoup.Attributes()
        try attributes.put("name", "description")
        try attributes.put("content", value)
        let meta = SwiftSoup.Element(Tag("meta"), "", attributes)
        children.append(meta)
      }
    }
    
    if let keywordsProperty = self.source.property(named: Constants.KeywordsPropertyKey) {
      let value = keywordsProperty.value(forLanguage: self.project.currentLanguage)
      if !value.isEmpty {
        let attributes = SwiftSoup.Attributes()
        try attributes.put("name", "KEYWORDS")
        try attributes.put("content", value)
        let meta = SwiftSoup.Element(Tag("meta"), "", attributes)
        children.append(meta)
      }
    }

    if let robotsProperty = self.source.property(named: Constants.RobotsPropertyKey) {
      let value = robotsProperty.value(forLanguage: self.project.currentLanguage)
      if !value.isEmpty {
        let attributes = SwiftSoup.Attributes()
        try attributes.put("name", "ROBOTS")
        try attributes.put("content", value)
        let meta = SwiftSoup.Element(Tag("meta"), "", attributes)
        children.append(meta)
      }
    }

    if let appleTitleProperty = self.source.property(named: Constants.AppleTitlePropertyKey) {
      let value = appleTitleProperty.value(forLanguage: self.project.currentLanguage)
      if !value.isEmpty {
        let attributes = SwiftSoup.Attributes()
        try attributes.put("name", "AppleTitle")
        try attributes.put("content", value)
        let meta = SwiftSoup.Element(Tag("meta"), "", attributes)
        children.append(meta)
      }
    }

    let projectStyleSheetProperty = self.project.property(named: Constants.StyleSheetPropertyKey)
    let pageStyleSheetProperty = self.source.property(named: Constants.StyleSheetPropertyKey)
    if let styleSheetProperty = projectStyleSheetProperty ?? pageStyleSheetProperty {
      let value = styleSheetProperty.value(forLanguage: self.project.currentLanguage)
      if !value.isEmpty {
        let attributes = SwiftSoup.Attributes()
        try attributes.put("href", value)
        try attributes.put("rel", "stylesheet")
        let meta = SwiftSoup.Element(Tag("link"), "", attributes)
        children.append(meta)
      }
    }
    
    if children.count > 0 {
      try document.head()?.insertChildren(0, children)
    }
    
    return try document.outerHtml()
  }
}
