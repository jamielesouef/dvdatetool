import Foundation


struct DVRescueTimeStampManager {
  let source: [Source]
}

struct DVTimestampBuilder {
  
  private let delegate: DVRescueParserDelegate
  let options: Options
  let source: [Source]
  
  init(source: [Source], options: Options) {
    self.delegate = DVRescueParserDelegate()
    self.options = options
    self.source = source
  }
  
  func run() throws {
    slog("start tool")
    
    try source.forEach { src in
      let data = try getDataFromFile(at: src.xml)
      parseXML(with: data, for: src)
    }
    
  }
}

private extension DVTimestampBuilder {
  func getDataFromFile(at url: URL) throws -> Data {
    let hander = DVFileHandler(url: url)
    let data = try hander.loadFile()
    return data
  }
  
  func parseXML(with data: Data, for source: Source) {
    let xmlParser = XMLParser(data: data)
    
    delegate.handler = { frames in
      let builder = DVPackageBuilder(
        source: source,
        frames: frames,
        options: options
      )
      
      do {
        builder.locateFiles()
        try builder.validate()
        try builder.prepare()
      } catch {
        fatalError(error.localizedDescription)
      }
      
    }
    
    xmlParser.delegate = delegate
    xmlParser.parse()
  }
}
