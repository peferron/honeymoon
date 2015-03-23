import UIKit

public class HMDefaultTextContainer: UIView, NSLayoutManagerDelegate, HMTextContainer {
    let groupSize = 10
    let groupInterval = 20 * NSEC_PER_MSEC

    let textStorage = NSTextStorage()
    let textContainer = NSTextContainer()
    let layoutManager = NSLayoutManager()

    var layoutCounter = 0

    public var text: String? {
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

//    public func layoutManager(layoutManager: NSLayoutManager, didCompleteLayoutForTextContainer textContainer: NSTextContainer?, atEnd layoutFinishedFlag: Bool) {
//        layoutCounter++
//        let currentLayoutCounter = layoutCounter
//
//        self.layer.sublayers = nil
//
//        let numberOfGlyphs = layoutManager.numberOfGlyphs
//        for var i = 0; i < numberOfGlyphs; i++ {
//            let glyphIndex = i // immutable copy of i for the GCD block
//            let time = dispatch_time(DISPATCH_TIME_NOW, Int64(UInt64(glyphIndex) * 3 * NSEC_PER_MSEC))
//            dispatch_after(time, dispatch_get_main_queue()) {
//                if currentLayoutCounter != self.layoutCounter {
//                    return
//                }
//                let textLayer = self.createTextLayerForGlyphIndex(glyphIndex)
//                self.animateTextLayer(textLayer, index: glyphIndex)
//                self.layer.addSublayer(textLayer)
//            }
//        }
//    }

    public func layoutManager(layoutManager: NSLayoutManager, didCompleteLayoutForTextContainer textContainer: NSTextContainer?, atEnd layoutFinishedFlag: Bool) {
        layoutCounter++
        let currentLayoutCounter = layoutCounter

        self.layer.sublayers = nil

        if layoutManager.numberOfGlyphs > 0 {
            addTextLayerForGlyphIndex(0, currentLayoutCounter: currentLayoutCounter)
        }
    }

    func addTextLayerForGlyphIndex(glyphIndex: Int, currentLayoutCounter: Int) {
        if glyphIndex >= layoutManager.numberOfGlyphs || currentLayoutCounter != self.layoutCounter {
            return
        }
        for var i = 0; i < groupSize && glyphIndex + i < layoutManager.numberOfGlyphs; i++ {
            let textLayer = self.createTextLayerForGlyphIndex(glyphIndex + i)
            self.animateTextLayer(textLayer, index: glyphIndex + i)
            self.layer.addSublayer(textLayer)
        }
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(groupInterval))
        dispatch_after(time, dispatch_get_main_queue()) {
            self.addTextLayerForGlyphIndex(glyphIndex + self.groupSize, currentLayoutCounter: currentLayoutCounter)
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

    public func animateTextLayer(textLayer: CATextLayer, index: Int) {
    }
}
