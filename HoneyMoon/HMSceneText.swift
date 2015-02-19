import SpriteKit

public class HMSceneText {
    // MARK: - Queuing

    var queue: [HMAsync.Action] = []

    public func enqueue(action: () -> Void) -> HMSceneText {
        return enqueueAsync { completion in
            action()
            completion()
        }
    }

    public func enqueueAsync(action: HMAsync.Action) -> HMSceneText {
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
                let firstAction = self.queue.removeAtIndex(0)
                firstAction(completion: self.dequeue)
            }
        }
    }

    // MARK: - Label creation

    var createLabel: (() -> SKLabelNode) = HMSceneText.defaultCreateLabel

    class func defaultCreateLabel() -> SKLabelNode {
        let label = SKLabelNode()
        label.fontSize = 32
        label.color = SKColor.whiteColor()
        label.position = CGPoint(x: 15, y: 15)
        label.horizontalAlignmentMode = .Left
        return label
    }

    public func createLabelWith(createLabel: () -> SKLabelNode) -> HMSceneText {
        return enqueue {
            self.createLabel = createLabel
        }
    }

    // MARK: - Touches

    var onTouch: (() -> Void)?

    func touchesBegan() {
        onTouch?()
        onTouch = nil
    }

    public func waitForTouch() -> HMSceneText {
        return enqueueAsync { completion in
            self.onTouch = completion
        }
    }

    // MARK: - Display

    public var container: SKNode!

    public func clear() -> HMSceneText {
        return enqueue(container.removeAllChildren)
    }

    public func append(paragraph: String) -> HMSceneText {
        return enqueue {
            let label = self.createLabel()
            label.text = paragraph
            self.container.addChild(label)
        }
    }
}
