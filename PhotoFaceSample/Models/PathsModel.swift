import Foundation

struct Paths: Codable {
  let document: String
  
  enum CodingKeys: String, CodingKey {
    case document = "quizId"
  }
}
