import UIKit

class StatusViewModel {
  
  var transactionID: String = "e5d7d083-7d69-403c-876f-981816badcbf"
  var status: Int?
  var statusDescription: String?
  
  let worker: PhotoFaceWorker
  
  init(worker: PhotoFaceWorker = PhotoFaceWorker()) {
    self.worker = worker
  }
  
  func setupTransactionID() {
    worker.getTransactionID(transactionID: self.transactionID) { [weak self] (response) in
      guard let self = self else { return }
    
      switch response {
      case .success(let model):
        self.status = model.objectReturn[0].result[0].status
        self.statusDescription = String(model.objectReturn[0].result[0].statusDescription!)
        print("@! >>> STATUS_DESCRIPTION", model.objectReturn[0].result[0].statusDescription)
      case .noConnection(let description):
          print("Server error timeOut: \(description) \n")
      case .serverError(let error):
          let errorData = "\(error.statusCode), -, \(error.msgError)"
          print("Server error: \(errorData) \n")
          break
      case .timeOut(let description):
          print("Server error noConnection: \(description) \n")
      }
    }
  }
  
}
