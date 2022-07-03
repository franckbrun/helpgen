//
//  OptionsHelper.swift
//  helpgen
//
//  Created by Franck Brun on 02/07/2022.
//

import Foundation

final class OptionsHelper {
  
  static func languages(from langArr: [String]) -> [String] {
    return langArr
    .map { $0.replacingOccurrences(of: " ", with: ",") }
    .joined(separator: ",")
    .split(separator: ",")
    .map { String($0) }
  }
  
}
