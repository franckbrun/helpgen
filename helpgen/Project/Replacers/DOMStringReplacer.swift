//
//  DOMStringReplacer.swift
//  helpgen
//
//  Created by Franck Brun on 25/06/2022.
//

import Foundation
import SwiftSoup

class DOMStringReplacer<S: LocalizedPropertyQueryable & ElementQueryable>: StringReplacer<S>, StringReplacers {
  
  var replacers = [StringReplacer<S>]()

  override func internalInit() {
    replacers.append(contentsOf: [
      PropertiesReplacer(project: project, source: source),
      ElementsReplacer(project: project, source: source)
    ])
  }
  
  override func replace(in sourceStr: String) throws -> String? {
    var hasChanges = false
    let doc = try SwiftSoup.parse(sourceStr)
    let elements = try doc.getAllElements()
    
    for element in elements {
      if let attributes = element.getAttributes() {
        for attr in attributes {
          logd(attr.getValue())
          if let newValue = try changeValue(in: attr.getValue()) {
            attr.setValue(value: newValue)
            hasChanges = true
          }
        }
      }
      
      logd(element.ownText())
      if let newValue = try changeValue(in: element.ownText()) {
        try element.text(newValue)
        hasChanges = true
      }
    }
    
    return hasChanges ? try doc.html() : nil
  }    
}
