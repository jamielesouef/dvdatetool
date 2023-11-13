import Foundation

final public class Slogger {
  static let current: Slogger = Slogger()
}

func slog(_ logging: Error, file: String = #file, line: Int = #line, function: String = #function) {
  if OptionsContainer.current.verbose == 1 {
    slog(logging.localizedDescription, file: #file, line: line, function: function)
  }
}

func vlog(_ logging: Any..., file: String = #file, line: Int = #line, function: String = #function) {
  if OptionsContainer.current.verbose == 1 {
    slog(logging, file: #file, line: line, function: function)
  }
}

func slog(_ logging: Any..., file: String = #file, line: Int = #line, function: String = #function) {
  if OptionsContainer.current.verbose == 0 {
    logging.forEach { print($0) }
    return
  }
  
  let logger = _Slogger(file: file, line: line, function: function)
  
  if let _f = logging.first as? Error {
    logger.log(_f)
  } else {
    logger.log(logging)
  }
}

private class _Slogger {
  
  let file: String
  let line: Int
  let function: String
  let fileName: String
  
  init(file: String, line: Int, function: String) {
    self.file = file
    self.line = line
    self.function = function
    self.fileName = file.split(separator: "/").last?.replacingOccurrences(of: ".swift", with: "") ?? ""
  }
    
  func log(_ logging: Any...) {
    let d = logging.map { String(describing: $0) }.joined(separator: " | ")
    message(d)
  }
  
  private func message(_ item: Any) {
    
    let prefix = item is Error ? "!!! " : ""
    
#if DEBUG
    let message = "\(prefix)\(item) |---\(fileName)::\(function):\(line))"
    print(message)
#endif
    
  }
}
