//
//  File.swift
//
//
//  Created by Jamie Le Souef on 12/11/2023.
//

import Foundation
extension Converter {
   class MediaConverter {
    func convert(data: [String: String]) throws -> Media {
      guard let ref = data["ref"],
            let format = data["format"],
            let size = data["size"] else {
        
        throw ConverterError.missingXMLData
      }
      
      guard let sizeInt = UInt(size) else {
        throw ConverterError.notANumber
      }
      
      return Media(ref: ref, format: format, size: sizeInt)
    }
  }
}
