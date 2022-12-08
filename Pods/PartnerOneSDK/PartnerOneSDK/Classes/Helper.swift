import UIKit

protocol PartnerHelperProtocol: AnyObject {
  var mainViewController: UIViewController { get }
  var transactionID: String { get }
}

open class PartnerHelper: PartnerHelperProtocol {
  
  public var mainViewController = UIViewController()
  public var transactionID: String = ""
  
  public init(mainViewController: UIViewController = UIViewController(),
              transactionID: String = "") {
    self.mainViewController = mainViewController
    self.transactionID = transactionID
  }
  
  public func initializeSDK(_ viewController: UIViewController) {
    let mainWorker = PartnerOneWorker()
    let mainViewModel = ScanViewModel(worker: mainWorker)
    let mainViewController = ScanViewController(viewModel: mainViewModel)
    viewController.navigationController?.pushViewController(mainViewController, animated: true)
  }
  
  public func openViewAfter(_ viewController: UIViewController) {
    viewController.navigationController?.popToViewController(mainViewController, animated: true)
  }
}
