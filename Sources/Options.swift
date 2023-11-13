import Foundation
import ArgumentParser

final class Options: ParsableArguments {
  @Argument(help: "Path of the file to open")
  var path: String
  
  @Argument(help: "Extension of the packaged files")
  var packageExtension: String = OptionsContainer.current.packageExtension
  
  @Argument(help: "Package prefix")
  var packagePrefix: String = OptionsContainer.current.packagePrefix
  
  @Argument(help: "Package postfix")
  var packagePostfix: String = OptionsContainer.current.packagePostfix
  
  @Argument(help: "Path to packaged files")
  var packgedFilesPath: String = OptionsContainer.current.packgedFilesPath
  
  @Flag(name: .shortAndLong)
  var verbose: Int
  
  @Option(name: .shortAndLong, help: "Create new files")
  var createNewFiles: Bool?
}



final class OptionsContainer {
  static let current = OptionsContainer()
  
  var path: String = "/"
  var packageExtension: String = "mov"
  var packgedFilesPath: String = "/"
  var verbose: Int = 0
  var packagePrefix = ""
  var packagePostfix = "_part"
  var createNewFiles: Bool?
  
  private init() {}
  
  func set(
    path: String,
    packageExtension: String,
    packgedFilesPath: String,
    verbose: Int,
    packagePrefix: String,
    packagePostfix: String,
    createNewFiles: Bool?
  ) {
    self.path = path
    self.packageExtension = packageExtension
    self.packgedFilesPath = packgedFilesPath
    self.verbose = verbose
    self.packagePrefix = packagePrefix
    self.packagePostfix = packagePostfix
    self.createNewFiles = createNewFiles
  }
}
