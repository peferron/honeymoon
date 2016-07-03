import AVFoundation

public class HMMusic {
    static var player: AVAudioPlayer?

    public static func play(filename: String, numberOfLoops: Int = -1) {
        let url = NSBundle.mainBundle().URLForResource((filename as NSString).stringByDeletingPathExtension, withExtension: (filename as NSString).pathExtension)!
        let player = try! AVAudioPlayer(contentsOfURL: url)
        player.numberOfLoops = numberOfLoops
        player.play()
    }

    public static func stop() {
        player?.stop()
        player = nil
    }
}
