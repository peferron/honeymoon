import SpriteKit

public class HMText {
    // MARK: - Queuing

    let queue = dispatch_queue_create("HMText", nil)

    public func enqueue(action: () -> Void) -> HMText {
        dispatch_async(queue, action)
        return self
    }

    public func enqueueAsync(action: HMAsync.Action) -> HMText {
        dispatch_async(queue) { HMAsync.sync(action) }
        return self
    }

    // MARK: - Label creation

    var createLabel = HMText.defaultCreateLabel

    public class func defaultCreateLabel(container: SKNode) -> SKLabelNode {
        let label = SKLabelNode()
        label.fontSize = 32
        label.fontColor = UIColor.blackColor()
        label.position = CGPoint(x: 15, y: container.frame.height - 15)
        label.horizontalAlignmentMode = .Left
        label.verticalAlignmentMode = .Top
        return label
    }

    public func enqueueCreateLabelWith(createLabel: (container: SKNode) -> SKLabelNode) -> HMText {
        return enqueue { self.createLabel = createLabel }
    }

    // MARK: - Display

    let container: SKNode

    public init(container: SKNode) {
        self.container = container
    }

    public func enqueueClear() -> HMText {
        return enqueue(container.removeAllChildren)
    }

    public func enqueueWrite(paragraph: String) -> HMText {
        return enqueue {
            let label = self.createLabel(self.container)
            label.text = paragraph
            self.container.addChild(label)
        }
    }

    public func enqueueAsk(choices: [String], userChoice: Int -> Void) -> HMText {
        return enqueueAsync { completion in
            for choice in choices {
                let label = self.createLabel(self.container)
                label.fontColor = UIColor.redColor()
                label.text = choice
                self.container.addChild(label)
            }
            userChoice(1)
            completion()
        }
    }
}
