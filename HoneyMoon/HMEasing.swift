public enum HMEasing {
    case ExpoEaseIn
    case ExpoEaseOut
    case QuadraticEaseOut

    func getFunction() -> (CGFloat -> CGFloat) {
        switch self {
        case .ExpoEaseIn:
            return HMEasing.expoEaseIn
        case .ExpoEaseOut:
            return HMEasing.expoEaseOut
        case .QuadraticEaseOut:
            return HMEasing.quadraticEaseOut
        }
    }

    static func expoEaseIn(p: CGFloat) -> CGFloat {
        return (pow(1024, p) - 1) / 1023
    }

    static func expoEaseOut(p: CGFloat) -> CGFloat {
        return (1 - pow(2, -10 * p)) * 1024 / 1023
    }

    static func quadraticEaseOut(p: CGFloat) -> CGFloat {
        return -(p * (p - 2))
    }
}
