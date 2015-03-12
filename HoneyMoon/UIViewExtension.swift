extension UIView {
    // Class variables are not yet supported. A workaround is to use a static var in a private struct.
    private struct AssociatedObjectKeyWrapper {
        static var value: UInt8 = 0
    }

    var associatedObject: AnyObject? {
        get {
            return objc_getAssociatedObject(self, &AssociatedObjectKeyWrapper.value)
        }
        set {
            objc_setAssociatedObject(self, &AssociatedObjectKeyWrapper.value, newValue, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN))
        }
    }
}
