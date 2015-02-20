public class HMAsync {
    public typealias Action = (completion: () -> Void) -> Void

    public static func parallel(actions: [Action], completion: () -> Void) {
        if actions.isEmpty {
            completion()
            return
        }

        let queue = dispatch_queue_create("HMAsync.parallel", nil)
        var completed = [Bool](count: actions.count, repeatedValue: false)

        for i in 0..<actions.count {
            actions[i] {
                dispatch_async(queue) {
                    completed[i] = true
                    if (self.every(completed) { $0 }) {
                        completion()
                    }
                }
            }
        }
    }

    static func every<T>(array: Array<T>, fn: (T) -> Bool) -> Bool {
        for item in array {
            if !fn(item) {
                return false
            }
        }
        return true
    }

    public static func sync(action: Action) {
        var completed = false
        action { completed = true }
        while !completed {}
    }
}