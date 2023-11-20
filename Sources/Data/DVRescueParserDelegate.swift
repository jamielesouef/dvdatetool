import Foundation

final class DVRescueParserDelegate: NSObject, XMLParserDelegate {
  
  private (set) var frameBuffer: [Frame]
  private var buffer: [[String: String]] = []
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
    
    guard buffer.count > 0, let first = buffer.first, let last = buffer.last else {
      fatalError(
        DVDateError.noMediaInfoFound.localizedDescription
      )
    }
    
    do {
      
      frameBuffer = try buffer.compactMap {
        try frameConverter.convert(
          data: $0
        )
      }
      
      let firstFrame = try frameConverter.unsafeConvert(data: first)
      let lastFrame = try frameConverter.unsafeConvert(data: last)
      frameBuffer.append(firstFrame)
      frameBuffer.append(lastFrame)
      
      frameBuffer = frameBuffer.sorted { $0.n < $1.n }
      
    } catch {
      vlog(error)
      fatalError(DVDateError.noFrameData.localizedDescription)
    }
    
    vlog("found \(frameBuffer.count) frames")
    
    handler?(frameBuffer)
    frameBuffer.removeAll(keepingCapacity: true)
    buffer.removeAll(keepingCapacity: true)
  }
  
  func parser(
    _ parser: XMLParser,
    didStartElement elementName: String,
    namespaceURI: String?,
    qualifiedName qName: String?,
    attributes attributeDict: [String : String] = [:]
  ) {
    
    switch elementName {
    case "frame":
      buffer.append(attributeDict)
    default: return
    }
    
  }
}

