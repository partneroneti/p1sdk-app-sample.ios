import UIKit

final class LoginView: BaseView {
  
  private let mainTitle: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
    label.text = "Partner One - Onboarding"
    label.textColor = .black
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  private let mainStackView: UIStackView = {
    let stack = UIStackView()
    stack.axis = .vertical
    stack.spacing = 10
    stack.translatesAutoresizingMaskIntoConstraints = false
    return stack
  }()
  
  let cpfTextField: MainTextInput = {
    let field = MainTextInput()
    field.titleLabel.text = "CPF"
    field.dataTextField.placeholder = "Informe o CPF"
    return field
  }()
  
  let beginButton: MainButton = {
    let button = MainButton()
    button.mainButton.setTitle("Iniciar", for: .normal)
    return button
  }()
  
  // MARK: - Initialize
      
  override func initialize() {
    backgroundColor = .white
    clipsToBounds = false
    
    addSubview(mainTitle)
    addSubview(mainStackView)
    mainStackView.addArrangedSubview(cpfTextField)
    mainStackView.addArrangedSubview(beginButton)
  }
  
  override func installConstraints() {
    NSLayoutConstraint.activate([
      mainTitle.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
      mainTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
      mainTitle.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
      
      mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
      mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
      mainStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
      mainStackView.heightAnchor.constraint(equalToConstant: 70)
    ])
  }
}
