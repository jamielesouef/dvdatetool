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
  
  init(media: Media, frames: [Frame], frameExtension: String = "dv") {
    
    self.src = media.ref
    self.srcFile = self.src.deletingPathExtension().lastPathComponent
    self.path = media.ref.deletingLastPathComponent()
    
    dvFiles = frames.enumerated().compactMap { i, frame in
      let dvFile = buildPath(for: frame, at: i)
      let exists = FileManager.default.fileExists(atPath: dvFile.absoluteString)
      
      if exists {
        slog("\(dvFile) exists")
        return DVFile(src: dvFile, timestamp: frame.recordDateTime)
      } else {
        slog("\(dvFile) not found")
      }
      
      return nil
      
    }
  }
}

private extension FileBuilder {
  func buildPath(for frame: Frame, at index: Int) -> URL {
    let index = index+1
    let pre = OptionsContainer.current.packagePrefix
    let post = OptionsContainer.current.packagePostfix
    let ext = OptionsContainer.current.packageExtension
    let src: String = "\(pre)\(srcFile)\(post)\(index).\(ext)"
    return path.appendingPathComponent(src)
  }
}
