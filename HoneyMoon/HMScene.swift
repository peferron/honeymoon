import SpriteKit

public class HMScene: SKScene {
    public var sceneDelegate: HMSceneDelegate?

    override public func didMoveToView(view: SKView) {
        backgroundColor = UIColor.blackColor()
        step = HMStep.start

        if HMScene.debugShowFilename {
            addFilenameLabel()
        }
    }

    // MARK: - User input

    public var onTouch: (() -> Void)?

    public func waitForTouch(completion: () -> Void) {
        onTouch = {
            self.onTouch = nil
            completion()
        }
    }

    override public func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
//        for touch: AnyObject in touches {
//            let location = touch.locationInNode(self)
//            println("Touch, x: \(location.x), y: \(location.y)")
//        }
        onTouch?()
    }

    public func didReceiveKey(key: String) {
        println("didReceiveKey: \(key)")
    }

    // MARK: - Filename

    class var classFilename: String {
        return NSStringFromClass(self).componentsSeparatedByString(".")[1]
    }

    var filename: String {
        return self.dynamicType.classFilename
    }

    class func unarchiveFromFile() -> HMScene {
        let path = NSBundle.mainBundle().pathForResource(classFilename, ofType: "sks")!
        let sceneData = NSData(contentsOfFile: path, options: .DataReadingMappedIfSafe, error: nil)!
        let archiver = NSKeyedUnarchiver(forReadingWithData: sceneData)
        archiver.setClass(classForKeyedUnarchiver(), forClassName: "SKScene")
        let scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as! HMScene
        archiver.finishDecoding()
        return scene
    }

    // Using a getter and setter here because otherwise the Swift compiler crashes with a segmentation fault (Xcode 6.3
    // beta).
    static var internalDebugShowFilename = false
    public static var debugShowFilename: Bool {
        get {
            return internalDebugShowFilename
        }
        set {
            internalDebugShowFilename = newValue
        }
    }

    func addFilenameLabel() {
        let label = SKLabelNode(text: filename)
        label.fontSize = 64
        label.fontColor = SKColor.greenColor()
        label.horizontalAlignmentMode = .Right
        label.verticalAlignmentMode = .Top
        label.position = CGPoint(x: frame.width - 15, y: frame.height - 15)
        label.zPosition = 100
        addChild(label)
    }

    // MARK: - Step

    public var step: String = HMStep.none {
        didSet {
            println("\(filename): didSet step: \(oldValue) -> \(step)")
            if !didSetStep(oldValue) {
                println("\(filename): cannot set step: \(oldValue) -> \(step)")
                step = oldValue
            }
        }
    }

    public func didSetStep(oldValue: String) -> Bool {
        return false
    }
}
