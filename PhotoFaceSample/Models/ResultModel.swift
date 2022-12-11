import Foundation
import ObjectMapper

struct ResultModel: Mappable {
  var status: Int
  var statusDescription: String

  init?(map: Map) {
    status = (try? map.value("status")) ?? 0
    statusDescription = (try? map.value("statusDescription")) ?? ""
  }

  mutating func mapping(map: Map) {
    status <- map["status"]
    statusDescription <- map["statusDescription"]
  }
}
