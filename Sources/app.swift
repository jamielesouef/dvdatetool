// The Swift Programming Language
// https://docs.swift.org/swift-book
import Foundation
import ArgumentParser

@main struct App: ParsableCommand {
  
  @OptionGroup var options: Options

  public mutating func run() throws {
    
    guard let path = options.path else {
      slog(DVDateError.noPath)
      return
    }
    slog("your name?")
  
    slog("setup loggin...")
    Slogger.current.verbose(options.verbose)
    slog("setup time tool...")
    let tool = DVRescueTimeStamp()
    
    try tool.run(pathString: path)

  }
}


