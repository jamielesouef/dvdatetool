import Foundation

func prompt_continue(message: String = "", callback: (() -> Void)? = nil) {
  slog("continue y/n? \(message)")
  guard let shouldContinue = readLine()?.lowercased(),
        shouldContinue == "n" || shouldContinue == "y" else {
    fatalError("Invalid response")
  }
  
  if shouldContinue == "n" {
    exit(0)
  }
}
