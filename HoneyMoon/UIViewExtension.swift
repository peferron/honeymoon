import UIKit

extension UIView {
    private static var associatedObjectKey: UInt8 = 0

    var associatedObject: AnyObject? {
        get {
            return objc_getAssociatedObject(self, &UIView.associatedObjectKey)
        }
        set {
            objc_setAssociatedObject(self, &UIView.associatedObjectKey, newValue, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN))
        }
    }
}
