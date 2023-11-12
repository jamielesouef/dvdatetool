//
//  File.swift
//  
//
//  Created by Jamie Le Souef on 12/11/2023.
//

import Foundation

final class MediaConverter: Converter {

  static func convert(data: [String: String]) throws -> Media {
    guard let ref = data["ref"],
          let format = data["format"],
          let size = data["size"] else {
      
      throw Error.missingXMLData
    }
  }
}
