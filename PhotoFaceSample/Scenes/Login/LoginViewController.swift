import UIKit

final class LoginViewController: BaseViewController<LoginView> {
  
  typealias Strings = LocalizableStrings
  
  var viewModel: LoginViewModel
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupBinds()
  }
  
  init(viewModel: LoginViewModel) {
    self.viewModel = viewModel
    super.init()
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
      let viewModel = StatusViewModel()
      let viewController = StatusViewController(viewModel: viewModel)
      self?.navigationController?.pushViewController(viewController, animated: true)
    }
  }
}
