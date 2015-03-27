import UIKit
import SpriteKit

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

    public class func moveBackground(background: SKNode, relativeToView view: UIView) {
        //        let tiltGroup = childNodeWithName("//tilt_group")!
        //        var prevPosition = tiltGroup.position
        //        var prevDate: NSDate = NSDate()
        //        let groupEffect = HMInterpolatingMotionEffectGroup { (horizontal, vertical) in
        //            let newPosition = CGPoint(x: CGFloat(-100 * horizontal), y: CGFloat(100 * vertical))
        //
        //            let deltaX = newPosition.x - prevPosition.x
        //            let deltaY = newPosition.y - prevPosition.y
        //            let deltaPosition = sqrt(deltaX * deltaX + deltaY + deltaY)
        //
        //            let newDate = NSDate()
        //            let deltaDate = newDate.timeIntervalSinceDate(prevDate)
        //            println("deltaDate: \(deltaDate), deltaPosition: \(deltaPosition)")
        //
        //            if abs(deltaPosition) < 1 {
        //                println("  Skip");
        //                return
        //            }
        //
        //            tiltGroup.removeAllActions()
        //            if deltaDate < 1 / 20 {
        //                println("  Set position");
        //                tiltGroup.position = newPosition
        //            } else {
        //                println("  Animate position")
        //                let action = SKAction.moveTo(newPosition, duration: deltaDate)
        //                tiltGroup.runAction(action)
        //            }
        //
        //            prevDate = newDate
        //            prevPosition = newPosition
        //        }
        //        view?.addMotionEffect(groupEffect)

        let deltaX = (background.frame.size.width - view.frame.size.width) / 2
        let deltaY = (background.frame.size.height - view.frame.size.height) / 2

        let groupEffect = HMInterpolatingMotionEffectGroup { (horizontal, vertical) in
            let newPosition = CGPoint(x: deltaX * CGFloat(horizontal), y: deltaY * CGFloat(vertical))
            background.position = newPosition
        }
        view.addMotionEffect(groupEffect)
    }
}
