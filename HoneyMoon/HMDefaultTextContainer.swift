import UIKit

public class HMDefaultTextContainer: UIView, NSLayoutManagerDelegate, HMTextContainer {
    static let groupSize = 10
    static let groupInterval = 20 * NSEC_PER_MSEC

    let textStorage = NSTextStorage()
    let textContainer = NSTextContainer()
    let layoutManager = NSLayoutManager()

    var layoutCounter = 0
    var layoutAttributedText = NSAttributedString(string: "")

    override public var frame: CGRect {
        didSet {
            textContainer.size = bounds.size
        }
    }

    public var attributedText: NSAttributedString = NSAttributedString(string: "") {
        didSet {
            textStorage.setAttributedString(attributedText)
        }
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        customInit()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customInit()
    }

    func customInit() {
        textContainer.lineBreakMode = .ByWordWrapping
        textContainer.size = bounds.size
        textContainer.maximumNumberOfLines = 0

        textStorage.addLayoutManager(layoutManager)
        layoutManager.addTextContainer(textContainer)
        layoutManager.delegate = self
    }

    // MARK: - Text layers

    var textLayers: [CATextLayer] {
        if let sublayers = layer.sublayers {
            return sublayers.filter { $0 is CATextLayer } as! [CATextLayer]
        }
        return []
    }

    public func layoutManager(layoutManager: NSLayoutManager, didCompleteLayoutForTextContainer textContainer: NSTextContainer?, atEnd layoutFinishedFlag: Bool) {
        if !HMDefaultTextContainer.hasPrefix(textStorage, prefix: layoutAttributedText) {
            label = nil
            layer.sublayers = nil
        }

        layoutCounter += 1
        layoutAttributedText = NSAttributedString(attributedString: textStorage)

        let textLayerGlyphCount = textLayers.count
        let labelGlyphCount = label?.text != nil ? label!.text!.utf16.count : 0
        let start = textLayerGlyphCount + labelGlyphCount
        if layoutManager.numberOfGlyphs > start {
            addTextLayerForGlyphIndex(start, layoutCounter: layoutCounter)
        }
    }

    func addTextLayerForGlyphIndex(glyphIndex: Int, layoutCounter: Int) {
        if glyphIndex >= layoutManager.numberOfGlyphs || layoutCounter != self.layoutCounter {
            return
        }
        for i in 0..<min(HMDefaultTextContainer.groupSize, layoutManager.numberOfGlyphs - glyphIndex) {
            let textLayer = createTextLayerForGlyphIndex(glyphIndex + i)
            animateTextLayer(textLayer, previousTextLayers: textLayers)
            layer.addSublayer(textLayer)
        }
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(HMDefaultTextContainer.groupInterval))
        dispatch_after(time, dispatch_get_main_queue()) { [weak self] in
            self?.addTextLayerForGlyphIndex(glyphIndex + HMDefaultTextContainer.groupSize, layoutCounter: layoutCounter)
            return
        }
    }

    func createTextLayerForGlyphIndex(glyphIndex: Int) -> CATextLayer {
        let glyphRange = NSMakeRange(glyphIndex, 1)
        var glyphRect = layoutManager.boundingRectForGlyphRange(glyphRange, inTextContainer: textContainer)

        // Kerning can cause the previous glyph to be cropped. Examples: the "r" in "Summer.", or the "y" in "Literally.".
        // To prevent that, if kerning is detected then the previous layer frame is extended to include the current glyph rect.
        let kerningRange = layoutManager.rangeOfNominallySpacedGlyphsContainingIndex(glyphIndex)
        if kerningRange.length > 0 && kerningRange.location == glyphIndex {
            if let previousTextLayer = textLayers.last {
                previousTextLayer.frame.size.width += glyphRect.maxX - previousTextLayer.frame.maxX
            }
        }

        // Letters that reach far down, like "y", have an underestimated glyphRect height and get cropped.
        glyphRect.size.height *= 2

        let characterRange = layoutManager.characterRangeForGlyphRange(glyphRange, actualGlyphRange: nil)

        let textLayer = CATextLayer()
        textLayer.frame = glyphRect
        textLayer.string = textStorage.attributedSubstringFromRange(characterRange)
        textLayer.contentsScale = UIScreen.mainScreen().scale

        return textLayer
    }

    class func hasPrefix(string: NSAttributedString, prefix: NSAttributedString) -> Bool {
        if string.length < prefix.length {
            return false
        }
        return string.attributedSubstringFromRange(NSMakeRange(0, prefix.length)).isEqualToAttributedString(prefix)
    }

    // MARK: - Animations

    public var isAnimationFinished: Bool {
        if label?.text != nil && label!.text!.utf16.count >= layoutManager.numberOfGlyphs {
            return true
        }
        if textLayers.count < layoutManager.numberOfGlyphs {
            return false
        }
        if layoutManager.numberOfGlyphs == 0 {
            return true
        }
        return isAnimationFinishedForTextLayers(textLayers)
    }

    public func animateTextLayer(textLayer: CATextLayer, previousTextLayers: [CATextLayer]) {
    }

    public func isAnimationFinishedForTextLayers(textLayers: [CATextLayer]) -> Bool {
        return true
    }

    public func finishAnimation() {
        // Disabled until the UILabel and the CATextLayers can get perfectly aligned.
//        dispatch_async(dispatch_get_main_queue()) {
//            self.layoutCounter++
//            self.layer.sublayers = nil
//            self.label = self.createLabel()
//        }
    }

    // MARK: - Label

    var label: UILabel? {
        get {
            return subviews.first as? UILabel
        }
        set {
            for subview in subviews {
                subview.removeFromSuperview()
            }
            if newValue != nil {
                addSubview(newValue!)
            }
        }
    }

    public func createLabel() -> UILabel {
        let label = UILabel(frame: bounds)
        label.frame.origin.x += 5
        label.numberOfLines = 0
        label.attributedText = textStorage
        label.sizeToFit()
        return label
    }
}
