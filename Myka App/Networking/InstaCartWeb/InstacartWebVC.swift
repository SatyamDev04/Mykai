import UIKit
import SafariServices
import WebKit
import PDFKit
import Photos
import SwiftSoup
final class InstacartContainerVC: UIViewController, WKNavigationDelegate, WKUIDelegate {

    // MARK: - UI
    private let header = UIView()
    private let footer = UIView()
    private let titleLabel = UILabel()
    private let backButton = UIButton(type: .system)
    private let backButtonFooter = UIButton(type: .system)
    private let reloadButton = UIButton(type: .system)
     var backButtonTapped: (() -> Void)?
    private let webView: WKWebView = {
      
        let cfg = WKWebViewConfiguration()
        cfg.websiteDataStore = .default()
        cfg.defaultWebpagePreferences.preferredContentMode = .mobile

        let wv = WKWebView(frame: .zero, configuration: cfg)
        wv.scrollView.contentInsetAdjustmentBehavior = .never
        wv.allowsBackForwardNavigationGestures = true
        return wv
    }()

    // Footer buttons
    let scanButtonStack = {
        let scanButtonStack = UIStackView()
        scanButtonStack.axis = .vertical
        scanButtonStack.alignment = .center
        scanButtonStack.spacing = 6
        scanButtonStack.isUserInteractionEnabled = true
        scanButtonStack.translatesAutoresizingMaskIntoConstraints = false
        return scanButtonStack
    }()
  
    let scanImageView = {
        let scanImageView = UIImageView(image: UIImage(systemName: "barcode.viewfinder"))
        scanImageView.contentMode = .scaleAspectFit
        scanImageView.tintColor = .black
        return scanImageView
    }()
    
    let scanLabel = {
        let scanLabel = UILabel()
        scanLabel.text = "Scan basket To Calculate"
        scanLabel.font = .systemFont(ofSize: 14, weight: .medium)
        scanLabel.textAlignment = .center
        return scanLabel
    }()
    
    private let compareButton = UIButton(type: .system)
    private let nextButton = UIButton(type: .system)
    var urlString = ""
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        setupHeader()
        setupFooter()
        setupWebView()
        layoutUI()

        webView.navigationDelegate = self
        webView.uiDelegate = self
        loadInstacart()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        navigationItem.largeTitleDisplayMode = .never
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    // MARK: - Setup
    private func setupHeader() {
        header.backgroundColor = .systemBackground
        header.layer.shadowColor = UIColor.black.cgColor
        header.layer.shadowOpacity = 0.08
        header.layer.shadowRadius = 6
        header.layer.shadowOffset = CGSize(width: 0, height: 2)

        backButton.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        backButton.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)
        backButton.tintColor = .black
        titleLabel.text = "instacart.com"
        titleLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        titleLabel.textAlignment = .center

        reloadButton.setImage(UIImage(systemName: "arrow.clockwise"), for: .normal)
        reloadButton.addTarget(self, action: #selector(didTapReload), for: .touchUpInside)
        
        reloadButton.tintColor = .black
        header.addSubview(backButton)
        header.addSubview(titleLabel)
        header.addSubview(reloadButton)
    }

    private func setupFooter() {
        footer.backgroundColor = .secondarySystemBackground
        footer.layer.shadowColor = UIColor.black.cgColor
        footer.layer.shadowOpacity = 0.08
        footer.layer.shadowRadius = 6
        footer.layer.shadowOffset = CGSize(width: 0, height: -2)
        
        backButtonFooter.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        backButtonFooter.tintColor = .black
        backButtonFooter.layer.cornerRadius = 12
        backButtonFooter.addTarget(self, action: #selector(didTapBackFooter), for: .touchUpInside)
        scanButtonStack.addArrangedSubview(scanImageView)
        scanButtonStack.addArrangedSubview(scanLabel)
        footer.addSubview(scanButtonStack)
        footer.addSubview(compareButton)
        footer.addSubview(nextButton)
        // Scan
        

   
        // Next
        nextButton.setImage(UIImage(systemName: "chevron.forward"), for: .normal)
       nextButton.tintColor = .black
        nextButton.layer.cornerRadius = 12
        nextButton.addTarget(self, action: #selector(didTapNext), for: .touchUpInside)
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapScan))
        scanButtonStack.addGestureRecognizer(tap)
        
        footer.addSubview(scanButtonStack)
        footer.addSubview(backButtonFooter)
        footer.addSubview(nextButton)
    }

    private func setupWebView() {
        // no-op; webview already configured
    }

    private func loadInstacart() {
        if let url = URL(string: urlString) {
            webView.load(URLRequest(url: url))
        }
    }

