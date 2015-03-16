import SpriteKit

public class HMTextQueue {
    // MARK: - Queuing

    let queue = dispatch_queue_create("HMTextQueue", nil)

    public func run(action: () -> Void) -> HMTextQueue {
        dispatch_async(queue, action)
        return self
    }

    public func wait(action: HMAsync.Action) -> HMTextQueue {
        dispatch_async(queue) { HMAsync.sync(action) }
        return self
    }

    // MARK: - Label updating

    let container: HMTextContainer

    public init(container: HMTextContainer) {
        self.container = container
    }

    public func erase() -> HMTextQueue {
        return wait { completion in
            dispatch_async(dispatch_get_main_queue()) {
                self.container.text = nil
                completion()
            }
        }
    }

    public func write(text: String) -> HMTextQueue {
        return wait { completion in
            dispatch_async(dispatch_get_main_queue()) {
                self.container.text = (self.container.text ?? "") + text
                completion()
            }
        }
    }
}
