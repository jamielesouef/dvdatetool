import Foundation

struct FrameConverter {
  
  private let formatter: DateFormatter
  
  init() {
    self.formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
  }
  
  func convert(data:[String: String]) throws -> Frame? {
    guard data["rec_start"] == "1",
          let n = data["n"],
          let rdt = data["rdt"],
          let recordDate = formatter.date(from: rdt) else {
      
      return nil
    }
    
    guard let nInt = UInt(n) else {
      throw DVDateError.notANumber
    }
    
    return Frame(n: nInt, recordDateTime: recordDate, recordStart: true)
    
  }
}

