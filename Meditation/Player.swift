import Foundation
import AVFoundation

class Player: NSObject {
    static let shared = Player()
    static let rateChangeNotificationName = NSNotification.Name("Player.rateChangeNotificationName")

    var playerRateObserverContext = Bool()

    private let player = AVPlayer()

    override init() {
        super.init()
        player.addObserver(self, forKeyPath: #keyPath(AVPlayer.rate), context: &playerRateObserverContext)
    }

    func play() {
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.playback, mode: .default)
            player.play()
        } catch {

        }
    }

    func pause() {
        player.pause()
    }

    func load(url: URL) {
        player.pause()
        player.replaceCurrentItem(with: AVPlayerItem(url: url))
    }

    var isPlaying: Bool {
        player.rate != 0
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(AVPlayer.rate) {
            NotificationCenter.default.post(name: Player.rateChangeNotificationName, object: self)
        }
    }

    var currentTime: TimeInterval {
        return player.currentTime().seconds
    }

    var duration: TimeInterval {
        return player.currentItem!.duration.seconds
    }

    func seek(to seconds: TimeInterval) {
        player.currentItem!.seek(to: CMTime(seconds: seconds, preferredTimescale: player.currentItem!.duration.timescale), completionHandler: nil)
    }
}
