import UIKit

public protocol HMTextContainer: class {
    var attributedText: NSAttributedString { get set }
    var isAnimationFinished: Bool { get }
    func finishAnimation()
}
