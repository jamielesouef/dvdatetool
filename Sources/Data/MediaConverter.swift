import Foundation

extension Converter {
   class MediaConverter {
    func convert(data: [String: String]) throws -> Media {
      guard let ref = data["ref"],
            let format = data["format"],
            let size = data["size"] else {
        
        throw DVDateError.missingXMLData
      }
      
      guard format == "DV" else {
        throw DVDateError.onlyDVSupport
      }
      
      guard let sizeInt = UInt(size) else {
        throw DVDateError.notANumber
      }
      
      return Media(ref: ref, format: format, size: sizeInt)
    }
  }
}
