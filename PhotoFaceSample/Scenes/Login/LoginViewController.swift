import UIKit

final class LoginViewController: BaseViewController<LoginView> {
  
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

private extension LoginViewController {
  func setupBinds() {
    baseView.beginButton.btnAction = { [weak self] in
      
    }
  }
  
  @objc
  func navigateToNext() {
    let viewController = StatusViewController()
    self.navigationController?.pushViewController(viewController, animated: true)
  }
}
