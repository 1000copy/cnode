public class URLLabel: UILabel {
    public var url : String?{
        didSet{
            attributedText = getAttributedText(url!)
        }
    }
    let layoutManager = NSLayoutManager()
    let textContainer = NSTextContainer(size: CGSize.zero)
    var textStorage = NSTextStorage() {
        didSet {
            textStorage.addLayoutManager(layoutManager)
        }
    }
    func getAttributedText(_ homepage : String) -> NSMutableAttributedString{
        let attributedString = NSMutableAttributedString(string: homepage, attributes: nil)
        let linkRange = NSMakeRange(0, homepage.utf8.count)
        let linkAttributes: [NSAttributedStringKey : AnyObject] = [
            NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue) : UIColor.blue, NSAttributedStringKey(rawValue: NSAttributedStringKey.underlineStyle.rawValue) : NSUnderlineStyle.styleSingle.rawValue as AnyObject,
            NSAttributedStringKey(rawValue: NSAttributedStringKey.link.rawValue): homepage as AnyObject]
        attributedString.setAttributes(linkAttributes, range:linkRange)
        return attributedString
    }
    public var onCharacterTapped: ((_ label: UILabel, _ characterIndex: Int) -> Void)?
    
    let tapGesture = UITapGestureRecognizer()
    
    public override var attributedText: NSAttributedString? {
        didSet {
            if let attributedText = attributedText {
                textStorage = NSTextStorage(attributedString: attributedText)
            } else {
                textStorage = NSTextStorage()
            }
        }
    }
    public override var lineBreakMode: NSLineBreakMode {
        didSet {
            textContainer.lineBreakMode = lineBreakMode
        }
    }
    
    public override var numberOfLines: Int {
        didSet {
            textContainer.maximumNumberOfLines = numberOfLines
        }
    }
    
    public required init?(coder aDecoder: NSCoder) {
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
        tapGesture.addTarget(self, action: #selector(URLLabel.labelTapped(_:)))
        addGestureRecognizer(tapGesture)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        textContainer.size = bounds.size
    }
    
    @objc func labelTapped(_ gesture: UITapGestureRecognizer) {
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
