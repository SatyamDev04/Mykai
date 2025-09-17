import UIKit
import WebKit
import PDFKit
import Photos

final class InstacartContainerVC: UIViewController, WKNavigationDelegate, WKUIDelegate {

    // MARK: - UI
    private let header = UIView()
    private let footer = UIView()
    private let titleLabel = UILabel()
    private let backButton = UIButton(type: .system)
    private let reloadButton = UIButton(type: .system)

    private let webView: WKWebView = {
        // Inject minimal CSS/JS to hide “Log in” bits + site top bar (non-fatal if it fails)
        let css = """
        :root { --mykai-top-pad: 0px; }
        /* hide obvious login buttons/links (best-effort, non-breaking) */
        a[href*="login"], a[aria-label="Log in"], [data-test*="login"], button:has(span:contains("Log in")) { display: none !important; }
        /* hide generic site header if present */
        header, .site-header, [data-test*="Header"], [class*="Header"] { display: none !important; }
        /* remove sticky gaps left by hidden header */
        body { padding-top: 0 !important; margin-top: 0 !important; }
        """
        let wrapped = """
        const style = document.createElement('style');
        style.innerHTML = `\(css)`;
        document.documentElement.appendChild(style);
        """
        let script = WKUserScript(source: wrapped, injectionTime: .atDocumentEnd, forMainFrameOnly: true)

        let cfg = WKWebViewConfiguration()
        cfg.websiteDataStore = .default()
        cfg.userContentController.addUserScript(script)
        cfg.defaultWebpagePreferences.preferredContentMode = .mobile

        let wv = WKWebView(frame: .zero, configuration: cfg)
        wv.scrollView.contentInsetAdjustmentBehavior = .never
        wv.allowsBackForwardNavigationGestures = true
        return wv
    }()

