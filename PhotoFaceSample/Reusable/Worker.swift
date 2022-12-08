import UIKit
import Alamofire
import ObjectMapper

protocol PhotoFaceWorkerProtocol: AnyObject {
  func parseMainData(_ completion: @escaping (Response<AuthenticationModel>) -> Void)
  func getTransaction(cpf: String, token: String, completion: @escaping (Response<AuthenticationModel>) -> Void)
  func getTransactionID(transactionID: String, completion: @escaping ((Response<AuthenticationModel>) -> Void))
}

class PhotoFaceWorker: Request, PhotoFaceWorkerProtocol {
  
  let network = DataParser()
  let apiURL = "https://integracao-sodexo-homologacao.partner1.com.br/api"
  
  func parseMainData(_ completion: @escaping (Response<AuthenticationModel>) -> Void) {
    guard let url = URL(string: "\(apiURL)/authentication") else {
      return
    }
    
    let body: [String:Any] = [
      "username": "HMG.IOS",
      "password": "eQtlC7BM",
      "grant_type": "password"
    ]
    
    network.mainParser(url: url, body: body, method: .post, completion: completion)
  }
  
  func getTransaction(cpf: String, token: String, completion: @escaping (Response<AuthenticationModel>) -> Void) {
    guard let url = URL(string: "\(apiURL)/transaction") else {
      return
    }
    
    let body: [String:Any] = [
      "cpf": cpf
    ]
    
    network.loginParser(url: url, body: body, header: token, method: .post, completion: completion)
  }
  
  func getTransactionID(transactionID: String, completion: @escaping ((Response<AuthenticationModel>) -> Void)) {
    guard let url = URL(string: "\(apiURL)/transaction/\(transactionID)") else {
      return
    }
    
    
  }
}
