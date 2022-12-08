import UIKit
import Alamofire
import ObjectMapper

protocol AccessTokeProtocol: AnyObject {
  var accessToken: String { get set }
}

protocol PhotoFaceWorkerProtocol: AnyObject {
  func parseMainData(_ completion: @escaping (Response<AuthenticationModel>) -> Void)
  func getTransaction(cpf: String, completion: @escaping (Response<TransactionModel>) -> Void)
  func getTransactionID(transactionID: String, completion: @escaping ((Response<AuthenticationModel>) -> Void))
}

class PhotoFaceWorker: Request, PhotoFaceWorkerProtocol, AccessTokeProtocol {
  
  let network = DataParser()
  let apiURL = "https://integracao-sodexo-homologacao.partner1.com.br/api"
  
  var accessToken: String
  
  init(accessToken: String = "") {
    self.accessToken = accessToken
  }
  
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
  
  func getTransaction(cpf: String, completion: @escaping (Response<TransactionModel>) -> Void) {
    guard let url = URL(string: "\(apiURL)/transaction") else {
      return
    }
    
    let body: [String:Any] = [
      "cpf": cpf
    ]
    
    network.loginParser(url: url, body: body, header: accessToken, method: .post, completion: completion)
    
//    "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1bmlxdWVfbmFtZSI6IkhNRy5JT1MiLCJqdGkiOiI0MyIsIm5iZiI6MTY3MDUxNzI2NSwiZXhwIjoxNjcwNTE5MDY1LCJpYXQiOjE2NzA1MTcyNjUsImlzcyI6IlBhcnRuZXJPbmVFc3RlaXJhIiwiYXVkIjoiUGFydG5lck9uZUVzdGVpcmEifQ._MW14Y_yQOSorjMhKFKDMDkBQzz-1I1dd_8Hxj5gQZs"
  }
  
  func getTransactionID(transactionID: String, completion: @escaping ((Response<AuthenticationModel>) -> Void)) {
    guard let url = URL(string: "\(apiURL)/transaction/\(transactionID)") else {
      return
    }
    
    
  }
}
