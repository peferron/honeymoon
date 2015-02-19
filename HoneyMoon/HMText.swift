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
            if self.queue.count == 1 {
                self.dequeue()
            }
        }
        return self
    }

    func dequeue() {
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
                    self.dequeue()
                }
            }
        }
    }

    // MARK: - Label creation

    public typealias HMLabelCreator = (container: SKNode) -> SKLabelNode

    var createLabel = HMText.defaultCreateLabel

    class func defaultCreateLabel(container: SKNode) -> SKLabelNode {
        let label = SKLabelNode()
        label.fontSize = 32
        label.color = SKColor.whiteColor()
        label.position = CGPoint(x: 15, y: container.frame.height - 15)
        label.horizontalAlignmentMode = .Left
        label.verticalAlignmentMode = .Top
        return label
    }

    public func createLabelWith(createLabel: HMLabelCreator) -> HMText {
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

    public func append(paragraph: String) -> HMText {
        return enqueue {
            let label = self.createLabel(self.container)
            label.text = paragraph
            self.container.addChild(label)
        }
    }
}
