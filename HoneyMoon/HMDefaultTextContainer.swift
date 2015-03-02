import UIKit

public class HMDefaultTextContainer: UITextView {
    override public init() {
        super.init()
    }

    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initStyle()
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        initStyle()
    }

    func initStyle() {
        // Init background.
        backgroundColor = nil

        // Init text style.
        textAlignment = .Justified
        textColor = UIColor.redColor()
        font = UIFont.systemFontOfSize(30)

        // Disable user interaction.
        editable = false
        selectable = false
        userInteractionEnabled = false
        resignFirstResponder()
    }
}
