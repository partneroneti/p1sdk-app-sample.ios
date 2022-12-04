import Foundation
import ObjectMapper

struct ObjectReturnModel: Mappable {
  var expires_in: Int?
  var access_token: String?
  var token_type: String?
  
  init?(map: Map) {
    expires_in = (try? map.value("expires_in")) ?? 0
    access_token = (try? map.value("access_token")) ?? ""
    token_type = (try? map.value("token_type")) ?? ""
  }
  
  mutating func mapping(map: Map) {
    expires_in <- map["expires_in"]
    access_token <- map["access_token"]
    token_type <- map["token_type"]
  }
}
