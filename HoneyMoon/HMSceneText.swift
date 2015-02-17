import SpriteKit

public class HMSceneText {
    // MARK: - Label creation

    var createLabel: (() -> SKLabelNode) = HMSceneText.defaultCreateLabel

    public class func defaultCreateLabel() -> SKLabelNode {
        let label = SKLabelNode()
        label.fontSize = 32
        label.color = SKColor.greenColor()
        return label
    }

    // MARK: - Touches

    var onTouch: (() -> Void)?

    func touchesBegan() {
        onTouch?()
        onTouch = nil
    }

    // MARK: - Queuing

    var queue: [(completion: () -> Void) -> Void] = []

    public func enqueue(action: () -> Void) -> HMSceneText {
        return enqueueAsync { completion in
            action()
            completion()
        }
    }

    public func enqueueAsync(action: (completion: () -> Void) -> Void) -> HMSceneText {
        dispatch_async(dispatch_get_main_queue()) {
            self.queue.append(action)
            if self.queue.count == 1 {
                self.dequeue()
            }
        }
        return self
    }

    func dequeue() {
        dispatch_async(dispatch_get_main_queue()) {
            if self.queue.count > 0 {
                let first = self.queue.removeAtIndex(0)
                first(completion: self.dequeue)
            }
        }
    }

    // MARK: - Convenience functions

    public func clear() -> HMSceneText {
        return enqueue {
            println("clear")
        }
    }

    public func createLabelWith(createLabel: () -> SKLabelNode) -> HMSceneText {
        return enqueue {
            println("createLabelWith")
            self.createLabel = createLabel
        }
    }

    public func append(paragraph: String) -> HMSceneText {
        return enqueueAsync { completion in
            println("append: \(paragraph)")
            completion()
        }
    }

    public func waitForTouch() -> HMSceneText {
        return enqueueAsync { completion in
            println("waitForTouch")
            self.onTouch = completion
        }
    }
}
