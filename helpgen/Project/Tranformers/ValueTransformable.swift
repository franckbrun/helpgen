//
//  ValueTransformable.swift
//  helpgen
//
//  Created by Franck Brun on 27/06/2022.
//

import Foundation

protocol ValueTransformable {
  
  func tranform(property: Property) throws -> String?
  
  func transform(element: Element) throws -> String?
  
  func transform(action: Action) throws -> String?
}
