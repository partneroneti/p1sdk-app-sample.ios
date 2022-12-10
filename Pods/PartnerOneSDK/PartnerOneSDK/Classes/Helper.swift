import UIKit
import FaceTecSDK

open class PartnerHelper {
  
  //MARK: - Public Properties
  
  public var sendDocumentPicture: (() -> Void)?
  public var navigateToStatus: (() -> Void)?
  public var transactionID: String = ""
  
  //MARK: - init

  public init(transactionID: String = "") {
    self.transactionID = transactionID
  }
  
  //MARK: - Public Functions
  
  public func initializeSDK(_ viewController: UIViewController) {
    let mainViewModel = ScanViewModel(helper: self)
    viewController.navigationController?.pushViewController(ScanViewController(viewModel: mainViewModel), animated: true)
  }
  
  public func startFaceCapture() -> UIViewController {
    let mainViewModel = ScanViewModel(helper: self)
    return ScanViewController(viewModel: mainViewModel)
  }
  
  public func startDocumentCapture() -> UIViewController {
    let mainViewModel = ScanViewModel(helper: self)
    return FacialScanViewController(viewModel: mainViewModel)
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
  
  public func faceTecDeviceKeyIdentifier(_ clientKey: String = "") -> String {
    return clientKey
  }
  
  public func faceTecPublicFaceScanEncryptionKey(_ key: String = "") -> String {
    return key
  }
  
  public func faceTecProductionKeyText(_ key: String = "") -> String {
    return key
  }
}
