//
//  GKScene.swift
//  GameKit
//
//  Created by Mat on 12/3/14.
//  Copyright (c) 2014 Mat. All rights reserved.
//

import SpriteKit

public class GKScene: SKScene {
    public var sceneDelegate: GKSceneDelegate?

    var filename: String {
        return self.dynamicType.classFilename
    }

    public var step: Int = -1 {
        didSet {
            println("\(filename): didSet step: \(oldValue) -> \(step)")
            if !didSetStep(oldValue) {
                println("\(filename): cannot set step: \(oldValue) -> \(step)")
                step = oldValue
            }
        }
    }

    public func didSetStep(oldValue: Int) -> Bool {
        return false
    }

    func nextStep() {
        step++
    }

    public func node(name: String) -> SKNode {
        return childNodeWithName(name)!
    }

    override public func didMoveToView(view: SKView) {
        backgroundColor = UIColor.blackColor()
        step = 0

        let label = SKLabelNode(text: filename)
        label.fontSize = 64
        label.fontColor = SKColor.greenColor()
        label.horizontalAlignmentMode = .Left
        label.position = CGPoint(x: 15, y: 15)
        label.zPosition = 100
        addChild(label)
    }

    override public func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            println("Touch, x: \(location.x), y: \(location.y)")
        }
        step++
    }

    public func didReceiveKey(key: String) {
        println("didReceiveKey: \(key)")
    }

    // MARK: - Animations

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
        zoom(node, scale: scale, x: x, y: y, easeFunction: .Expo, easeMode: .EaseIn, time: 0, completion: {})
    }

    // MARK: - Class funcs and vars

    class func unarchiveFromFile() -> GKScene {
        let path = NSBundle.mainBundle().pathForResource(classFilename, ofType: "sks")!
        let sceneData = NSData(contentsOfFile: path, options: .DataReadingMappedIfSafe, error: nil)!
        let archiver = NSKeyedUnarchiver(forReadingWithData: sceneData)
        archiver.setClass(classForKeyedUnarchiver(), forClassName: "SKScene")
        let scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as! GKScene
        archiver.finishDecoding()
        return scene
    }

    class var classFilename: String {
        return NSStringFromClass(self).componentsSeparatedByString(".")[1]
    }
}
