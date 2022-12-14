import UIKit
import Foundation
import ObjectMapper

class DocumentDataModel: NSObject, Mappable {
  var type: String?
  var byte: String?
  
  required init?(map: Map) {}

  func mapping(map: Map) {
    type <- map["type"]
    byte <- map["byte"]
  }
}
