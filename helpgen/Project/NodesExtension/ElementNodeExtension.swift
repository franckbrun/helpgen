//
//  ElementNodeExtension.swift
//  helpgen
//
//  Created by Franck Brun on 25/06/2022.
//

import Foundation

extension ElementNode: PropertyQueryable {
  
  func property(named propertyName: String) -> String? {
    return self.propertiesNode.property(named: propertyName)
  }
  
}
