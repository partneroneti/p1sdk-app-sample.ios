import UIKit
import FaceTecSDK

enum PictureView {
  case frontView
  case backView
}

open class ScanViewModel {
  
  var worker: PartnerOneWorker
  var sideTitle: String = ""
  var transactionID: String = ""
  private var latestProcessor: Processor!
  
  var didTapOpenFaceTec: (() -> Void)?
  var didOpenStatusView: (() -> Void)?
  
  init(worker: PartnerOneWorker) {
    self.worker = worker
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
  
  func getSession() {
    worker.getSession { (response) in
      switch response {
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
  }
  
  func sendPicture() {
    print("Foto enviada.")
  }
}
