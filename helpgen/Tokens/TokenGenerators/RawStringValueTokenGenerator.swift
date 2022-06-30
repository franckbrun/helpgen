//
//  RawStringValueTokenGenerator.swift
//  helpgen
//
//  Created by Franck Brun on 30/06/2022.
//

import Foundation

class RawStringValueTokenGenerator: ValueTokenGenerator {
  
  let rawStringStartExpression = ##"^(?:(?<start>#+)")"##
  
  override func tokenise(str: String) -> Token? {
    
    if let startMatches = matches(expression: rawStringStartExpression, str: str) {
      if let startTag = startMatches[0].string(withRangeName: "start", in: str) {
        let count = startTag.count
        let rawStringExpression = ##"^(?:#{\##(count)}")(?<value>(?:\s|.)*?)(?:"#{\##(count)})"##
        if let matches = matches(expression: rawStringExpression, str: str) {
          if let token = valueTokenFor(match: matches[0], in: str) {
            return token
          }
        }
      }
    }
    
    return nil
  }
  
}
