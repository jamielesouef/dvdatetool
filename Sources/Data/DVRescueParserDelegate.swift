import Foundation

final class DVRescueParserDelegate: NSObject, XMLParserDelegate {
  
  private (set) var frameBuffer: [Frame]
  
  let frameConverter: FrameConverter
  
  var handler: (([Frame]) -> Void)?
  
  init(frameBuffer: [Frame] = []) {
    
    self.frameBuffer = frameBuffer
    
    self.frameConverter = FrameConverter()
    super.init()
  }
  
  func parserDidStartDocument(_ parser: XMLParser) {
    vlog("Start of the document")
    vlog("Line number: \(parser.lineNumber)")
  }
  
  func parserDidEndDocument(_ parser: XMLParser) {
    vlog("End of the document")
    vlog("Line number: \(parser.lineNumber)")
    
    guard frameBuffer.count > 0 else {
      fatalError(DVDateError.noMediaInfoFound.localizedDescription)
    }
    vlog("found \(frameBuffer.count) frames")
    
    handler?(frameBuffer)
    frameBuffer.removeAll(keepingCapacity: true)
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
     default: return
      }
    } catch {
      slog(error)
    }
  }
}

