import Foundation

struct DVFileHandler {
  
  let url: URL
  
  func loadFile() throws -> Data {
    if FileManager.default.fileExists(atPath: url.relativePath) {
      slog("found and opening file from path \(url.relativePath)")
      do {
        return try Data(contentsOf: url)
      } catch {
        throw(DVDateError.errorReadingFile(description: error.localizedDescription))
      }
    } else {
      throw(DVDateError.fileNotFound(file: url))
    }
  }
}
