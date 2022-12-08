import UIKit

//MARK: - Protocol

protocol PartnerOneWorkerProtocol: AnyObject {
  func sendPictures(transactionId: String,
                    type: String,
                    byte: String,
                    completion: @escaping (_ response: Response<DocumentModel>) -> Void)
  func getSession(completion: @escaping ((Response<SessionModel>) -> Void))
}

class PartnerOneWorker: PartnerOneWorkerProtocol {
  
  //MARK: - Properties
  
  let network = DataParser()
  public var apiURL = "https://integracao-sodexo-homologacao.partner1.com.br/api"
  
  //MARK: - Functions
  ///
  /// Send documentation pictures taken befor to /api/document
  ///
  func sendPictures(transactionId: String,
                    type: String,
                    byte: String,
                    completion: @escaping (Response<DocumentModel>) -> Void) {
    guard let url = URL(string: "\(apiURL)/document") else {
      return
    }
    
    let bodyData: [String:Any] = [
      "transactionId": transactionId,
      "documents": [
        "type": type,
        "byte": byte
      ]
    ]
    
    network.mainParser(url: url, body: bodyData, method: .post, completion: completion)
  }
  
  /// Get session data from /api/session
  ///
  func getSession(completion: @escaping ((Response<SessionModel>) -> Void)) {
    guard let url = URL(string: "\(apiURL)/session") else {
      return
    }
    
    network.sessionParser(url: url, method: .get, completion: completion)
  }
  
  /// Send data captured from Facetec to /api/liveness
  ///
  func sendLivenessData(transactionId: String,
                        faceScan: String,
                        auditTrailImage: String,
                        lowQualityAuditTrailImage: String,
                        sessionId: String,
                        deviceKey: String,
                        completion: @escaping ((Response<LivenessModel>) -> Void)) {
    guard let url = URL(string: "\(apiURL)/liveness") else {
      return
    }
    
    let bodyData: [String:Any] = [
      "transactionId": transactionId,
      "faceScan": faceScan,
      "auditTrailImage": auditTrailImage,
      "lowQualityAuditTrailImage": lowQualityAuditTrailImage,
      "sessionId": sessionId,
      "deviceKey": deviceKey
    ]
    
    network.mainParser(url: url, body: bodyData, method: .post, completion: completion)
  }
  
  /// Get Fectec Keys from /api/credentials
  ///
  func getFaceTecCredentials(completion: @escaping ((Response<CredentialsModel>) -> Void)) {
    guard let url = URL(string: "\(apiURL)/credentials") else {
      return
    }
    
    network.mainParser(url: url, method: .get, completion: completion)
  }
}
