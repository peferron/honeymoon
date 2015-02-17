import SpriteKit

public class HMSceneAnimations {
    // MARK: - Zoom

    public func zoomIn(node: SKNode, scale: CGFloat, x: CGFloat, y: CGFloat, time: NSTimeInterval, completion: () -> Void) {
        zoom(node, scale: scale, x: x, y: y, easeFunction: .Expo, easeMode: .EaseIn, time: time, completion: completion)
    }

    public func zoomOut(node: SKNode, scale: CGFloat, x: CGFloat, y: CGFloat, time: NSTimeInterval, completion: () -> Void) {
        zoom(node, scale: scale, x: x, y: y, easeFunction: .Expo, easeMode: .EaseOut, time: time, completion: completion)
    }

    func zoom(node: SKNode, scale: CGFloat, x: CGFloat, y: CGFloat, easeFunction: CurveType, easeMode: EasingMode, time: NSTimeInterval, completion: () -> Void) {
        let scaledX = -x * scale
        let scaledY = -y * scale

        if time <= 0 {
            node.xScale = scale
            node.yScale = scale
            node.position = CGPoint(x: scaledX, y: scaledY)
            completion()
            return
        }

        let scaleAction = SKEase.ScaleToWithNode(node, easeFunction: easeFunction, mode: easeMode, time: time, toValue: scale)
        let moveAction = SKEase.MoveToWithNode(node, easeFunction: easeFunction, mode: easeMode, time: time, toVector: CGVector(dx: scaledX, dy: scaledY))
        node.runAction(SKAction.group([scaleAction, moveAction]), completion: completion)
    }

    // MARK: - Debug zoom

    public func adjustZoom(node: SKNode, key: String) {
        switch key {
        case "w":
            adjustZoom(node, dScale: 0, dX: 0, dY: 1)
        case "a":
            adjustZoom(node, dScale: 0, dX: -1, dY: 0)
        case "s":
            adjustZoom(node, dScale: 0, dX: 0, dY: -1)
        case "d":
            adjustZoom(node, dScale: 0, dX: 1, dY: 0)
        case "r":
            adjustZoom(node, dScale: 1, dX: 0, dY: 0)
        case "f":
            adjustZoom(node, dScale: -1, dX: 0, dY: 0)
        default:
            break
        }
    }

    public func adjustZoom(node: SKNode, dScale: CGFloat, dX: CGFloat, dY: CGFloat) {
        assert(node.xScale == node.yScale, "node should have identical xScale and yScale")
        let scale = node.xScale + dScale
        let x = -node.position.x / node.xScale + dX
        let y = -node.position.y / node.yScale + dY
        println("adjustZoom, scale: \(scale), x: \(x), y: \(y)")
        zoom(node, scale: scale, x: x, y: y, easeFunction: .Expo, easeMode: .EaseIn, time: 0) {}
    }
}