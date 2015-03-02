public protocol HMTextContainer: AnyObject {
    var text: String! { get set }
}

extension UITextView: HMTextContainer {}
extension UITextField: HMTextContainer {}
