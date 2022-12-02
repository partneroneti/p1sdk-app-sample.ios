import UIKit

final class StatusView: BaseView {
  
  private let mainTitle: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
    label.text = "Partner One - Onboarding"
    label.textColor = .black
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  // MARK: - Initialize
  
  override func initialize() {
    backgroundColor = .white
    clipsToBounds = false
    
    addSubview(mainTitle)
  }
  
  override func installConstraints() {
    NSLayoutConstraint.activate([
      mainTitle.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
      mainTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
      mainTitle.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
    ])
  }
}
