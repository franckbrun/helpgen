//
//  Action.swift
//  helpgen
//
//  Created by Franck Brun on 05/07/2022.
//

import Foundation

enum ActionType: String {
  case link
  case open
}

struct Action {
  let type: ActionType
  let params: String
  let text: String
}
