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

class LoginViewModel: LogiViewModelProtocol, AccessTokeProtocol {
  
  weak var viewController: LoginViewController?
  private weak var navigationDelegate: PhotoFaceNavigationDelegate?
  
  let helper = PartnerHelper()
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
        /// Passes AccessToken to Worker Layer
        ///
        self.worker.accessToken = model.objectReturn[0].accessToken
        self.accessToken = model.objectReturn[0].accessToken
        
        print("@! >>> ACCESS_TOKEN: ", model.objectReturn[0].accessToken)
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
  
  /// Login Authentication
  /// 
  func sendCPFAuth(cpf: String, completion: @escaping (() -> Void)) {
    worker.getTransaction(cpf: cpf) { [weak self] (response) in
      guard let self = self else { return }
      
      switch response {
      case .success(let model):
        /// Get and passa TransactionID to SDK Helper
        ///
        self.helper.transactionID = String(model.objectReturn[0].transactionId!)
        
        /// Navigate to SDK after API response 200
        ///
        if let viewController = self.viewController {
          self.openSDK(viewController)
        }
        
        print("@! >>> TRANSACTION_ID: \(String(model.objectReturn[0].transactionId!))")
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
    helper.initializeSDK(viewController)
  }
  
  func openStatusView(_ viewController: UIViewController) {
    let mainViewModel = StatusViewModel()
    let mainViewController = StatusViewController(viewModel: mainViewModel)
    let topController = UIApplication.shared.keyWindow?.rootViewController
    
    if topController == LoginViewController(viewModel: self) {
      viewController.navigationController?.pushViewController(mainViewController, animated: true)
    }
    
    helper.visibleViewController(viewControllerToPush: mainViewController)
  }
}
