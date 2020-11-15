import UIKit
import WebKit

class WebViewController: UIViewController {

    let webView: WKWebView = {
        let config = WKWebViewConfiguration()
        config.suppressesIncrementalRendering = true
        config.allowsInlineMediaPlayback = true
        let webView = WKWebView(frame: .zero, configuration: config)
        return webView
    }()

    // MARK: - View Lifecycles

    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        addWebView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: - Setup Subviews
extension WebViewController {
    private func addWebView() {
        view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}
