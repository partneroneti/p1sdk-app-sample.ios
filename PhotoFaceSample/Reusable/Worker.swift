import UIKit
import Alamofire
import ObjectMapper

protocol AccessTokeProtocol: AnyObject {
  var accessToken: String { get set }
}

protocol PhotoFaceWorkerProtocol: AnyObject {
  func parseMainData(_ completion: @escaping (Response<AuthenticationModel>) -> Void)
  func getTransaction(cpf: String, completion: @escaping (Response<TransactionModel>) -> Void)
  func getTransactionID(transactionID: String, completion: @escaping ((Response<TransactionIDModel>) -> Void))
  func getCredentials(completion: @escaping (Response<CredentialsModel>) -> Void)
}

class PhotoFaceWorker: Request, PhotoFaceWorkerProtocol, AccessTokeProtocol {
  
  let network = DataParser()
  var apiURL: String = "https://integracao-sodexo-homologacao.partner1.com.br/api"
  
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
  }
  
  func getTransactionID(transactionID: String, completion: @escaping ((Response<TransactionIDModel>) -> Void)) {
    guard let url = URL(string: "\(apiURL)/transaction/\(transactionID)") else {
      return
    }
    
    network.loginParser(url: url, header: accessToken, method: .get, completion: completion)
  }
  
  func getCredentials(completion: @escaping (Response<CredentialsModel>) -> Void) {
    guard let url = URL(string: "\(apiURL)/credentials") else {
      return
    }
    
    network.getParser(url: url, header: accessToken, method: .get, completion: completion)
  }
}
