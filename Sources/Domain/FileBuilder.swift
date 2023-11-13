import Foundation

struct DVFile {
  let src: URL
  let timestamp: Date
}

final class FileBuilder {
  let src: URL
  var dvFiles: [DVFile] = []
  let srcFile: String
  let path: URL
  
  init(media: Media, frames: [Frame]) {
    
    self.src = media.ref
    self.srcFile = self.src.deletingPathExtension().lastPathComponent
    self.path = media.ref.deletingLastPathComponent()
    
    dvFiles = frames.enumerated().compactMap { i, frame in
      let dvFile: URL = makePathURL(for: frame, at: i)
      let exists: Bool = FileManager.default.fileExists(atPath: dvFile.absoluteString)
      
      if exists {
        slog("\(dvFile) exists")
        return DVFile(src: dvFile, timestamp: frame.recordDateTime)
      } else {
        slog("\(dvFile) not found")
      }
      
      return nil
      
    }
  }
  
  func validate() throws {
    guard let filePaths = FileManager.default.enumerator(atPath: path.absoluteString)?.allObjects as? [String] else {
      return 
    }
    
    let packExtFiles = filePaths.filter { $0.contains(OptionsContainer.current.packageExtension)}
    
    let dC = dvFiles.count
    let pC = packExtFiles.count
    
    if dC != pC {
      throw DVDateError.validateStepFailed(reason: "file count does not match: \(dC):\(pC)")
    }
    
    slog("Found \(pC) files, matches \(dC)")
  }
}

private extension FileBuilder {
  func makePathURL(for frame: Frame, at index: Int) -> URL {
    let index = index+1
    let pre = OptionsContainer.current.packagePrefix
    let post = OptionsContainer.current.packagePostfix
    let ext = OptionsContainer.current.packageExtension
    let src: String = "\(pre)\(srcFile)\(post)\(index).\(ext)"
    return path.appendingPathComponent(src)
  }
}
