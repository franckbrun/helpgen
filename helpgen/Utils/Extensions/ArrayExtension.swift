//
//  ArrayExtension.swift
//  helpgen
//
//  Created by Franck Brun on 26/06/2022.
//

import Foundation

extension Array where Array.Element == Property {
  
  func find(propertyName name: String) -> Property? {
    for element in self {
      if element.name == name {
        return element
      }
    }
    return nil
  }
  
}

extension Array where Array.Element == PropertyLocalization {
  
  func find(propertyLoc lang: String) -> PropertyLocalization? {
    for element in self {
      if element.lang == lang {
        return element
      }
    }
    return nil
  }
  
}
