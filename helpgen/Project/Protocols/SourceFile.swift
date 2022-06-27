//
//  SourceFile.swift
//  helpgen
//
//  Created by Franck Brun on 24/06/2022.
//

import Foundation
import SystemPackage

protocol SourceFile: Identifiable {
  
  var filePath: FilePath { get }

  var fileType: FileType { get }

}
