import UIKit
import Alamofire
import PartnerOneSDK

//MARK: - Protocols

protocol LogiViewModelProtocol: AnyObject {
  var worker: PhotoFaceWorker { get }
}

/// Just for navigation Purposes
///
protocol PhotoFaceNavigationDelegate: AnyObject {
  func openSDK(_ viewController: UIViewController)
  func openStatusView()
}

//MARK: - Class

class LoginViewModel: LogiViewModelProtocol {
  
  private weak var navigationDelegate: PhotoFaceNavigationDelegate?
  
  let worker: PhotoFaceWorker
  var transactionID: String = ""
  var accessToken: String = ""
  
  init(worker: PhotoFaceWorker,
       navigationDelegate: PhotoFaceNavigationDelegate? = nil) {
    self.worker = worker
    self.navigationDelegate = navigationDelegate
  }
  
  func getInitialData() {
    print("@! >>> Begin main data fetch...")
    
    worker.parseMainData { [weak self] (response) in
      guard let self = self else { return }
      switch response {
      case .success(let model):
        self.accessToken = model.objectReturn[0].accessToken ?? ""
        print(self.accessToken)
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
  
  func sendCPFAuth(cpf: String, completion: @escaping (() -> Void)) {
    worker.getTransaction(cpf: cpf, token: accessToken) { (response) in
      switch response {
      case .success(let model):
//        model
        print(model)
        break
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

// MARK: - Navigation Delegate

extension LoginViewModel {
  
  func openSDK(_ viewController: UIViewController) {
    let viewModel = ScanViewModel(transactionID: transactionID)
    let mainViewController = ScanViewController(viewModel: viewModel, viewTitle: "Frente")
    viewController.navigationController?.pushViewController(mainViewController, animated: true)
  }
  
  func openStatusView(_ viewController: UIViewController) {
    let viewModel = StatusViewModel()
    let mainViewController = StatusViewController(viewModel: viewModel)
    
    viewController.navigationController?.pushViewController(mainViewController, animated: true)
  }
}
