import UIKit

public class HMDefaultTextContainer: UIView, NSLayoutManagerDelegate, HMTextContainer {
    let textStorage = NSTextStorage()
    let textContainer = NSTextContainer()
    let layoutManager = NSLayoutManager()

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

    public func layoutManager(layoutManager: NSLayoutManager, didCompleteLayoutForTextContainer textContainer: NSTextContainer?, atEnd layoutFinishedFlag: Bool) {
        removeAllSublayers()

        for var glyphIndex = 0; glyphIndex < layoutManager.numberOfGlyphs; glyphIndex++ {
            let glyphRange = NSMakeRange(glyphIndex, 1)
            var glyphRect = layoutManager.boundingRectForGlyphRange(glyphRange, inTextContainer: textContainer!)

            // Kerning can cause the previous glyph to be cropped. Examples: the "r" in "Summer.", or the "y" in "Literally.".
            // To prevent that, if kerning is detected then the previous layer frame is extended to include the current glyph rect.
            var kerningRange = layoutManager.rangeOfNominallySpacedGlyphsContainingIndex(glyphIndex)
            if kerningRange.length > 0 && kerningRange.location == glyphIndex {
                if let previousTextLayer = layer.sublayers?.last? as? CATextLayer {
                    previousTextLayer.frame.size.width += glyphRect.maxX - previousTextLayer.frame.maxX
                }
            }

            let characterRange = layoutManager.characterRangeForGlyphRange(glyphRange, actualGlyphRange: nil)
            var textLayer = createTextLayerWithFrame(glyphRect, string: textStorage.attributedSubstringFromRange(characterRange))
            animateTextLayer(textLayer, index: glyphIndex)

            layer.addSublayer(textLayer)
        }
    }

    func removeAllSublayers() {
        if let sublayers = layer.sublayers {
            for sublayer in sublayers {
                sublayer.removeFromSuperlayer()
            }
        }
    }

    public func createAttributedString(string: String?) -> NSAttributedString {
        return NSAttributedString(string: string ?? "")
    }

    public func createTextLayerWithFrame(frame: CGRect, string: NSAttributedString) -> CATextLayer {
        var textLayer = CATextLayer()
        textLayer.frame = frame
        textLayer.string = string
        textLayer.contentsScale = UIScreen.mainScreen().scale
        return textLayer
    }

    public func animateTextLayer(textLayer: CATextLayer, index: Int) {
    }
}
