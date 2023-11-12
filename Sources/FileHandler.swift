//
//  File.swift
//  
//
//  Created by Jamie Le Souef on 12/11/2023.
//

import Foundation

class FileHandler {
  let fileManager = FileManager.default
  let url: URL
  let path: String
  
  enum _Error: Error {
    case errorReadingFile(string: String)
    case fileNotFound(string: URL)
  }
  
  init(pathString: String) {
    self.path = pathString
    self.url = URL(fileURLWithPath: pathString)
  }
  
  func loadFile() throws -> Data {
    if fileManager.fileExists(atPath: path) {
      do {
        return try Data(contentsOf: url)
      } catch {
        throw(_Error.errorReadingFile(string: error.localizedDescription))
      }
    } else {
      throw(_Error.fileNotFound(string: url))
    }
  }
}
