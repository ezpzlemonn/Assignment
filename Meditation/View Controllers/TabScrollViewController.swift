import UIKit

class TabBarViewController: UIViewController {
    private let scrollView = UIScrollView()
    private var tabButtons: [TabButton] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        setupScrollView()
        setupTabs()
    }

    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }

    private func setupTabs() {
        var previousButton: TabButton?

        for tab in tabs {
            let button = TabButton(title: tab.title)
            scrollView.addSubview(button)
            tabButtons.append(button)

            button.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                button.topAnchor.constraint(equalTo: scrollView.topAnchor),
                button.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
                button.widthAnchor.constraint(equalToConstant: 100)
            ])

            if let previousButton = previousButton {
                button.leadingAnchor.constraint(equalTo: previousButton.trailingAnchor).isActive = true
            } else {
                button.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
            }

            previousButton = button
        }

        if let previousButton = previousButton {
            scrollView.trailingAnchor.constraint(equalTo: previousButton.trailingAnchor).isActive = true
        }
    }
}
