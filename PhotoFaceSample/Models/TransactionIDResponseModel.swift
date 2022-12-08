import Foundation
import ObjectMapper

struct TransactionIDResponseModel: Mappable {
  var transactionId: String
  var result: [ResultModel]

  init?(map: Map) {
    transactionId = (try? map.value("transactionId")) ?? ""
    result = [(try? map.value("statusDescription")) ?? ResultModel(map: map)!]
  }

  mutating func mapping(map: Map) {
    transactionId <- map["transactionId"]
    result <- map["result"]
  }
}
