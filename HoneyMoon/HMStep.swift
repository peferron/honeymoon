// This would be better suited by an enumeration. However, each HMScene subclass should be able to extend the
// enumeration with their own steps, which doesn't seem possible with today's Swift (Xcode 6.3 beta).
// TODO: Once I have internet back, look this up.
public class HMStep {
    public static let none = "none"
    public static let start = "start"
}