import UIKit
import Alamofire
import ObjectMapper

protocol PhotoFaceWorkerProtocol: AnyObject {
  func parseMainData(_ completion: @escaping (_ response: Result<LoginModel, ErrorType>) -> Void)
}

class PhotoFaceWorker: Request, PhotoFaceWorkerProtocol {
  
  let network = DataParser()
  let apiURL = "https://integracao-sodexo-homologacao.partner1.com.br/swagger/v1/swagger.json"
  
  func parseMainData(_ completion: @escaping (Result<LoginModel, ErrorType>) -> Void) {
    guard let url = URL(string: "\(apiURL)/api/transaction") else {
      return
    }
    
    network.decoderParser(url: url, method: .post, completion: completion)
    
//    let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
//      guard let dataResponse = data,
//            error == nil else {
//        print(error?.localizedDescription ?? "Response Error")
//        return }
//      do {
//        let decoder = JSONDecoder()
//        let response = try? decoder.decode(LoginModel.self, from: dataResponse)
//
//        if let response = response {
//          completion(.success(model: response))
//        } else {
//          print("Not possible to parse...")
//        }
//
//      } catch let parsingError {
//        print("Sorray... The data could not be parsed for some reason.", parsingError)
//      }
//    }
//    task.resume()
  }
}
