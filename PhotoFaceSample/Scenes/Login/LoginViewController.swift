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

private extension LoginViewController {
  func setupBinds() {
    /// Navigation do SDK Screen
    ///
    baseView.beginButton.btnAction = { [weak self] in
      guard let self = self else { return }
      
      let dataTextField = self.baseView.cpfTextField.dataTextField
      let cpfNumber = dataTextField.text!
      
      if cpfNumber != "" && cpfNumber.count == 11 {
        self.viewModel.sendCPFAuth(cpf: cpfNumber, completion: {
          self.viewModel.openSDK(self)
          self.viewModel.setupTransactionID()
        })
      }
    }
  }
}

//public static String createUserAgentForNewSession(){
//            return FaceTecSDK.createFaceTecAPIUserAgentString("");
//        }
//
//    public static String createUserAgentForSession(String sessionId){
//        return FaceTecSDK.createFaceTecAPIUserAgentString(sessionId);
//    }
