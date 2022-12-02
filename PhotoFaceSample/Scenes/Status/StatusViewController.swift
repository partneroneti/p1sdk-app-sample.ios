import UIKit

final class StatusViewController: BaseViewController<StatusView> {
  
  var viewModel: StatusViewModel
  
  init(viewModel: StatusViewModel) {
    self.viewModel = viewModel
    super.init()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupBinds()
  }
}

private extension StatusViewController {
  func setupBinds() {
    baseView.transactionIdLabel.descriptionLabel.text = viewModel.transactionID
    baseView.statusLabel.descriptionLabel.text = viewModel.status
  }
}
