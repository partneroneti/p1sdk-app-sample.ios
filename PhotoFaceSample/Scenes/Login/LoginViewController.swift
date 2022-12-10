import UIKit
import PartnerOneSDK

final class LoginViewController: BaseViewController<LoginView> {
  
  //MARK: - Propertier
  
  typealias Strings = LocalizableStrings
  var viewModel: LoginViewModel
  
  //MARK: - init
  
  init(viewModel: LoginViewModel) {
    self.viewModel = viewModel
    super.init()
  }
  
  //MARK: - View Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupBinds()
    dismissKeyboard()
    viewModel.viewController = self
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    viewModel.getInitialData()
  }
}

extension LoginViewController: UITextFieldDelegate {
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    return true
  }
}

//MARK: - Private Functions

private extension LoginViewController {
  func setupBinds() {
    /// Navigation do SDK Screen
    ///
    baseView.beginButton.btnAction = { [weak self] in
      guard let self = self else { return }
      
      let dataTextField = self.baseView.cpfTextField.dataTextField
      let cpfNumber = dataTextField.text!
      
      if cpfNumber != "" && cpfNumber.count == 11 {
        self.viewModel.sendCPFAuth(cpf: cpfNumber)
        print("@! >>> Botão de Login apertado!")
      }
    }
  }
  
  func dismissKeyboard() {
    let tapGestureReconizer = UITapGestureRecognizer(target: self, action: #selector(tap))
    tapGestureReconizer.cancelsTouchesInView = false
    view.addGestureRecognizer(tapGestureReconizer)
  }
  
  @objc
  func tap(sender: UITapGestureRecognizer) {
    view.endEditing(true)
  }
}
