import Foundation

final class DVRescueParserDelegate: NSObject, XMLParserDelegate {
  
  private var media: Media?
  private var frameBuffer: [Frame] = []
  
  func parserDidStartDocument(_ parser: XMLParser) {
    slog("Start of the document")
    slog("Line number: \(parser.lineNumber)")
  }
  
  func parserDidEndDocument(_ parser: XMLParser) {
    slog("End of the document")
    slog("Line number: \(parser.lineNumber)")
    
    guard media != nil else {
      fatalError(DVDateError.noMediaInfoFound.localizedDescription)
    }
    
    guard frameBuffer.count > 0 else {
      fatalError(DVDateError.noMediaInfoFound.localizedDescription)
    }
    slog(frameBuffer.count)
  }
  
  func parser(
    _ parser: XMLParser,
    didStartElement elementName: String,
    namespaceURI: String?,
    qualifiedName qName: String?,
    attributes attributeDict: [String : String] = [:]
  ) {
    slog("parsing \(elementName)")
    do {
      switch elementName {
      case "frame":
        let frame = try Converter.frame.convert(data: attributeDict)
        frameBuffer.append(frame)
      case "media":
        let _media = try Converter.media.convert(data: attributeDict)
        media = _media
      default: return
      }
    } catch {
      slog(error)
    }
  }
}

