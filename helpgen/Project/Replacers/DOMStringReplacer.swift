//
//  DOMStringReplacer.swift
//  helpgen
//
//  Created by Franck Brun on 25/06/2022.
//

import Foundation
import SwiftSoup

class DOMStringReplacer<S: PropertyQueryable & ElementQueryable, T: ValueTransformable>: StringReplacer<S>, StringReplacers {
  
  var replacers = [StringReplacer<S>]()

  let valueTransformer: T
  
  init(project: Project, source: S, valueTransformer: T) {
    self.valueTransformer = valueTransformer
    super.init(project: project, source: source)
  }
  
  override func internalInit() {
    replacers.append(contentsOf: [
      ElementsReplacer(project: project, source: source, valueTransformer: valueTransformer),
      PropertiesReplacer(project: project, source: source, valueTransformer: valueTransformer),
      EraserReplacer(project: project, source: source, valueTransformer: valueTransformer),
      ActionsReplacer(project: project, source: source, valueTransformer: valueTransformer),
    ])
  }
  
  override func replace(in sourceStr: String) throws -> String? {
    var hasChanges = false
    let doc = try SwiftSoup.parse(sourceStr)
    let elements = try doc.getAllElements()
    
    hasChanges = try addMeta(in: doc)
    
    for element in elements {
      if let attributes = element.getAttributes() {
        for attr in attributes {
          if let newValue = try changeValue(in: attr.getValue()) {
            attr.setValue(value: newValue)
            hasChanges = true
          }
        }
      }
      
      if let newValue = try changeValue(in: element.ownText()) {
        try element.text("")
        try element.append(newValue)
        hasChanges = true
      }
    }
    
    return hasChanges ? try doc.html() : nil
  }
  
  func addMeta(in document: SwiftSoup.Document) throws -> Bool {
    var hasChanges = false
    
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

    if children.count > 0 {
      try document.head()?.insertChildren(0, children)
      hasChanges = true
    }
    
    return hasChanges
  }
  
}
