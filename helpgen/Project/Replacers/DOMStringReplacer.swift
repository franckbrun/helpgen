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
  
}
