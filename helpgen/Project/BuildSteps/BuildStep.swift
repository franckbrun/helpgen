//
//  BuildStep.swift
//  helpgen
//
//  Created by Franck Brun on 24/06/2022.
//

import Foundation

protocol BuildStep {
  
  func exec() throws
  
}
