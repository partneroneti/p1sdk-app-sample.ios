import UIKit

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
  }
}

extension LoginViewController: UITextFieldDelegate {
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
     
    let dataTextField = baseView.cpfTextField.dataTextField
    let currentString: NSString = dataTextField.text! as NSString
    
    let newString: NSString =  currentString.replacingCharacters(in: range, with: string) as NSString
    return newString.length <= 8
    
    var appendString = ""

    if range.length == 0 {
      switch range.location {
      case 3:
        appendString = "."
      case 7:
        appendString = "."
      case 11:
        appendString = "-"
      default:
        break
      }
    }

    dataTextField.text?.append(appendString)

    if (dataTextField.text?.count)! > 13 && range.length == 0 {
      return false
    }

    return true
  }
}

private extension LoginViewController {
  func setupBinds() {
    /// Navigation do SDK Screen
    ///
    baseView.beginButton.btnAction = { [weak self] in
      guard let self = self else { return }
      
      self.viewModel.getInitialData()
//      self.viewModel.openSDK(self)
    }
    
    /// Navigate to Status Screen
    ///
  }
}
