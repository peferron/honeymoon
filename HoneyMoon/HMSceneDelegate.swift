import SpriteKit

public protocol HMSceneDelegate: class {
    func didFinishForScene(sender: HMScene, nextSceneClass: HMScene.Type)
}
