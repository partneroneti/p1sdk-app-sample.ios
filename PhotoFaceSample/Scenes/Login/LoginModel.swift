import Foundation
import ObjectMapper

struct LoginModel: Mappable {
  var cpf: String?

  init?(map: Map) {
    cpf = (try? map.value("cpf")) ?? ""
  }

  mutating func mapping(map: Map) {
    cpf <- map["cpf"]
  }
}

//struct LoginModel: Decodable {
//  var cpf: String?
//}
