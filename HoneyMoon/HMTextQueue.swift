import SpriteKit

public class HMTextQueue {
    // MARK: - Queuing

    let queue = dispatch_queue_create("HMTextQueue", nil)

    public func run(action: () -> Void) -> HMTextQueue {
        dispatch_async(queue, action)
        return self
    }

    func enqueue(action: HMAsync.Action) -> HMTextQueue {
        dispatch_async(queue) { HMAsync.sync(action) }
        return self
    }

    // MARK: - Text

    let container: HMTextContainer
    let trigger: HMAsync.Action

    public init(container: HMTextContainer, trigger: HMAsync.Action) {
        self.container = container
        self.trigger = trigger
    }

    public func print(text: String) -> HMTextQueue {
        return setText(text, append: false)
    }

    public func append(text: String) -> HMTextQueue {
        return setText(text, append: true)
    }

    func setText(text:String, append: Bool) -> HMTextQueue {
        return enqueue { completion in
            dispatch_async(dispatch_get_main_queue()) {
                // No need for an [unowned self] or [weak self] here, the queue will only be deallocated after all GCD
                // closures are executed.
                if append {
                    self.container.text += text
                } else {
                    self.container.text = text
                }
                self.handleContainerAnimation(completion)
            }
        }
    }

    func handleContainerAnimation(completion: () -> Void) {
        trigger {
            if self.container.isAnimating {
                self.container.finishAnimation()
                self.handleContainerAnimation(completion)
            } else {
                completion()
            }
        }
    }
}
