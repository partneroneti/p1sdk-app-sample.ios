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
    baseView.statusLabel.descriptionLabel.text = "\(String(describing: viewModel.statusDescription!))"
    
    self.viewModel.didChangeStatus = { [weak self] in
      guard let self = self else {
        return
      }
      
      if self.viewModel.status == 2 {
        self.viewModel.setReproved(self.baseView.statusLabel.descriptionLabel)
      } else if self.viewModel.status == 1 {
        self.viewModel.setApproved(self.baseView.statusLabel.descriptionLabel)
      }
    }
    
    /// Action to pop to home
    ///
    baseView.didTapReset = {
      self.navigationController?.popToRootViewController(animated: true)
    }
    
    /// Status realoader
    ///
    viewModel.triggerGetStatus()
  }
}
