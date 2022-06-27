//
//  Logger.swift
//  helpgen
//
//  Created by Franck Brun on 23/06/2022.
//

import Foundation

enum LogLevel: Int {
  case none
  case error
  case info
  case verbose
  case debug
  case all
}

class Logger {
  static var currentLevel = LogLevel.info
  
  static func log(level: LogLevel, line: String) {
    if level.rawValue <= currentLevel.rawValue {
      print(line)
    }
  }
}

func loge(_ line: String) {
  Logger.log(level: .error, line: line)
}

func logi(_ line: String) {
  Logger.log(level: .info, line: line)
}

func logv(_ line: String) {
  Logger.log(level: .verbose, line: line)
}

func logd(_ line: String) {
  Logger.log(level: .debug, line: line)
}
