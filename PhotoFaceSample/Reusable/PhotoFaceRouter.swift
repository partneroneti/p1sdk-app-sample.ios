import UIKit
import PartnerOneSDK

class PhotoFaceRouter: Router {
  public var childRouters: [Router] = []
  private let presenter: UINavigationController
  private weak var navigationDelegate: RouterDelegate?
  
  init(navigationDelegate: RouterDelegate? = nil,
       presenter: UINavigationController) {
    self.navigationDelegate = navigationDelegate
    self.presenter = presenter
  }
  
  func start() {
    let viewModel = LoginViewModel(navigationDelegate: self)
    let viewController = LoginViewController(viewModel: viewModel)
    presenter.pushViewController(viewController, animated: true)
  }
  
  public func close() {
    presenter.dismiss(animated: true)
  }
  
  func pushViewController(_ viewController: UIViewController) {
    let navigationController = UINavigationController(rootViewController: viewController)
    navigationController.pushViewController(navigationController, animated: true)
  }
}

extension PhotoFaceRouter: PhotoFaceNavigationDelegate {
  func openSDK(_ viewController: UIViewController) {
    pushViewController(viewController)
  }
  
  func openStatusView(_ viewController: UIViewController) {
    let viewModel = StatusViewModel()
    let viewController = StatusViewController(viewModel: viewModel)
    pushViewController(viewController)
  }
}