    // MARK: - Layout
    private func layoutUI() {
        [header, webView, footer].forEach { v in
             v.translatesAutoresizingMaskIntoConstraints = false
             view.addSubview(v)
         }

         // IMPORTANT: disable autoresizing for header subviews
         backButton.translatesAutoresizingMaskIntoConstraints = false
         reloadButton.translatesAutoresizingMaskIntoConstraints = false
         titleLabel.translatesAutoresizingMaskIntoConstraints = false

         let headerHeight: CGFloat = 56
         let footerHeight: CGFloat = 88

         NSLayoutConstraint.activate([
             header.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
             header.leadingAnchor.constraint(equalTo: view.leadingAnchor),
             header.trailingAnchor.constraint(equalTo: view.trailingAnchor),
             header.heightAnchor.constraint(equalToConstant: headerHeight),

             backButton.leadingAnchor.constraint(equalTo: header.leadingAnchor, constant: 12),
             backButton.centerYAnchor.constraint(equalTo: header.centerYAnchor),
             backButton.widthAnchor.constraint(equalToConstant: 32),
             backButton.heightAnchor.constraint(equalToConstant: 32),

             reloadButton.trailingAnchor.constraint(equalTo: header.trailingAnchor, constant: -12),
             reloadButton.centerYAnchor.constraint(equalTo: header.centerYAnchor),
             reloadButton.widthAnchor.constraint(equalToConstant: 32),
             reloadButton.heightAnchor.constraint(equalToConstant: 32),

             titleLabel.centerXAnchor.constraint(equalTo: header.centerXAnchor),
             titleLabel.centerYAnchor.constraint(equalTo: header.centerYAnchor),

             footer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
             footer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
             footer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
             footer.heightAnchor.constraint(equalToConstant: footerHeight),

             webView.topAnchor.constraint(equalTo: header.bottomAnchor),
             webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
             webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
             webView.bottomAnchor.constraint(equalTo: footer.topAnchor)
         ])

         // IMPORTANT: disable autoresizing for header subviews
         backButton.translatesAutoresizingMaskIntoConstraints = false
         reloadButton.translatesAutoresizingMaskIntoConstraints = false
         titleLabel.translatesAutoresizingMaskIntoConstraints = false
         scanButtonStack.setInteraction(false)
         

         NSLayoutConstraint.activate([
             header.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
             header.leadingAnchor.constraint(equalTo: view.leadingAnchor),
             header.trailingAnchor.constraint(equalTo: view.trailingAnchor),
             header.heightAnchor.constraint(equalToConstant: headerHeight),

             backButton.leadingAnchor.constraint(equalTo: header.leadingAnchor, constant: 12),
             backButton.centerYAnchor.constraint(equalTo: header.centerYAnchor),
             backButton.widthAnchor.constraint(equalToConstant: 32),
             backButton.heightAnchor.constraint(equalToConstant: 32),

             reloadButton.trailingAnchor.constraint(equalTo: header.trailingAnchor, constant: -12),
             reloadButton.centerYAnchor.constraint(equalTo: header.centerYAnchor),
             reloadButton.widthAnchor.constraint(equalToConstant: 32),
             reloadButton.heightAnchor.constraint(equalToConstant: 32),

             titleLabel.centerXAnchor.constraint(equalTo: header.centerXAnchor),
             titleLabel.centerYAnchor.constraint(equalTo: header.centerYAnchor),

             footer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
             footer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
             footer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
             footer.heightAnchor.constraint(equalToConstant: footerHeight),

             webView.topAnchor.constraint(equalTo: header.bottomAnchor),
             webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
             webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
             webView.bottomAnchor.constraint(equalTo: footer.topAnchor)
         ])

        // Footer subviews


        [backButtonFooter, scanButtonStack, nextButton].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

        NSLayoutConstraint.activate([
            // Left two icon buttons
            backButtonFooter.leadingAnchor.constraint(equalTo: footer.leadingAnchor, constant: 16),
            backButtonFooter.centerYAnchor.constraint(equalTo: footer.centerYAnchor),
            backButtonFooter.widthAnchor.constraint(equalToConstant: 32),

            scanButtonStack.centerXAnchor.constraint(equalTo: footer.centerXAnchor),
            scanButtonStack.centerYAnchor.constraint(equalTo: footer.centerYAnchor),
    
            // Primary action
            nextButton.trailingAnchor.constraint(equalTo: footer.trailingAnchor, constant: -16),
            nextButton.centerYAnchor.constraint(equalTo: footer.centerYAnchor),
            nextButton.heightAnchor.constraint(equalToConstant: 44),
            nextButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 32)
        ])
    }

    // MARK: - Actions
    @objc private func didTapBack() {
        if webView.canGoBack {
            webView.goBack()
        } else {
            navigationController?.popViewController(animated: true)
            backButtonTapped?()
        }
    }
    @objc private func didTapBackFooter() {
        if webView.canGoBack {
            webView.goBack()
        }
    }

    @objc private func didTapReload() {
        if webView.url != nil { webView.reload() }
        else { loadInstacart() }
    }

    @objc private func didTapScan() {
        // TODO: hook up your scanner
        self.didTapShare()
    }

    @objc private func didTapCompare() {
        // TODO: open your compare flow
        toast("Compare tapped")
    }

    @objc private func didTapNext() {
        if webView.canGoForward {
               webView.goForward()
           }
       
    }

    // MARK: - WKNavigationDelegate (optional extras)
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        titleLabel.text = "instacart.com"
        scanButtonStack.setInteraction(true)
    }
    
    func webView(_ webView: WKWebView,
                 createWebViewWith configuration: WKWebViewConfiguration,
                 for navigationAction: WKNavigationAction,
                 windowFeatures: WKWindowFeatures) -> WKWebView? {

        guard let url = navigationAction.request.url else { return nil }

        // Google / Facebook popup
        UIApplication.shared.open(url)
       
        return nil
    }


    // MARK: - Helpers
    private func toast(_ msg: String) {
        let alert = UIAlertController(title: nil, message: msg, preferredStyle: .alert)
        present(alert, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) { [weak alert] in alert?.dismiss(animated: true) }
    }
    // MARK: - Share (Full-page capture)
     private func didTapShare() {
         showIndicator(withTitle: "", and: "")
         
         getHtmlFromWebView()
//         webView.createPDF(configuration: WKPDFConfiguration()) { [weak self] result in
//                guard let self else {
//                    self?.hideIndicator()
//                    return }
//                switch result {
//                case .success(let data):
//                    guard let url = self.writeTemp(data, name: "instacart-full.pdf") else {
//                        self.hideIndicator()
//                        return}
//                    
//                    guard let image = drawPDFfromURL(url: url, scale: 3.0) else {
//                        self.hideIndicator()
//                        return }
//                    self.scanAndCalculate(selectedImage: image)
//                    self.hideIndicator()
//                case .failure(let err):
//                    print("PDF error:", err)
//                    self.hideIndicator()
//                }
//            }
          
         }
    
    func scanAndCalculate(selectedImage:UIImage){
        
    
        let str = """
        Perform OCR on the image.

        Rules (STRICT):
        - Read ONLY numbers that represent actual prices paid.
        - IGNORE any numbers that are:
          - Struck-through
          - Discounted-from / original / crossed prices
          - Per-unit prices (e.g. "$2.99 / lb", "$1.50 each", "$/kg")
          - Weights, quantities, dates, barcodes, percentages, or taxes per unit
          - Savings, discounts, coupons, or comparisons
        - If both an original price and a discounted price are shown, select ONLY the discounted (final paid) price.
        - Do NOT include prices next to units like "lb", "kg", "oz", "each", "/", or "per".
        - Prefer totals labeled as: TOTAL, GRAND TOTAL, PAYABLE AMOUNT.
        - If multiple totals exist, choose the highest clearly labeled final amount.
        - If final total is not clearly visible, return null.

        Output requirements:
        - Return ONLY valid JSON
        - No markdown
        - No explanations
        - No extra text

        Expected JSON format:
        {
          "detected_prices": [number],
          "final_total": number | null,
          "confidence": "high | medium | low"
        }
        """
        GeminiAPIClient.shared.sendImageWithPrompt(
            apiKey: "AIzaSyBcdGXiuAiemsKObg1le0we5SI8XuSY0s8",
            image: selectedImage,
            prompt: str
        ) { result in

            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    let text = response
                    if let value = Double(text) {
                        print(String(format: "%.2f", value))
                        self.scanLabel.text = ("TOTAL: \(String(format: "%.2f", value))")
                    }
                 
                   
                case .failure(let error):
                    print("Gemini Error:", error.localizedDescription)
                }
            }
        }
    }
    
    
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {

        guard let url = navigationAction.request.url else {
            decisionHandler(.allow)
            return
        }
        let absolute = url.absoluteString.lowercased()
          if absolute.contains("google.com/recaptcha") {
           
              if let url = URL(string: urlString) {
                  UIApplication.shared.open(url)
                  self.navigationController?.popViewController(animated: false)
                  backButtonTapped?()
                  decisionHandler(.cancel)
              }
              return
          }
        let authDomains = [
            "accounts.google.com",
            "facebook.com",
            "fb.com",
            "login",
                "signin",
                "sign-in",
                "auth",
                "accounts"
        ]

        if authDomains.contains(where: { url.host?.contains($0) == true }) {

            // Open in Safari
            UIApplication.shared.open(url)
            decisionHandler(.cancel)
            return
        }

        decisionHandler(.allow)
    }
    private func openInSafariVC(_ url: URL) {
        let safariVC = SFSafariViewController(url: url)
        safariVC.modalPresentationStyle = .pageSheet
        present(safariVC, animated: true)
    }
    
    func getHtmlFromWebView() {
        webView.evaluateJavaScript("(function() { return document.documentElement.outerHTML; })();") { result, error in
            
            if let error = error {
                print("JS Error:", error.localizedDescription)
                return
            }
            
            guard var html = result as? String else {
                print("No HTML returned")
                return
            }
            
            // 1️⃣ Clean HTML
            html = html
                .replacingOccurrences(of: "\\u003C", with: "<")
                .replacingOccurrences(of: "\\n", with: "\n")
                .replacingOccurrences(of: "\\\"", with: "\"")
            
            // 2️⃣ Remove <script> and <style> tags
            html = html.replacingOccurrences(
                of: "<script[\\s\\S]*?</script>",
                with: "",
                options: .regularExpression
            )
            
            html = html.replacingOccurrences(
                of: "<style[\\s\\S]*?</style>",
                with: "",
                options: .regularExpression
            )
            
            // 3️⃣ Remove HTML comments
            html = html.replacingOccurrences(
                of: "<!--.*?-->",
                with: "",
                options: .regularExpression
            )
            
            print("***HTML:", html)
            
            // Example: You can now parse prices here
            let (prices, total) = self.extractAllPricesAndTotal(html: html)
            
            prices.forEach { print("PRICE:", $0) }
            print("TOTAL:",total )
            
            DispatchQueue.main.async {
                self.scanLabel.text = ("TOTAL:\(total)")
                self.hideIndicator()
            }
        }
    }
  

    private func extractAllPricesAndTotal(html: String) -> ([Double], String) {
        var prices = [Double]()
        
        do {
            let document = try SwiftSoup.parse(html)
            let parents = try document.select("span.e-gx2pr0")
            
            for parent in parents.array() {
                let mainValue = try parent.select("span.e-1qkvt8e").first()?.text() ?? ""
                let currencySpans = try parent.select("span.e-p745l")
                
                var decimal = ""
                if currencySpans.size() > 1 {
                    decimal = try currencySpans.last()?.text() ?? ""
                }
                
                let priceString: String
                if !decimal.isEmpty {
                    priceString = "\(mainValue).\(decimal)"
                } else {
                    priceString = mainValue
                }
                
                if let price = Double(priceString) {
                    prices.append(price)
                }
            }
            
        } catch {
            print("SwiftSoup parsing error:", error)
        }
        
        let total = prices.reduce(0, +)
        let formattedTotal = String(format: "%.2f", total)
        
        return (prices, formattedTotal)
    }
    
    
    func savePDFToPhotos(from url: URL, scale: CGFloat = 3.0, completion: @escaping (Bool, Error?) -> Void) {
        guard let image = drawPDFfromURL(url: url, scale: scale) else {
            completion(false, NSError(domain: "PDFError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to create image from PDF"]))
            return
        }
        
        PHPhotoLibrary.requestAuthorization { status in
            guard status == .authorized else {
                completion(false, NSError(domain: "PhotoLibraryError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Photo library access denied"]))
                return
            }
            
            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.creationRequestForAsset(from: image)
            }) { success, error in
                DispatchQueue.main.async {
                    completion(success, error)
                }
            }
        }
    }
    
    func drawPDFfromURL(url: URL, scale: CGFloat = 3.0) -> UIImage? {
        guard let document = CGPDFDocument(url as CFURL) else { return nil }
        guard let page = document.page(at: 1) else { return nil }

        let pageRect = page.getBoxRect(.mediaBox)
        let scaledSize = CGSize(width: pageRect.width * scale, height: pageRect.height * scale)
        
        let renderer = UIGraphicsImageRenderer(size: scaledSize)
        let img = renderer.image { ctx in
            UIColor.white.set()
            ctx.fill(CGRect(origin: .zero, size: scaledSize))
            
            ctx.cgContext.translateBy(x: 0.0, y: scaledSize.height)
            ctx.cgContext.scaleBy(x: scale, y: -scale)
            
            // High-quality rendering settings
            ctx.cgContext.setAllowsAntialiasing(true)
            ctx.cgContext.setShouldAntialias(true)
            ctx.cgContext.interpolationQuality = .high
            
            ctx.cgContext.drawPDFPage(page)
        }

        return img
    }


    
    private func writeTemp(_ data: Data, name: String) -> URL? {
        let url = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(name)
        do { try data.write(to: url, options: .atomic); return url } catch { return nil }
    }
    
}


extension UIView {
    func setInteraction(_ enabled: Bool, fadeTo alphaValue: CGFloat = 0.4) {
        isUserInteractionEnabled = enabled
        UIView.animate(withDuration: 0.2) {
            self.alpha = enabled ? 1.0 : alphaValue
        }
    }
}
