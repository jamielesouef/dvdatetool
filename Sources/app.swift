// The Swift Programming Language
// https://docs.swift.org/swift-book
import Foundation
import ArgumentParser

@main struct App: ParsableCommand {
  
  @OptionGroup var options: Options

  public mutating func run() throws {
    
    vlog("DVDateTool.")
    Slogger.current.verbose(options.verbose)
    vlog("setup time tool...")
    buildOptions()
    let tool = DVRescueTimeStamp()
    
    try tool.run(pathString: options.path)

  }
}

private extension App {
  func buildOptions() {
    OptionsContainer.current.set(
      path: options.path,
      packageExtension: options.packageExtension,
      packgedFilesPath: options.packgedFilesPath,
      verbose: options.verbose,
      packagePrefix: options.packagePrefix,
      packagePostfix: options.packagePostfix,
      createNewFiles: options.createNewFiles
    )
  }
}


