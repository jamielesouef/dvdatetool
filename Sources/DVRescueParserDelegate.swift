//
//  File.swift
//
//
//  Created by Jamie Le Souef on 12/11/2023.
//

import Foundation

struct Media {
  let ref: String
  let format: String
  let size: UInt
}

struct Frame {
  let n: UInt
  let recordDateTime: Date
  let recordStart: Bool
}

final class DVRescueParserDelegate: NSObject, XMLParserDelegate {
  
  private var media: [Media?] = []
  private var frameBuffer: [Frame] = []
  
  func parserDidStartDocument(_ parser: XMLParser) {
    slog("Start of the document")
    slog("Line number: \(parser.lineNumber)")
  }
  
  func parserDidEndDocument(_ parser: XMLParser) {
    slog("End of the document")
    slog("Line number: \(parser.lineNumber)")
    slog(media.first??.size)
    slog(frameBuffer.count)
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
        let frame = try Converter.frame.convert(data: attributeDict)
        frameBuffer.append(frame)
      case "media":
        let _media = try Converter.media.convert(data: attributeDict)
        media.append(_media)
      default: return
      }
    } catch {
      slog(error)
    }
  }
}

