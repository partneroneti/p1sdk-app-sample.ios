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
  
  let helper = PartnerHelper()
  let worker: PhotoFaceWorker
  var transactionID: String = ""
  var accessToken: String = ""
  var status: Int?
  var statusDescription: String?
  var session: String?
  var livenessCode: Int?
  var livenessMessage: String?
  
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
        self.transactionID = model.objectReturn[0].transactionId
        self.helper.transaction = self.transactionID
        
        self.getCredentials()
        /// Navigate to SDK after API response 200
        ///
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
          self.setupTransactionID(self.transactionID)
        }
        
        print("@! >>> Transaction ID gerado: \(String(model.objectReturn[0].transactionId))")
        
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
  func setupTransactionID(_ transactionID: String = "") {
    
    worker.getTransactionID(transactionID: transactionID) { [weak self] (response) in
      guard let self = self else { return }
      
      switch response {
      case .success(let model):
        self.status = Int(model.objectReturn[0].result[0].status)
        self.statusDescription = String(model.objectReturn[0].result[0].statusDescription)
        
        /// Matrix Decision Navigator
        ///
        self.navigateToView(self.status!)
        
        /// Erase prints below
        ///
        print("@! >>> Satus da matriz de decisão: ", model.objectReturn[0].result[0].status)
        print("@! >>> Descrição da matriz de decisão: ", model.objectReturn[0].result[0].statusDescription)
        
        self.helper.transaction = self.transactionID
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
        self.certificate = model.objectReturn[0].certificate
        self.deviceKeyIdentifier = model.objectReturn[0].deviceKeyIdentifier
        self.productionKeyText = model.objectReturn[0].productionKeyText
        
        /// Erase prints below
        ///
        print("@! >>> FaceTec Certificado: ", model.objectReturn[0].certificate)
        print("@! >>> FaceTec DeviceKeyIdentifier: ", model.objectReturn[0].deviceKeyIdentifier)
        print("@! >>> FaceTec ProductionKey: ",  model.objectReturn[0].productionKeyText)
        
        Config.ProductionKeyText = self.productionKeyText ?? "Production Key não encontrada."
        Config.DeviceKeyIdentifier = self.deviceKeyIdentifier ?? "Device Key não encontrado."
        Config.PublicFaceScanEncryptionKey = self.certificate ?? "Certificado não encontrado."
        
        self.helper.faceTecDeviceKeyIdentifier = self.deviceKeyIdentifier ?? ""
        
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
  
  func sendDocuments() {
    
    var newDocuments = [[String:Any]]()
    newDocuments = helper.documentsImages
    
    var documents: [String: Any] = [
      "transactionId": self.transactionID,
      "documents": newDocuments
    ]
    
    worker.sendDocumentPictures(transactionId: transactionID,
                                documents: documents) { [weak self] (response) in
      guard let self = self else { return }
      switch response {
      case .success:
        print("@! >>> Documento enviado com sucesso!")
        
        /// Navigate to viiew based on API status return
        ///
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
          self.setupTransactionID(self.transactionID)
        }
        
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
      case .success(let model):
        self.session = model.objectReturn[0].session
        self.helper.sessionToken = model.objectReturn[0].session
        
        print("@! >>> Session: ", String(self.session!))
          
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
          self.setupLiveness(faceScan: self.helper.getFaceScan,
                             auditTrailImage: self.helper.getAuditTrailImage,
                             lowQualityAuditTrailImage: self.helper.getLowQualityAuditTrailImage)
        }
        
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
  
  func setupLiveness(faceScan: String, auditTrailImage: String, lowQualityAuditTrailImage: String) {
    worker.getLiveness(transactionID: self.transactionID,
                       faceScan: faceScan,
                       auditTrailImage: auditTrailImage,
                       lowQualityAuditTrailImage: lowQualityAuditTrailImage,
                       sessionId: helper.createUserAgentForSession(self.session ?? ""),
                       deviceKey: deviceKeyIdentifier ?? "") { [weak self] (response) in
      guard let self = self else { return }
      
      switch response {
      case .success(let model):
        self.livenessCode = model.objectReturn[0].code
        self.livenessMessage = model.objectReturn[0].description
        
        print("@! >>> Liveness Code: \(String(describing: self.livenessCode))")
        print("@! >>> Liveness Code: \(String(describing: self.livenessMessage))")
        
        self.helper.wasProcessed = true
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
    case 0: openStatus()
      break
    case 1: openStatus()
    case 2: openStatus()
    case 3: openFaceCapture()
    case 4: openDocumentCapture()
    default:
      break
    }
  }
  
  func setSessionCode(_ code: Int) {
    switch code {
    case 1:
      helper.navigateToStatus = {
        self.openStatus()
      }
      print("@! >>> Sucesso. Redirecionando para tela de Status.")
    case 3 :
      helper.navigateToStatus = {
        self.openStatus()
      }
      print("@! >>> Transação REPROVADA. Redirecionando para tela de Status.")
    default:
      break
    }
  }
  
  func postDocuments() {
    helper.sendDocumentPicture = {
      self.sendDocuments()
    }
  }
  
  private
  func openStatus() {
    let worker = PhotoFaceWorker(accessToken: accessToken)
    let statusViewModel = StatusViewModel(worker: worker,
                                          helper: helper,
                                          transactionID: helper.transaction)
    statusViewModel.status = self.status
    statusViewModel.transactionID = self.transactionID
    statusViewModel.statusDescription = self.statusDescription
    statusViewModel.deviceKeyIdentifier = self.deviceKeyIdentifier ?? ""
    let statusViewController = StatusViewController(viewModel: statusViewModel)
    self.viewController?.navigationController?.pushViewController(statusViewController, animated: true)
    print("@! >>> Seu status atual é: \(String(describing: self.statusDescription)).")
  }
  
  func openFaceCapture() {
    createSession()
    
    let faceCaptureViewController = helper.startFaceCapture()
    viewController?.navigationController?.pushViewController(faceCaptureViewController, animated: true)
    
    helper.navigateToStatus = {
      self.openStatus()
      print("Navegando para tela de Status...")
    }
  }
  
  private
  func openDocumentCapture() {
    let documentViewController = helper.startDocumentCapture()
    viewController?.navigationController?.pushViewController(documentViewController, animated: true)
    
    print("@! >>> Logado com sucesso!")
    print("@! >>> Redirecionando para captura de documento...")
  }
}
