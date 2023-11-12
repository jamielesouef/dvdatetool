//
//  File.swift
//  
//
//  Created by Jamie Le Souef on 12/11/2023.
//

import Foundation

class Converter {
  enum Error: Swift.Error {
    case missingXMLData, notANumber
  }
  
  private init() {}
}

extension Converter.Error: LocalizedError {
  var errorDescription: String? {
    switch self {
    case .missingXMLData: "Something missing from XML data to create"
    case .notANumber: "N is not a number"
    }
  }
}
