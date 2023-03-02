import UIKit
import SnapKit

open class ToastView: UIView {

  // MARK: Properties

  open var text: String? {
    get { return self.textLabel.text }
    set { self.textLabel.text = newValue }
  }
    
    private var _iconImageName:String?
    open var iconImageName: String? {
        get {
            return _iconImageName
        }
        set {
            self._iconImageName = newValue
            if let name = _iconImageName {
                self.imageIcon.image = UIImage(named: name)
            }
        }
    }


  // MARK: Appearance

  /// The background view's color.
  override open dynamic var backgroundColor: UIColor? {
    get { return self.backgroundView.backgroundColor }
    set { self.backgroundView.backgroundColor = newValue }
  }

  /// The background view's corner radius.
  @objc open dynamic var cornerRadius: CGFloat {
    get { return self.backgroundView.layer.cornerRadius }
    set { self.backgroundView.layer.cornerRadius = newValue }
  }

  /// The inset of the text label.
  @objc open dynamic var textInsets = UIEdgeInsets(top: 6, left: 10, bottom: 6, right: 10)

  /// The color of the text label's text.
  @objc open dynamic var textColor: UIColor? {
    get { return self.textLabel.textColor }
    set { self.textLabel.textColor = newValue }
  }

  /// The font of the text label.
  @objc open dynamic var font: UIFont? {
    get { return self.textLabel.font }
    set { self.textLabel.font = newValue }
  }

  /// The bottom offset from the screen's bottom in portrait mode.
  @objc open dynamic var bottomOffsetPortrait: CGFloat = {
    switch UIDevice.current.userInterfaceIdiom {
    case .unspecified: return 30
    case .phone: return 30
    case .pad: return 60
    case .tv: return 90
    case .carPlay: return 30
    case .mac: return 60
    @unknown default: return 30
    }
  }()

  /// The bottom offset from the screen's bottom in landscape mode.
  @objc open dynamic var bottomOffsetLandscape: CGFloat = {
    switch UIDevice.current.userInterfaceIdiom {
    case .unspecified: return 20
    case .phone: return 20
    case .pad: return 40
    case .tv: return 60
    case .carPlay: return 20
    case .mac: return 40
    @unknown default: return 20 
    }
  }()


  // MARK: UI

  private let backgroundView: UIView = {
    let `self` = UIView()
    self.backgroundColor = UIColor(white: 0, alpha: 0.5)
    self.layer.cornerRadius = 10
    self.clipsToBounds = true
    return self
  }()
    
  private let textLabel: UILabel = {
      let `self` = UILabel()
      self.textColor = .white
      self.backgroundColor = .clear
      self.font = FONT_NOTOSANS_KR_REGULAR(16)
      self.numberOfLines = 0
      self.textAlignment = .left
      return self
  }()
    
  private let imageIcon: UIImageView = {
      let `self` = UIImageView()
      return self
  }()
    

  // MARK: Initializing

  public init() {
      super.init(frame: .zero)
      self.isUserInteractionEnabled = false
      self.addSubview(self.backgroundView)
  }

  required convenience public init?(coder aDecoder: NSCoder) {
    self.init()
  }


  // MARK: Layout

    override open func layoutSubviews() {
        super.layoutSubviews()
        
        self.backgroundView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.top.bottom.equalToSuperview()
        }
        self.backgroundView.addSubview(self.textLabel)
        if let _ = self.iconImageName  {
            self.backgroundView.addSubview(self.imageIcon)
            self.imageIcon.snp.makeConstraints { make in
                make.leading.equalToSuperview().inset(self.textInsets.left)
                make.height.width.equalTo(24)
                make.centerY.equalToSuperview()
            }
            self.textLabel.snp.makeConstraints { make in
                make.leading.equalTo(self.imageIcon.snp.trailing).offset(8)
                make.top.equalToSuperview().inset(self.textInsets.top)
                make.bottom.equalToSuperview().inset(self.textInsets.bottom)
                make.trailing.equalToSuperview().inset(self.textInsets.right)
            }
        } else {
            self.textLabel.snp.makeConstraints { make in
                make.edges.equalToSuperview().inset(self.textInsets)
            }
        }
        self.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-self.bottomOffsetPortrait)
        }
    }

    override open func hitTest(_ point: CGPoint, with event: UIEvent!) -> UIView? {
        if let superview = self.superview {
            let pointInWindow = self.convert(point, to: superview)
            let contains = self.frame.contains(pointInWindow)
            if contains && self.isUserInteractionEnabled {
                return self
            }
        }
        return nil
    }

}
