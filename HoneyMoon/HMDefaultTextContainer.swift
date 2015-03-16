import UIKit

public class HMDefaultTextContainer: UILabel {
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        initStyle()
    }

    func initStyle() {
        textColor = UIColor.whiteColor()
        font = UIFont.systemFontOfSize(26)
        lineBreakMode = .ByWordWrapping
        numberOfLines = 0
    }

    public override func textRectForBounds(bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        let rect = super.textRectForBounds(bounds, limitedToNumberOfLines: numberOfLines)
        return CGRect(x: bounds.origin.x, y: bounds.origin.y, width: rect.size.width, height: rect.size.height)
    }

    public override func drawTextInRect(rect: CGRect) {
        super.drawTextInRect(textRectForBounds(rect, limitedToNumberOfLines: numberOfLines))
    }
}
