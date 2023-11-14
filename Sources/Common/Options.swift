import Foundation
import ArgumentParser

struct Options: ParsableArguments {
  @Argument(help: "Path to the dvresuce xml file(s)")
  var path: String
  
  @Argument(help: "Extension of the packaged files")
  var packageExtension: String = "mov"
  
  @Argument(help: "Package prefix")
  var packagePrefix: String = ""
  
  @Argument(help: "Package postfix")
  var packagePostfix: String = ""
  
  @Argument(help: "Path to packaged files")
  var packgedFilesPath: String = "/"
  
  @Flag(name: .shortAndLong, help: "Show more logging")
  var verbose: Int
  
  @Flag(name: .shortAndLong, help: "Look for xml files within sub folders")
  var recursive: Int
  
  @Option(name: .shortAndLong, help: "Create new files")
  var createNewFiles: Bool?
  
  @Option(name: .shortAndLong, help: "The DVRescue XML postfix")
  var xmlPostfix: String = "dvrescue.xml"
  
}