    // Footer buttons
    private let scanButton = UIButton(type: .system)
    private let compareButton = UIButton(type: .system)
    private let nextButton = UIButton(type: .system)

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
        navigationController?.setNavigationBarHidden(true, animated: animated)   // show our custom header
        navigationItem.largeTitleDisplayMode = .never
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)  // restore for next screen
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

        titleLabel.text = "instacart.com"
        titleLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        titleLabel.textAlignment = .center

        reloadButton.setImage(UIImage(systemName: "arrow.clockwise"), for: .normal)
        reloadButton.addTarget(self, action: #selector(didTapReload), for: .touchUpInside)

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

        // Scan
        scanButton.setTitle("Scan basket", for: .normal)
        scanButton.setImage(UIImage(systemName: "barcode.viewfinder"), for: .normal)
        scanButton.tintColor = .label
        scanButton.titleLabel?.font = .systemFont(ofSize: 13, weight: .medium)
        scanButton.contentHorizontalAlignment = .center
        scanButton.addTarget(self, action: #selector(didTapScan), for: .touchUpInside)
        scanButton.alignImageAboveTitle()

        // Compare
        compareButton.setTitle("Compare prices", for: .normal)
        compareButton.setImage(UIImage(systemName: "chart.bar.doc.horizontal"), for: .normal)
        compareButton.tintColor = .label
        compareButton.titleLabel?.font = .systemFont(ofSize: 13, weight: .medium)
        compareButton.contentHorizontalAlignment = .center
        compareButton.addTarget(self, action: #selector(didTapCompare), for: .touchUpInside)
        compareButton.alignImageAboveTitle()

        // Next
        nextButton.setTitle("Next", for: .normal)
        nextButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        nextButton.backgroundColor = .systemGreen
        nextButton.tintColor = .white
        nextButton.layer.cornerRadius = 12
        nextButton.addTarget(self, action: #selector(didTapNext), for: .touchUpInside)

        footer.addSubview(scanButton)
        footer.addSubview(compareButton)
        footer.addSubview(nextButton)
    }

    private func setupWebView() {
        // no-op; webview already configured
    }

    private func loadInstacart() {
        if let url = URL(string: "https://customers.dev.instacart.tools/store/recipes/7868843") {
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
         scanButton.isEnabled = false
         

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
        [scanButton, compareButton, nextButton].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

        NSLayoutConstraint.activate([
            // Left two icon buttons
            scanButton.leadingAnchor.constraint(equalTo: footer.leadingAnchor, constant: 16),
            scanButton.centerYAnchor.constraint(equalTo: footer.centerYAnchor),
            scanButton.widthAnchor.constraint(equalToConstant: 120),

            compareButton.leadingAnchor.constraint(equalTo: scanButton.trailingAnchor, constant: 12),
            compareButton.centerYAnchor.constraint(equalTo: footer.centerYAnchor),
            compareButton.widthAnchor.constraint(equalToConstant: 140),

            // Primary action
            nextButton.trailingAnchor.constraint(equalTo: footer.trailingAnchor, constant: -16),
            nextButton.centerYAnchor.constraint(equalTo: footer.centerYAnchor),
            nextButton.heightAnchor.constraint(equalToConstant: 44),
            nextButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 100)
        ])
    }

    // MARK: - Actions
    @objc private func didTapBack() {
        if webView.canGoBack {
            webView.goBack()
        } else {
            navigationController?.popViewController(animated: true)
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
        // TODO: continue flow (e.g., go to cart)
        toast("Next tapped")
    }

    // MARK: - WKNavigationDelegate (optional extras)
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        titleLabel.text = "instacart.com"
        scanButton.isEnabled = true
    }
    func webView(_ webView: WKWebView,
                 createWebViewWith configuration: WKWebViewConfiguration,
                 for navigationAction: WKNavigationAction,
                 windowFeatures: WKWindowFeatures) -> WKWebView? {
        // Handle target="_blank" -> open in same webview
        if navigationAction.targetFrame == nil {
            webView.load(navigationAction.request)
        }
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
//         renderWebViewToImage { [weak self] image in
//                 guard let self, let image else { return }
//                 let vc = UIActivityViewController(activityItems: [image], applicationActivities: nil)
//                 vc.popoverPresentationController?.sourceView = self.view
//                 self.present(vc, animated: true)
//             }\
         
         webView.createPDF(configuration: WKPDFConfiguration()) { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let data):
                    guard let url = self.writeTemp(data, name: "instacart-full.pdf") else {return}
                    let image = savePDFToPhotos(from:url, completion: {succeeded,error in
                        if succeeded {
                            self.showToast("Image saved to Photos")
                        }else{
                            self.showToast(error?.localizedDescription ?? "")
                        }
                    })
//                    guard let image else { return }
//                    let vc = UIActivityViewController(activityItems: [image], applicationActivities: nil)
//                    vc.popoverPresentationController?.sourceView = self.view
//                    self.present(vc, animated: true)
                case .failure(let err):
                    print("PDF error:", err)
                }
            }
          
         }
    
    func drawPDFfromURL(url: URL) -> UIImage? {
        guard let document = CGPDFDocument(url as CFURL) else { return nil }
        guard let page = document.page(at: 1) else { return nil }

        let pageRect = page.getBoxRect(.mediaBox)
        let renderer = UIGraphicsImageRenderer(size: pageRect.size)
        let img = renderer.image { ctx in
            UIColor.white.set()
            ctx.fill(pageRect)

            ctx.cgContext.translateBy(x: 0.0, y: pageRect.size.height)
            ctx.cgContext.scaleBy(x: 1.0, y: -1.0)

            ctx.cgContext.drawPDFPage(page)
        }

        return img
    }
    private func renderWebViewToImage(completion: @escaping (UIImage?) -> Void) {
        let cfg = WKPDFConfiguration()
        webView.createPDF(configuration: cfg) { result in
            switch result {
            case .success(let data):
                completion(self.pdfToImage(data))
            case .failure:
                completion(nil)
            }
        }
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
    private func pdfToImage(_ data: Data) -> UIImage? {
        guard
            let provider = CGDataProvider(data: data as CFData),
            let doc = CGPDFDocument(provider),
            let page = doc.page(at: 1)   // Instacart is usually 1 very tall page
        else { return nil }
     
        let box = page.getBoxRect(.mediaBox)
     
        // Render at device scale (Retina)
        let scale = UIScreen.main.scale
        let size = CGSize(width: box.width, height: box.height)
     
        let format = UIGraphicsImageRendererFormat()
        format.scale = scale
        format.opaque = true
     
        let renderer = UIGraphicsImageRenderer(size: size, format: format)
        return renderer.image { ctx in
            let cg = ctx.cgContext
            cg.interpolationQuality = .none
            cg.setShouldAntialias(true)
     
            // Flip PDF coords
            cg.translateBy(x: 0, y: size.height)
            cg.scaleBy(x: 1, y: -1)
     
            cg.drawPDFPage(page)
        }
    }
         /// Converts the entire web page to a single tall UIImage by:
         /// 1) createPDF (captures 100% height)  2) rasterize & stitch PDF pages vertically.
    private func captureFullPageImageViaPDF_HiRes(pixelScale: CGFloat = 3.0,
                                                  maxMegaPixels: CGFloat = 80,
                                                  completion: @escaping (UIImage?) -> Void) {
        webView.createPDF(configuration: WKPDFConfiguration()) { [weak self] result in
            guard let self else { completion(nil); return }
            switch result {
            case .success(let data):
                completion(self._rasterizePDFToImage_HiRes(data,
                                                            pixelScale: pixelScale,
                                                            maxMegaPixels: maxMegaPixels))
            case .failure:
                completion(nil)
            }
        }
    }
     
             /// Rasterize a multi-page PDF to one tall image (memory-aware).
    private func _rasterizePDFToImage_HiRes(_ pdfData: Data,
                                            pixelScale: CGFloat,
                                            maxMegaPixels: CGFloat) -> UIImage? {
        guard
            let provider = CGDataProvider(data: pdfData as CFData),
            let doc = CGPDFDocument(provider),
            doc.numberOfPages > 0
        else { return nil }
     
        // Compute target pixel sizes per page at desired scale
        var totalHeightPx: CGFloat = 0
        var widthsPx: [CGFloat] = []
        var heightsPx: [CGFloat] = []
     
        var maxWidthPx: CGFloat = 0
        for i in 1...doc.numberOfPages {
            guard let page = doc.page(at: i) else { continue }
            let box = page.getBoxRect(.mediaBox) // in points
            let w = ceil(box.width * pixelScale)
            let h = ceil(box.height * pixelScale)
            widthsPx.append(w)
            heightsPx.append(h)
            maxWidthPx = max(maxWidthPx, w)
            totalHeightPx += h
        }
     
        // Cap total pixels to avoid OOM (e.g., 80 MP)
        let totalPixels = maxWidthPx * totalHeightPx
        let maxPixels = maxMegaPixels * 1_000_000
        let down = totalPixels > maxPixels ? sqrt(maxPixels / totalPixels) : 1
        let finalW = floor(maxWidthPx * down)
        let finalHeights = heightsPx.map { floor($0 * down) }
        let finalTotalH = finalHeights.reduce(0, +)
     
        // Render
        let format = UIGraphicsImageRendererFormat()
        format.scale = 1       // working directly in pixels
        format.opaque = true   // improves sharpness on white pages
     
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: finalW, height: finalTotalH), format: format)
        let img = renderer.image { ctx in
            var y: CGFloat = 0
            let cg = ctx.cgContext
            cg.interpolationQuality = .none            // crisper edges for text/icons
            cg.setShouldAntialias(true)
            cg.setAllowsAntialiasing(true)
            cg.setAllowsFontSmoothing(true)
            cg.setShouldSmoothFonts(true)
     
            for i in 1...doc.numberOfPages {
                guard let page = doc.page(at: i) else { continue }
                let pageH = finalHeights[i-1]
                let pageBox = page.getBoxRect(.mediaBox)
     
                let scale = finalW / max(pageBox.width * pixelScale * down / (pixelScale), 1)
                // Because we’re in pixels with scale=1, we can compute simply:
                let xScale = finalW / pageBox.width
                let yScale = pageH   / pageBox.height
     
                cg.saveGState()
                // Flip into PDF coordinate space for the current slice
                cg.translateBy(x: 0, y: y + pageH)
                cg.scaleBy(x: xScale, y: -yScale)
                cg.drawPDFPage(page)
                cg.restoreGState()
     
                y += pageH
            }
        }
        return img
    }
    func renderHighQualityPDF(from url: URL, targetDPI: CGFloat = 300.0) -> UIImage? {
        guard let document = CGPDFDocument(url as CFURL) else { return nil }
        guard let page = document.page(at: 1) else { return nil }
        
        let mediaBox = page.getBoxRect(.mediaBox)
        let scale = targetDPI / 72.0 // PDF default is 72 DPI
        let scaledSize = CGSize(width: mediaBox.width * scale, height: mediaBox.height * scale)
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue
        
        guard let context = CGContext(
            data: nil,
            width: Int(scaledSize.width),
            height: Int(scaledSize.height),
            bitsPerComponent: 8,
            bytesPerRow: 0,
            space: colorSpace,
            bitmapInfo: bitmapInfo
        ) else { return nil }
        
        // High-quality rendering settings
        context.interpolationQuality = .high
        context.setAllowsAntialiasing(true)
        context.setShouldAntialias(true)
        context.setRenderingIntent(.defaultIntent)
        
        // Fill background
        context.setFillColor(UIColor.white.cgColor)
        context.fill(CGRect(origin: .zero, size: scaledSize))
        
        // Apply transformation
        context.translateBy(x: 0, y: scaledSize.height)
        context.scaleBy(x: scale, y: -scale)
        
        // Draw PDF page
        context.drawPDFPage(page)
        
        guard let cgImage = context.makeImage() else { return nil }
        return UIImage(cgImage: cgImage)
    }
    private func writeTemp(_ data: Data, name: String) -> URL? {
        let url = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(name)
        do { try data.write(to: url, options: .atomic); return url } catch { return nil }
    }
    
   

    func renderPDFWithPDFKit(url: URL, dpi: CGFloat = 300.0) -> UIImage? {
        guard let document = PDFDocument(url: url) else { return nil }
        guard let page = document.page(at: 0) else { return nil }
        
        let pageRect = page.bounds(for: .mediaBox)
        let scale = dpi / 72.0 // Convert from PDF points (72 DPI) to desired DPI
        
        let renderer = UIGraphicsImageRenderer(
            size: CGSize(width: pageRect.width * scale, height: pageRect.height * scale)
        )
        
        return renderer.image { ctx in
            UIColor.white.set()
            ctx.fill(CGRect(origin: .zero, size: renderer.format.bounds.size))
            
            ctx.cgContext.translateBy(x: 0.0, y: pageRect.height * scale)
            ctx.cgContext.scaleBy(x: scale, y: -scale)
             
            page.draw(with: .mediaBox, to: ctx.cgContext)
        }
    }
}

// MARK: - Small convenience for stacked icon+label buttons
private extension UIButton {
    func alignImageAboveTitle(spacing: CGFloat = 6) {
        guard let imageView = imageView, let titleLabel = titleLabel else { return }
        let insetAmount = spacing / 2
        contentEdgeInsets = UIEdgeInsets(top: insetAmount, left: insetAmount, bottom: insetAmount, right: insetAmount)
        titleEdgeInsets = UIEdgeInsets(top: spacing, left: -imageView.bounds.width, bottom: -imageView.bounds.height, right: 0)
        imageEdgeInsets = UIEdgeInsets(top: -titleLabel.intrinsicContentSize.height - spacing, left: 0, bottom: 0, right: -titleLabel.intrinsicContentSize.width)
    }
}
