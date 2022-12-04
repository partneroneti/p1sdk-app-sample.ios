import Foundation
import ObjectMapper

struct TestModel: Mappable {
  var paths: String?
  
  init?(map: Map) {
    paths = (try? map.value("paths")) ?? ""
  }

  mutating func mapping(map: Map) {
    paths <- map["paths"]
  }
}
