import SpriteKit

public class HMScene: SKScene {
    public weak var sceneDelegate: HMSceneDelegate?

    override public func didMoveToView(view: SKView) {
        backgroundColor = UIColor.blackColor()
        if HMScene.debugShowFilename {
            addFilenameLabel()
        }
    }

    // MARK: - User input

    public var onTouch: (() -> Void)?

    public func waitForTouch(completion: () -> Void) {
        onTouch = { [unowned self] in
            self.onTouch = nil
            completion()
        }
    }

    override public func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
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

    public class var sksFilename: String {
        return classFilename
    }

    public class var classFilename: String {
        return NSStringFromClass(self).componentsSeparatedByString(".")[1]
    }

    public var filename: String {
        return self.dynamicType.classFilename
    }

    class func unarchiveFromFile() -> HMScene {
        let path = NSBundle.mainBundle().pathForResource(sksFilename, ofType: "sks")!
        let sceneData = NSData(contentsOfFile: path, options: .DataReadingMappedIfSafe, error: nil)!
        let archiver = NSKeyedUnarchiver(forReadingWithData: sceneData)
        archiver.setClass(classForKeyedUnarchiver(), forClassName: "SKScene")
        let scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as HMScene
        archiver.finishDecoding()
        return scene
    }

    // Class variables are not yet supported. A workaround is to use a static var in a private struct.
    private struct DebugShowFilenameWrapper {
        static var value: Bool = false
    }
    public class var debugShowFilename: Bool {
        get {
            return DebugShowFilenameWrapper.value
        }
        set {
            DebugShowFilenameWrapper.value = newValue
        }
    }

    func addFilenameLabel() {
        let label = SKLabelNode(text: filename)
        label.fontSize = 30
        label.fontColor = SKColor.greenColor()
        label.horizontalAlignmentMode = .Right
        label.verticalAlignmentMode = .Bottom
        label.position = CGPoint(x: frame.width - 15, y: 15)
        label.zPosition = 100
        addChild(label)
    }
}
