import UIKit
import SpriteKit

public class HMInterpolatingMotionEffect: UIInterpolatingMotionEffect {
    static let key = "key"
    
    var callback: (Float -> Void)?

    convenience public init(type: UIInterpolatingMotionEffectType, callback: Float -> Void) {
        self.init(keyPath: HMInterpolatingMotionEffect.key, type: type)
        self.callback = callback
        minimumRelativeValue = -1
        maximumRelativeValue = 1
    }

    override public func keyPathsAndRelativeValuesForViewerOffset(viewerOffset: UIOffset) -> [String : AnyObject]? {
        let dict = super.keyPathsAndRelativeValuesForViewerOffset(viewerOffset)
        if let value = dict?[HMInterpolatingMotionEffect.key] as? Float {
            callback?(value)
        }
        return [String : AnyObject]()
    }

    public class func addMotionEffectToBackground(background: SKNode, relativeToView view: UIView, delta: CGVector) {
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

        let groupEffect = HMInterpolatingMotionEffectGroup { (horizontal, vertical) in
            let newPosition = CGPoint(x: -delta.dx * CGFloat(horizontal), y: delta.dy * CGFloat(vertical))
            background.position = newPosition
        }
        view.addMotionEffect(groupEffect)
    }
}
