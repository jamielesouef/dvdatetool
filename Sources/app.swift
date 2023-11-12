// The Swift Programming Language
// https://docs.swift.org/swift-book
import Foundation
import ArgumentParser



@main struct App: ParsableCommand {
  private enum _Error: String, Error {
      case noPath = "No path supplied"
  }
  
  @Option(name: .shortAndLong, help: "Path of the file to open")
  var path: String? = nil
  
  @Flag(name: .shortAndLong)
  var verbose: Bool = false

  public mutating func run() throws {
    
    guard let path = path else {
      throw _Error.noPath
    }
    
    Slogger.current.verbose(verbose)
    
    let tool = DVRescueTimeStamp()
    try tool.run(pathString: path)

  }
}


