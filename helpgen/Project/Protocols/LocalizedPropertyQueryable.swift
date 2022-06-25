//
//  LocalizedPropertyQueryable.swift
//  helpgen
//
//  Created by Franck Brun on 25/06/2022.
//

import Foundation

protocol LocalizedPropertyQueryable {

  func property(named propertyName: String, language lang: String) -> String?
  
}
