import UIKit
import FaceTecSDK

final class FacialScanViewController: UIViewController, FaceTecFaceScanProcessorDelegate, URLSessionDelegate {
  
  //MARK: - Properties
  
  var viewModel: ScanViewModel
  var helper: PartnerHelper
  
  private var latestExternalDatabaseRefID: String = ""
  private var latestSessionResult: FaceTecSessionResult!
  private var latestIDScanResult: FaceTecIDScanResult!
  private var sessionResult: FaceTecSessionResult?
  private var resultCallback: FaceTecFaceScanResultCallback?
  private var latestProcessor: Processor!
  private var utils: SampleAppUtilities?
  
  public var faceScanBase64: String = ""
  
  var sessionId: String?
  var deviceKey: String?
  var transactionId: String?
  var processorResponse: (() -> Void)?
  
  private let activity: UIActivityIndicatorView = {
    let activity = UIActivityIndicatorView()
    activity.style = .whiteLarge
    activity.startAnimating()
    activity.translatesAutoresizingMaskIntoConstraints = false
    return activity
  }()
  
  //MARK: - init
  
  init(viewModel: ScanViewModel, helper: PartnerHelper) {
    self.viewModel = viewModel
    self.helper = helper
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  //MARK: - View Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationItem.hidesBackButton = true
    view.backgroundColor = .white
    view.addSubview(activity)
    activity.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    activity.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    FaceTec.initialize()
    setupFaceTec()
  }
}

//MARK: - Private Functions

extension FacialScanViewController {
  func setupFaceTec() {
    self.transactionId = helper.transaction
    self.deviceKey = helper.faceTecDeviceKeyIdentifier
    self.sessionId = helper.sessionToken()
    
    FaceTec.sdk.initializeInProductionMode(productionKeyText: Config.ProductionKeyText,
                                           deviceKeyIdentifier: Config.DeviceKeyIdentifier,
                                           faceScanEncryptionKey: Config.PublicFaceScanEncryptionKey)
    
    Config.initializeFaceTecSDKFromAutogeneratedConfig(completion: { [weak self] initializationSuccessful in
      guard let self = self else {
        return
      }
      
      Config.displayLogs()
      
      Config.ProductionKeyText = self.helper.faceTecProductionKeyText
      Config.DeviceKeyIdentifier = self.helper.faceTecDeviceKeyIdentifier
      Config.PublicFaceScanEncryptionKey = self.helper.faceTecPublicFaceScanEncryptionKey
      
      LivenessCheckProcessor(sessionToken: self.helper.createUserAgentForSession(),
                             fromViewController: self)
      
      self.faceTecLivenessData(completion: {})
      
      if self.helper.wasProcessed == true {
        print("@! >>> Foi processado!")
      }
      
      self.processorResponse = {
        if self.resultCallback?.onFaceScanGoToNextStep(scanResultBlob: "") != nil {
          print("BLOB!")
        } else {
          self.navigationController?.popViewController(animated: true)
        }
      }
    })
  }
  
  func processSessionWhileFaceTecSDKWaits(sessionResult: FaceTecSessionResult,
                                          faceScanResultCallback: FaceTecFaceScanResultCallback) {
    self.resultCallback = faceScanResultCallback
  }
  
  func onFaceTecSDKCompletelyDone() {
    print("Escaneamento Completo. Navegando para Status!")
  }
  
  func onComplete() {
    helper.navigateToStatus?()
  }
  
  func getLatestExternalDatabaseRefID() -> String {
    return latestExternalDatabaseRefID;
  }
  
  func setLatestSessionResult(sessionResult: FaceTecSessionResult) {
    latestSessionResult = sessionResult
  }
  
  func initializeProcessor() -> Processor {
    return LivenessCheckProcessor(sessionToken: helper.createUserAgentForSession(), fromViewController: self)
  }
  
  public func createUserAgentForNewSession() -> String {
    return FaceTec.sdk.createFaceTecAPIUserAgentString("")
  }
  
  public func createUserAgentForSession(_ sessionId: String) -> String {
    return FaceTec.sdk.createFaceTecAPIUserAgentString(sessionId)
  }
  
  public func getLowQualityAuditTrailImage() -> String {
    return sessionResult?.lowQualityAuditTrailCompressedBase64![0] ?? ""
  }
  
  public func faceTecLivenessData(faceScanBase: String = "",
                                  auditTrailImage: String = "",
                                  lowQualityAuditTrailImage: String = "",
                                  completion: @escaping (() -> Void)) {
    self.helper.getFaceScan = faceScanBase
    self.helper.getAuditTrailImage = auditTrailImage
    self.helper.getLowQualityAuditTrailImage = lowQualityAuditTrailImage
    
    self.faceScanBase64 = faceScanBase
    
    completion()
    
    print("@! >>> Processamento finalizado.")
    
    let livenessProcessor = LivenessCheckProcessor(sessionToken: self.helper.createUserAgentForSession(),
                                                   fromViewController: self)
    livenessProcessor.success = true
    livenessProcessor.faceScanResultCallback = resultCallback
  }
}
