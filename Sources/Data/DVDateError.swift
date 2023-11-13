import Foundation

enum DVDateError: Swift.Error {
  case missingXMLData
  case notANumber
  case onlyDVSupport
  case noMediaInfoFound
  case errorReadingFile(description: String)
  case fileNotFound(file: URL)
  case noPath
  case validateStepFailed(reason: String)
  
}

extension DVDateError: LocalizedError {
  var errorDescription: String? {
    switch self {
    case .missingXMLData: "Something missing from XML data to create"
    case .notANumber: "N is not a number"
    case .onlyDVSupport: "Only DV format is supported"
    case .noMediaInfoFound: "No Media infor found in XML"
    case .errorReadingFile(let description): "Could not read file. \(description)"
    case .fileNotFound(let file): "Could not find file \(file)"
    case .noPath: "Path argument is required"
    case .validateStepFailed(let reason): "Vailidation failed: \(reason)"
    }
  }
}
