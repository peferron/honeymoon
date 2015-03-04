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
}
