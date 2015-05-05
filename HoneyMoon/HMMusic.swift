import AVFoundation

public class HMMusic {
    static var player: AVAudioPlayer?

    public static func play(filename: String, numberOfLoops: Int = -1) {
        let url = NSBundle.mainBundle().URLForResource(filename.stringByDeletingPathExtension, withExtension: filename.pathExtension)!
        var error: NSError?
        player = AVAudioPlayer(contentsOfURL: url, error: &error)
        player!.numberOfLoops = numberOfLoops
        player!.play()
    }

    public static func stop() {
        player?.stop()
        player = nil
    }
}
