import Foundation

struct DVFile {
  let src: URL
  let file: String
  let timestamp: Date
  
  init(src: URL, timestamp: Date) {
    self.src = src
    self.timestamp = timestamp
    self.file = src.lastPathComponent
  }
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
    vlog(path.absoluteString)
    guard let filePaths = FileManager.default.enumerator(atPath: path.absoluteString)?.allObjects as? [String] else {
      throw DVDateError.validateStepFailed(reason: "Could not find all objects")
    }
    
    let packExtFiles = filePaths.filter { $0.contains(OptionsContainer.current.packageExtension)}
    
    let dC = dvFiles.count
    let pC = packExtFiles.count
    vlog("dc", dC, "pC", pC)
    
    if dC != pC {
      throw DVDateError.validateStepFailed(reason: "file count does not match: \(dC):\(pC)")
    }
    
    slog("Found \(pC) files, matches \(dC)")
  }
  
  func prepare() throws {
    try dvFiles.forEach { file in
      let attribute = try FileManager.default.attributesOfItem(atPath: file.src.absoluteString)
      guard let cD = attribute[.creationDate] as? Date else {
        throw DVDateError.couldNotGetCreateDate
      }
      slog("will change create date for \(file.file) from \(cD.description) to \(file.timestamp.description)")
    }
    
    slog("contine y/n? (this can not be undone)")
    let response = readLine()
    
    switch response {
    case "y" : try perform()
    default: exit(0)
    }
  }
  
  func perform() throws {
    slog("will change files")
    dvFiles.forEach { file in
      slog("Changing create date for \(file.file)")
      let attributes = [
        FileAttributeKey.creationDate: file.timestamp,
      ]
      
      
      do {
        let absoluteString = try copyFileIfRequried(from: file.src).absoluteString
        try FileManager.default.setAttributes(attributes, ofItemAtPath: absoluteString)
      } catch {
        vlog(error)
      }
      slog("Done!")
    }
  }
}

private extension FileBuilder {
  
  func copyFileIfRequried(from src: URL) throws -> URL {
    guard OptionsContainer.current.createNewFiles != nil else {
      return src
    }
    
    var path: URL = src.deletingLastPathComponent()
    var name: [String] = src.lastPathComponent.components(separatedBy: ".")
    let ext = name.removeLast()
    name.append("copy")
    name.append(ext)
    
    let newName = name.joined(separator: ".")
    let newPath = path.appendingPathComponent(newName)
    try FileManager.default.copyItem(atPath: src.absoluteString, toPath: newPath.absoluteString)
    slog("Made copy \(newName)")
    return newPath
    
  }
  
  func makePathURL(for frame: Frame, at index: Int) -> URL {
    let index = index+1
    let pre = OptionsContainer.current.packagePrefix
    let post = OptionsContainer.current.packagePostfix
    let ext = OptionsContainer.current.packageExtension
    let src: String = "\(pre)\(srcFile)\(post)\(index).\(ext)"
    return path.appendingPathComponent(src)
  }
}
