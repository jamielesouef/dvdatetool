import Foundation

extension Converter {
   class MediaConverter {
    func convert(data: [String: String]) throws -> Media {
      guard let ref = data["ref"],
            let path = URL(string: ref),
            let format = data["format"] else {
        throw DVDateError.missingXMLData
      }
      
      guard format == "DV" else {
        throw DVDateError.onlyDVSupport
      }
      
      return Media(ref: ref == "-" ? inferRefFromXML() : path, format: format, size: 0)
    }
  }
}

private extension Converter.MediaConverter {
  func inferRefFromXML() -> URL {
    guard let path = URL(string: OptionsContainer.current.path) else {
      vlog(DVDateError.noPath)
      fatalError()
    }
    let absPath = path.deletingLastPathComponent()
    let file = path.lastPathComponent.replacingOccurrences(of: ".dvrescue.xml", with: "")
    
    return absPath.appendingPathComponent(file)
  }
}
