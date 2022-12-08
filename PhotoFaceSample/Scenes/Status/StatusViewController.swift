import UIKit

final class StatusViewController: BaseViewController<StatusView> {
  
  //MARK: - Properties
  
  var viewModel: StatusViewModel
  
  //MARK: - init
  
  init(viewModel: StatusViewModel) {
    self.viewModel = viewModel
    super.init()
  }
  
  //MARK: - View Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupBinds()
    viewModel.setupTransactionID()
  }
}

//MARK: - Private extension

private extension StatusViewController {
  func setupBinds() {
    navigationItem.hidesBackButton = true
    
    baseView.transactionIdLabel.descriptionLabel.text = viewModel.transactionID
    baseView.statusLabel.descriptionLabel.text = "\(viewModel.statusDescription)"
    
    /// Action to pop to home
    ///
    baseView.didTapReset = {
      self.navigationController?.popToRootViewController(animated: true)
    }
    
    /// Status realoader
    ///
    viewModel.triggerGetStatus(in: .seconds(10)) { [weak self] in
      guard let self = self else { return }
      self.viewModel.setupTransactionID()
    }
  }
}
