//
//  Constants.swift
//  helpgen
//
//  Created by Franck Brun on 25/06/2022.
//

import Foundation

struct Constants {
  
  static let DescriptionPropertyKey = "description"
  static let KeywordsPropertyKey = "keywords"
  static let RobotsPropertyKey = "keywords"
  static let AppleTitlePropertyKey = "apple_title"

  static let PropertyKey = "property"
  static let TemplatePropertyKey = "template"
  static let TypePropertyKey = "type"
  static let NamePropertyKey = "name"
  static let LanguagePropertyKey = "lang"
  static let ExplicitPropertyKey = "explicit"
  static let OutputKey = "output"
  static let OutputFilenameKey = "filename"

  static let HelpFileExtension = "help"
  static let LanguageProjectExtension = "lproj"
  
  static let InfoPListStringsFilename = "InfoPlist.strings"
  
  static let PropertyNameCharacterSeparator = Character(".")
  
  static let ProjectPropertyNameRadix = "project"
  static let PagePropertyNameRadix = "page"
  
  static let ProjectBundleDevelopmentRegionPropertyKey = "bundleDevelopmentRegion"
  static let ProjectBundleIdentifierPropertyKey = "bundleIdentifier"
  static let ProjectBundleInfoDictionaryVersionPropertyKey = "bundleInfoDictionaryVersion"
  static let ProjectBundleNamePropertyKey = "bundleName"
  static let ProjectBundlePackageTypePropertyKey = "bundlePackageType"
  static let ProjectBookIconPathPropertyKey = "bookIconPath"
  static let ProjectBundleShortVersionStringPropertyKey = "bundleShortVersionString"
  static let ProjectBundleSignaturePropertyKey = "bundleSignature"
  static let ProjectBundleVersionPropertyKey = "bundleVersion"
  static let ProjectBookAccessPathPropertyKey = "bookAccessPath"
  static let ProjectBookIndexPathPropertyKey = "bookIndexPath"
  static let ProjectBookCSIndexPathPropertyKey = "bookCSIndexPath"
  static let ProjectBookKBProductPropertyKey = "bookKBProduct"
  static let ProjectBookTitlePropertyKey = "bookTitle"
  static let ProjectBookTypePropertyKey = "bookType"

  static let ProjectAssetsFolderPropertyKey = "assetsFolder"

  static let ContainerPathString = "Contents"
  static let ResourcesPathString = "Contents/Resources"
  static let AssetsPathString = "assets"
}
