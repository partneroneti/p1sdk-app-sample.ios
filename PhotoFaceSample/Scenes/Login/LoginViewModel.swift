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
  func openDocumentCapture()
  func openFaceCapture()
  func openStatusView()
}

//MARK: - Class

class LoginViewModel: LogiViewModelProtocol, AccessTokeProtocol {
  
  //MARK: - Properties
  
  weak var viewController: LoginViewController?
  private weak var navigationDelegate: PhotoFaceNavigationDelegate?
  private var decisionMatrix: DecisionMatrix?
  
  let helper = PartnerHelper()
  let worker: PhotoFaceWorker
  var transactionID: String = ""
  var accessToken: String = ""
  var status: Int?
  var statusDescription: String?
  
  ///FaceTec properties
  ///
  var certificate: String?
  var productionKeyText: String?
  var deviceKeyIdentifier: String?
  
  //MARK: - init
  
  init(worker: PhotoFaceWorker,
       navigationDelegate: PhotoFaceNavigationDelegate? = nil) {
    self.worker = worker
    self.navigationDelegate = navigationDelegate
  }
  
}

//MARK: - API Info Functions

extension LoginViewModel {
  
  func getInitialData() {
    print("@! >>> Busca inicial de dados...")
    
    worker.parseMainData { [weak self] (response) in
      guard let self = self else { return }
      switch response {
      case .success(let model):
        /// Passes AccessToken to Worker Layer
        ///
        self.worker.accessToken = model.objectReturn[0].accessToken
        self.accessToken = model.objectReturn[0].accessToken
        
        print("@! >>> Access Token gerado: ", model.objectReturn[0].accessToken)
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
  func sendCPFAuth(cpf: String) {
    worker.getTransaction(cpf: cpf) { [weak self] (response) in
      guard let self = self else { return }
      
      switch response {
      case .success(let model):
        /// Get and passa TransactionID to SDK Helper
        ///
        self.helper.transactionID = String(model.objectReturn[0].transactionId!)
        self.transactionID = String(model.objectReturn[0].transactionId!)
        
        /// Navigate to SDK after API response 200
        ///
        DispatchQueue.main.async {
          self.setupTransactionID(self.transactionID)
        }
        
        print("@! >>> Transaction ID gerado: \(String(model.objectReturn[0].transactionId!))")
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
  
  /// First time getting TransactionID
  ///
  func setupTransactionID(_ transactionID: String) {
    
    worker.getTransactionID(transactionID: transactionID) { [weak self] (response) in
      guard let self = self else { return }
      
      switch response {
      case .success(let model):
        self.status = Int(model.objectReturn[0].result[0].status!)
        self.statusDescription = String(model.objectReturn[0].result[0].statusDescription!)
        
        /// Matrix Decision Navigator
        ///
        self.navigateToView(Int(model.objectReturn[0].result[0].status!))
        
        /// Erase prints below
        ///
        print("@! >>> Satus da matriz de decisão: ", Int(model.objectReturn[0].result[0].status!))
        print("@! >>> Descrição da matriz de decisão", String(model.objectReturn[0].result[0].statusDescription!))
        
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
  
  func getCredentials() {
    worker.getCredentials { [weak self] (response) in
      guard let self = self else { return }
      
      switch response {
      case .success(let model):
        self.certificate = model.objectReturn[0].certificate ?? ""
        self.deviceKeyIdentifier = model.objectReturn[0].deviceKeyIdentifier ?? ""
        self.productionKeyText = model.objectReturn[0].productionKeyText ?? ""
        
        /// Erase prints below
        ///
        print("@! >>> FaceTec Certificado: ", String(model.objectReturn[0].certificate!))
        print("@! >>> FaceTec DeviceKeyIdentifier: ", String(model.objectReturn[0].deviceKeyIdentifier!))
        print("@! >>> FaceTec ProductionKey: ", String(model.objectReturn[0].productionKeyText!))
        
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
  
  func getSession(deviceKey: String, userAgent: String) {
//    worker.get
  }
  
  func sendDocuments() {
    worker.sendDocumentPictures(transactionId: transactionID,
                                imgType: "base64",
                                imgByte: "") { [weak self] (response) in
      guard let self = self else { return }
      switch response {
      case .success:
        self.navigationDelegate?.openStatusView()
        print("@! >>> Documentos enviados com sucesso!")
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
  
  func createSession() {
    guard let deviceKeyIdentifier = deviceKeyIdentifier else { return }
    
    worker.getSession(userAgent: helper.createUserAgentForNewSession(),
                      deviceKey: deviceKeyIdentifier) { [weak self] (response) in
      guard let self = self else { return }
      
      switch response {
      case .success:
        self.navigationDelegate?.openStatusView()
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
  
  func navigateToView(_ status: Int = 0) {
    switch status {
    case 0:
      break
    case 1:
      navigationDelegate?.openStatusView()
    case 2:
      navigationDelegate?.openStatusView()
    case 3:
      navigationDelegate?.openFaceCapture()
    case 4:
      navigationDelegate?.openDocumentCapture()
    default:
      break
    }
  }
  
//  func openStatusView() -> UIViewController {
//    let mainViewModel = StatusViewModel()
//    mainViewModel.transactionID = transactionID
//    mainViewModel.statusDescription = statusDescription
//    let mainViewController = StatusViewController(viewModel: mainViewModel)
//    viewController.navigationController?.pushViewController(mainViewController, animated: true)
//    
//    self.viewController?.navigationController?.pushViewController(mainViewController, animated: <#T##Bool#>)
//    
//    navigationDelegate?.openStatusView()
//    
//    return mainViewController
//  }
}
