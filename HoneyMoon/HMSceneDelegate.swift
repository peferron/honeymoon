import SpriteKit

public protocol HMSceneDelegate: class {
    func didFinishForScene(scene: HMScene, nextSceneClass: HMScene.Type)
}
