//
//  ElementsQueryable.swift
//  helpgen
//
//  Created by Franck Brun on 25/06/2022.
//

import Foundation

protocol ElementQueryable {
  
  func element(type: ElementType?, name: String?, language: String?, limit: Int) -> [Element]

  // TODO: Implement this
  //func element(type: ElementType, with properties:[Property]) -> [ElementNode]
  
}
