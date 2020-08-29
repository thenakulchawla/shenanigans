
// convert to Int and compare
let todaysDate = Date().getFormattedDate(format: "yyyy-MM-dd") // Set output formate

extension Date {
   func getFormattedDate(format: String) -> String {
       let dateformat = DateFormatter()
       dateformat.dateFormat = format
       return dateformat.string(from: self)
   }

   var millisecondsSince1970:Double {
       return Double((self.timeIntervalSince1970 * 1000.0).rounded())
   }

   init(milliseconds:Double) {
       self = Date(timeIntervalSince1970: TimeInterval(milliseconds / 1000))
   }
}
