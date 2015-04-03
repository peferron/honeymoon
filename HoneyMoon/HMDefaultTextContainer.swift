import UIKit

public class HMDefaultTextContainer: UIView, NSLayoutManagerDelegate, HMTextContainer {
    class var groupSize: Int { return 10 }
    class var groupInterval: UInt64 { return 20 * NSEC_PER_MSEC }

    let textStorage = NSTextStorage()
    let textContainer = NSTextContainer()
    let layoutManager = NSLayoutManager()

    var layoutCounter = 0
    var layoutAttributedString = NSAttributedString(string: "")

    override public var frame: CGRect {
        didSet {
            textContainer.size = bounds.size
        }
    }

    public var text: String = "" {
        didSet {
            textStorage.setAttributedString(createAttributedString(text))
        }
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        customInit()
    }

    required public init(coder aDecoder: NSCoder) {
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

    public func createAttributedString(string: String) -> NSAttributedString {
        return NSAttributedString(string: string)
    }

    // MARK: - Text layers

    var textLayers: [CATextLayer] {
        if let sublayers = layer.sublayers {
            return sublayers.filter { $0 is CATextLayer } as [CATextLayer]
        }
        return []
    }

    public func layoutManager(layoutManager: NSLayoutManager, didCompleteLayoutForTextContainer textContainer: NSTextContainer?, atEnd layoutFinishedFlag: Bool) {
        if !HMDefaultTextContainer.hasPrefix(textStorage, prefix: layoutAttributedString) {
            label = nil
            layer.sublayers = nil
        }

        layoutCounter++
        layoutAttributedString = NSAttributedString(attributedString: textStorage)

        let textLayerGlyphCount = textLayers.count
        let labelGlyphCount = label?.text?.utf16Count ?? 0
        let start = textLayerGlyphCount + labelGlyphCount
        if layoutManager.numberOfGlyphs > start {
            addTextLayerForGlyphIndex(start, layoutCounter: layoutCounter)
        }
    }

    func addTextLayerForGlyphIndex(glyphIndex: Int, layoutCounter: Int) {
        if glyphIndex >= layoutManager.numberOfGlyphs || layoutCounter != self.layoutCounter {
            return
        }
        for var i = 0; i < HMDefaultTextContainer.groupSize && glyphIndex + i < layoutManager.numberOfGlyphs; i++ {
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
        var kerningRange = layoutManager.rangeOfNominallySpacedGlyphsContainingIndex(glyphIndex)
        if kerningRange.length > 0 && kerningRange.location == glyphIndex {
            if let previousTextLayer = textLayers.last {
                previousTextLayer.frame.size.width += glyphRect.maxX - previousTextLayer.frame.maxX
            }
        }

        let characterRange = layoutManager.characterRangeForGlyphRange(glyphRange, actualGlyphRange: nil)

        var textLayer = CATextLayer()
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

    public var isAnimating: Bool {
        if label != nil && label!.text?.utf16Count >= layoutManager.numberOfGlyphs {
            return false
        }
        if textLayers.count < layoutManager.numberOfGlyphs {
            return true
        }
        if layoutManager.numberOfGlyphs == 0 {
            return false
        }
        return !isAnimationFinishedForTextLayers(textLayers)
    }

    public func animateTextLayer(textLayer: CATextLayer, previousTextLayers: [CATextLayer]) {
    }

    public func isAnimationFinishedForTextLayers(textLayers: [CATextLayer]) -> Bool {
        return true
    }

    public func finishAnimation() {
        dispatch_async(dispatch_get_main_queue()) {
            self.layoutCounter++
            self.layer.sublayers = nil
            self.label = self.createLabel()
        }
    }

    // MARK: - Label

    var label: UILabel? {
        get {
            return subviews.first? as? UILabel
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
