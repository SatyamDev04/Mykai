//
//  ImportedRecipeWebViewVC.swift
//  My Kai
//
//  Created by YATIN  KALRA on 24/09/25.
//

import UIKit
import WebKit

class ImportedRecipeWebViewVC: UIViewController, WKNavigationDelegate, WKUIDelegate {

    @IBOutlet weak var webV: UIView!
    
    var WebUrl = ""
    var urlString: String?
    var webView: WKWebView!
    
    var backAction:(_ tapOn: String)->() = {_ in}
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.urlString = WebUrl
        // Setup Buttons
//        self.ImportToRecimeBtnO.isUserInteractionEnabled = false
//        self.ImportToRecimeBtnO.backgroundColor = #colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
//        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5){
//            self.ImportToRecimeBtnO.isUserInteractionEnabled = true
//            self.ImportToRecimeBtnO.backgroundColor = #colorLiteral(red: 0.02352941176, green: 0.7568627451, blue: 0.4117647059, alpha: 1) // Enable button
//        }
        
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
        setupToolbar()
    }
    
    @IBAction func backBtnTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func ingreridientTap(_ sender: UIButton) {
        backAction("Ing")
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cookwareTap(_ sender: UIButton) {
        backAction("Cook")
        self.navigationController?.popViewController(animated: true)
    }
    
    // WKNavigationDelegate method to capture the clicked URL
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if navigationAction.navigationType == .linkActivated, // Check if it's a user-initiated action
           let clickedURL = navigationAction.request.url?.absoluteString {
            print("User clicked on URL: \(clickedURL)")
            self.urlString = clickedURL
//            self.ImportToRecimeBtnO.isUserInteractionEnabled = true
//            self.ImportToRecimeBtnO.backgroundColor = #colorLiteral(red: 0.02352941176, green: 0.7568627451, blue: 0.4117647059, alpha: 1)
        }
        
        // Allow the navigation to proceed
        decisionHandler(.allow)
    }
 
    private func setupToolbar() {
            let toolbar = UIToolbar()
            view.addSubview(toolbar)
            toolbar.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                toolbar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                toolbar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                toolbar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
                toolbar.heightAnchor.constraint(equalToConstant: 44)
            ])
            
            // Buttons
            let safariBtn = UIBarButtonItem(image: UIImage(systemName: "safari"), style: .plain, target: self, action: #selector(openInSafari))
            let backBtn = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(goBack))
            let forwardBtn = UIBarButtonItem(image: UIImage(systemName: "chevron.right"), style: .plain, target: self, action: #selector(goForward))
            let shareBtn = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(shareLink))
            
            let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            
            toolbar.setItems([safariBtn, flexibleSpace, backBtn, flexibleSpace, forwardBtn, flexibleSpace, shareBtn], animated: false)
        }

    
       @objc private func openInSafari() {
           if let url = webView.url {
               UIApplication.shared.open(url)
           }
       }
       
       @objc private func goBack() {
           if webView.canGoBack {
               webView.goBack()
           }
       }
       
       @objc private func goForward() {
           if webView.canGoForward {
               webView.goForward()
           }
       }
       
       @objc private func shareLink() {
           if let url = webView.url {
               let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
               present(activityVC, animated: true)
           }
       }

}
