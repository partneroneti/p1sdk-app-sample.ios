import UIKit
import PartnerOneSDK

class PhotoFaceRouter: Router, PhotoFaceNavigationDelegate {
  
  var worker: PhotoFaceWorker
  private var helper: PartnerHelper?
  
  public var childRouters: [Router] = []
  private let presenter: UINavigationController
  private weak var navigationDelegate: RouterDelegate?
  
  init(navigationDelegate: RouterDelegate? = nil,
       presenter: UINavigationController,
       worker: PhotoFaceWorker = PhotoFaceWorker()) {
    self.navigationDelegate = navigationDelegate
    self.presenter = presenter
    self.worker = worker
  }
  
  func start() {
    let worker = PhotoFaceWorker()
    let viewModel = LoginViewModel(worker: worker, navigationDelegate: self)
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

extension PhotoFaceRouter {
  func openSDK(_ viewController: UIViewController) {
    pushViewController(viewController)
  }
  
  func openStatusView() {
    let viewModel = StatusViewModel()
    let viewController = StatusViewController(viewModel: viewModel)
    pushViewController(viewController)
  }
  
  func openDocumentCapture() {
    guard let viewController = helper?.startDocumentCapture() else { return }
    pushViewController(viewController)
  }
  
  func openFaceCapture() {
    guard let viewController = helper?.startFaceCapture() else { return }
    pushViewController(viewController)
  }
}
