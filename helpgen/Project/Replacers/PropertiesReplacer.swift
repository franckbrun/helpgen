//
//  PropertiesReplacer.swift
//  helpgen
//
//  Created by Franck Brun on 25/06/2022.
//

import Foundation

enum PropertySource: String {
  case project
  case page
}

class PropertiesReplacer<S: PropertyQueryable, T: ValueTransformable>: StringReplacer<S> {
  
  let regExprCache = RegExprCache.shared
  
  var searchRegExpr: String {
    "%\\{\(RegExprConstant.propertyQueryRegExpr)\\}%"
  }
  
  let valueTransformer: T
  
  init(project: Project, source: S, valueTransformer: T) {
    self.valueTransformer = valueTransformer
    super.init(project: project, source: source)
  }
  
  override func replace(in sourceStr: String) throws -> String? {
    if let matches = regExprCache.matches(expression: self.searchRegExpr, str: sourceStr) {
      logd(matches.debugDescription)
      
      var hasChanges = false
      var str = sourceStr
      
      for match in matches.reversed() {
        if let value = try value(for: match, in: str) {
          if let range = Range(match.range, in: str) {
            str.replaceSubrange(range.lowerBound..<range.upperBound, with: value)
            hasChanges = true
          }
        }
      }
      return hasChanges ? str : nil
    }
    return nil
  }
  
  func value(for match: NSTextCheckingResult, in str: String) throws -> String? {
    if let propertyName = match.string(withRangeName: RegExprConstant.propertyNameKey, in: str) {
      
      var language = project.currentLanguage
      
      // Specific language for this propertyy
      if let propertiesString = match.string(withRangeName: RegExprConstant.PropertiesNameKey, in: str) {
        let properties = Property.parseList(from: propertiesString)
        if let languageProperty = properties.find(propertyName: Constants.LanguagePropertyKey) {
          language = languageProperty.value
        }
      }
      
      if let (source, name) = decompose(propertyName: propertyName) {
        if let property = property(for: name, from: source) {
          // Pass property for the specific language
          return try valueTransformer.tranform(property: property.clone(forLanguage: language))
        }
      }
    }
    
    return nil
  }
  
  /// search property value for type ("propertyName[:properties]]")
  private func property(for propertyName: String, from propertySource: PropertySource) -> Property? {
    switch propertySource {
    case .project:
      return project.property(named: propertyName)
    case .page:
      return source.property(named: propertyName)
    }
  }
  
  private func decompose(propertyName: String) -> (PropertySource, String)? {
    let components = propertyName.split(separator: Constants.PropertyNameCharacterSeparator)
    if components.count == 1 {
      return (.page, propertyName)
    } else {
      guard let source = PropertySource(rawValue: String(components[0])) else {
        loge("unknow property source '\(propertyName)' (should be 'page' or 'project' or empty)")
        return nil
      }
      return (source, components.dropFirst().joined(separator: "\(Constants.PropertyNameCharacterSeparator)"))
    }
  }
  
}

