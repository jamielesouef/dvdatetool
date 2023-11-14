import Foundation

final class DVRescueParserDelegate: NSObject, XMLParserDelegate {
  
  private (set) var media: Media?
  private (set) var frameBuffer: [Frame]
  
  let frameConverter: FrameConverter
  let mediaConverter: MediaConverter
  
  var handler: ((Media, [Frame]) -> Void)?
  
  init(media: Media? = nil, frameBuffer: [Frame] = [], options: Options) {
    self.media = media
    self.frameBuffer = frameBuffer
    
    self.frameConverter = FrameConverter()
    self.mediaConverter = MediaConverter(path: options.path)
    super.init()
  }
  
  func parserDidStartDocument(_ parser: XMLParser) {
    vlog("Start of the document")
    vlog("Line number: \(parser.lineNumber)")
  }
  
  func parserDidEndDocument(_ parser: XMLParser) {
    vlog("End of the document")
    vlog("Line number: \(parser.lineNumber)")
    
    guard let media else {
      fatalError(DVDateError.noMediaInfoFound.localizedDescription)
    }
    
    guard frameBuffer.count > 0 else {
      fatalError(DVDateError.noMediaInfoFound.localizedDescription)
    }
    vlog("found \(frameBuffer.count) frames")
    
    handler?(media, frameBuffer)
  }
  
  func parser(
    _ parser: XMLParser,
    didStartElement elementName: String,
    namespaceURI: String?,
    qualifiedName qName: String?,
    attributes attributeDict: [String : String] = [:]
  ) {
    do {
      switch elementName {
      case "frame":
        guard let frame = try frameConverter.convert(data: attributeDict) else { return }
        frameBuffer.append(frame)
      case "media":
        let _media = try mediaConverter.convert(data: attributeDict)
        media = _media
      default: return
      }
    } catch {
      slog(error)
    }
  }
}

