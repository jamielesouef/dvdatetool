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
  case couldNotGetCreateDate
  case noVideoFilesFound
  case noFrameData
  case couldNotCreateFrame(unsafe: Bool)
  
}

extension DVDateError: LocalizedError {
  var errorDescription: String? {
    switch self {
    case .missingXMLData: "Something missing from XML data to create, ignoring"
    case .notANumber: "N is not a number"
    case .onlyDVSupport: "Only DV format is supported"
    case .noMediaInfoFound: "No Media info found in XML"
    case .errorReadingFile(let description): "Could not read file. \(description)"
    case .fileNotFound(let file): "Could not find file \(file)"
    case .noPath: "Path argument is required"
    case .validateStepFailed(let reason): "Vailidation failed: \(reason)"
    case .couldNotGetCreateDate: "Could not get create date"
    case .noVideoFilesFound: "Could not find any dv files"
    case .noFrameData: "No frame data"
    case .couldNotCreateFrame(let unsafe): "Could not create \(unsafe ? "un" : "")frame"
    }
  }
}
