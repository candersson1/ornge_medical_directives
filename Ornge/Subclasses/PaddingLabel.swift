import UIKit

class PaddingLabel: UILabel {

    var textInsets: UIEdgeInsets {
        didSet { invalidateIntrinsicContentSize() }
    }

    // Create a new PaddingLabel instance programamtically with the desired insets
    required init(padding: UIEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)) {
        self.textInsets = padding
        super.init(frame: CGRect.zero)
    }

    // Create a new PaddingLabel instance programamtically with default insets
    override init(frame: CGRect) {
        textInsets = UIEdgeInsets.zero // set desired insets value according to your needs
        super.init(frame: frame)
    }

    // Create a new PaddingLabel instance from Storyboard with default insets
    required init?(coder aDecoder: NSCoder) {
        textInsets = UIEdgeInsets.zero // set desired insets value according to your needs
        super.init(coder: aDecoder)
    }

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: textInsets))
    }

    // Override `intrinsicContentSize` property for Auto layout code
    override var intrinsicContentSize: CGSize {
        let superContentSize = super.intrinsicContentSize
        let width = superContentSize.width + textInsets.left + textInsets.right
        let heigth = superContentSize.height + textInsets.top + textInsets.bottom
        return CGSize(width: width, height: heigth)
    }

    // Override `sizeThatFits(_:)` method for Springs & Struts code
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let superSizeThatFits = super.sizeThatFits(size)
        let width = superSizeThatFits.width + 10 + textInsets.left + textInsets.right
        let heigth = superSizeThatFits.height + textInsets.top + textInsets.bottom
        return CGSize(width: width, height: heigth)
    }
    
    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        let insetRect = bounds.inset(by: textInsets)
        let textRect = super.textRect(forBounds: insetRect, limitedToNumberOfLines: numberOfLines)
        let invertedInsets = UIEdgeInsets(top: -textInsets.top,
                left: -textInsets.left,
                bottom: -textInsets.bottom,
                right: -textInsets.right)
        return textRect.inset(by: invertedInsets)
    }
}
