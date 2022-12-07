import UIKit

protocol PartnerHelperProtocol: AnyObject {
  var transactionID: String { get }
}

public class PartnerHelper: PartnerHelperProtocol {
  
  var transactionID: String = ""
  
  public func openViewAfter(from viewController: UIViewController, to: UIViewController = UIViewController()) {
    DispatchQueue.main.async {
      viewController.navigationController?.pushViewController(to, animated: true)
    }
  }
}
