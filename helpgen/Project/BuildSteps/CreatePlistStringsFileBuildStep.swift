//
//  CreatePlistStringsFileBuildStep.swift
//  helpgen
//
//  Created by Franck Brun on 04/07/2022.
//

import Foundation
import System

class CreatePlistStringsFileBuildStep<S: StorageWrapper>: BuildStep {
  
  let project: Project
  let storage: S
  
  init(project: Project, storage: S) {
    self.project = project
    self.storage = storage
  }
  
  func exec() throws {
    if self.project.currentLanguage.isEmpty {
      loge("no language specified for CreatePlistStringsFileBuildStep")
      return
    }
    if let strings = strings(forLanguage: self.project.currentLanguage) {
      var filePath = FilePath(Constants.ResourcesPathString)
      if let folderPath = FilePath.Component("\(self.project.currentLanguage).\(Constants.LanguageProjectExtension)") {
        filePath.append(folderPath)
        filePath.append(FilePath(Constants.InfoPListStringsFilename).components)
      } else {
        throw GenericError.internalError
      }

      if let data = strings.data(using: .utf8) {
        try storage.write(to: filePath, contents: data)
      } else {
        throw GenericError.internalError
      }
    }
  }
  
  func strings(forLanguage lang: String) -> String? {
    var strings = [String : String]()
    
    let localisablePlistProperties:[(String, String)] = [
      (Constants.ProjectBundleNamePropertyKey, InfoPlistConstants.ProjectBundleNameKey),
      (Constants.ProjectBookIconPathPropertyKey, InfoPlistConstants.ProjectBookIconPathKey),
      (Constants.ProjectBookAccessPathPropertyKey, InfoPlistConstants.ProjectBookAccessPathKey),
      (Constants.ProjectBookIndexPathPropertyKey, InfoPlistConstants.ProjectBookIndexPathKey),
      (Constants.ProjectBookCSIndexPathPropertyKey, InfoPlistConstants.ProjectBookCSIndexPathKey),
      (Constants.ProjectBookTitlePropertyKey, InfoPlistConstants.ProjectBookTitleKey),
    ]

    for (propertyName, infoplistKey) in localisablePlistProperties {
      if let property = self.project.property(named: propertyName), property.hasLocalization(forLanguage: self.project.currentLanguage) {
        strings[infoplistKey] = property.value(forLanguage: self.project.currentLanguage)
      }
    }
    
    if strings.count == 0 {
      return nil
    }
    
    return strings.reduce("") { (partialResult: String, keyValue:(key: String, value: String)) in
      return partialResult + "\(keyValue.key) = \"\(keyValue.value);\"\n"
    }    
  }
  
}
