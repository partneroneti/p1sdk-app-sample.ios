import UIKit

final class MainButton: BaseView {
  
  var btnAction: (() -> Void)?
  
  lazy var mainButton: UIButton = {
    let button = UIButton()
    button.backgroundColor = .systemBlue
    button.setTitleColor(.white, for: .normal)
    button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
    button.layer.cornerRadius = 4
    button.addTarget(self, action: #selector(didTapAction), for: .touchUpInside)
    button.isUserInteractionEnabled = true
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()
  
  // MARK: - Initialize
      
  override func initialize() {
    backgroundColor = .white
    
    addSubview(mainButton)
  }
  
  override func installConstraints() {
    NSLayoutConstraint.activate([
      mainButton.widthAnchor.constraint(equalTo: widthAnchor),
      mainButton.heightAnchor.constraint(equalToConstant: 40),
      mainButton.topAnchor.constraint(equalTo: topAnchor),
      mainButton .bottomAnchor.constraint(equalTo: bottomAnchor)
    ])
  }
  
  @objc
  func didTapAction() {
    self.btnAction?()
  }
}
