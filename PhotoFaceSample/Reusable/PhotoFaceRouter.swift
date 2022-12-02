import UIKit

class PhotoFaceRouter {
  public var childRouters: [UIViewController] = []
  private let presenter: UINavigationController
//  private weak var navigationDelegate: RouterDelegate?
  
  init(presenter: UINavigationController) {
    self.presenter = presenter
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
  func openSDK() {
//    let viewController =
  }
  
  func openStatusView() {
    let viewModel = StatusViewModel()
    let viewController = StatusViewController(viewModel: viewModel)
    pushViewController(viewController)
  }
}


