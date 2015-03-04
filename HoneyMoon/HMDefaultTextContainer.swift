import UIKit

public class HMDefaultTextContainer: UITextView {
    override public init() {
        super.init()
    }

    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
    }

    override public init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        initStyle()
    }

    func initStyle() {
        // Init background.
        backgroundColor = nil

        // Init text style.
        textColor = UIColor.whiteColor()
        font = UIFont.systemFontOfSize(26)

        // Disable user interaction.
        editable = false
        selectable = false
        userInteractionEnabled = false
        resignFirstResponder()
    }

//    func newAttributedString(string: String) -> NSMutableAttributedString {
//        let att = NSMutableAttributedString(string: string)
//        att.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(36), range: NSMakeRange(0, att.length))
//        return att
//    }
//
//    func animateAttributedString() {
//        let timer = NSTimer.scheduledTimerWithTimeInterval(0.05, target: self, selector: "showFirstCharacter", userInfo: nil, repeats: true)
//        timer.fire()
//    }
//
//    func showFirstCharacter() {
//        let att = attributedText.mutableCopy() as! NSMutableAttributedString
//        if let first = self.indexOfFirstTransparentCharacter(att) {
//            let characterColor = textColor.colorWithAlphaComponent(1)
//            att.addAttribute(NSForegroundColorAttributeName, value: characterColor, range: NSMakeRange(first, 1))
//            self.attributedText = att
//        }
//    }
//
//    func indexOfFirstTransparentCharacter(att: NSAttributedString) -> Int? {
//        for i in 0..<att.length {
//            if let characterColor = att.attribute(NSForegroundColorAttributeName, atIndex: i, effectiveRange: nil) as? UIColor {
//                if CGColorGetAlpha(characterColor.CGColor) < 1 {
//                    return i
//                }
//            }
//        }
//        return nil
//    }
//
//    override public var text: String! {
//        get {
//            return super.text
//        }
//        set {
//            let att = newAttributedString(newValue)
//            for i in 0..<att.length {
//                let characterColor = textColor.colorWithAlphaComponent(0)
//                att.addAttribute(NSForegroundColorAttributeName, value: characterColor, range: NSMakeRange(i, 1))
//            }
//            attributedText = att
//            animateAttributedString()
//        }
//    }
}
