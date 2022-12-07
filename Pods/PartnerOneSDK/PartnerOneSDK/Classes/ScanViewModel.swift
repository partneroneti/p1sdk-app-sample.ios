import UIKit
import FaceTecSDK

enum PictureView {
  case frontView
  case backView
}

open class ScanViewModel {
  
  var sideTitle: String = ""
  var transactionID: String
  
  var didTapOpenFaceTec: (() -> Void)?
  var didOpenStatusView: (() -> Void)?
  
  public init(transactionID: String) {
    self.transactionID = transactionID
  }
  
  func setPhotoSide(_ cases: PictureView) -> String {
    switch cases {
    case .backView:  return "Verso"
    case .frontView: return "Frente"
    }
  }
  
  func navigateToNextView(_ viewController: UIViewController) {
    if sideTitle == setPhotoSide(.frontView) {
      let nextViewController = ScanViewController(viewModel: self, viewTitle: "Verso")
      viewController.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    if sideTitle == setPhotoSide(.backView) {
      didTapOpenFaceTec?()
      print("@! >>> Starting FaceTec...")
    }
  }
  
  func navigateStatusView() {
    if sideTitle == setPhotoSide(.backView) {
      didOpenStatusView?()
    }
  }
  
  func sendPicture() {
    print("Foto enviada.")
  }
}
