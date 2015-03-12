public enum HMEasing {
    case ExpoEaseIn, ExpoEaseOut
    case QuadraticEaseOut, QuadraticEaseInOut

    func getFunction() -> (CGFloat -> CGFloat) {
        switch self {
        case .ExpoEaseIn:
            return HMEasing.expoEaseIn
        case .ExpoEaseOut:
            return HMEasing.expoEaseOut
        case .QuadraticEaseOut:
            return HMEasing.quadraticEaseOut
        case .QuadraticEaseInOut:
            return HMEasing.quadraticEaseInOut
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

    static func quadraticEaseInOut(p: CGFloat) -> CGFloat {
        if p < 0.5 {
            return 2 * p * p;
        }
        return (-2 * p * p) + (4 * p) - 1;
    }
}
