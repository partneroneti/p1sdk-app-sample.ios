import UIKit
import PartnerOneSDK

final class LoginViewController: BaseViewController<LoginView> {
  
  typealias Strings = LocalizableStrings
  var viewModel: LoginViewModel
  
  init(viewModel: LoginViewModel) {
    self.viewModel = viewModel
    super.init()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupBinds()
    viewModel.getInitialData()
  }
}

extension LoginViewController: UITextFieldDelegate {
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    return true
  }
}

private extension LoginViewController {
  func setupBinds() {
    /// Navigation do SDK Screen
    ///
    baseView.beginButton.btnAction = { [weak self] in
      guard let self = self else { return }
      
      let dataTextField = self.baseView.cpfTextField.dataTextField
      let cpfNumber = dataTextField.text!
      
      self.viewModel.sendCPFAuth(cpf: cpfNumber)
      
      if cpfNumber != "" && cpfNumber.count == 11 {
        self.viewModel.openSDK(self)
      }
    }
    
    /// Navtigation to Status Screen
    ///
    let viewModel = StatusViewModel()
    let viewController = StatusViewController(viewModel: viewModel)
    
    let partnerModel = ScanViewModel(transactionID: "")
    let partnerView = ScanViewController(viewModel: partnerModel)
  }
}
