
import UIKit
@preconcurrency import WebKit

class WebViewVC: UIViewController, WKNavigationDelegate, WKUIDelegate {

    @IBOutlet weak var webV: UIView!
    @IBOutlet weak var ImportToRecimeBtnO: UIButton!

    
    var WebUrl = ""
    var urlString: String?
    var webView: WKWebView!
    
    var backAction:(_ url: String)->() = {_ in}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.urlString = WebUrl
        // Setup Buttons
        self.ImportToRecimeBtnO.isUserInteractionEnabled = false
        self.ImportToRecimeBtnO.backgroundColor = #colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5){
            self.ImportToRecimeBtnO.isUserInteractionEnabled = true
            self.ImportToRecimeBtnO.backgroundColor = #colorLiteral(red: 0.02352941176, green: 0.7568627451, blue: 0.4117647059, alpha: 1) // Enable button
        }
        
        // Initialize WebView
        webView = WKWebView(frame: self.webV.bounds)
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        webView.navigationDelegate = self
        webView.uiDelegate = self
        self.webV.addSubview(webView)
        
        // Load Initial URL
        if let url = URL(string: WebUrl) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
        
        setupSwipeGestures()
        
        // Add observers to track progress and updates
     //   webView.addObserver(self, forKeyPath: #keyPath(WKWebView.url), options: .new, context: nil)
    }
    
//    deinit {
//        // Remove observers
//        webView.removeObserver(self, forKeyPath: #keyPath(WKWebView.url))
//    }
    
//    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//     if keyPath == "URL" {
//            urlString = webView.url?.absoluteString
//            //urlLabel.text = urlString
//            self.ImportToRecimeBtnO.isUserInteractionEnabled = true
//            self.ImportToRecimeBtnO.backgroundColor = #colorLiteral(red: 0.02352941176, green: 0.7568627451, blue: 0.4117647059, alpha: 1) // Enable button
//        }
//    }
    
    
    private func setupSwipeGestures() {
            // Swipe right to go back
            let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
            swipeRight.direction = .right
            self.webView.addGestureRecognizer(swipeRight)
            
            // Swipe left to go forward
            let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
            swipeLeft.direction = .left
            self.webView.addGestureRecognizer(swipeLeft)
        }
        
        @objc private func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
            if gesture.direction == .right {
                if webView.canGoBack {
                    webView.goBack()
                }
            } else if gesture.direction == .left {
                if webView.canGoForward {
                    webView.goForward()
                }
            }
        }
    
    @IBAction func BackBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
  
    @IBAction func ImportToRecimeBtn(_ sender: UIButton) {
        //self.showToast(self.urlString ?? "")
        print("url:", self.urlString ?? "")
        
        self.backAction(self.urlString ?? "")
        self.navigationController?.popViewController(animated: true)
    }
 
    // WKNavigationDelegate method to capture the clicked URL
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if navigationAction.navigationType == .linkActivated, // Check if it's a user-initiated action
           let clickedURL = navigationAction.request.url?.absoluteString {
            print("User clicked on URL: \(clickedURL)")
            self.urlString = clickedURL
            self.ImportToRecimeBtnO.isUserInteractionEnabled = true
            self.ImportToRecimeBtnO.backgroundColor = #colorLiteral(red: 0.02352941176, green: 0.7568627451, blue: 0.4117647059, alpha: 1)
        }
        
        // Allow the navigation to proceed
        decisionHandler(.allow)
    }
 
}
