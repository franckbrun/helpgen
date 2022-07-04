//
//  HelpSourceFile.swift
//  helpgen
//
//  Created by Franck Brun on 24/06/2022.
//

import Foundation
import System

class HelpSourceFile: SourceFile {
  
  let id = UUID().uuidString
  
  let fileType: FileType
  
  let filePath: FilePath
  
  var object: HelpSourceObject?
     
  var defaultOutputFilename: String? {
    return self.filePath.lastComponent?.string
  }
  
  init(path: FilePath) {
    self.filePath = path
    self.fileType = FileType.fileType(for: path)
  }
  
  convenience init(path: FilePath, object: HelpSourceObject) {
    self.init(path: path)
    self.object = object
  }
  
}

extension HelpSourceFile: SourcePropertiesQueryable {

  func projectProperties() -> [Property]? {
    return object?.properties?.compactMap { property in
      let projectPropertyPrefix = "\(Constants.ProjectPropertyNameRadix)."
      if property.name.hasPrefix(projectPropertyPrefix) {
        let propertyName = property.name.deletingPrefix(projectPropertyPrefix)
        return Property(name: propertyName, value: property.value, localizedValues: property.localizedValues)
      }
      return nil
    }
  }
  
  func sourceProperties() -> [Property]? {
    return object?.properties?.compactMap { property in
      if !property.name.hasPrefix("\(Constants.ProjectPropertyNameRadix).") {
        let pagePropertyPrefix = "\(Constants.PagePropertyNameRadix)."
        var propertyName = property.name
        if propertyName.hasPrefix(pagePropertyPrefix) {
          propertyName = propertyName.deletingPrefix(pagePropertyPrefix)
        }
        return Property(name: propertyName, value: property.value, localizedValues: property.localizedValues)
      }
      return nil
    }
  }

}

extension HelpSourceFile: PropertyQueryable {
  
  func property(named propertyName: String) -> Property? {
    return self.object?.properties?.find(propertyName: propertyName)
  }
    
}

extension HelpSourceFile: ElementQueryable {
  
  func element(type: ElementType?, name: String?, language: String?, limit: Int = 0) -> [Element] {
    guard let allElements = self.object?.elements else {
      return []
    }
    
    var elements = [Element]()
    
    for element in allElements {
      
      if let queryedElementType = type, element.type != queryedElementType {
        continue
      }

      if let queryedElementName = name {
        guard let elementName = element.name else {
          continue
        }
        if elementName != queryedElementName {
          continue
        }
      }
      
      if let queryedElementLanguage = language {
        if let elementLangage = element.property(named: Constants.LanguagePropertyKey)?.value {
          if elementLangage != queryedElementLanguage {
            continue
          }
        }
      }

      elements.append(element)
      if limit > 0, elements.count >= limit {
        break
      }
      
    }
        
    return elements
  }
  
}
