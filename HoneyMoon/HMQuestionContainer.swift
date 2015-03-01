import UIKit

public class HMQuestionContainer: UIView {
    override init() {
        super.init()
    }

    public required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
    }

    public func ask(choices: [String], completion: Int -> ()) {
        dispatch_async(dispatch_get_main_queue()) {
            for i in 0..<choices.count {
                let button = UIButton.buttonWithType(.System) as! UIButton
                button.associatedObject = Block<() -> ()>({
                    self.erase()
                    completion(i)
                })
                button.addTarget(self, action: "buttonTouchedUpInside:", forControlEvents: .TouchUpInside)

                button.backgroundColor = UIColor.grayColor()
                button.setTitle(choices[i], forState: .Normal)
                button.titleLabel?.font = UIFont.systemFontOfSize(64)

                button.sizeToFit()
                button.frame = CGRect(x: 0, y: 0, width: button.frame.width + 50, height: button.frame.height + 20)
                button.center = CGPoint(x: self.center.x, y: self.bounds.height * CGFloat(i + 1) / CGFloat(choices.count + 1))
                
                self.addSubview(button)
            }
        }
    }

    func erase() {
        for subview in self.subviews {
            if subview is UIButton {
                subview.removeFromSuperview()
            }
        }
    }

    func buttonTouchedUpInside(button: UIButton) {
        let block = button.associatedObject as? Block<() -> ()>
        button.associatedObject = nil
        block?.f()
    }
}
