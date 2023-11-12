import Foundation

final public class DVRescueTimeStamp {
  
  private let delegate: XMLParserDelegate = DVRescueParserDelegate()
  
  func run(pathString: String) throws {
    slog("start tool")
    try openFile(atPath: pathString)
  }
}

private extension DVRescueTimeStamp {
  func openFile(atPath path: String) throws {
    
    let hander = FileHandler(pathString: path)
    let data = try hander.loadFile()
    let xmlParser = XMLParser(data: data)
    
    xmlParser.delegate = delegate
    xmlParser.parse()
  }
}
