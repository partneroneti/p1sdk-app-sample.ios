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
  func openStatusView(_ viewController: UIViewController)
}

//MARK: - Class

class LoginViewModel: LogiViewModelProtocol {
  
  private weak var navigationDelegate: PhotoFaceNavigationDelegate?
  
  let worker: PhotoFaceWorker
  var transactionID: String = ""
  
  
  init(worker: PhotoFaceWorker,
       navigationDelegate: PhotoFaceNavigationDelegate? = nil) {
    self.worker = worker
    self.navigationDelegate = navigationDelegate
  }
  
  func getInitialData() {
    print("@! >>> START TO GETTING DATA...")
    
    worker.parseMainData({ [weak self] (data) in
      DispatchQueue.main.async {
        switch data {
        case .success(let model):
          print(model)
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
  
  func sendCPFAuth(cpf: String) {
    self.worker.postCPF(cpf: cpf,
                        completion: { [weak self] (data) in
      DispatchQueue.main.async {
        switch data {
        case .success(let model):
          print(model)
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
