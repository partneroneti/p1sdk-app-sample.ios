import Foundation
import ObjectMapper

struct ErrorModel: Mappable {
  var type: String?
  var title: String?
  var status: Int?
  var detail: String?
  var instance: String?
  var additionalProp1: String?
  var additionalProp2: String?
  var additionalProp3: String?
  
  init?(map: Map) {
    type = (try? map.value("type")) ?? ""
    title = (try? map.value("title")) ?? ""
    status = (try? map.value("status")) ?? 0
    detail = (try? map.value("detail")) ?? ""
    instance = (try? map.value("instance")) ?? ""
    additionalProp1 = (try? map.value("additionalProp1")) ?? ""
    additionalProp2 = (try? map.value("additionalProp2")) ?? ""
    additionalProp3 = (try? map.value("additionalProp3")) ?? ""
  }
  
  mutating func mapping(map: Map) {
      type <- map["type"]
      title <- map["title"]
      status <- map["status"]
      detail <- map["detail"]
      instance <- map["instance"]
      additionalProp1 <- map["additionalProp1"]
      additionalProp2 <- map["additionalProp2"]
      additionalProp3 <- map["additionalProp3"]
  }
}
