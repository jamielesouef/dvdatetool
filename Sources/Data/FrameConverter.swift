//
//  File.swift
//
//
//  Created by Jamie Le Souef on 12/11/2023.
//

import Foundation


extension Converter {
  class FrameConverter {
    
    private let formatter: DateFormatter
    
    init() {
      self.formatter = DateFormatter()
      formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    }
    
    func convert(data:[String: String]) throws -> Frame {
      guard data["rec_start"] == "1",
            let n = data["n"],
            let rdt = data["rdt"],
            let recordDate = formatter.date(from: rdt) else {
        
        throw ConverterError.missingXMLData
      }
      
      guard let nInt = UInt(n) else {
        throw ConverterError.notANumber
      }
      
      return Frame(n: nInt, recordDateTime: recordDate, recordStart: true)
      
    }
  }
}
