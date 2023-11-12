import Foundation

struct DVFile {
  let src: URL
}

final class FileBuilder {
  let src: URL
  var dvFiles: [DVFile] = []
  
  init?(media: Media, frames: [Frame]) {
    guard let url = URL(string: media.ref) else { return nil }
    self.src = url
    let srcFile = self.src.deletingPathExtension().lastPathComponent
    let path = url.deletingLastPathComponent()
    
    dvFiles = frames.enumerated().map { i, frame in
      let src: String = srcFile + "_\(i).dv"
      let dvFile: URL = path.appendingPathComponent(src)
      slog(dvFile)
      return DVFile(src: dvFile)
    }
  }
}
