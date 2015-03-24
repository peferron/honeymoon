import UIKit

public class HMInterpolatingMotionEffect: UIInterpolatingMotionEffect {
    class var key: String {
        return "key"
    }

    var callback: (Float -> Void)?

    convenience public init(type: UIInterpolatingMotionEffectType, callback: Float -> Void) {
        self.init(keyPath: HMInterpolatingMotionEffect.key, type: type)
        self.callback = callback
        minimumRelativeValue = -1
        maximumRelativeValue = 1
    }

    override public func keyPathsAndRelativeValuesForViewerOffset(viewerOffset: UIOffset) -> [NSObject : AnyObject]! {
        let dict = super.keyPathsAndRelativeValuesForViewerOffset(viewerOffset)
        let value = dict[HMInterpolatingMotionEffect.key] as Float
        callback?(value)
        return [NSObject : AnyObject]()
    }
}
