import SpriteKit

public class HMViewController: UIViewController, HMSceneDelegate {
    var incoming: SKView?
    var outgoing: SKView?

    public func createSKView() -> SKView {
        return SKView(frame: view.bounds)
    }

    public func presentScene(sceneClass: HMScene.Type) {
        outgoing = incoming

        let incomingScene = sceneClass.unarchiveFromFile()
        println("GKViewController: presentScene: \(incomingScene.filename)")
        incomingScene.scaleMode = .AspectFit
        incomingScene.sceneDelegate = self
        incoming = createSKView()
        incoming?.ignoresSiblingOrder = true

        // Default behavior is to remove the outgoing view, but in more sophisticated transitions we might want to keep
        // both incoming and outgoing views alive for a while.
        outgoing?.removeFromSuperview()
        view.addSubview(incoming!)
        view.sendSubviewToBack(incoming!)

        incoming?.presentScene(incomingScene)
    }

    // MARK: - HMSceneDelegate

    public func didFinishForScene(scene: HMScene, nextSceneClass: HMScene.Type) {
        println("GKViewController: didFinishForScene: \(scene.filename) -> \(nextSceneClass.classFilename)")
        presentScene(nextSceneClass)
    }

    // MARK: - Keys

    let cachedkeyCommands = [
        UIKeyCommand(input: "w", modifierFlags: nil, action: "didReceiveKeyW"),
        UIKeyCommand(input: "a", modifierFlags: nil, action: "didReceiveKeyA"),
        UIKeyCommand(input: "s", modifierFlags: nil, action: "didReceiveKeyS"),
        UIKeyCommand(input: "d", modifierFlags: nil, action: "didReceiveKeyD"),
        UIKeyCommand(input: "r", modifierFlags: nil, action: "didReceiveKeyR"),
        UIKeyCommand(input: "f", modifierFlags: nil, action: "didReceiveKeyF"),
    ]

    override public var keyCommands: [AnyObject]? {
        return cachedkeyCommands
    }

    override public func canBecomeFirstResponder() -> Bool {
        return true
    }

    func didReceiveKeyW() {
        forwardKey("w")
    }

    func didReceiveKeyA() {
        forwardKey("a")
    }

    func didReceiveKeyS() {
        forwardKey("s")
    }

    func didReceiveKeyD() {
        forwardKey("d")
    }

    func didReceiveKeyR() {
        forwardKey("r")
    }

    func didReceiveKeyF() {
        forwardKey("f")
    }

    func forwardKey(key: String) {
        (incoming?.scene as? HMScene)?.didReceiveKey(key)
    }

    // MARK: - UIViewController boilerplate

    override public func shouldAutorotate() -> Bool {
        return true
    }

    override public func supportedInterfaceOrientations() -> Int {
        return Int(UIInterfaceOrientationMask.Landscape.rawValue)
    }

    override public func prefersStatusBarHidden() -> Bool {
        return true
    }
}
