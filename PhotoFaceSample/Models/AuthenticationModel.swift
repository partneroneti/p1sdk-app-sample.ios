import Foundation
import ObjectMapper

//struct AuthenticationModel: Decodable {
//  var success: Bool?
//  var message: String?
//  var timeProcess: Int?
//  var requestId: String?
//  var objectReturn: [ObjectReturnModel]?
//}

struct AuthenticationModel: Mappable {
  var success: Bool?
  var message: String?
  var timeProcess: Int?
  var requestId: String?
  var objectReturn: [ObjectReturnModel]
  
  init?(map: Map) {
    success = (try? map.value("success")) ?? false
    message = (try? map.value("message")) ?? ""
    timeProcess = (try? map.value("timeProcess")) ?? 0
    requestId = (try? map.value("requestId")) ?? ""
    objectReturn = [(try? map.value("objectReturn")) ?? ObjectReturnModel(map: map)!]
  }
  
  mutating func mapping(map: Map) {
    success <- map["success"]
    message <- map["message"]
    timeProcess <- map["timeProcess"]
    requestId <- map["requestId"]
    objectReturn <- map["objectReturn"]
  }
}
