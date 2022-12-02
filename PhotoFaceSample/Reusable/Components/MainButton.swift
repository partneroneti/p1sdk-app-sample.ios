import UIKit

final class MainButton: BaseView {
  
  var btnAction: (() -> Void)?
  
  lazy var mainButton: UIButton = {
    let button = UIButton()
    button.backgroundColor = .systemBlue
    button.setTitleColor(.white, for: .normal)
    button.layer.cornerRadius = 4
    button.addTarget(self, action: #selector(didTapAction), for: .touchUpInside)
    button.isUserInteractionEnabled = true
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()
  
  // MARK: - Initialize
      
  override func initialize() {
    backgroundColor = .red
    clipsToBounds = false
    
    addSubview(mainButton)
  }
  
  override func installConstraints() {
    NSLayoutConstraint.activate([
      mainButton.widthAnchor.constraint(equalTo: widthAnchor),
      mainButton.heightAnchor.constraint(equalToConstant: 40)
    ])
  }
  
  @objc
  func didTapAction() {
    self.btnAction?()
  }
}
