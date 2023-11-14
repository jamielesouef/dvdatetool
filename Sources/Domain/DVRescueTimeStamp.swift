import Foundation


struct DVRescueTimeStampManager {
  let source: [Source]
}

struct DVRescueTimeStamp {
  
  private let delegate: DVRescueParserDelegate
  let options: Options
  let source: Source
  
  init(source: [Source], options: Options) {
    self.delegate = DVRescueParserDelegate(options: options)
    self.options = options
    self.source = source.first!
  }
  
  func run() throws {
    slog("start tool")
    let data = try getDataFromFile(at: source.xml)
    parseXML(with: data)
    
  }
}

private extension DVRescueTimeStamp {
  func getDataFromFile(at url: URL) throws -> Data {
    let hander = FileHandler(url: url)
    let data = try hander.loadFile()
    return data
  }
  
  func parseXML(with data: Data) {
    let xmlParser = XMLParser(data: data)
    delegate.handler = self.process
    xmlParser.delegate = delegate
    xmlParser.parse()
  }
  
  func process(media: Media, frames: [Frame]) {
    let builder = PackageFileBuilder(options: options, media: media, frames: frames)
    do {
      try builder.validate()
      try builder.prepare()
    } catch {
      fatalError(error.localizedDescription)
    }
  }
}
