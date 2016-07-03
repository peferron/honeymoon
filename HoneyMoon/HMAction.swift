import SpriteKit

public class HMAction: SKAction {
    // MARK: - Move

    public class func moveTo(location: CGPoint, duration: NSTimeInterval, easing: CGFloat -> CGFloat) -> SKAction {
        var first = true
        var start: CGPoint?
        var delta: CGVector?
        return customActionWithDuration(duration) { (node, time) in
            if first {
                first = false
                start = node.position
                delta = CGVector(dx: location.x - start!.x, dy: location.y - start!.y)
                if duration > 0 {
                    return
                }
            }
            let progress = duration <= 0 ? 1 : easing(time / CGFloat(duration))
            node.position = CGPoint(x: start!.x + delta!.dx * progress, y: start!.y + delta!.dy * progress)
        }
    }

    // MARK: - Scale

    public class func scaleTo(scale: CGFloat, duration: NSTimeInterval, easing: CGFloat -> CGFloat) -> SKAction {
        var first = true
        var start: CGFloat?
        var delta: CGFloat?
        return customActionWithDuration(duration) { (node, time) in
            if first {
                first = false
                start = node.xScale
                delta = scale - start!
                if duration > 0 {
                    return
                }
            }
            let progress = duration <= 0 ? 1 : easing(time / CGFloat(duration))
            node.setScale(start! + delta! * progress)
        }
    }

    // MARK: - Zoom

    public class func zoomTo(location: CGPoint, scale: CGFloat, duration: NSTimeInterval, easing: CGFloat -> CGFloat) -> SKAction {
        let scaledLocation = locationAtScale(location, scale)
        let scaleAction = scaleTo(scale, duration: duration, easing: easing)
        let moveAction = moveTo(scaledLocation, duration: duration, easing: easing)
        return group([scaleAction, moveAction])
    }

    public class func zoomInTo(location: CGPoint, scale: CGFloat, duration: NSTimeInterval) -> SKAction {
        return zoomTo(location, scale: scale, duration: duration, easing: HMEasing.expoEaseIn)
    }

    public class func zoomOutTo(location: CGPoint, scale: CGFloat, duration: NSTimeInterval) -> SKAction {
        return zoomTo(location, scale: scale, duration: duration, easing: HMEasing.expoEaseOut)
    }

    public class func zoomImmediately(node: SKNode, location: CGPoint, scale: CGFloat) {
        node.setScale(scale)
        node.position = locationAtScale(location, scale)
    }

    public class func adjustZoom(node: SKNode, key: String) {
        switch key {
        case "w":
            adjustZoom(node, scale: 0, location: CGVector(dx: 0, dy: 1))
        case "a":
            adjustZoom(node, scale: 0, location: CGVector(dx: -1, dy: 0))
        case "s":
            adjustZoom(node, scale: 0, location: CGVector(dx: 0, dy: -1))
        case "d":
            adjustZoom(node, scale: 0, location: CGVector(dx: 1, dy: 0))
        case "r":
            adjustZoom(node, scale: 1, location: CGVector(dx: 0, dy: 0))
        case "f":
            adjustZoom(node, scale: -1, location: CGVector(dx: 0, dy: 0))
        default:
            break
        }
    }

    public class func adjustZoom(node: SKNode, scale: CGFloat, location: CGVector) {
        assert(node.xScale == node.yScale, "node should have equal xScale and yScale")
        let adjustedLocation = CGPoint(x: -node.position.x / node.xScale + location.dx, y: -node.position.y / node.yScale + location.dy)
        let adjustedScale = node.xScale + scale
        print("adjustZoom, location: \(adjustedLocation), scale: \(adjustedScale)")
        zoomImmediately(node, location: adjustedLocation, scale: adjustedScale)
    }

    class func locationAtScale(location: CGPoint, _ scale: CGFloat) -> CGPoint {
        return CGPoint(x: -location.x * scale, y: -location.y * scale)
    }
}
