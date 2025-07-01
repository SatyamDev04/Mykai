//
//  TrackingVC.swift
//  My Kai
//
//  Created by YES IT Labs on 25/04/25.
//

import UIKit

@preconcurrency import WebKit

class TrackingVC: UIViewController , WKNavigationDelegate, WKUIDelegate {
    
    @IBOutlet weak var webV: UIView!
    
    var WebUrl = ""
    
    var webView: WKWebView!
    
    var comesfrom = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    }
    
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
        if comesfrom == "OrderHistory"{
            self.navigationController?.popViewController(animated: true)
        }else{
            let storyboard = UIStoryboard(name: "Profile", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "OrderHistoryVC") as! OrderHistoryVC
            vc.comesfrom = comesfrom
            self.navigationController?.pushViewController(vc, animated: true)
//            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
}
 
