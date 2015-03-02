import UIKit

public class HMDefaultQuestionContainer: UIVisualEffectView {
    public required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    public init(frame: CGRect) {
        super.init(effect: UIBlurEffect(style: .Dark))
        self.frame = frame
        self.hidden = true
    }

    public func ask(choices: [(text: String, action: () -> ())]) {
        ask(choices.map { $0.text }) {
            choices[$0].action()
        }
    }

    public func ask(choices: [String], completion: Int -> ()) {
        dispatch_async(dispatch_get_main_queue()) {
            let vibrancyEffect = UIVibrancyEffect(forBlurEffect: self.effect as! UIBlurEffect)
            let vibrancyView = UIVisualEffectView(effect: vibrancyEffect)
            vibrancyView.frame = self.bounds
            self.contentView.addSubview(vibrancyView)
            self.hidden = false

            for i in 0..<choices.count {
                let button = UIButton.buttonWithType(.System) as! UIButton
                button.associatedObject = Block<() -> ()>({
                    self.hidden = true
                    vibrancyView.removeFromSuperview()
                    completion(i)
                })
                button.addTarget(self, action: "buttonTouchedUpInside:", forControlEvents: .TouchUpInside)

                button.setTitle(choices[i], forState: .Normal)
                button.titleLabel?.font = UIFont.systemFontOfSize(64)

                button.sizeToFit()
                button.frame = CGRect(x: 0, y: 0, width: button.frame.width + 50, height: button.frame.height + 20)
                button.center = CGPoint(x: self.center.x, y: self.bounds.height * CGFloat(i + 1) / CGFloat(choices.count + 1))

                vibrancyView.contentView.addSubview(button)
            }
        }
    }

    func buttonTouchedUpInside(button: UIButton) {
        let block = button.associatedObject as? Block<() -> ()>
        button.associatedObject = nil
        block?.f()
    }
}
