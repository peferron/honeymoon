public protocol HMTextContainer: class {
    var text: String? { get set }
}

extension UILabel: HMTextContainer {}
