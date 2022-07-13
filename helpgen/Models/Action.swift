//
//  Action.swift
//  helpgen
//
//  Created by Franck Brun on 05/07/2022.
//

import Foundation

enum ActionType: String {
  case link
  case openApp = "open_app"
  case openPrefPane = "open_prefpane"
  case style
}

struct Action {
  let type: ActionType
  let params: String
  let text: String
}
