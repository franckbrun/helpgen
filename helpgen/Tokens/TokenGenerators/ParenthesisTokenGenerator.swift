//
//  ParenthesisTokenGenerator.swift
//  helpgen
//
//  Created by Franck Brun on 14/07/2022.
//

import Foundation

class ParenthesisTokenGenerator: TokenGenerator {
  
  override func tokenise(str: String) throws -> Token? {
    throw GenericError.notImplemented("\(String(describing: self)).\(#function)")
  }
}
