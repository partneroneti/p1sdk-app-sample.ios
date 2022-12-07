import UIKit

final class CroppingView: BaseView {
  
  private var overlayView: UIView = {
    let view = UIView()
    view.backgroundColor = .black.withAlphaComponent(0.75)
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  var cropReferenceView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  override func layoutSubviews() {
    super.layoutSubviews()
  }
  
  // MARK: - Initialize
  
  override func initialize() {
    backgroundColor = .clear
    clipsToBounds = false
    
    addSubview(overlayView)
    overlayView.addSubview(cropReferenceView)
  }
  
  override func installConstraints() {
    NSLayoutConstraint.activate([
      overlayView.widthAnchor.constraint(equalTo: widthAnchor),
      overlayView.heightAnchor.constraint(equalTo: heightAnchor),
      overlayView.bottomAnchor.constraint(equalTo: bottomAnchor),
      
      cropReferenceView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
      cropReferenceView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
      cropReferenceView.topAnchor.constraint(equalTo: topAnchor, constant: 160),
      cropReferenceView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -240),
      cropReferenceView.centerXAnchor.constraint(equalTo: overlayView.centerXAnchor),
      cropReferenceView.centerYAnchor.constraint(equalTo: overlayView.centerYAnchor),
    ])
  }
}
