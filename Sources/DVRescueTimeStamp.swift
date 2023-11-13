import Foundation

final public class DVRescueTimeStamp {
  
  private let delegate: DVRescueParserDelegate = DVRescueParserDelegate()
  
  func run(pathString: String) throws {
    slog("start tool")
    let data = try getDataFromFile(atPath: pathString)
    parseXML(with: data)
    try process(media: delegate.media, frames: delegate.frameBuffer)
  }
}

private extension DVRescueTimeStamp {
  func getDataFromFile(atPath path: String) throws -> Data {
    let hander = FileHandler(pathString: path)
    let data = try hander.loadFile()
    return data
  }
  
  func parseXML(with data: Data) {
    let xmlParser = XMLParser(data: data)
    
    xmlParser.delegate = delegate
    xmlParser.parse()
  }
  
  func process(media: Media?, frames: [Frame]) throws {
    guard let media = media else {
      fatalError(DVDateError.noMediaInfoFound.localizedDescription)
    }
    
    let builder = FileBuilder(media: media, frames: frames)
    try builder.validate()
    try builder.prepare()
  }
}
