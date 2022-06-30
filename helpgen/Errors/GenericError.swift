//
//  GenericError.swift
//  helpgen
//
//  Created by Franck Brun on 25/06/2022.
//

import Foundation

enum GenericError: Error {
  case notImplemented(String)
  case stringConversionError
  case internalError
}

extension GenericError: LocalizedError {
  public var errorDescription: String? {
    switch self {
    case .notImplemented(let method):
      return "\(method) is not implemented"
    case .stringConversionError:
      return "unable to convert data"
    case .internalError:
      return "internal error"
    }
  }
}
