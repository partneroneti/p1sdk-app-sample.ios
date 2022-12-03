import UIKit
import Alamofire
import PartnerOneSDK

protocol PhotoFaceNavigationDelegate: AnyObject {
  var worker: PhotoFaceWorker { get }
  func openSDK(_ viewController: UIViewController)
  func openStatusView(_ viewController: UIViewController)
}

class LoginViewModel {
  
  private weak var navigationDelegate: PhotoFaceNavigationDelegate?
  
  let worker: PhotoFaceWorker
  
  init(worker: PhotoFaceWorker,
       navigationDelegate: PhotoFaceNavigationDelegate? = nil) {
    self.worker = worker
    self.navigationDelegate = navigationDelegate
  }
  
  func getInitialData() {
    print("@! >>> START TO GETTING DATA...")
    
    print("@! >>> SHOWING API \(worker.apiURL)/api/transaction")
    
    worker.parseMainData({ (data) in
      DispatchQueue.main.async {
        switch data {
        case .success(let model):
          print(model.cpf)
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
    })
  }
}

// MARK: - Navigation Delegate

extension LoginViewModel: PhotoFaceNavigationDelegate {
  
  func openSDK(_ viewController: UIViewController) {
    //    navigationDelegate?.openSDK(viewController)
    let viewModel = ScanViewModel()
    let mainViewController = ScanViewController(viewModel: viewModel)
    viewController.navigationController?.pushViewController(mainViewController, animated: true)
  }
  
  func openStatusView(_ viewController: UIViewController) {
    //    navigationDelegate?.openStatusView()
    
    let viewModel = StatusViewModel()
    let mainViewController = StatusViewController(viewModel: viewModel)
    viewController.navigationController?.pushViewController(mainViewController, animated: true)
  }
}
