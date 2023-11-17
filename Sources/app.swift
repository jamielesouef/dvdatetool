// The Swift Programming Language
// https://docs.swift.org/swift-book
import Foundation
import ArgumentParser

@main struct App: ParsableCommand {
  
  @OptionGroup var options: Options

  public mutating func run() throws {
    Slogger.current.setup(options: options)
    vlog("DVDateTool.")
    
    vlog("setup time tool...")
    let source = try DVSourceBuilder(options: options).run()
   
    try DVTimestampBuilder(
      source: source,
      options: options
    )
      .run()
    
  }
}

