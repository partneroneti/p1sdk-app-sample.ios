import UIKit

struct Status {
  var message: String
  
  mutating func set(msg: String) {
    message = msg
  }
}

class StatusViewModel {
  
  //MARK: - Properties
  
  let worker: PhotoFaceWorker
  
  var didChangeStatus: ((Status) -> Void)?
  var statusMessage: Status = Status(message: "") {
    didSet {
      didChangeStatus?(statusMessage)
    }
  }
  var transactionID: String?
  var status: Int?
  var statusDescription: String?
  var timer: DispatchSourceTimer?
  
  //MARK: - init
  
  init(worker: PhotoFaceWorker = PhotoFaceWorker()) {
    self.worker = worker
  }
}

//MARK: - Functions

extension StatusViewModel {
  /// TransactionID getter
  ///
  func setupTransactionID() {
    guard let transactionID = self.transactionID else {
      return
    }
    
    worker.getTransactionID(transactionID: transactionID) { [weak self] (response) in
      guard let self = self else { return }
    
      switch response {
      case .success(let model):
        self.status = model.objectReturn[0].result[0].status
        self.statusDescription = String(model.objectReturn[0].result[0].statusDescription)
        
        self.didChangeStatus = { status in
          self.statusMessage.set(msg: String(model.objectReturn[0].result[0].statusDescription))
        }
        
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
  
  /// Trigger to refresh status
  /// 
  func triggerGetStatus(in interval: DispatchTimeInterval, completion: @escaping (() -> Void)) {
    timer = DispatchSource.makeTimerSource(flags: .strict, queue: .main)
    timer?.setEventHandler(handler: completion)
    timer?.schedule(deadline: .now() + interval, leeway: .milliseconds(500))
    timer?.activate()
  }
}
