import Foundation
import ArgumentParser

struct Options: ParsableArguments {
  @Argument(help: "Path of the file to open")
  var path: String? = nil
  
  @Flag(name: .shortAndLong)
  var verbose: Bool = false
}
