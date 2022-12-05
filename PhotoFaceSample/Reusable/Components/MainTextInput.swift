import UIKit

final class MainTextInput: BaseView {
  
  private let mainStackView: UIStackView = {
    let stack = UIStackView()
    stack.axis = .vertical
    stack.translatesAutoresizingMaskIntoConstraints = false
    return stack
  }()
  
  let titleLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
    label.textColor = .lightGray
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  var dataTextField: UITextField = {
    let field = UITextField()
    field.minimumFontSize = 16
    field.textColor = .black
    field.layer.borderColor = UIColor.lightGray.cgColor
    field.layer.borderWidth = 1
    field.layer.cornerRadius = 4
    field.backgroundColor = .white
    field.translatesAutoresizingMaskIntoConstraints = false
    return field
  }()
  
  // MARK: - Initialize
      
  override func initialize() {
    backgroundColor = .white
    clipsToBounds = false
    
    addSubview(mainStackView)
    mainStackView.addArrangedSubview(titleLabel)
    mainStackView.addArrangedSubview(dataTextField)
  }
  
  override func installConstraints() {
    NSLayoutConstraint.activate([
      mainStackView.widthAnchor.constraint(equalTo: widthAnchor),
      
      titleLabel.widthAnchor.constraint(equalTo: mainStackView.widthAnchor),
      titleLabel.heightAnchor.constraint(equalToConstant: 20),
      
      dataTextField.heightAnchor.constraint(equalToConstant: 40),
      dataTextField.widthAnchor.constraint(equalTo: mainStackView.widthAnchor)
    ])
  }
}
