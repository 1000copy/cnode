class AboutPage: UIViewController {
    var count = 0
    var avatar = UIImageView()
    var name = UILabel()
    var slogan = UITextView()
    var site = CustomLabel()
    var dismiss = UIButton()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(name)
        view.addSubview(avatar)
        view.addSubview(slogan)
        view.addSubview(site)
        view.addSubview(dismiss)
        name.text =  "刘传君"
        slogan.text = "创过业、做过产品、一个爱读书，喜欢分享的程序员"
//        slogan.numberOfLines = 0
        slogan.isEditable = false
        slogan.isUserInteractionEnabled = false

        site.text = "https://lcj.sxl.cn/"
        site.textAlignment = .center
        dismiss.setTitle("Close",for: .normal)
        dismiss.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
        constrain(self.view, avatar, name,slogan,site){
            $1.top == $0.top + 100
            $1.centerX == $0.centerX
            $1.height == 38
            $1.width == 38
            
            $2.top == $1.bottom + 15
            $2.centerX == $1.centerX
            
            $3.top == $2.bottom + 5
            $3.centerX == $1.centerX
            $3.width == 100
            $3.height == 100
            
            $4.top == $3.bottom + 5
            $4.centerX == $1.centerX
            $4.width == 200
            $4.height == 30
        }
        let url = "https://avatars2.githubusercontent.com/u/4485958?v=4&s=400"
//        avatar.kf.setImage(with:URL(string:url))
        avatar.setImage2(url)
        //
        let homepage : String = "https://lcj.sxl.cn"
        let attributedString = NSMutableAttributedString(string: homepage, attributes: nil)
        let linkRange = NSMakeRange(0, homepage.utf8.count)
        
        let linkAttributes: [String : AnyObject] = [
            NSForegroundColorAttributeName : UIColor.blue, NSUnderlineStyleAttributeName : NSUnderlineStyle.styleSingle.rawValue as AnyObject,
            NSLinkAttributeName: homepage as AnyObject]
        attributedString.setAttributes(linkAttributes, range:linkRange)
        
        site.attributedText = attributedString
        
        site.onCharacterTapped = { label, characterIndex in
            let url = URL(string: homepage)!
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    func buttonAction(_ sender:UIButton!){
        centerPage.popViewController(animated: true)
    }
}
import UIKit


class CustomLabel: UILabel {
    
    let layoutManager = NSLayoutManager()
    let textContainer = NSTextContainer(size: CGSize.zero)
    var textStorage = NSTextStorage() {
        didSet {
            textStorage.addLayoutManager(layoutManager)
        }
    }
    var onCharacterTapped: ((_ label: UILabel, _ characterIndex: Int) -> Void)?
    
    let tapGesture = UITapGestureRecognizer()
    
    override var attributedText: NSAttributedString? {
        didSet {
            if let attributedText = attributedText {
                textStorage = NSTextStorage(attributedString: attributedText)
            } else {
                textStorage = NSTextStorage()
            }
        }
    }
    override var lineBreakMode: NSLineBreakMode {
        didSet {
            textContainer.lineBreakMode = lineBreakMode
        }
    }
    
    override var numberOfLines: Int {
        didSet {
            textContainer.maximumNumberOfLines = numberOfLines
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    func setUp() {
        isUserInteractionEnabled = true
        layoutManager.addTextContainer(textContainer)
        textContainer.lineFragmentPadding = 0
        textContainer.lineBreakMode = lineBreakMode
        textContainer.maximumNumberOfLines = numberOfLines
        tapGesture.addTarget(self, action: #selector(CustomLabel.labelTapped(_:)))
        addGestureRecognizer(tapGesture)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        textContainer.size = bounds.size
    }
    
    func labelTapped(_ gesture: UITapGestureRecognizer) {
        guard gesture.state == .ended else {
            return
        }
        let locationOfTouch = gesture.location(in: gesture.view)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        let textContainerOffset = CGPoint(x: (bounds.width - textBoundingBox.width) / 2 - textBoundingBox.minX,
                                          y: (bounds.height - textBoundingBox.height) / 2 - textBoundingBox.minY)
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouch.x - textContainerOffset.x, y: locationOfTouch.y - textContainerOffset.y)
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer,
                                                            in: textContainer,  fractionOfDistanceBetweenInsertionPoints: nil)
        
        onCharacterTapped?(self, indexOfCharacter)
    }
    
}
