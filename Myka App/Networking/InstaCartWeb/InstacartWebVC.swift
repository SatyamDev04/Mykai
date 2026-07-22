import UIKit
import SafariServices
import WebKit
import PDFKit
import Photos
import SwiftSoup

final class InstacartContainerVC: UIViewController, WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler {

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
        cfg.preferences.javaScriptCanOpenWindowsAutomatically = true
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
        scanButtonStack.spacing = 3
        scanButtonStack.isUserInteractionEnabled = true
        scanButtonStack.translatesAutoresizingMaskIntoConstraints = false
        return scanButtonStack
    }()
  
    let scanImageView = {
        let scanImageView = UIImageView(image: UIImage(named: "basket"))
        scanImageView.contentMode = .scaleAspectFit
        scanImageView.tintColor = .black
        return scanImageView
    }()
    
    let scanLabel = {
        let scanLabel = UILabel()
        scanLabel.text = "Scan basket for total"
        scanLabel.font = .systemFont(ofSize: 14, weight: .medium)
        scanLabel.textAlignment = .center
        return scanLabel
    }()
    
    private let compareButton = UIButton(type: .system)
    private let nextButton = UIButton(type: .system)
    var urlString = ""
    private var popupWebView: WKWebView?
    private var lastExternalOpen: (url: String, date: Date)?
    private let authMessageHandlerName = "instacartAuthTap"
    private let basketTotalMessageHandlerName = "instacartBasketTotal"
    private var hasStartedBasketAutoCalculation = false
    
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
        configureAuthTapDetection()
        configureBasketTotalObservation()
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
        footer.backgroundColor = .white
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

    private func configureAuthTapDetection() {
        
        let controller = webView.configuration.userContentController
        controller.removeScriptMessageHandler(forName: authMessageHandlerName)
        controller.add(self, name: authMessageHandlerName)

        let script = """
        (function() {
          if (window.__instacartAuthTapInstalled) { return; }
          window.__instacartAuthTapInstalled = true;

          function normalizedText(value) {
            return (value || '').toLowerCase().replace(/\\s+/g, ' ').trim();
          }

          function matchesAuthIntent(text) {
            if (!text) return false;
            return [
              'log in',
              'login',
              'sign in',
              'signin',
              'continue with google',
              'continue with facebook',
              'continue with apple',
              'continue with email',
              'google',
              'facebook',
              'apple'
            ].some(function(token) { return text.indexOf(token) !== -1; });
          }

          function authProvider(text) {
            if (text.indexOf('google') !== -1 || text.indexOf('accounts.google') !== -1) return 'google';
            if (text.indexOf('facebook') !== -1 || text.indexOf('fb.com') !== -1) return 'facebook';
            if (text.indexOf('apple') !== -1 || text.indexOf('appleid.apple') !== -1) return 'apple';
            return 'unknown';
          }

          function candidateText(candidate) {
            var img = candidate.querySelector && candidate.querySelector('img[alt]');
            return normalizedText([
              candidate.innerText,
              candidate.textContent,
              candidate.value,
              candidate.getAttribute && candidate.getAttribute('aria-label'),
              candidate.getAttribute && candidate.getAttribute('title'),
              candidate.getAttribute && candidate.getAttribute('data-testid'),
              img && img.getAttribute('alt')
            ].filter(Boolean).join(' '));
          }

          document.addEventListener('click', function(event) {
            var element = event.target;
            if (!element) return;

            var candidate = element.closest('a, button, [role="button"], input[type="button"], input[type="submit"], [data-testid], [aria-label]');
            if (!candidate) return;

            var text = candidateText(candidate);
            var href = candidate.href || candidate.getAttribute('href') || '';
            var form = candidate.closest && candidate.closest('form');
            var action = form ? (form.getAttribute('action') || '') : '';
            var combined = normalizedText([text, href, action].join(' '));

            if (!matchesAuthIntent(combined)) {
              return;
            }

            console.log('[InstacartAuthTap]', combined, href, action);
            window.webkit.messageHandlers.\(authMessageHandlerName).postMessage({
              provider: authProvider(combined),
              text: text,
              href: href,
              action: action
            });
          }, true);
        })();
        """

        controller.addUserScript(
            WKUserScript(
                source: script,
                injectionTime: .atDocumentEnd,
                forMainFrameOnly: false
            )
        )
    }

    private func configureBasketTotalObservation() {
        let controller = webView.configuration.userContentController
        controller.removeScriptMessageHandler(forName: basketTotalMessageHandlerName)
        controller.add(self, name: basketTotalMessageHandlerName)

        let script = """
        (function() {
          if (window.__instacartBasketTotalInstalled) { return; }
          window.__instacartBasketTotalInstalled = true;

          var lastPayload = '';
          var timer = null;

          function getPrice(card) {
            var priceText = '';
            var priceElement = card.querySelector('span.screen-reader-only');
            if (priceElement) {
              priceText = priceElement.textContent || '';
            }

            var match = priceText.match(/\\$(\\d+(?:\\.\\d{1,2})?)/);
            return match ? parseFloat(match[1]) || 0 : 0;
          }

          function getQuantity(card) {
            var quantityElement = card.querySelector('span[aria-live=polite] > span:last-child');
            var quantityText = quantityElement ? (quantityElement.textContent || '').trim() : '';
            var quantity = parseInt(quantityText, 10);
            return Number.isFinite(quantity) ? quantity : 1;
          }

          function calculateBasketTotal() {
            var cards = Array.prototype.slice.call(document.querySelectorAll('div[data-testid=ingredient-item-card]'));
            if (!cards.length) { return null; }

            var prices = cards.map(function(card) {
              var selectedIcon = card.querySelector('div[role=button] svg');
              var isSelected = selectedIcon && selectedIcon.getAttribute('aria-hidden') === 'true';
              if (!isSelected) { return 0; }
              return getPrice(card) * getQuantity(card);
            });

            var total = prices.reduce(function(sum, value) { return sum + value; }, 0);
            return {
              prices: prices,
              total: total.toFixed(2)
            };
          }

          function postBasketTotal() {
            var result = calculateBasketTotal();
            if (!result) { return; }

            var payload = JSON.stringify(result);
            if (payload === lastPayload) { return; }

            lastPayload = payload;
            window.webkit.messageHandlers.\(basketTotalMessageHandlerName).postMessage(result);
          }

          function scheduleBasketTotalUpdate() {
            clearTimeout(timer);
            timer = setTimeout(postBasketTotal, 250);
          }

          document.addEventListener('click', scheduleBasketTotalUpdate, true);
          document.addEventListener('input', scheduleBasketTotalUpdate, true);
          document.addEventListener('change', scheduleBasketTotalUpdate, true);

          new MutationObserver(scheduleBasketTotalUpdate).observe(document.documentElement, {
            attributes: true,
            childList: true,
            subtree: true,
            characterData: true,
            attributeFilter: ['aria-hidden', 'aria-live', 'data-testid', 'class']
          });

          scheduleBasketTotalUpdate();
        })();
        """

        controller.addUserScript(
            WKUserScript(
                source: script,
                injectionTime: .atDocumentEnd,
                forMainFrameOnly: false
            )
        )
    }

    private func loadInstacart() {
        if let url = URL(string: urlString) {
            webView.load(URLRequest(url: url))
        }
    }

    deinit {
        closePopupWebView()
        webView.configuration.userContentController.removeScriptMessageHandler(forName: authMessageHandlerName)
        webView.configuration.userContentController.removeScriptMessageHandler(forName: basketTotalMessageHandlerName)
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
         scanButtonStack.setInteraction(true)
         

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
            // DO NOT pop here — let parent controller handle stack replacement
            backButtonTapped?()
        }
    }
    @objc private func didTapBackFooter() {
        if webView.canGoBack {
            webView.goBack()
        }
    }

    @objc private func didTapReload() {
        hasStartedBasketAutoCalculation = false
        if webView.url != nil { webView.reload() }
        else { loadInstacart() }
    }

    @objc private func didTapScan() {
        hasStartedBasketAutoCalculation = true
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
        hasStartedBasketAutoCalculation = false
        scanButtonStack.setInteraction(true)
    }
    
    func webView(_ webView: WKWebView,
                 createWebViewWith configuration: WKWebViewConfiguration,
                 for navigationAction: WKNavigationAction,
                 windowFeatures: WKWindowFeatures) -> WKWebView? {

        logNavigation("POPUP", navigationAction: navigationAction)

        guard let url = navigationAction.request.url else {
            // Some OAuth providers create a blank popup first, then assign location later.
            // Keep that shell hidden and route its first real navigation into the main WebView.
            print("[InstacartWeb] POPUP URL is nil; creating hidden popup shell.")
            closePopupWebView()

            let popup = WKWebView(frame: .zero, configuration: configuration)
            popup.navigationDelegate = self
            popup.uiDelegate = self
            popup.isHidden = true
            popupWebView = popup
            view.addSubview(popup)
            return popup
        }

        handleNavigationURL(url, source: "POPUP")
       
        return nil
    }

    func webViewDidClose(_ webView: WKWebView) {
        if webView === popupWebView {
            closePopupWebView()
        }
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
                        self.scanLabel.text = ("TOTAL : $\(String(format: "%.2f", value))")
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
        
        let isPopupNavigation = webView === popupWebView
        logNavigation(isPopupNavigation ? "POPUP NAV" : "NAV", navigationAction: navigationAction)

        let absolute = url.absoluteString.lowercased()
        if absolute.contains("google.com/recaptcha") {
            decisionHandler(.allow)
            return
        }

        if isPopupNavigation {
            handleNavigationURL(url, source: "POPUP NAV")
            closePopupWebView(webView)
            decisionHandler(.cancel)
            return
        }

        if shouldOpenOutsideWebView(url) {
            openExternalURL(url, source: "NAV")
            decisionHandler(.cancel)
            return
        }

        if shouldOpenSocialAuthInSafari(url) {
            // Do not run Google/Apple/Facebook OAuth inside WKWebView. Hand it to Safari
            // and leave the Instacart cart/checkout WebView state untouched.
            openExternalURL(url, source: "SOCIAL AUTH")
            decisionHandler(.cancel)
            return
        }

        if navigationAction.targetFrame == nil {
            // Non-auth target="_blank" links can stay inside this single visible WebView.
            webView.load(URLRequest(url: url))
            decisionHandler(.cancel)
            return
        }

        if isSocialAuthURL(url) {
            print("[InstacartWeb] AUTH URL detected in WebView:", url.absoluteString)
        }

        decisionHandler(.allow)
    }

    private func closePopupWebView(_ popup: WKWebView? = nil) {
        let popupToClose = popup ?? popupWebView
        popupToClose?.navigationDelegate = nil
        popupToClose?.uiDelegate = nil
        popupToClose?.stopLoading()
        popupToClose?.removeFromSuperview()

        if popupToClose === popupWebView {
            popupWebView = nil
        }
    }

    private func handleNavigationURL(_ url: URL, source: String) {
        if shouldOpenOutsideWebView(url) {
            openExternalURL(url, source: source)
        } else if shouldOpenSocialAuthInSafari(url) {
            openExternalURL(url, source: "\(source) SOCIAL AUTH")
        } else {
            if isSocialAuthURL(url) {
                print("[InstacartWeb] AUTH URL allowed in WebView:", url.absoluteString)
            }
            webView.load(URLRequest(url: url))
        }
    }

    private func openExternalURL(_ url: URL, source: String) {
        let absoluteString = url.absoluteString
        if let lastExternalOpen = lastExternalOpen,
           lastExternalOpen.url == absoluteString,
           Date().timeIntervalSince(lastExternalOpen.date) < 1.5 {
            print("[InstacartWeb] \(source) skipped duplicate external open:", absoluteString)
            return
        }

        lastExternalOpen = (absoluteString, Date())
        print("[InstacartWeb] \(source) opening externally:", url.absoluteString)
        UIApplication.shared.open(url)
    }

    private func logNavigation(_ label: String, navigationAction: WKNavigationAction) {
        let url = navigationAction.request.url
        print("[InstacartWeb] \(label) URL:", url?.absoluteString ?? "nil")
        print("[InstacartWeb] \(label) HOST:", url?.host ?? "")
        print("[InstacartWeb] \(label) TYPE:", navigationAction.navigationType.rawValue)
        print("[InstacartWeb] \(label) TARGET FRAME NIL:", navigationAction.targetFrame == nil)
        print("[InstacartWeb] \(label) MAIN FRAME:", navigationAction.targetFrame?.isMainFrame ?? false)
    }

    private func shouldOpenOutsideWebView(_ url: URL) -> Bool {
        let scheme = url.scheme?.lowercased() ?? ""

        // Native app links and custom schemes cannot be rendered by WKWebView.
        guard scheme == "http" || scheme == "https" || scheme == "about" else {
            return true
        }

        let host = url.host?.lowercased() ?? ""
        return host == "itunes.apple.com" || host == "apps.apple.com"
    }

    private func shouldOpenSocialAuthInSafari(_ url: URL) -> Bool {
        let absolute = url.absoluteString.lowercased()
        let host = url.host?.lowercased() ?? ""

        let isSocialProviderHost =
            host.contains("accounts.google.com") ||
            host.contains("appleid.apple.com") ||
            host.contains("facebook.com") ||
            host.contains("fb.com")

        let hasSocialProviderHint =
            absolute.contains("google") ||
            absolute.contains("facebook") ||
            absolute.contains("fb.com") ||
            absolute.contains("apple")

        let hasAuthFlowHint =
            absolute.contains("oauth") ||
            absolute.contains("authorize") ||
            absolute.contains("continue_with") ||
            absolute.contains("social") ||
            absolute.contains("sso")

        return isSocialProviderHost || (hasSocialProviderHint && hasAuthFlowHint)
    }

    private func isSocialAuthURL(_ url: URL) -> Bool {
        let absolute = url.absoluteString.lowercased()
        let host = url.host?.lowercased() ?? ""

        let isSocialHost =
            host.contains("accounts.google.com") ||
            host.contains("appleid.apple.com") ||
            host.contains("facebook.com") ||
            host.contains("fb.com")

        let isAuthPath =
            absolute.contains("/login") ||
            absolute.contains("/signin") ||
            absolute.contains("sign_in") ||
            absolute.contains("continue_with") ||
            absolute.contains("oauth") ||
            absolute.contains("authorize") ||
            absolute.contains("auth") ||
            absolute.contains("social")

        return isSocialHost || isAuthPath
    }

    private func handleAuthTapMessage(_ body: Any) {
        guard let body = body as? [String: Any] else {
            print("[InstacartWeb] AUTH TAP message body:", body)
            return
        }

        let provider = body["provider"] as? String ?? "unknown"
        let text = body["text"] as? String ?? ""
        let href = body["href"] as? String ?? ""
        let action = body["action"] as? String ?? ""

        print("[InstacartWeb] AUTH TAP provider:", provider)
        print("[InstacartWeb] AUTH TAP text:", text)
        print("[InstacartWeb] AUTH TAP href:", href)
        print("[InstacartWeb] AUTH TAP action:", action)

        let candidateURLString = urlString //!href.isEmpty ? href : action
        if let url = resolvedURL(from: candidateURLString) {
            if text == "google google" || text == "facebook facebook" || text == "apple"/* || shouldOpenSocialAuthInSafari(url)*/ {
                openExternalURL(url, source: "AUTH TAP SOCIAL AUTH")
                backButtonTapped?()
            } else {
                openExternalURL(url, source: "AUTH TAP SOCIAL AUTH")
                backButtonTapped?()
              //  handleNavigationURL(url, source: "AUTH TAP")
            }
        }
        
    }

    private func resolvedURL(from string: String) -> URL? {
        guard !string.isEmpty else { return nil }

        if let url = URL(string: string), url.scheme != nil {
            return url
        }

        return URL(string: string, relativeTo: webView.url)?.absoluteURL
    }

    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == basketTotalMessageHandlerName {
            updateBasketTotal(from: message.body)
            return
        }

        if message.name == authMessageHandlerName {
            handleAuthTapMessage(message.body)
            return
        }
    }

    private func updateBasketTotal(from body: Any) {
        guard hasStartedBasketAutoCalculation else { return }
        guard let body = body as? [String: Any] else { return }

        let total: String
        if let totalText = body["total"] as? String {
            total = totalText
        } else if let totalValue = body["total"] as? Double {
            total = String(format: "%.2f", totalValue)
        } else {
            return
        }

        DispatchQueue.main.async {
            self.scanLabel.text = "TOTAL : $\(total)"
        }
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
            
            let (prices, total) = self.extractAllPricesAndTotalWithStatus(html: html)
            
            prices.forEach { print("PRICE:", $0) }
            print("TOTAL:",total )
            
            DispatchQueue.main.async {
                self.scanLabel.text = ("TOTAL : $\(total)")
                self.hideIndicator()
            }
        }
    }
  

    private func extractAllPricesAndTotalWithStatus(html: String) -> ([Double], String) {
        var pricesList = [Double]()

        do {
            let document = try SwiftSoup.parse(html)
            let cards = try document.select("div[data-testid=ingredient-item-card]")
            let priceRegex = try NSRegularExpression(pattern: "\\$(\\d+(\\.\\d{1,2})?)")

            for card in cards.array() {
                let ariaHidden = try card
                    .select("div[role=button] svg")
                    .first()?
                    .attr("aria-hidden") ?? ""

                let isSelected = ariaHidden == "true"
                var itemTotal = 0.0

                if isSelected {
                    let priceText = try card
                        .select("span.screen-reader-only")
                        .first()?
                        .text() ?? ""

                    let nsRange = NSRange(priceText.startIndex..<priceText.endIndex, in: priceText)
                    var price = 0.0
                    if let match = priceRegex.firstMatch(in: priceText, options: [], range: nsRange),
                       let range = Range(match.range(at: 1), in: priceText) {
                        price = Double(String(priceText[range])) ?? 0.0
                    }

                    let quantityText = try card
                        .select("span[aria-live=polite] > span:last-child")
                        .first()?
                        .text()
                        .trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

                    let quantity = Int(quantityText) ?? 1
                    itemTotal = price * Double(quantity)
                }

                pricesList.append(itemTotal)
            }
        } catch {
            print("SwiftSoup parsing error:", error)
        }

        let total = pricesList.reduce(0, +)
        let formattedTotal = String(format: "%.2f", total)
        return (pricesList, formattedTotal)
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
