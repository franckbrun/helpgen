//
//  HTMLHelpGenerator.swift
//  helpgen
//
//  Created by Franck Brun on 24/06/2022.
//

import Foundation

enum HTMLHelpError: Error {
  case general
  case emptyTemplateFile
}

class HTMLHelpGenerator<S: SourceFile & LocalizedPropertyQueryable & ElementQueryable, T: ValueTransformable> : Generator<S, T>, StringReplacers {

  var replacers = [StringReplacer<S>]()
  
  override func internalInit() {
    self.replacers.append(contentsOf: [
      DOMStringReplacer(project: project, source: source, valueTransformer: valueTransformer)
    ])
  }
  
  override func generate() throws -> Any?  {
    guard let templateContents = project.template(for: source) else {
      throw HTMLHelpError.emptyTemplateFile
    }
    return try changeValue(in:templateContents);
  }
}
