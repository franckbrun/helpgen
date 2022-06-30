//
//  Constants.swift
//  helpgen
//
//  Created by Franck Brun on 25/06/2022.
//

import Foundation

struct Constants {
  
  static let PropertyKey = "property"
  static let TemplatePropertyKey = "template"
  static let TypePropertyKey = "type"
  static let NamePropertyKey = "name"
  static let LanguagePropertyKey = "lang"
  static let OutputFilenameKey = "filename"

  static let HelpFileExtension = "help"
  static let LanguageProjectExtension = "lproj"
  
  static let PropertyNameCharacterSeparator = Character(".")
  
  static let ProjectPropertyNameRadix = "project"
  static let PagePropertyNameRadix = "page"
  
  static let ProjectBundleIdentifierPropertyKey = "bundleIdentifier"
  
  static let ContainerPathString = "Contents"
  static let ResourcesPathString = "Contents/Resources"
}
