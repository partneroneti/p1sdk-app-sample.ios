import Foundation
import ObjectMapper

struct ObjectReturnModel: Mappable {
  var expiresIn: Int
  var accessToken: String
  var tokenType: String
  
  init?(map: Map) {
    expiresIn = (try? map.value("expires_in")) ?? 0
    accessToken = (try? map.value("access_token")) ?? ""
    tokenType = (try? map.value("token_type")) ?? ""
  }

  mutating func mapping(map: Map) {
    expiresIn <- map["expires_in"]
    accessToken <- map["access_token"]
    tokenType <- map["token_type"]
  }
}
