//
//  EraserReplacer.swift
//  helpgen
//
//  Created by Franck Brun on 01/07/2022.
//

import Foundation

class EraserReplacer<S: PropertyQueryable & ElementQueryable, T: ValueTransformable>: PropertiesReplacer<S, T> {
  
  override var searchRegExpr: String {
    #"%\{.*?\}%"#
  }
  
  override func value(for match: NSTextCheckingResult, in str: String) throws -> String? {
    return ""
  }
}
