import Foundation
import ObjectMapper

struct TransactionModel: Mappable {
  var transactionId: String
  
  init?(map: Map) {
    transactionId = (try? map.value("transactionId")) ?? ""
  }
  
  mutating func mapping(map: Map) {
    transactionId <- map["transactionId"]
  }
}
