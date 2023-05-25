import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var tabStack: UIStackView!
    @IBOutlet weak var collectionView: UICollectionView!

    private var selectedTabButton: TabButton?
    private let tabButtons = tabs.map { TabButton(title: $0.title) }
    private let timeFormatter = DateComponentsFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()
        tabStack.arrangedSubviews.forEach {
            tabStack.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }

        tabButtons.forEach { button in
            tabStack.addArrangedSubview(button)
            button.setContentCompressionResistancePriority(.required, for: .horizontal)
            button.setContentCompressionResistancePriority(.required, for: .vertical)
            button.onTap(tabButtonDidTap(button:))
        }

        selectedTabButton = tabButtons[0]
        tabButtons[0].selected = true

        collectionView.dataSource = self
        collectionView.collectionViewLayout = trackCollectionLayout
    }

    func tabButtonDidTap(button: TabButton) {
        selectedTabButton?.selected = false
        selectedTabButton = button
        button.selected = true
        collectionView.reloadData()
    }

    var currentTab: Tab {
        return tabs[tabButtons.firstIndex(of: selectedTabButton!)!]
    }

    // MARK: - collection view data source
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentTab.songs.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "track", for: indexPath) as! TrackCollectionViewCell

        let song = currentTab.songs[indexPath.row]
        cell.titleLabel.text = song.title
        cell.durationLabel.text = timeFormatter.string(from: song.duration)
        cell.imageView.image = UIImage(data: try! Data(contentsOf: song.artworkURL))
        return cell
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controlVC = segue.destination as? ControlViewController {
            controlVC.song = currentTab.songs[collectionView.indexPathsForSelectedItems![0].row]
            segue.destination.sheetPresentationController?.prefersGrabberVisible = true
        }
    }
}

let trackCollectionLayout: UICollectionViewCompositionalLayout = {
    let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .estimated(1))
    let item = NSCollectionLayoutItem(layoutSize: size)
    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(1))
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 2)
    let section = NSCollectionLayoutSection(group: group)
    return UICollectionViewCompositionalLayout(section: section)
}()
