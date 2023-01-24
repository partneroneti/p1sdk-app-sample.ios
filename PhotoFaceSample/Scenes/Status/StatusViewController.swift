import UIKit

protocol StatusViewControllerProtocol: AnyObject {
  func presentFaceTec()
}

final class StatusViewController: BaseViewController<StatusView> {
  
  //MARK: - Properties
  
  var viewModel: StatusViewModel
  weak var delegate: StatusViewControllerProtocol?
  
  //MARK: - init
  
  init(viewModel: StatusViewModel) {
    self.viewModel = viewModel
    super.init()
  }
  
  //MARK: - View Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
      
      
      viewModel.viewController = self
      
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
    baseView.restartBtn.btnAction = {
        print("@! >>> Fechar Status.")
        self.navigationController?.popViewController(animated: true)
    }
    
    viewModel.dismissStatus = { [weak self] in
      guard let self = self else { return }
      self.viewModel.openFaceCapture(self)
    }
    
    /// Status realoader
    ///
    viewModel.triggerGetStatus()
  }
}
