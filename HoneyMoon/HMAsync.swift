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
                    if (completed.every { $0 }) {
                        completion()
                    }
                }
            }
        }
    }

    public static func sync(action: Action) {
        let group = dispatch_group_create()
        dispatch_group_enter(group)
        action { dispatch_group_leave(group) }
        dispatch_group_wait(group, DISPATCH_TIME_FOREVER)
    }
}