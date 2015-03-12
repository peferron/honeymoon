public class HMAsync {
    public typealias Action = (completion: () -> Void) -> Void

    // This function looks like a good candidate for a GCD group. However, if we want to guard against actions calling
    // their completion callback multiple times, we need a boolean flag. To access to this boolean flag safely from
    // multiple threads, we need to wrap it in a dispatch_async. At this point we might as well get rid of the GCD group
    // and simply use a counter instead.
    public static func parallel(actions: [Action], completion: () -> Void) {
        if actions.isEmpty {
            completion()
            return
        }

        let queue = dispatch_queue_create("HMAsync.parallel", nil)
        var pending = actions.count
        
        for action in actions {
            var done = false
            action {
                dispatch_async(queue) {
                    if done {
                        // This action has already called its completion callback at least once before.
                        return
                    } 
                    done = true
                    pending--
                    if pending == 0 {
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

    public static func wait(seconds: Float, completion: () -> Void) {
        let nanoseconds = Int64(Double(seconds) * Double(NSEC_PER_SEC))
        let time = dispatch_time(DISPATCH_TIME_NOW, nanoseconds)
        dispatch_after(time, dispatch_get_main_queue(), completion)
    }
}