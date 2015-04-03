import UIKit

public protocol HMTextContainer: class {
    var attributedText: NSAttributedString { get set }
    var isAnimating: Bool { get }
    func finishAnimation()
}
