import Foundation

struct Source {
  let xml: URL
  let video: URL?
  
  func isValid() -> Bool {
    video != nil
  }
}

final class SourceBuilder {
  let options: Options
  
  init(options: Options) {
    self.options = options
    slog(options.path)
  }
  
  func run() throws -> [Source] {
    let resuceURLs = try getXMLURLS(from: options.path)
    let source = buildSources(urls: resuceURLs).filter { $0.isValid() }
    
    shouldContinue(sources: source)
    
    return source
    
  }
}

private extension SourceBuilder {
  
  func shouldContinue(sources: [Source]) {
    let sourceWithNoVideo = sources.map { $0.video == nil }
    if sourceWithNoVideo.count > 0 {
      sources.forEach {
        slog("could not find a video for \($0.xml.lastPathComponent)")
      }
      
      prompt_continue()
    }
  }
  
  func buildSources(urls: [URL]) -> [Source] {
    urls.map { url in
      let file = url.lastPathComponent.replacingOccurrences(of: options.xmlPostfix, with: "")
      let expectedVideoSource: URL = url.deletingLastPathComponent().appendingPathComponent(file)
      vlog("looking for \(expectedVideoSource)")
      
      var video: URL? = nil
      
      if FileManager.default.fileExists(atPath: expectedVideoSource.absoluteString){
        video = expectedVideoSource
      }
      
      return Source(xml: url, video: video)
    }
  }
  
  func getXMLURLS(from path: String) throws -> [URL] {
    var enumerationOptions: FileManager.DirectoryEnumerationOptions = [
      .skipsHiddenFiles,
      .skipsPackageDescendants,
    ]
    
    if options.verbose == 0 {
      enumerationOptions.insert(.skipsSubdirectoryDescendants)
    }
    
    let url = URL(fileURLWithPath: options.path)
    vlog("checking at path \(options.path)")
    guard let filePaths = FileManager.default.enumerator(
      at: url,
      includingPropertiesForKeys: [.isRegularFileKey],
      options: enumerationOptions,
      errorHandler: fileManagerError
    )?.allObjects as? [URL]   else {
      throw DVDateError.errorReadingFile(
        description: "Could not find any xml objects"
      )
    }
    
    let xmls = filePaths.filter { $0.lastPathComponent.contains(options.xmlPostfix) }
    xmls.forEach {
      vlog("found \($0)")
    }
    
    return xmls
    
  }
  func fileManagerError(url: URL, error: Error) -> Bool {
    vlog(error)
    return true
  }
}

