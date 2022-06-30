//
//  CreateHelpBookPlistBuildStep.swift
//  helpgen
//
//  Created by Franck Brun on 27/06/2022.
//

import Foundation
import SystemPackage

struct HelpBookPList: Codable {
  var bundleDevelopmentRegion = "en_US"
  var bundleIdentifier: String?
  var bundleInfoDictionaryVersion = "6.0"
  var bundleName: String?
  var bundleShortVersionString: String?
  var bundleVersion: String?
  var bundlePackageType = "BNDL"
  var bundleSignature = "hbwr"
  
  var bookIconPath: String?
  var bookAccessPath: String?
  var bookIndexPath: String?
  var bookCSIndexPath: String?
  var bookKBProduct = ""
  var bookTitle: String?
  var bookType = "3"
  
  private enum CodingKeys: String, CodingKey {
    case bundleDevelopmentRegion = "CFBundleDevelopmentRegion"
    case bundleIdentifier = "CFBundleIdentifier"
    case bundleInfoDictionaryVersion = "CFBundleInfoDictionaryVersion"
    case bundleName = "CFBundleName"
    case bundleShortVersionString = "CFBundleShortVersionString"
    case bundleVersion = "CFbundleVersion"
    case bundlePackageType = "CFBundlePackageType"
    case bundleSignature = "CFBundleSignature"
    case bookIconPath = "HPDBookIconPath"
    case bookAccessPath = "HPDBookAccessPath"
    case bookIndexPath = "HPDBbookIndexPath"
    case bookCSIndexPath = "HPDBookCSIndexPath"
    case bookKBProduct = "HPDBookKBProduct"
    case bookTitle = "HPDBookTitle"
    case bookType = "HPDBookType"
  }
}

class CreateHelpBookPlistBuildStep<S: StorageWrappable>: BuildStep {
  
  let project: Project
  let storage: S
  
  init(project: Project, storage: S) {
    self.project = project
    self.storage = storage
  }
  
  func exec() throws {
    let helpBook = createHelpBookPList()
    let encoder = PropertyListEncoder()
    encoder.outputFormat = .xml
    let data = try encoder.encode(helpBook)
    try storage.write(to: FilePath("\(Constants.ContainerPathString)/Info.plist"), contents: data)
  }
  
  func createHelpBookPList() -> HelpBookPList {
    var helpBook = HelpBookPList()

    let keyPaths:[(String, Any)] = [
      (Constants.ProjectBundleDevelopmentRegionPropertyKey, \HelpBookPList.bundleDevelopmentRegion),
      (Constants.ProjectBundleIdentifierPropertyKey, \HelpBookPList.bundleIdentifier),
      (Constants.ProjectBundleInfoDictionaryVersionPropertyKey, \HelpBookPList.bundleInfoDictionaryVersion),
      (Constants.ProjectBundleNamePropertyKey, \HelpBookPList.bundleName),
      (Constants.ProjectBundlePackageTypePropertyKey, \HelpBookPList.bundlePackageType),
      (Constants.ProjectBookIconPathPropertyKey, \HelpBookPList.bookIconPath),
      (Constants.ProjectBundleShortVersionStringPropertyKey, \HelpBookPList.bundleShortVersionString),
      (Constants.ProjectBundleSignaturePropertyKey, \HelpBookPList.bundleSignature),
      (Constants.ProjectBundleVersionPropertyKey, \HelpBookPList..bundleVersion),
      (Constants.ProjectBookAccessPathPropertyKey, \HelpBookPList.bookAccessPath),
      (Constants.ProjectBookIndexPathPropertyKey, \HelpBookPList.bookIndexPath),
      (Constants.ProjectBookCSIndexPathPropertyKey, \HelpBookPList.bookCSIndexPath),
      (Constants.ProjectBookKBProductPropertyKey, \HelpBookPList.bookKBProduct),
      (Constants.ProjectBookTitlePropertyKey, \HelpBookPList.bookTitle),
      (Constants.ProjectBookTypePropertyKey, \HelpBookPList.bookType),
    ]

    for (identifier, keypath) in keyPaths {
      if let property = project.properties[identifier] {
        if let kp = keypath as? WritableKeyPath<HelpBookPList, String> {
          helpBook[keyPath: kp] = property.value
        } else if let kp = keypath as? WritableKeyPath<HelpBookPList, String?> {
          helpBook[keyPath: kp] = property.value
        }
      }
    }
        
    return helpBook
  }
}
