import SpriteKit

public class HMAction: SKAction {
    public class func moveTo(location end: CGPoint, duration: NSTimeInterval, easing: HMEasing) -> SKAction {
        let easingFunction = easing.getFunction()
        var first = true
        var start: CGPoint?
        var delta: CGPoint?
        return SKAction.customActionWithDuration(duration) { (node, time) in
            if first {
                first = false
                start = node.position
                delta = CGPoint(x: end.x - start!.x, y: end.y - start!.y)
                return
            }
            let progress = easingFunction(time / CGFloat(duration))
            node.position = CGPoint(x: start!.x + delta!.x * progress, y: start!.y + delta!.y * progress)
        }
    }

    public class func scaleTo(scale end: CGFloat, duration: NSTimeInterval, easing: HMEasing) -> SKAction {
        let easingFunction = easing.getFunction()
        var first = true
        var start: CGFloat?
        var delta: CGFloat?
        return SKAction.customActionWithDuration(duration) { (node, time) in
            if first {
                first = false
                start = node.xScale
                delta = end - start!
                return
            }
            let progress = easingFunction(time / CGFloat(duration))
            node.setScale(start! + delta! * progress)
        }
    }
}
