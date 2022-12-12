import Foundation
import ObjectMapper

struct SessionIDModel: Mappable {
  var session: String

  init?(map: Map) {
    session = (try? map.value("session")) ?? ""
  }

  mutating func mapping(map: Map) {
    session <- map["session"]
  }
}
