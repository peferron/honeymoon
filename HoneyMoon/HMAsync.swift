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
        let semaphore = dispatch_semaphore_create(0)
        action { dispatch_semaphore_signal(semaphore) }
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
    }
}