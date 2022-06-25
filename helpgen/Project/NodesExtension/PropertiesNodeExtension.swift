//
//  PropertiesNodeExtension.swift
//  helpgen
//
//  Created by Franck Brun on 25/06/2022.
//

import Foundation

extension PropertiesNode: PropertyQueryable {
  
  func property(named propertyName: String) -> String? {
    for property in properties {
      if property.name == propertyName {
        return property.value
      }
    }
    return nil
  }
}
