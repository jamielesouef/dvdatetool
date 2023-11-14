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

final class PackageFileBuilder {
  let src: URL
  var dvFiles: [DVFile] = []
  let srcFile: String
  let path: URL
  
  private let options: Options
  
  init(options: Options, media: Media, frames: [Frame]) {
    self.options = options
    self.src = media.ref
    self.srcFile = self.src.deletingPathExtension().lastPathComponent
    self.path = media.ref.deletingLastPathComponent()
    
    dvFiles = frames.enumerated().compactMap { i, frame in
      let dvFile: URL = makePathURL(for: frame, at: i)
      let exists: Bool = FileManager.default.fileExists(atPath: dvFile.absoluteString)
      
      if exists {
        return DVFile(src: dvFile, timestamp: frame.recordDateTime)
      } else {
        slog("\(dvFile) not found")
      }
      
      return nil
      
    }
  }
  
  func validate() throws {
    guard let files = FileManager.default.enumerator(at: path, includingPropertiesForKeys: nil)?.allObjects as? [URL] else {
      throw DVDateError.validateStepFailed(reason: "Could not find all objects")
    }
    
    let packExtFiles = files.filter { $0.lastPathComponent.contains(options.packageExtension)}
    
    let dC = dvFiles.count
    let pC = packExtFiles.count
    vlog("dc", dC, "pC", pC)
    
    if dC == 0 {
      vlog(path)
      throw DVDateError.noVideoFilesFound
    }
    
    if dC != pC {
      throw DVDateError.validateStepFailed(reason: "file count does not match: \(dC):\(pC)")
    }
    
    slog("Found \(pC) files, matches \(dC)")
  }
  
  func prepare() throws {
    try dvFiles.forEach { file in
      let attribute = try FileManager.default.attributesOfItem(atPath: file.src.relativePath)
      guard let cD = attribute[.creationDate] as? Date else {
        throw DVDateError.couldNotGetCreateDate
      }
      slog("will change create date for \(file.file) from \(cD.description) to \(file.timestamp.description)")
    }
    
    prompt_continue(message: "(this can not be undone)")
    
  }
  
  func perform() throws {
    slog("will change files")
    dvFiles.forEach { file in
      
      let attributes = [
        FileAttributeKey.creationDate: file.timestamp,
      ]
      
      if options.dryRyn == 1 {
        slog("Changing create date for \(file.file) to \(file.timestamp.formatted())")
      } else {
        
        do {
          let relativeString = try copyFileIfRequried(from: file.src).relativeString
          try FileManager.default.setAttributes(attributes, ofItemAtPath: relativeString)
        } catch {
          vlog(error)
        }
        slog("Done!")
      }
    }
  }
}

private extension PackageFileBuilder {
  
  func copyFileIfRequried(from src: URL) throws -> URL {
    guard options.createNewFiles != nil else {
      return src
    }
    
    var name: [String] = src.lastPathComponent.components(separatedBy: ".")
    let ext = name.removeLast()
    name.append("copy")
    name.append(ext)
    
    let newName = name.joined(separator: ".")
    let newURL = path.appendingPathComponent(newName)
    
    if options.dryRyn == 1 {
      slog("will make a copy named \(newURL)")
      return newURL
    }
    
    try FileManager.default.copyItem(atPath: src.absoluteString, toPath: newURL.absoluteString)
    slog("Made copy \(newURL)")
    return newURL
    
  }
  
  func makePathURL(for frame: Frame, at index: Int) -> URL {
    let index = index+1
    let pre = options.packagePrefix
    let post = options.packagePostfix
    let ext = options.packageExtension
    let src: String = "\(pre)\(srcFile)\(post)\(index).\(ext)"
    return path.appendingPathComponent(src)
  }
}
