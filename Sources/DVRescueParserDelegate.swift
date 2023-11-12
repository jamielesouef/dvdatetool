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
  let frameBuffer: [Frame]
}

struct Frame {
  let n: UInt
  let recordDateTime: Date
  let recordStart: Bool
}

final class DVRescueParserDelegate: NSObject, XMLParserDelegate {
  
  private let media: Media? = nil
  private var frameBuffer: [Frame] = []
  
  func parserDidStartDocument(_ parser: XMLParser) {
    slog("Start of the document")
    slog("Line number: \(parser.lineNumber)")
  }
  
  func parserDidEndDocument(_ parser: XMLParser) {
    slog("End of the document")
    slog("Line number: \(parser.lineNumber)")
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
      print(attributeDict)
    case "media":
      print(attributeDict)
    default: return
    }
  }
}

