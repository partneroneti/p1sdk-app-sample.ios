import UIKit

open class ScanView: BaseView {
  
  var didTapTakePicture: (() -> Void)?
  var didTapBack: (() -> Void)?
  
  let photoPreviewContainer: CapturedImageView = {
    let view = CapturedImageView()
    return view
  }()
  
  let background: CroppingView = {
    let view = CroppingView()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  let cameraContainer: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  let viewTitle: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 26, weight: .regular)
    label.textColor = .white
    label.textAlignment = .center
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  lazy var takePicBtn: UIButton = {
    let button = UIButton()
    button.backgroundColor = .systemRed
    button.setTitle("Fotografar", for: .normal)
    button.setTitleColor(.white, for: .normal)
    button.layer.cornerRadius = 25
    button.addTarget(self, action: #selector(takePictureAction), for: .touchUpInside)
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()
  
  private lazy var returnBtn: UIButton = {
    let button = UIButton()
    button.setTitle("Voltar", for: .normal)
    button.setTitleColor(.white, for: .normal)
    button.addTarget(self, action: #selector(backAction), for: .touchUpInside)
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()
  
  // MARK: - Initialize
  
  open override func initialize() {
    backgroundColor = .black
    clipsToBounds = false
    
    addSubview(viewTitle)
    addSubview(takePicBtn)
    addSubview(returnBtn)
    addSubview(cameraContainer)
    cameraContainer.addSubview(background)
  }
  
  open override func installConstraints() {
    if #available(iOS 11.0, *) {
      NSLayoutConstraint.activate([
        cameraContainer.widthAnchor.constraint(equalTo: widthAnchor),
        cameraContainer.heightAnchor.constraint(equalTo: heightAnchor),
        
        background.widthAnchor.constraint(equalTo: cameraContainer.widthAnchor),
        background.heightAnchor.constraint(equalTo: cameraContainer.heightAnchor),
        
        viewTitle.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
        viewTitle.widthAnchor.constraint(equalTo: widthAnchor),
        
        takePicBtn.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25),
        takePicBtn.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25),
        takePicBtn.heightAnchor.constraint(equalToConstant: 50),
        takePicBtn.bottomAnchor.constraint(equalTo: returnBtn.topAnchor, constant: -50),
        
        returnBtn.heightAnchor.constraint(equalToConstant: 30),
        returnBtn.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20),
        returnBtn.widthAnchor.constraint(equalTo: widthAnchor)
      ])
    }
  }
  
  func setupMaskLayer() {
    let maskLayer = CAShapeLayer()
    maskLayer.frame = background.bounds
    maskLayer.lineWidth = 5
    maskLayer.cornerRadius = 15
    
    let path = UIBezierPath(roundedRect: background.bounds,
                            byRoundingCorners: [.topLeft, .topRight, .bottomLeft, .bottomRight],
                            cornerRadii: CGSize(width: 20, height: 20))
    maskLayer.fillRule = CAShapeLayerFillRule.evenOdd
    
    background.cropReferenceView.addDashedBorder(radius: 10, pattern: [4,4], color: UIColor.white.cgColor)
    background.cropReferenceView.layer.borderWidth = 10
    background.cropReferenceView.layer.cornerRadius = 10
    
    path.append(UIBezierPath(rect: background.cropReferenceView.frame))
    maskLayer.path = path.cgPath
    
    background.layer.mask = maskLayer
  }
}

private extension ScanView {
  @objc
  func takePictureAction() {
    self.didTapTakePicture?()
  }
  
  @objc
  func backAction() {
    self.didTapBack?()
  }
}
