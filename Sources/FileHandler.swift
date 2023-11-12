import Foundation

class FileHandler {
  let fileManager = FileManager.default
  let url: URL
  let path: String
  
 
  
  init(pathString: String) {
    self.path = pathString
    self.url = URL(fileURLWithPath: pathString)
  }
  
  func loadFile() throws -> Data {
    if fileManager.fileExists(atPath: path) {
      slog("found and opening file from path \(path)")
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
