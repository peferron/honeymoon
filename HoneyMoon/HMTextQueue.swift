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

    public func enqueueAttributedText(attributedText: NSAttributedString, append: Bool) -> HMTextQueue {
        return enqueue { completion in
            dispatch_async(dispatch_get_main_queue()) {
                // No need for an [unowned self] or [weak self] here, the queue will only be deallocated after all GCD
                // closures are executed.
                if append {
                    let mut = self.container.attributedText.mutableCopy() as NSMutableAttributedString
                    mut.appendAttributedString(attributedText)
                    self.container.attributedText = mut
                } else {
                    self.container.attributedText = attributedText
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
