//
//  RegExprMatchable.swift
//  helpgen
//
//  Created by Franck Brun on 25/06/2022.
//

import Foundation

protocol RegExprMatchable {
  
  func match(expression: String, str: String) -> String?
  
  func matches(expression: String, str: String) -> [NSTextCheckingResult]?
  
}
