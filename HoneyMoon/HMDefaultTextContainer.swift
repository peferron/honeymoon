import UIKit

public class HMDefaultTextContainer: UIView, NSLayoutManagerDelegate, HMTextContainer {
    class var groupSize: Int { return 10 }
    class var groupInterval: UInt64 { return 20 * NSEC_PER_MSEC }

    let textStorage = NSTextStorage()
    let textContainer = NSTextContainer()
    let layoutManager = NSLayoutManager()

    var layoutCounter = 0
    var layoutAttributedString: NSAttributedString = NSAttributedString(string: "")

    public var text: String? {
        didSet {
            textStorage.setAttributedString(createAttributedString(text))
        }
    }

    override public var frame: CGRect {
        didSet {
            textContainer.size = bounds.size
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
        initTextContainer()
        textStorage.addLayoutManager(layoutManager)
        layoutManager.addTextContainer(textContainer)
        layoutManager.delegate = self
    }

    func initTextContainer() {
        textContainer.lineBreakMode = .ByWordWrapping
        textContainer.size = bounds.size
        textContainer.maximumNumberOfLines = 0
    }

    public func layoutManager(layoutManager: NSLayoutManager, didCompleteLayoutForTextContainer textContainer: NSTextContainer?, atEnd layoutFinishedFlag: Bool) {
        if !HMDefaultTextContainer.hasPrefix(textStorage, prefix: layoutAttributedString) {
            self.layer.sublayers = nil
        }

        layoutCounter++
        layoutAttributedString = NSAttributedString(attributedString: textStorage)

        let start = self.layer.sublayers?.count ?? 0
        if layoutManager.numberOfGlyphs > start {
            addTextLayerForGlyphIndex(start, layoutCounter: layoutCounter)
        }
    }

    class func hasPrefix(string: NSAttributedString, prefix: NSAttributedString) -> Bool {
        if string.length < prefix.length {
            return false
        }
        return string.attributedSubstringFromRange(NSMakeRange(0, prefix.length)).isEqualToAttributedString(prefix)
    }

    func addTextLayerForGlyphIndex(glyphIndex: Int, layoutCounter: Int) {
        if glyphIndex >= layoutManager.numberOfGlyphs || layoutCounter != self.layoutCounter {
            return
        }
        for var i = 0; i < HMDefaultTextContainer.groupSize && glyphIndex + i < layoutManager.numberOfGlyphs; i++ {
            let textLayer = createTextLayerForGlyphIndex(glyphIndex + i)
            animateTextLayer(textLayer, previousTextLayers: (layer.sublayers? ?? []) as [CATextLayer])
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
            if let previousTextLayer = layer.sublayers?.last? as? CATextLayer {
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

    public func createAttributedString(string: String?) -> NSAttributedString {
        return NSAttributedString(string: string ?? "")
    }

    public func animateTextLayer(textLayer: CATextLayer, previousTextLayers: [CATextLayer]) {
    }
}
