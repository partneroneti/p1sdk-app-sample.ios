import Foundation
import ObjectMapper

struct TransactionIDModel: Mappable {
  var transactionId: String
  var result: [ResultModel]

  init?(map: Map) {
    transactionId = (try? map.value("transactionId")) ?? ""
    result = [(try? map.value("result")) ?? ResultModel(map: map)!]
  }

  mutating func mapping(map: Map) {
    transactionId <- map["transactionId"]
    result <- map["result"]
  }
}
