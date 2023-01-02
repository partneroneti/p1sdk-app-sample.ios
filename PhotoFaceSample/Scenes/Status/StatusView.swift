import UIKit

final class StatusView: BaseView {
  
  typealias Strings = LocalizableStrings
  
  private let mainTitle: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
    label.text = Strings.mainTitle.rawValue
    label.textColor = .black
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  private let mainStack: UIStackView = {
    let stack = UIStackView()
    stack.axis = .vertical
    stack.spacing = 20
    stack.translatesAutoresizingMaskIntoConstraints = false
    return stack
  }()
  
  let transactionIdLabel: DescriptionLabel = {
    let label = DescriptionLabel()
    label.titleLabel.text = Strings.transactionIDTitle.rawValue
    return label
  }()
  
  let statusLabel: DescriptionLabel = {
    let label = DescriptionLabel()
    label.titleLabel.text = Strings.statusTitle.rawValue
    return label
  }()
  
  let restartBtn: MainButton = {
    let button = MainButton()
    button.mainButton.setTitle(Strings.restartTitle.rawValue, for: .normal)
    return button
  }()
  
  // MARK: - Initialize
  
  override func initialize() {
    backgroundColor = .white
    
    addSubview(mainTitle)
    addSubview(mainStack)
    mainStack.addArrangedSubview(transactionIdLabel)
    mainStack.addArrangedSubview(statusLabel)
    mainStack.addArrangedSubview(restartBtn)
  }
  
  override func installConstraints() {
    NSLayoutConstraint.activate([
      mainTitle.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
      mainTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
      mainTitle.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
      mainStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
      mainStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
      mainStack.centerYAnchor.constraint(equalTo: centerYAnchor),
      transactionIdLabel.heightAnchor.constraint(equalToConstant: 40),
      statusLabel.heightAnchor.constraint(equalToConstant: 40)
    ])
  }
}
