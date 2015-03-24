import CoreGraphics

public class HMEasing {
    public class func cubicEaseInOut(p: CGFloat) -> CGFloat {
        if p < 0.5 {
            return 4 * p * p * p
        }
        let f = 2 * p - 2
        return 0.5 * f * f * f + 1
    }

    public class func expoEaseIn(p: CGFloat) -> CGFloat {
        return (pow(1024, p) - 1) / 1023
    }

    public class func expoEaseOut(p: CGFloat) -> CGFloat {
        return (1 - pow(2, -10 * p)) * 1024 / 1023
    }

    public class func quadraticEaseOut(p: CGFloat) -> CGFloat {
        return -(p * (p - 2))
    }

    public class func quadraticEaseInOut(p: CGFloat) -> CGFloat {
        if p < 0.5 {
            return 2 * p * p
        }
        return (-2 * p * p) + (4 * p) - 1
    }
}
