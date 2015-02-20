class HMUtils {
    static func every<T>(array: Array<T>, fn: (T) -> Bool) -> Bool {
        for item in array {
            if !fn(item) {
                return false
            }
        }
        return true
    }
}