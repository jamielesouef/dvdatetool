//
//  File.swift
//
//
//  Created by Jamie Le Souef on 12/11/2023.
//

import Foundation

enum ConverterError: Swift.Error {
  case missingXMLData, notANumber
}

extension ConverterError: LocalizedError {
  var errorDescription: String? {
    switch self {
    case .missingXMLData: "Something missing from XML data to create"
    case .notANumber: "N is not a number"
    }
  }
}
