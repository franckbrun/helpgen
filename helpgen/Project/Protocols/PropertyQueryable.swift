//
//  PropertyQueryable.swift
//  helpgen
//
//  Created by Franck Brun on 24/06/2022.
//

import Foundation

protocol PropertyQueryable {

  subscript(propertyName: String) -> String? { get }
  
}
