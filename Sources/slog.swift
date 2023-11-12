import Foundation

final public class Slogger {
  static let current: Slogger = Slogger()
  private (set) var verbose: Bool = false
  
  private init() {
    
  }
  
  func verbose(_ bool: Bool) {
    self.verbose = bool
  }
}

func slog(_ loggin: Error) {
  slog(loggin.localizedDescription, file: #file)
}

func slog(_ logging: Any..., file: String = #file, line: Int = #line, function: String = #function) {
  if Slogger.current.verbose == false {
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
  
  func error(_ error: Error) {
    message(error, true)
  }
  
  func log(_ logging: Any...) {
    let d = logging.map { String(describing: $0) }.joined(separator: " | ")
    message(d)
  }
  
  private func message(_ item: Any, _ error: Bool = false) {
    let prefix = error ? "!!!" : "---"
    
#if DEBUG
    let message = "\(prefix)| \(item) |---\(fileName)::\(function):\(line))"
    debugPrint(message)
#endif
    
  }
}
