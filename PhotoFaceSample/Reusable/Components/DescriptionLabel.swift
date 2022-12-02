import UIKit

final class DescriptionLabel: BaseView {
  
  private let mainStack: UIStackView = {
    let stack = UIStackView()
    stack.axis = .vertical
    stack.translatesAutoresizingMaskIntoConstraints = false
    return stack
  }()
  
  let titleLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
    label.textColor = .lightGray
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  let descriptionLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
    label.textColor = .black
    label.numberOfLines = 0
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  // MARK: - Initialize
      
  override func initialize() {
    backgroundColor = .white
    clipsToBounds = false
    
    addSubview(mainStack)
    mainStack.addArrangedSubview(titleLabel)
    mainStack.addArrangedSubview(descriptionLabel)
  }
  
  override func installConstraints() {
    NSLayoutConstraint.activate([
      mainStack.leadingAnchor.constraint(equalTo: leadingAnchor),
      mainStack.trailingAnchor.constraint(equalTo: trailingAnchor),
      titleLabel.widthAnchor.constraint(equalTo: mainStack.widthAnchor),
      descriptionLabel.widthAnchor.constraint(equalTo: mainStack.widthAnchor)
    ])
  }
}
