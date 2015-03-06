public struct HMState {
    public let sceneClass: HMScene.Type
    
    public init(sceneClass: HMScene.Type) {
        self.sceneClass = sceneClass
    }

    // MARK: - Save & load

    static let sceneClassNameKey = "state.sceneClassName"

    public func save() {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(NSStringFromClass(self.sceneClass), forKey: HMState.sceneClassNameKey)
        defaults.synchronize()
    }

    public static func load() -> HMState? {
        let defaults = NSUserDefaults.standardUserDefaults()
        let sceneClassName = defaults.stringForKey(HMState.sceneClassNameKey)
        if let sceneClass = NSClassFromString(sceneClassName) as? HMScene.Type {
            return HMState(sceneClass: sceneClass)
        }
        return nil
    }
}
