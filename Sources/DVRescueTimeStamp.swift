//
//  File.swift
//
//
//  Created by Jamie Le Souef on 12/11/2023.
//

import Foundation

final public class DVRescueTimeStamp {
  
  private let delegate: XMLParserDelegate = DVRescueParserDelegate()
  
  func run(pathString: String) throws {
    try openFile(atPath: pathString)
  }
}

private extension DVRescueTimeStamp {
  func openFile(atPath path: String) throws {
    slog(path)
    let hander = FileHandler(pathString: path)
    let data = try hander.loadFile()
    
    let xmlParser = XMLParser(data: data)
    
    xmlParser.delegate = delegate
    xmlParser.parse()
  }
}
