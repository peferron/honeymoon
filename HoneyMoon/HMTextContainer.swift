import UIKit

public protocol HMTextContainer: class {
    var text: String { get set }
    var isAnimating: Bool { get }
    func finishAnimation()
}
