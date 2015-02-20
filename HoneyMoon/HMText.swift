import SpriteKit

public class HMText {
    // MARK: - Queuing

    var queue: [HMAsync.Action] = []

    public func enqueue(action: () -> Void) -> HMText {
        return enqueueAsync { completion in
            action()
            completion()
        }
    }

    public func enqueueAsync(action: HMAsync.Action) -> HMText {
        dispatch_async(dispatch_get_main_queue()) {
            self.queue.append(action)
        }
        return self
    }

    public func start() {
        dispatch_async(dispatch_get_main_queue()) {
            if self.queue.isEmpty {
                return
            }
            let firstAction = self.queue.removeAtIndex(0)
            var completed = false
            firstAction {
                dispatch_async(dispatch_get_main_queue()) {
                    if completed {
                        return
                    }
                    completed = true
                    self.start()
                }
            }
        }
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
        return enqueue {
            self.createLabel = createLabel
        }
    }

    // MARK: - Display

    let container: SKNode

    public init(container: SKNode) {
        self.container = container
    }

    public func clear() -> HMText {
        return enqueue(container.removeAllChildren)
    }

    public func write(paragraph: String) -> HMText {
        return enqueue {
            let label = self.createLabel(self.container)
            label.text = paragraph
            self.container.addChild(label)
        }
    }

    public func ask(choices: [String], completion: Int -> Void) -> HMText {
        return enqueueAsync { enqueueCompletion in
            for choice in choices {
                let label = self.createLabel(self.container)
                label.fontColor = UIColor.redColor()
                label.text = choice
                self.container.addChild(label)
                enqueueCompletion()
            }
        }
    }
}
