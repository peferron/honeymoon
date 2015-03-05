// This would be better suited by an enumeration. However, any non-trivial HMScene subclass needs to extend the
// enumeration with their own steps, which is not supported by Swift (Xcode 6.3 beta).
public class HMStep {
    public static let none = "none"
    public static let start = "start"
}
