public protocol HMTextContainer: class {
    var text: String! { get set }
}

extension UITextView: HMTextContainer {}
extension UITextField: HMTextContainer {}
