//
//  ActionsReplacer.swift
//  helpgen
//
//  Created by Franck Brun on 05/07/2022.
//

import Foundation

enum ActionsReplacerError: Error {
  case missingActionType
  case unknownActionType(String)
}

extension ActionsReplacerError: LocalizedError {
  var errorDescription: String? {
    switch self {
    case .missingActionType:
      return "missing action type"
    case .unknownActionType(let name):
      return "unknown action type '\(name)'"
    }
  }
}

class ActionsReplacer<S: PropertyQueryable & ElementQueryable, T: ValueTransformable>: PropertiesReplacer<S, T> {
  
  override var searchRegExpr: String {
    #"(@(?<action>link|openApp|openPrefPane|style)\[(?<params>.*)\]\((?<value>.*)\))"#
  }
  
  override func value(for match: NSTextCheckingResult, in str: String) throws -> String? {
    guard let actionTypeNamed = match.string(withRangeName: "action", in: str) else {
      throw ActionsReplacerError.missingActionType
    }
    guard let actionType = ActionType(rawValue: actionTypeNamed) else {
      throw ActionsReplacerError.unknownActionType(actionTypeNamed)
    }
    
    let params = match.string(withRangeName: "params", in: str) ?? ""
    let value = match.string(withRangeName: "value", in: str) ?? ""
    let action = Action(type: actionType, params: params, text: value)
    
    var result: String?
    if let transformResult = try self.valueTransformer.transform(action: action) {
      result = transformResult
    }
    
    return result
  }
}
