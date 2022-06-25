//
//  StringReplacable.swift
//  helpgen
//
//  Created by Franck Brun on 25/06/2022.
//

import Foundation

protocol StringReplacable {

  func replace(in: String) throws -> String?
  
}
