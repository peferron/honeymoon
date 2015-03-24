import Foundation

public class HMState {
    private class var sceneClassNameKey: String {
        return "sceneClassName"
    }

    public class var sceneClass: HMScene.Type? {
        get {
            if let sceneClassName = NSUserDefaults.standardUserDefaults().stringForKey(sceneClassNameKey) {
                return NSClassFromString(sceneClassName) as? HMScene.Type
            }
            return nil
        }
        set {
            let sceneClassName = NSStringFromClass(newValue)
            NSUserDefaults.standardUserDefaults().setObject(sceneClassName, forKey: sceneClassNameKey)
        }
    }

    public class func valid() -> Bool {
        return sceneClass != nil
    }
}
