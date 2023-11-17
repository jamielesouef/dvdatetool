import Foundation

struct PackageVideoFile {
  let src: URL
  let file: String
  let timestamp: Date
  
  init(src: URL, timestamp: Date) {
    self.src = src
    self.timestamp = timestamp
    self.file = src.lastPathComponent
  }
}

final class DVPackageBuilder {
  let source: Source
  var dvFiles: [PackageVideoFile] = []
  let frames: [Frame]
  private var isValid: Bool = false
  private let options: Options
  
  init(source: Source, frames: [Frame], options: Options) {
    self.options = options
    self.source = source
    self.frames = frames
  }
  
  func locateFiles() {
    dvFiles = frames
      .sorted { $0.n < $1.n}
      .enumerated().compactMap { i, frame in
        
        let dvFile: URL = makePathURL(for: frame, at: i+1)
        
        let exists: Bool = FileManager.default.fileExists(atPath: dvFile.relativePath)
        
        if exists {
          vlog("\(dvFile) found")
          return PackageVideoFile(src: dvFile, timestamp: frame.recordDateTime)
        } else {
          vlog("\(dvFile) not found")
        }
        
        return nil
        
      }
    
    slog("found \(dvFiles.count) package fiels for \(source.xml.lastPathComponent)")
  }
  
  func validate() {
    do {
      guard let files = FileManager.default.enumerator(at: source.baseBath, includingPropertiesForKeys: nil)?.allObjects as? [URL] else {
        throw DVDateError.validateStepFailed(reason: "Could not find all objects")
      }
      
      let packExtFiles = files.filter { $0.lastPathComponent.contains(options.packageExtension)}
      
      let dC = dvFiles.count
      let pC = packExtFiles.count
      vlog("dc", dC, "pC", pC)
      
      if dC == 0 {
        vlog(source.baseBath)
        throw DVDateError.noVideoFilesFound
      }
      
      if dC != pC {
        throw DVDateError.validateStepFailed(reason: "file count does not match: \(dC):\(pC)")
      }
      
      slog("Found \(pC) files, matches \(dC)")
      self.isValid = true
    } catch {
      slog(error)
      self.isValid = false
    }
  }
  
  func prepare() throws {
    if isValid {
      try dvFiles
        .map { file in
          let attribute = try FileManager.default.attributesOfItem(atPath: file.src.relativePath)
          guard let creationDate = attribute[.creationDate] as? Date else {
            throw DVDateError.couldNotGetCreateDate
          }
          
          return (file, creationDate)
          
          
        }.filter { (file, date) in
          file.timestamp != date
        }
        .forEach { (file, createDate) in
          slog("will change create date for \(file.file) from \(createDate) to \(file.timestamp.description)")
      }
      
      prompt_continue(message: "(this can not be undone)")
    }
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

private extension DVPackageBuilder {
  
  func copyFileIfRequried(from src: URL) throws -> URL {
    guard options.createNewFiles != nil else {
      return src
    }
    
    var name: [String] = src.lastPathComponent.components(separatedBy: ".")
    let ext = name.removeLast()
    name.append("copy")
    name.append(ext)
    
    let newName = name.joined(separator: ".")
    let newURL = source.baseBath.appendingPathComponent(newName)
    
    if options.dryRyn == 1 {
      slog("will make a copy named \(newURL)")
      return newURL
    }
    
    try FileManager.default.copyItem(atPath: src.absoluteString, toPath: newURL.absoluteString)
    slog("Made copy \(newURL)")
    return newURL
    
  }
  
  func makePathURL(for frame: Frame, at index: Int) -> URL {
    let srcFile = source.xml.lastPathComponent.replacingOccurrences(of: ".dv.dvrescue.xml", with: "")
    let index = index
    let pre = options.packagePrefix
    let post = options.packagePostfix
    let ext = options.packageExtension
    let src: String = "\(pre)\(srcFile)\(post)\(index).\(ext)"
    return source.baseBath.appendingPathComponent(src)
  }
}
