import UIKit
import FaceTecSDK

open class PartnerHelper {
  
  //MARK: - Public Properties
  
  private var processor: LivenessCheckProcessor?
  
  public var sendDocumentPicture: (() -> Void)?
  public var onNavigateToFaceCapture: (() -> Void)?
  public var waitingFaceTecResponse: (() -> Void)?
  public var navigateToStatus: (() -> Void)?
  public var onSuccessFaceTec: (() -> Void)?
  
  public var transaction: String = ""
  public var sessionToken: String = ""
  public var faceTecDeviceKeyIdentifier: String = ""
  public var faceTecPublicFaceScanEncryptionKey: String = ""
  public var faceTecProductionKeyText: String = ""
  
  public var getFaceScan: String = ""
  public var getAuditTrailImage: String = ""
  public var getLowQualityAuditTrailImage: String = ""
  
  public var faceScanResultCallback: FaceTecFaceScanResultCallback?
  
  //MARK: - init

  public init() {}
  
  //MARK: - Public Functions
  
  public func initializeSDK(_ viewController: UIViewController) {
    let mainViewModel = ScanViewModel(helper: self)
    viewController.navigationController?.pushViewController(ScanViewController(viewModel: mainViewModel), animated: true)
  }
  
  public func startFaceCapture() -> UIViewController {
    let mainViewModel = ScanViewModel(helper: self)
    let viewController = FacialScanViewController(viewModel: mainViewModel)
    
    processor?.helper = self
    
    return viewController
  }
  
  public func startDocumentCapture() -> UIViewController {
    let mainViewModel = ScanViewModel(helper: self)
    return ScanViewController(viewModel: mainViewModel, viewTitle: "Frente")
  }
  
  public func transactionId(_ id: String = "") -> String {
    return id
  }
  
  public func sessionToken(_ token: String = "") -> String {
    return token
  }
  
  public func createUserAgentForNewSession() -> String {
    return FaceTec.sdk.createFaceTecAPIUserAgentString("")
  }
  
  public func createUserAgentForSession(_ sessionToken: String = "") -> String {
    return FaceTec.sdk.createFaceTecAPIUserAgentString(sessionToken)
  }
  
  public func lastViewController(_ viewController: UIViewController = UIViewController()) -> UIViewController {
    return viewController
  }
  
  
}
