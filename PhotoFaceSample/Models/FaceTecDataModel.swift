import Foundation
import ObjectMapper

struct FaceTecDataModel: Mappable {
  var certificate: String
  var deviceKeyIdentifier: String
  var productionKeyText: String

  init?(map: Map) {
    certificate = (try? map.value("certificate")) ?? ""
    deviceKeyIdentifier = (try? map.value("deviceKeyIdentifier")) ?? ""
    productionKeyText = (try? map.value("productionKeyText")) ?? ""
  }

  mutating func mapping(map: Map) {
    certificate <- map["certificate"]
    deviceKeyIdentifier <- map["deviceKeyIdentifier"]
    productionKeyText <- map["productionKeyText"]
  }
}
