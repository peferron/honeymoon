public class HMInterpolatingMotionEffectGroup: UIMotionEffectGroup {
    convenience public init(callback: (horizontal: Float, vertical: Float) -> Void) {
        self.init()

        // Assumption: both motion effect callbacks run on the same thread.
        var horizontal: Float = 0
        var vertical: Float = 0
        let horizontalEffect = HMInterpolatingMotionEffect(type: .TiltAlongHorizontalAxis) { value in
            horizontal = value
            callback(horizontal: horizontal, vertical: vertical)
        }
        let verticalEffect = HMInterpolatingMotionEffect(type: .TiltAlongVerticalAxis) { value in
            vertical = value
            callback(horizontal: horizontal, vertical: vertical)
        }

        motionEffects = [horizontalEffect, verticalEffect]
    }
}
