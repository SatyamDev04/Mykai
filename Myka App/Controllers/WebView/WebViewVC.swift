
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
        self.ImportToRecimeBtnO.isUserInteractionEnabled = false
        self.ImportToRecimeBtnO.backgroundColor = #colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5){
            self.ImportToRecimeBtnO.isUserInteractionEnabled = true
            self.ImportToRecimeBtnO.backgroundColor = #colorLiteral(red: 0.02352941176, green: 0.7568627451, blue: 0.4117647059, alpha: 1)
        }
        
        
        webView = WKWebView(frame: self.webV.bounds)
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        webView.navigationDelegate = self
        webView.uiDelegate = self
        self.webV.addSubview(webView)
        
        if let url = URL(string: WebUrl) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
        setupSwipeGestures()
    }
    
    
    private func setupSwipeGestures() {
        
            let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
            swipeRight.direction = .right
            self.webView.addGestureRecognizer(swipeRight)
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
        print("url:", self.urlString ?? "")
        self.backAction(self.urlString ?? "")
        self.navigationController?.popViewController(animated: true)
    }
 
   
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if navigationAction.navigationType == .linkActivated,
           let clickedURL = navigationAction.request.url?.absoluteString {
            print("User clicked on URL: \(clickedURL)")
            self.urlString = clickedURL
            self.ImportToRecimeBtnO.isUserInteractionEnabled = true
            self.ImportToRecimeBtnO.backgroundColor = #colorLiteral(red: 0.02352941176, green: 0.7568627451, blue: 0.4117647059, alpha: 1)
        }
        decisionHandler(.allow)
    }
 
}
