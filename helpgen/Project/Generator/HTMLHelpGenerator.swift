//
//  HTMLHelpGenerator.swift
//  helpgen
//
//  Created by Franck Brun on 24/06/2022.
//

import Foundation
import SwiftSoup

enum HTMLHelpError: Error {
  case general
}

class HTMLHelpGenerator<S: SourceFile & PropertyQueryable> : Generator<S> {

  override func generate() throws -> Result<Any?, Error>  {
    let contents = defaultHTMLHelpContents()
    
    let doc = try SwiftSoup.parse(contents)
    let elements = try doc.getAllElements()
    
    for element in elements {
      if let attributes = element.getAttributes() {
        for attr in attributes {
          logd(attr.getValue())
        }
      }      
      logd(element.ownText())
    }
    
    return .success(try doc.html())
  }

  func defaultHTMLHelpContents() -> String {
    // TODO: Add project.defaultHTMLFile
    
    return
"""
<!DOCTYPE html>
<html>
  <head>
    <title>%{property:title}%</title>
    <meta name="AppleTitle" content="%{property:apple_title}%">
  </head>
  <body>
    <a name="%apple_anchor%"></a>
    <div>%{element:*}%</div>    
  </body>
</html>
"""
  }

}
