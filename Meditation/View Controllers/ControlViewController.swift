import UIKit
import MediaPlayer

class ControlViewController: UIViewController {
    private static var lastSong: Song?

    var song: Song! {
        didSet {
            shouldLoad = Self.lastSong?.url != song.url
            Self.lastSong = song
        }
    }
    private var shouldLoad = true

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var systemVolumeContainer: UIStackView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var seekSlider: UISlider!

    private static let playImage = "play.fill"
    private static let pauseImage = "pause.fill"

    private weak var refreshTimer: Timer?
    private var dragging = false

    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = UIImage(data: try! Data(contentsOf: song.artworkURL))
        titleLabel.text = song.title
        NotificationCenter.default.addObserver(self, selector: #selector(rateDidChange), name: Player.rateChangeNotificationName, object: Player.shared)
        if shouldLoad {
            Player.shared.load(url: song.url)
            Player.shared.play()
        }

        let volumeView = MPVolumeView()
        systemVolumeContainer.arrangedSubviews[1].removeFromSuperview()
        systemVolumeContainer.insertArrangedSubview(volumeView, at: 1)

        seekSlider.addTarget(self, action: #selector(sliderDidChange), for: [.touchUpInside, .touchUpOutside])
        seekSlider.addTarget(self, action: #selector(sliderDidDrag), for: [.touchDragInside, .touchDragOutside])
        seekSlider.addTarget(self, action: #selector(draggingDidStop), for: [.touchCancel])
        refreshTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [self] _ in
            if !dragging {
                updateSeekSlider()
            }
        })
        updatePlayButton()
        updateSeekSlider()
    }

    @IBAction func playDidTap() {
        if Player.shared.isPlaying {
            Player.shared.pause()
        } else {
            Player.shared.play()
        }
    }

    private func updateSeekSlider() {
        let currentValue = Player.shared.currentTime / Player.shared.duration
        seekSlider.setValue(Float(currentValue), animated: false)
    }

    private func updatePlayButton() {
        playButton.setImage(UIImage(systemName: Player.shared.isPlaying ? Self.pauseImage : Self.playImage), for: .normal)
    }

    @objc
    private func rateDidChange() {
        updatePlayButton()
    }

    @objc
    private func sliderDidChange() {
        draggingDidStop()
        Player.shared.seek(to: Double(seekSlider.value) * Player.shared.duration)
    }

    @objc
    private func sliderDidDrag() {
        dragging = true
    }

    @objc
    private func draggingDidStop() {
        dragging = false
    }
}
