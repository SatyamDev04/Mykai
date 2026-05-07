//
//  CreateRecipeNewVC.swift
//  My Kai
//
//  Created by YATIN  KALRA on 11/09/25.
//
import UIKit
import DropDown
import IQKeyboardManager
import WebKit
import SDWebImage
import SwiftyJSON

// MARK: - CreateRecipeNewVC
class CreateRecipeNewVC: UIViewController, UITextViewDelegate, WKNavigationDelegate {
    
    // MARK: IBOutlets
    @IBOutlet weak var recipeImg: UIImageView!
    @IBOutlet weak var recipeImgUploadBtnO: UIButton!
    @IBOutlet weak var recipeImgEditBtnO: UIButton!
    @IBOutlet weak var recipeTitleTF: UITextField!
    @IBOutlet weak var ingredientBgV: UIView!
    @IBOutlet weak var cookwareBgV: UIView!
    @IBOutlet weak var recipeBgV: UIView!
    @IBOutlet weak var IngredientLbl: UILabel!
    @IBOutlet weak var CookwareLbl: UILabel!
    @IBOutlet weak var recipeLbl: UILabel!
    @IBOutlet weak var IngredientasBtnO: UIButton!
    @IBOutlet weak var CookwareBtnO: UIButton!
    @IBOutlet weak var recipeBtnO: UIButton!
    @IBOutlet weak var servingCountLbl: UILabel!
    @IBOutlet weak var convertUnitBtnO: UIButton!
    @IBOutlet weak var ingredientTblVBgV: UIView!
    @IBOutlet weak var ingredientTblV: UITableView!
    @IBOutlet weak var ingredientTblVH: NSLayoutConstraint!
    @IBOutlet weak var cookwareTblVBgV: UIView!
    @IBOutlet weak var cookwareTblV: UITableView!
    @IBOutlet weak var cookwareTblVH: NSLayoutConstraint!
    @IBOutlet weak var recipeTblVBgV: UIView!
    @IBOutlet weak var recipeTblV: UITableView!
    @IBOutlet weak var recipeTblVH: NSLayoutConstraint!
    @IBOutlet weak var addIngredientV: UIView!
    @IBOutlet weak var addCookwareV: UIView!
    @IBOutlet weak var addRecipeV: UIView!
    @IBOutlet weak var addIngredientHeaderBtnO: UIButton!
    @IBOutlet weak var ingredientHeaderV: UIView!
    @IBOutlet weak var ingredientHeaderTF: UITextField!
    @IBOutlet weak var ingredientFinalLbl: UILabel!
    @IBOutlet weak var addIngredientTF: UITextField!
    @IBOutlet weak var addCookWareTF: UITextField!
    @IBOutlet weak var addIngredientAmoutTF: UITextField!
    @IBOutlet weak var addIngredientMesurementTF: UITextField!
    @IBOutlet weak var addRecipeHeaderBtnO: UIButton!
    @IBOutlet weak var recipeHeaderV: UIView!
    @IBOutlet weak var recipeHeaderTF: UITextField!
    @IBOutlet weak var recipeStepLbl: UILabel!
    @IBOutlet weak var addrecipeTxtV: UITextView!
    @IBOutlet weak var addrecipeTxtVHConstraint: NSLayoutConstraint!
    @IBOutlet weak var prepTimeLbl: UILabel!
    @IBOutlet weak var cookTimeLbl: UILabel!
    @IBOutlet weak var PrivateBtnO: UIButton!
    @IBOutlet weak var PublicBtnO: UIButton!
    @IBOutlet weak var FavoritesTxtF: UITextField!
    @IBOutlet weak var FavoritesBgV: UIView!
    @IBOutlet weak var autherNoteTxtV: UITextView!
    // popups view
    @IBOutlet weak var noRecipebgV: UIView!
    @IBOutlet var DiscardPopupV: UIView!
    @IBOutlet var SavePopUpV: UIView!
    
    // MARK: Private / State
    private let createProgrammaticTextField = false
    private var imagePicker1: ImagePicker1!
    private var count = 1
    private var dropDown = DropDown()
    private var searchInDropDown = DropDown()
    private var searchCookDropDown = DropDown()
    private var ingredientUnitDropDown = DropDown()
    private var textChangedWorkItem: DispatchWorkItem?
    var comefrom = ""
    var RecipeImportedData : RecipeURL?
    var cookBooksData = [FavDropDownModel]()
    var SelCookBookId = "0"
    private var imageResolverWebView: WKWebView?
    private var lastResolvedImportedImageURL: String?
    var addIngredientImgStr: String = ""
    var addCookwareImgStr: String = ""
    private let maxUploadImageBytes = 100 * 1024
 
    var backCase = ""
    var isIngredientPickImg = false
    var imgIndex = 0
    var backAction: () -> () = {}
    private var recipeImageBase64: String?
    
    // MARK: - ViewModel
    
    private var viewModel:CreateRecipeViewModel!
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPopups()
        setupImagePicker()
        setupTableView()
        setupObservers()
        setupInitialUIState()
        addIngredientAmoutTF.inputAccessoryView = makeFractionToolbar()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(labelTapped))
        ingredientFinalLbl.isUserInteractionEnabled = true
        ingredientFinalLbl.addGestureRecognizer(tapGesture)
      
        addIngredientAmoutTF.keyboardType = .decimalPad
        updateNextRecipeStepLabel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        populateAllIfLocalDataAvailable()
    }
    
    deinit {
        // Remove observers safely (match what we added)
        ingredientTblV.removeObserver(self, forKeyPath: "contentSize")
        cookwareTblV.removeObserver(self, forKeyPath: "contentSize")
        recipeTblV.removeObserver(self, forKeyPath: "contentSize")
    }
    
    // MARK: Setup helpers
    private func setupPopups() {
        self.viewModel = CreateRecipeViewModel(viewController: self)
        
        self.DiscardPopupV.frame = self.view.bounds
        self.view.addSubview(self.DiscardPopupV)
        self.DiscardPopupV.isHidden = true
        
        self.SavePopUpV.frame = self.view.bounds
        self.view.addSubview(self.SavePopUpV)
        self.SavePopUpV.isHidden = true
        
        self.addIngredientMesurementTF.delegate = self
        
        searchInDropDown.backgroundColor = .white
        searchInDropDown.anchorView = addIngredientTF
        searchInDropDown.bottomOffset = CGPoint(x: 0, y: addIngredientTF.frame.size.height)
        searchInDropDown.direction = .bottom
        searchInDropDown.setupCornerRadius(10)
        searchInDropDown.width = addIngredientTF.frame.width
        
        searchCookDropDown.backgroundColor = .white
        searchCookDropDown.anchorView = addCookWareTF
        searchCookDropDown.bottomOffset = CGPoint(x: 0, y: addCookWareTF.frame.size.height)
        searchCookDropDown.direction = .bottom
        searchCookDropDown.setupCornerRadius(10)
        searchCookDropDown.width = addCookWareTF.frame.width
    
        ingredientUnitDropDown.backgroundColor = .white
        
        prepTimeLbl.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showDatePrepPicker))
        prepTimeLbl.addGestureRecognizer(tapGesture)
        
        cookTimeLbl.isUserInteractionEnabled = true
        let tapGesturee = UITapGestureRecognizer(target: self, action: #selector(showDateCookPicker))
        cookTimeLbl.addGestureRecognizer(tapGesturee)
        viewModel.Api_To_GetAllCookBooks()
        if let data = self.RecipeImportedData {
            self.viewModel.fillImportedData(from: data)
            self.viewModel.comeFrom = backCase
            self.servingCountLbl.text = "\(data.servings?.stringValue() ?? "") servings"
            
            self.count = Int(data.servings?.stringValue() ?? "0") ?? 0
            self.recipeTitleTF.text = data.label
            self.prepTimeLbl.text =  "\(data.prepTime ?? 0) min"
            viewModel.prepTime = "\(data.prepTime ?? 0) min"
            self.cookTimeLbl.text = "\(data.totalTime?.stringValue() ?? "0") min"
            viewModel.cookTime = "\(data.totalTime?.stringValue() ?? "0") min"
            self.PrivateBtnO.isSelected = (data.isPublic ?? 0) == 0 ? true : false
            
            self.PublicBtnO.isSelected = (data.isPublic ?? 0) == 0 ? false : true
            self.viewModel.isPublic = (data.isPublic ?? 0) == 0 ? false : true
            self.autherNoteTxtV.text = data.description
            viewModel.description = data.description ?? ""
            if let imgStr = data.image, !imgStr.isEmpty {
                if imgStr.hasPrefix("http://") || imgStr.hasPrefix("https://") {
                    loadImportedRecipeImage(from: imgStr)
                } else {
                    self.recipeImg.setImage(base64String: imgStr)
                    
               
                    guard  let data = Data(base64Encoded: imgStr, options: .ignoreUnknownCharacters) else{return}
                    viewModel.imageData = data
                }
            } else {
                self.recipeImg.image = UIImage(named: "Camera")
            }
            recipeBgV.isHidden = true
            noRecipebgV.isHidden = false
        }
    }

    private func loadImportedRecipeImage(from rawURLString: String) {
        let secureURLString = rawURLString.replacingOccurrences(of: "http://", with: "https://")
        recipeImg.image = UIImage(named: "No_Image")

        if let normalizedURL = normalizedRemoteURL(from: secureURLString) {
            recipeImg.setRemoteImage(normalizedURL, placeholder: UIImage(named: "No_Image"))
        }

        let webView = getOrCreateImageResolverWebView()
        let requestURL = normalizedRemoteURL(from: secureURLString) ?? URL(string: secureURLString)
        guard let url = requestURL else { return }
        webView.load(URLRequest(url: url))
        
        
    }

    private func normalizedRemoteURL(from rawString: String) -> URL? {
        let trimmed = rawString
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "\"", with: "")
            .replacingOccurrences(of: "\\/", with: "/")

        guard !trimmed.isEmpty else { return nil }
        if let url = URL(string: trimmed) {
            return url
        }

        let allowed = CharacterSet(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~:/?#[]@!$&'()*+,;=%")
        if let encoded = trimmed.addingPercentEncoding(withAllowedCharacters: allowed) {
            return URL(string: encoded)
        }

        return nil
    }

    private func getOrCreateImageResolverWebView() -> WKWebView {
        if let webView = imageResolverWebView {
            return webView
        }

        let webView = WKWebView(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
        webView.isHidden = true
        webView.navigationDelegate = self
        view.addSubview(webView)
        imageResolverWebView = webView
        return webView
    }

    private func applyResolvedImportedImage(from url: URL) {
        guard lastResolvedImportedImageURL != url.absoluteString else { return }
        lastResolvedImportedImageURL = url.absoluteString
        print("Resolved imported image final URL:", url.absoluteString)
        SDWebImageManager.shared.loadImage(
            with: url,
            options: .highPriority,
            progress: nil
        ) { [weak self] image, data, error, _, finished, _ in
            guard let self = self, finished, error == nil else { return }

            DispatchQueue.main.async {
                self.recipeImg.image = image ?? UIImage(named: "No_Image")
                self.recipeImg.contentMode = .scaleAspectFit
                self.recipeImgUploadBtnO.isUserInteractionEnabled = false
                self.recipeImgEditBtnO.isHidden = false
            }
            self.storeCompressedRecipeImage(image: image, originalData: data)
        }
    }

    private func storeCompressedRecipeImage(image: UIImage?, originalData: Data? = nil) {
        let fallbackImage = image ?? (originalData.flatMap { UIImage(data: $0) })
        guard let finalImage = fallbackImage else { return }

        let compressedData = compressedImageData(from: finalImage, originalData: originalData, maxBytes: maxUploadImageBytes)
        viewModel.imageData = compressedData
        recipeImageBase64 = compressedData.base64EncodedString()
        print("Compressed recipe image size:", compressedData.count, "bytes")
    }

    private func compressedImageData(from image: UIImage, originalData: Data?, maxBytes: Int) -> Data {
        if let originalData = originalData, originalData.count <= maxBytes {
            return originalData
        }

        var workingImage = image
        var compressionQuality: CGFloat = 0.9
        var bestData = image.jpegData(compressionQuality: compressionQuality) ?? Data()

        if bestData.count <= maxBytes {
            return bestData
        }

        for _ in 0..<8 {
            if let jpegData = workingImage.jpegData(compressionQuality: compressionQuality) {
                bestData = jpegData
                if jpegData.count <= maxBytes {
                    return jpegData
                }
            }

            if compressionQuality > 0.35 {
                compressionQuality -= 0.1
            } else {
                let nextSize = CGSize(
                    width: max(workingImage.size.width * 0.85, 240),
                    height: max(workingImage.size.height * 0.85, 240)
                )
                if let resized = resizedImage(workingImage, targetSize: nextSize) {
                    workingImage = resized
                }
            }
        }

        while bestData.count > maxBytes,
              workingImage.size.width > 220,
              workingImage.size.height > 220 {
            let nextSize = CGSize(
                width: max(workingImage.size.width * 0.8, 220),
                height: max(workingImage.size.height * 0.8, 220)
            )
            guard let resized = resizedImage(workingImage, targetSize: nextSize),
                  let jpegData = resized.jpegData(compressionQuality: 0.3) else {
                break
            }
            workingImage = resized
            bestData = jpegData
            if jpegData.count <= maxBytes {
                return jpegData
            }
        }

        return bestData
    }

    private func resizedImage(_ image: UIImage, targetSize: CGSize) -> UIImage? {
        guard targetSize.width > 0, targetSize.height > 0 else { return nil }

        let rendererFormat = UIGraphicsImageRendererFormat.default()
        rendererFormat.scale = 1
        let renderer = UIGraphicsImageRenderer(size: targetSize, format: rendererFormat)

        return renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: targetSize))
        }
    }

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        guard webView == imageResolverWebView else { return }
        print("Image resolver started loading URL:", webView.url?.absoluteString ?? "nil")
    }

    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        guard webView == imageResolverWebView else { return }
        print("Image resolver redirected to URL:", webView.url?.absoluteString ?? "nil")
        if let resolvedURL = webView.url {
            applyResolvedImportedImage(from: resolvedURL)
        }
    }

    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        guard webView == imageResolverWebView else { return }
        print("Image resolver committed URL:", webView.url?.absoluteString ?? "nil")
        if let resolvedURL = webView.url {
            applyResolvedImportedImage(from: resolvedURL)
        }
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        guard webView == imageResolverWebView else { return }
        print("Image resolver finished URL:", webView.url?.absoluteString ?? "nil")
        guard let resolvedURL = webView.url else { return }
        applyResolvedImportedImage(from: resolvedURL)
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        guard webView == imageResolverWebView else { return }
        print("Image resolver provisional load failed:", error.localizedDescription)
        print("Image resolver failed provisional URL:", webView.url?.absoluteString ?? "nil")
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        guard webView == imageResolverWebView else { return }
        print("Image resolver load failed:", error.localizedDescription)
        print("Image resolver failed URL:", webView.url?.absoluteString ?? "nil")
    }
    
    @objc  func showDateCookPicker(){
        let pickerVC = PrepTimePickerViewController()
        pickerVC.modalPresentationStyle = .overFullScreen
        pickerVC.setInitial(hours: 0, minutes: 15)
        pickerVC.comeForm = "cook"
        if let text = cookTimeLbl.text?
            .replacingOccurrences(of: "min", with: "")
            .trimmingCharacters(in: .whitespaces),
           let minutes = Int(text) {
            pickerVC.totalMinutes = minutes
        }
        pickerVC.onSave = { hours, minutes in
            print("Selected: \(hours)h \(minutes)m")
            self.cookTimeLbl.text = "\(hours * 60 + minutes) min"
            self.viewModel.cookTime = "\(hours * 60 + minutes) min"
            
        }
        present(pickerVC, animated: false)
    }
    
    @objc  func showDatePrepPicker(){
        
        let pickerVC = PrepTimePickerViewController()
        pickerVC.modalPresentationStyle = .overFullScreen
        pickerVC.setInitial(hours: 0, minutes: 15)
        pickerVC.comeForm = "prep"
        if let text = prepTimeLbl.text?
            .replacingOccurrences(of: "min", with: "")
            .trimmingCharacters(in: .whitespaces),
           let minutes = Int(text) {
            pickerVC.totalMinutes = minutes
        }
        
        
        pickerVC.onSave = { hours, minutes in
            print("Selected: \(hours)h \(minutes)m")
            self.prepTimeLbl.text = "\(hours * 60 + minutes) min"
            self.viewModel.prepTime = "\(hours * 60 + minutes) min"
        }
        present(pickerVC, animated: false)
    }
    
    func debouncedSearchIngredients(query: String,type: String) {
        // cancel previous
        textChangedWorkItem?.cancel()
        let workItem = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            self.viewModel.fetchDropDown(query: query, type: type)
        }
        textChangedWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: workItem)
    }
    
    private func setupImagePicker() {
        imagePicker1 = ImagePicker1(presentationController1: self, delegate1: self)
    }
    
    
    private func setupObservers() {
        ingredientTblV.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        cookwareTblV.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        recipeTblV.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        recipeTitleTF.delegate = self
        autherNoteTxtV.delegate = self
        autherNoteTxtV.delegate =  self
        // Bind to viewModel changes to reload tables
        viewModel.onIngredientsChanged = { [weak self] in
            DispatchQueue.main.async {
                self?.ingredientTblV.reloadData()
            }
        }
        viewModel.onCookwareChanged = { [weak self] in
            DispatchQueue.main.async {
                self?.cookwareTblV.reloadData()
            }
        }
        viewModel.onRecipeStepsChanged = { [weak self] in
            DispatchQueue.main.async {
                self?.recipeTblV.reloadData()
                self?.updateNextRecipeStepLabel()
            }
        }
    }
    
    private func setupInitialUIState() {
        self.recipeImgEditBtnO.isHidden = true
        self.IngredientLbl.backgroundColor = UIColor(red: 254/255, green: 159/255, blue: 69/255, alpha: 1)
        self.CookwareLbl.backgroundColor = UIColor(red: 255/255, green: 247/255, blue: 240/255, alpha: 1)
        self.recipeLbl.backgroundColor = UIColor(red: 255/255, green: 247/255, blue: 240/255, alpha: 1)
        
        self.IngredientLbl.textColor = .white
        self.CookwareLbl.textColor = UIColor(red: 60/255, green: 69/255, blue: 65/255, alpha: 1)
        self.recipeLbl.textColor = UIColor(red: 60/255, green: 69/255, blue: 65/255, alpha: 1)
        
        self.ingredientHeaderV.isHidden = true
        self.recipeHeaderV.isHidden = true
        
        self.cookwareBgV.isHidden = true
        self.recipeBgV.isHidden = true
        self.noRecipebgV.isHidden = true
        self.ingredientFinalLbl.isHidden = false
        self.ingredientFinalLbl.text = "Add Ingridient"
        self.addIngredientTF.isHidden = true
        self.addIngredientAmoutTF.isHidden = true
        self.addIngredientMesurementTF.isHidden = true
        
        self.addIngredientTF.delegate = self
        self.addCookWareTF.delegate = self
        addrecipeTxtV.delegate = self
        addrecipeTxtV.isScrollEnabled = false
        
        addCookWareTF.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(cookwareDoneClicked))
        
        addrecipeTxtV.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(addRecipeDoneClicked))
        
        bindViewmodel()
    }
    
    
    private func setupTableView() {
        ingredientTblV.register(UINib(nibName: "IngredientsTblVCell", bundle: nil), forCellReuseIdentifier: "IngredientsTblVCell")
        ingredientTblV.delegate = self
        ingredientTblV.dataSource = self
        ingredientTblV.separatorStyle = .none
        
        cookwareTblV.register(UINib(nibName: "IngredientsTblVCell", bundle: nil), forCellReuseIdentifier: "IngredientsTblVCell")
        cookwareTblV.delegate = self
        cookwareTblV.dataSource = self
        cookwareTblV.separatorStyle = .none
        
        recipeTblV.register(UINib(nibName: "RecipeTblVCell", bundle: nil), forCellReuseIdentifier: "RecipeTblVCell")
        recipeTblV.delegate = self
        recipeTblV.dataSource = self
        recipeTblV.separatorStyle = .none
    }
    
    
    // MARK: KVO for content size
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize" {
            if let tableView = object as? UITableView {
                if tableView == ingredientTblV {
                    ingredientTblVH.constant = tableView.contentSize.height
                } else if tableView == cookwareTblV {
                    cookwareTblVH.constant = tableView.contentSize.height
                } else {
                    recipeTblVH.constant = tableView.contentSize.height
                }
                view.layoutIfNeeded()
            }
        }
    }
    
    
    // MARK: Actions
    @objc private func labelTapped() {
        ingredientFinalLbl.isHidden = true
        self.addIngredientAmoutTF.isHidden = true
        self.addIngredientMesurementTF.isHidden = true
        self.addIngredientTF.isHidden = false
        self.addIngredientTF.becomeFirstResponder()
    }
    
    
    @IBAction func UploadImage_Btn(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Select Image", message: nil, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Choose from gallery ", style: .default, handler: { _ in
            self.imagePicker1.presentGallery(from: sender)
        }))
        alertController.addAction(UIAlertAction(title: "Take a photo ", style: .default, handler: { _ in
            self.imagePicker1.presentCamera(from: sender)
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            alertController.popoverPresentationController?.sourceView = sender
            alertController.popoverPresentationController?.sourceRect = sender.bounds
            alertController.popoverPresentationController?.permittedArrowDirections = [.down, .up]
        }
        self.present(alertController, animated: true)
    }
    
    
    @IBAction func saveRacipeBtn(_ sender: UIButton) {
        if let data = self.RecipeImportedData {
            if comefrom == "cookbook"{
                if data.createdType == "create"{
                    self.editRecipe(type: "create",uri: data.uri ?? "")
                }else{
                    self.editRecipe(type: "import", sourceUrl: data.sourceURL,uri: data.uri ?? "")
                }
            }else{
                self.saveRecipe(type: "import", sourceUrl: data.sourceURL)
            }
             
        }else{
            self.saveRecipe(type: "create")
        }
    }
    
    
    @IBAction func IngredientBtn(_ sender: UIButton) {
        setActiveTab(.ingredient)
    }
    
    @IBAction func CookBtn(_ sender: UIButton) {
        setActiveTab(.cookware)
    }
    
    @IBAction func recipeBtn(_ sender: UIButton) {
        
        setActiveTab(.recipe)
    }
    
    @IBAction func ServingCountMinusBtn(_ sender: UIButton) {
        if self.count > 1 { self.count -= 1 }
        self.servingCountLbl.text = "\(String(self.count)) servings"
        viewModel.servings = servingCountLbl.text ?? ""
        
        
    }
    
    @IBAction func ServingCountPlusBtn(_ sender: UIButton) {
        self.count += 1
        self.servingCountLbl.text =  "\(String(self.count)) servings"
    }
    
    @IBAction func convertUntiBtn(_ sender: UIButton){
        let sb = UIStoryboard(name: "CreateRecipeSB", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "ConvertUnitPopVC") as! ConvertUnitPopVC
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func ingredientHeaderBtn(_ sender: UIButton) {
        self.ingredientHeaderV.isHidden = false
    }
    
    @IBAction func ingredientHeaderCancelBtn(_ sender: UIButton){
        self.ingredientHeaderV.isHidden = true
        if ingredientHeaderTF.text != ""{
            self.addIngredientHeaderBtnO.setTitle(self.ingredientHeaderTF.text, for: .normal)
        }else{
            self.addIngredientHeaderBtnO.setTitle("+ Header", for: .normal)
        }
    }
    
    
    @IBAction func recipeHeaderBtn(_ sender: UIButton) {
        self.recipeHeaderV.isHidden = false
    }
    
    
    @IBAction func recipeHeaderCancelBtn(_ sender: UIButton){
        self.recipeHeaderV.isHidden = true
        if recipeHeaderTF.text != ""{
            self.addRecipeHeaderBtnO.setTitle(self.recipeHeaderTF.text, for: .normal)
        }else{
            self.addRecipeHeaderBtnO.setTitle("+ Header", for: .normal)
        }
    }
    
    
    @IBAction func PrivateBtn(_ sender: UIButton) {
        self.PrivateBtnO.isSelected = true
        self.PublicBtnO.isSelected = false
        self.viewModel.isPublic = false
    }
    
    
    @IBAction func PublicBtn(_ sender: UIButton) {
        self.PrivateBtnO.isSelected = false
        self.PublicBtnO.isSelected = true
        self.viewModel.isPublic = true
    }
    
    @IBAction func backBtnTap(_ sender: UIButton) {
        if RecipeDraftManager.hasDraftData(){
            self.DiscardPopupV.isHidden = false
        }else{
            self.navigationController?.popViewController(animated: true)
           
        }
    }
    
    @IBAction func disgardChangesYesBtnTap(_ sender: UIButton) {
        if backCase == "imported"{
            RecipeDraftManager.clear()
            backAction()
            self.navigationController?.popToRootViewController(animated: true)
        }else{
            RecipeDraftManager.clear()
            self.navigationController?.popViewController(animated: true)
            backAction()
        }
    }
    
    @IBAction func disgardChangesNoBtnTap(_ sender: UIButton) {
        if backCase == "imported"{
            backAction()
            self.navigationController?.popToRootViewController(animated: true)
        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func FavoritesDropBtn(_ sender: UIButton) {
        if self.FavoritesTxtF.text! != ""{
            self.FavoritesBgV.backgroundColor = #colorLiteral(red: 0.9960784314, green: 0.9725490196, blue: 0.9450980392, alpha: 1)
            self.FavoritesBgV.borderColor = #colorLiteral(red: 0.9960784314, green: 0.6235294118, blue: 0.2705882353, alpha: 0.8)
        }else{
            self.FavoritesBgV.backgroundColor = #colorLiteral(red: 0.968627451, green: 0.968627451, blue: 0.968627451, alpha: 1)
            self.FavoritesBgV.borderColor = #colorLiteral(red: 0.8823529412, green: 0.8823529412, blue: 0.8823529412, alpha: 1)
        }
        
        dropDown.dataSource = cookBooksData.map { $0.name ?? "" }
        dropDown.anchorView = sender
        dropDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height)
        dropDown.setupCornerRadius(10)
        dropDown.backgroundColor = .white
        dropDown.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        dropDown.layer.shadowOpacity = 0
        dropDown.layer.shadowRadius = 4
        dropDown.layer.shadowOffset = CGSize(width: 0, height: 0)
        dropDown.selectionAction = { [weak self] (index: Int, item: String) in
            guard let self = self else { return }
            self.FavoritesTxtF.text = item
            self.SelCookBookId = "\(self.cookBooksData[index].id ?? 0)"
            self.viewModel.selectedCookbook = item
            self.viewModel.selectedCookbookId = "\(self.cookBooksData[index].id ?? 0)"
        
        }
        dropDown.show()
    }
    
    // MARK: - Helpers
    
    private enum Tab { case ingredient, cookware, recipe }
    
    private func setActiveTab(_ tab: Tab) {

        // reset fonts first
        IngredientLbl.font = UIFont(name: "Poppins-Regular", size: 16)
        CookwareLbl.font = UIFont(name: "Poppins-Regular", size: 16)
        recipeLbl.font = UIFont(name: "Poppins-Regular", size: 16)

        switch tab {
            
        case .ingredient:
            
            IngredientLbl.font = UIFont(name: "Poppins-SemiBold", size: 16)

            IngredientLbl.backgroundColor = UIColor(red: 254/255, green: 159/255, blue: 69/255, alpha: 1)
            CookwareLbl.backgroundColor = UIColor(red: 255/255, green: 247/255, blue: 240/255, alpha: 1)
            recipeLbl.backgroundColor = UIColor(red: 255/255, green: 247/255, blue: 240/255, alpha: 1)

            IngredientLbl.textColor = .white
            CookwareLbl.textColor = UIColor(red: 60/255, green: 69/255, blue: 65/255, alpha: 1)
            recipeLbl.textColor = UIColor(red: 60/255, green: 69/255, blue: 65/255, alpha: 1)

            ingredientBgV.isHidden = false
            cookwareBgV.isHidden = true
            recipeBgV.isHidden = true
            noRecipebgV.isHidden = true

        case .cookware:
            
            CookwareLbl.font = UIFont(name: "Poppins-SemiBold", size: 16)

            IngredientLbl.backgroundColor = UIColor(red: 255/255, green: 247/255, blue: 240/255, alpha: 1)
            CookwareLbl.backgroundColor = UIColor(red: 254/255, green: 159/255, blue: 69/255, alpha: 1)
            recipeLbl.backgroundColor = UIColor(red: 255/255, green: 247/255, blue: 240/255, alpha: 1)

            IngredientLbl.textColor = UIColor(red: 60/255, green: 69/255, blue: 65/255, alpha: 1)
            CookwareLbl.textColor = .white
            recipeLbl.textColor = UIColor(red: 60/255, green: 69/255, blue: 65/255, alpha: 1)

            ingredientBgV.isHidden = true
            cookwareBgV.isHidden = false
            
            recipeBgV.isHidden = true
            noRecipebgV.isHidden = true

        case .recipe:
            
            recipeLbl.font = UIFont(name: "Poppins-SemiBold", size: 16)

            IngredientLbl.backgroundColor = UIColor(red: 255/255, green: 247/255, blue: 240/255, alpha: 1)
            CookwareLbl.backgroundColor = UIColor(red: 255/255, green: 247/255, blue: 240/255, alpha: 1)
            recipeLbl.backgroundColor = UIColor(red: 254/255, green: 159/255, blue: 69/255, alpha: 1)

            IngredientLbl.textColor = UIColor(red: 60/255, green: 69/255, blue: 65/255, alpha: 1)
            CookwareLbl.textColor = UIColor(red: 60/255, green: 69/255, blue: 65/255, alpha: 1)
            recipeLbl.textColor = .white

            ingredientBgV.isHidden = true
            cookwareBgV.isHidden = true
            if self.RecipeImportedData != nil || viewModel.comeFrom == "imported"{
                recipeBgV.isHidden = true
                noRecipebgV.isHidden = false
            }else{
                recipeBgV.isHidden = false
                noRecipebgV.isHidden = true
            }
            
        }
    }
    
    @objc func cookwareDoneClicked(_ sender: Any) {
        if addCookWareTF.text != "" {
          viewModel.addCookware(name: addCookWareTF.text ?? "", img: addCookwareImgStr, header: "")
            self.searchCookDropDown.isHidden = true
            self.addCookWareTF.text = ""
           
        }
    }
    
    @objc func addRecipeDoneClicked(_ sender: Any) {
        addRecipe()
    }

}

// MARK: - UITextFieldDelegate
extension CreateRecipeNewVC: UITextFieldDelegate{
    
    private func makeFractionToolbar() -> UIView {

        let container = UIView()
        container.backgroundColor = .systemBackground
        container.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50)

        let fractions = ["1/2","1/3","1/4","1/8","2/3"]

        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 10
        stack.translatesAutoresizingMaskIntoConstraints = false

        for frac in fractions {

            let button = UIButton(type: .system)
            button.setTitle(frac, for: .normal)

            button.backgroundColor = UIColor.systemGray6
            button.layer.cornerRadius = 16
            button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)

            button.addAction(UIAction { _ in
                self.fractionTapped(frac)
            }, for: .touchUpInside)

            stack.addArrangedSubview(button)
        }

        let doneButton = UIButton(type: .system)
        doneButton.setTitle("Done", for: .normal)
        doneButton.backgroundColor = .systemBlue
        doneButton.setTitleColor(.white, for: .normal)
        doneButton.layer.cornerRadius = 16

        doneButton.addAction(UIAction { _ in
            self.doneTapped()
        }, for: .touchUpInside)

        stack.addArrangedSubview(doneButton)

        container.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 12),
            stack.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -12),
            stack.topAnchor.constraint(equalTo: container.topAnchor, constant: 6),
            stack.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -6)
        ])

        return container
    }
    
//    private func makeFractionToolbar() -> UIView {
//        
//        let toolbar = UIToolbar()
//        toolbar.sizeToFit()
//        
//        let fractions = ["1/2", "1/3", "1/4", "1/8", "2/3"]
//        
//        var items: [UIBarButtonItem] = []
//        
//        for (index, frac) in fractions.enumerated() {
//            
//            let button = UIBarButtonItem(
//                title: frac,
//                style: .plain,
//                target: self,
//                action: #selector(fractionTapped(_:))
//            )
//            
//            items.append(button)
//            
//            // add spacing between buttons
//            if index < fractions.count - 1 {
//                items.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil))
//            }
//        }
//        
//        // spacing before Done
//        items.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil))
//        
//        let done = UIBarButtonItem(
//            title: "Done",
//            style: .done,
//            target: self,
//            action: #selector(doneTapped)
//        )
//        
//        items.append(done)
//        
//        toolbar.items = items
//        
//        return toolbar
//    }
    
    private func fractionTapped(_ fraction: String) {

        if let decimal = convertFractionToDecimal(fraction) {
            addIngredientAmoutTF.text = String(format: "%.2f", decimal)
        }
    }
    
    func convertFractionToDecimal(_ text: String) -> Double? {

        let trimmed = text.trimmingCharacters(in: .whitespaces)

        if trimmed.contains(" ") {
            let parts = trimmed.split(separator: " ")
            if parts.count == 2,
               let whole = Double(parts[0]),
               let fraction = convertFractionToDecimal(String(parts[1])) {
                return whole + fraction
            }
        }

        if trimmed.contains("/") {
            let parts = trimmed.split(separator: "/")
            if parts.count == 2,
               let numerator = Double(parts[0]),
               let denominator = Double(parts[1]) {
                return numerator / denominator
            }
        }

        return Double(trimmed)
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if  textField == addIngredientMesurementTF{
            self.viewModel.fetchImperialUnits()
            return false
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        didChangeTextFildsForlocalData(textField)
        if textField == addIngredientTF{
            self.addIngredientTF.isHidden = true
            self.ingredientFinalLbl.isHidden = false
            if addIngredientTF.text == ""{
                self.ingredientFinalLbl.text = "Add Ingredients"
            }else{
                self.ingredientFinalLbl.text = addIngredientTF.text
                self.addIngredientAmoutTF.isHidden = false
                self.addIngredientMesurementTF.isHidden = false
            }
            
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == addIngredientTF{
            textField.addTarget(self, action: #selector(addIngredientValueChanged(_:)), for: .editingChanged)
        }else if textField == addCookWareTF{
            textField.addTarget(self, action: #selector(addCookwareValueChanged(_:)), for: .editingChanged)
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        didChangeTextviewForlocalData(textView)
        let size = CGSize(width: addrecipeTxtV.frame.width, height: .infinity)
        let estimatedSize = addrecipeTxtV.sizeThatFits(size)
        
      
        let lineHeight = addrecipeTxtV.font?.lineHeight ?? 0
        let maxHeight = lineHeight * 4
        
        addrecipeTxtVHConstraint.constant = min(estimatedSize.height, maxHeight)
        addrecipeTxtV.isScrollEnabled = estimatedSize.height > maxHeight
    }
    
    @objc func addIngredientValueChanged(_ sender:UITextField) {
        debouncedSearchIngredients(query: addIngredientTF.text ?? "", type: "1")
    }
    
    @objc func addCookwareValueChanged(_ sender:UITextField) {
        debouncedSearchIngredients(query: addCookWareTF.text ?? "", type: "2")
    }
}

// MARK: - ImagePickerDelegate1

extension CreateRecipeNewVC: ImagePickerDelegate1{
    func didSelect1(image: UIImage?, tag: Int, info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = image else { return }

        DispatchQueue.main.async {
            self.recipeImg.image = image
            self.recipeImg.contentMode = .scaleToFill
            self.recipeImgUploadBtnO.isUserInteractionEnabled = false
            self.recipeImgEditBtnO.isHidden = false
            self.storeCompressedRecipeImage(image: image)
        }
    }
}

// MARK: - UITableViewDelegate & DataSource

extension CreateRecipeNewVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == self.ingredientTblV {
            return viewModel.numberOfSections(for: .ingredient)
        } else if tableView == self.cookwareTblV {
            return viewModel.numberOfSections(for: .cookware)
        } else {
            return viewModel.numberOfSections(for: .recipe)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.ingredientTblV {
            return viewModel.numberOfRows(in: section, for: .ingredient)
        } else if tableView == self.cookwareTblV {
            return viewModel.numberOfRows(in: section, for: .cookware)
        } else {
            return viewModel.numberOfRows(in: section, for: .recipe)
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.ingredientTblV {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientsTblVCell", for: indexPath) as! IngredientsTblVCell
            
            cell.checkBoxView.isHidden = true
            
            guard let model = viewModel.modelForRow(at: indexPath, for: .ingredient) as? IngredientDataModel else {return cell}
            
            let title = viewModel.headerTitle(for: indexPath.section, in: .ingredient) ?? ""
            if title == "Ingredients" || !title.isEmpty{
                cell.type = .withHeader
            }else{
                cell.type = .normal
            }
            
            cell.ingredientlbl?.text = model.name
            
            if let quantity = model.quantity, let unit = model.unit {
                
//                if unit == "" {
//                    cell.amout_MeasurmentLbl?.text = "\(quantity) Unit".trimmingCharacters(in: .whitespaces)
//                }else{
                    cell.amout_MeasurmentLbl?.text = "\(quantity) \(unit)".trimmingCharacters(in: .whitespaces)
//                }
            } else {
                cell.amout_MeasurmentLbl?.text = ""
            }
            
            cell.img.sd_setImage(with: URL(string: model.img ?? ""), placeholderImage: UIImage(named: "NewRec"))
            cell.selectionStyle = .none
            return cell
        }else if tableView == cookwareTblV{
            let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientsTblVCell", for: indexPath) as! IngredientsTblVCell
            cell.type = .normal
            cell.checkBoxView.isHidden = true
            
            guard let model = viewModel.modelForRow(at: indexPath, for: .cookware) as? IngredientDataModel else {return cell}
            cell.ingredientlbl?.text = model.name
            cell.img.sd_setImage(with: URL(string: model.img ?? ""), placeholderImage: UIImage(named: "addCook"))
            cell.selectionStyle = .none
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeTblVCell", for: indexPath) as! RecipeTblVCell
            
            guard let model = viewModel.modelForRow(at: indexPath, for: .recipe) as? StepsDataModel else {return cell}
            print(model)
            let title = viewModel.headerTitle(for: indexPath.section, in: .recipe) ?? ""
         
            if title == "Recipe" || title.isEmpty{
                cell.type = .normal
                let stepNumber = globalStepNumber(for: indexPath)
                cell.stepLbl.text = "Step - \(stepNumber)"
                
            }else{
                cell.type = .normal
                let stepNumber = globalStepNumber(for: indexPath)
                cell.stepLbl.text = "Step - \(stepNumber)"
                
            }
            
            cell.recipeLbl?.text = model.instruction ?? ""
            cell.selectionStyle = .none
            
            return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {}
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {return 75}
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView == self.ingredientTblV {
            guard let title = viewModel.headerTitle(for: section, in: .ingredient) else { return nil }
            if title.isEmpty || title == "Ingrediants" || title == "Ingredients" {
                return nil
            }
            
            let label = UILabel()
            label.text = "   \(title)"
            label.font = UIFont(name: "Poppins-SemiBold", size: 16)
            label.textColor = #colorLiteral(red: 0.2352941176, green: 0.2705882353, blue: 0.2549019608, alpha: 1)
            
            return label
        }else if tableView == recipeTblV {
            guard let title = viewModel.headerTitle(for: section, in: .recipe) else { return nil }
            if title.isEmpty || title == "Recipe" {
                return nil
            }
            
            let label = UILabel()
            label.text = title
            label.font = UIFont(name: "Poppins-SemiBold", size: 16)
            label.textColor = #colorLiteral(red: 0.2352941176, green: 0.2705882353, blue: 0.2549019608, alpha: 1)
            
            return label
        }else if tableView == cookwareTblV {
            guard let title = viewModel.headerTitle(for: section, in: .cookware) else { return nil }
            if title.isEmpty {
                return nil
            }
            
            let label = UILabel()
            label.text = "   \(title)"
            label.font = UIFont.boldSystemFont(ofSize: 18)
            label.textColor = #colorLiteral(red: 0.2352941176, green: 0.2705882353, blue: 0.2549019608, alpha: 1)
            
            return label
        }
        return nil
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == self.ingredientTblV {
            guard let title = viewModel.headerTitle(for: section, in: .ingredient) else { return 0 }
            return title.isEmpty || title == "Ingredients" ? 0 : 40
        } else if tableView == recipeTblV {
            guard let title = viewModel.headerTitle(for: section, in: .recipe) else { return 0 }
            return title.isEmpty || title == "Recipe" ? 0 : 40
        } else if tableView == cookwareTblV {
            guard let title = viewModel.headerTitle(for: section, in: .cookware) else { return 0 }
            return title.isEmpty ? 0 : 40
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
    -> UISwipeActionsConfiguration? {

        guard tableView == ingredientTblV else { return nil }

        let delete = UIContextualAction(style: .destructive, title: "") { [weak self] _, _, completion in
            self?.viewModel.removeIngredient(at: indexPath)
            completion(true)
        }

        delete.image = UIImage(systemName: "trash")
        return UISwipeActionsConfiguration(actions: [delete])
    }
}


extension CreateRecipeNewVC {
    @objc private func doneTapped() {
        view.endEditing(true)
        addIngredient()
    }
    
    // MARK: - validated
    func addIngredient() {
        
        let ingredientName = addIngredientTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let amountText = addIngredientAmoutTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
//        let amountText = addIngredientAmoutTF.text ?? ""

        let decimalAmount = convertFractionToDecimal(amountText) ?? 0
        let unitText = addIngredientMesurementTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let imgStr = addIngredientImgStr.trimmingCharacters(in: .whitespacesAndNewlines)
        let headerText = ingredientHeaderTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        if  ingredientName.isEmpty || amountText.isEmpty || !viewModel.isValidAmount(amountText) || unitText.isEmpty {
            return
        }
        
        viewModel.addIngredient(name: ingredientName, quantity: "\(decimalAmount)", unit: unitText, img: imgStr, header: headerText)
        
        DispatchQueue.main.async {
            self.addIngredientAmoutTF.text = ""
            self.addIngredientMesurementTF.text = ""
            self.addIngredientImgStr = ""
            self.addIngredientTF.text = ""
            self.ingredientHeaderTF.text = ""
            self.ingredientHeaderV.isHidden = true
            self.ingredientFinalLbl.isHidden = false
            self.ingredientFinalLbl.text = "Add Ingridient"
            self.addIngredientTF.isHidden = true
            self.addIngredientAmoutTF.isHidden = true
            self.addIngredientMesurementTF.isHidden = true
            // reload triggered by viewModel closure
        }
    }
    
    func addCookware() {
        // This is no longer called directly, replaced by cookwareDoneClicked
        // Kept here for compatibility if ever used differently
    }
    
    func addRecipe() {
        
        let recipeName = addrecipeTxtV.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
        let headerText = recipeHeaderTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
        if  recipeName.isEmpty  {
            return
        }
        
        viewModel.addRecipeStep(instruction: recipeName, header: headerText)
        updateNextRecipeStepLabel()
        DispatchQueue.main.async {
            self.recipeHeaderV.isHidden = true
            self.recipeHeaderTF.text = ""
            self.addrecipeTxtV.text = ""
            // reload triggered by viewModel closure
        }
    }
    func updateNextRecipeStepLabel() {

        var totalSteps = 0
        let sections = viewModel.numberOfSections(for: .recipe)

        for section in 0..<sections {
            totalSteps += viewModel.numberOfRows(in: section, for: .recipe)
        }

        let nextStep = totalSteps + 1
        recipeStepLbl.text = "Step-\(nextStep)"
    }
    
    func globalStepNumber(for indexPath: IndexPath) -> Int {

        var step = 0

        for section in 0..<indexPath.section {
            step += viewModel.numberOfRows(in: section, for: .recipe)
        }

        step += indexPath.row + 1

        return step
    }
    
    func saveRecipe(type: String, sourceUrl: String? = nil,uri:String? = nil) {
        // Determine public/private status
        let isPublicStr = PublicBtnO.isSelected ? "0" : "1"
        
        // Prepare basic recipe data
        let yield = servingCountLbl.text?
            .removeSpaces
            .replace(string: "servings", withString: "") ?? ""
        let servings = yield
        
        let prepTime = prepTimeLbl.text?
            .removeSpaces
            .replace(string: "min", withString: "") ?? ""
        
        let cookTime = cookTimeLbl.text?
            .removeSpaces
            .replace(string: "min", withString: "") ?? ""
        
        // Generate recipe JSON string
        var jsonString: String = ""
        let currentImageBase64 = recipeImageBase64 ?? (!viewModel.imageData.isEmpty ? viewModel.imageData.base64EncodedString() : nil)
        
        if type == "import" {
            guard let generatedJson = viewModel.generateRecipeJSON(
                summary: self.autherNoteTxtV.text ?? "",
                recipe_key: isPublicStr,
                cook_book: SelCookBookId,
                title: recipeTitleTF.text ?? "",
                yield: yield,
                servings: servings,
                prep_time: prepTime,
                cook_time: cookTime,
                is_public: isPublicStr,
                img: currentImageBase64 ?? "",
                createdType: type,
                sourceURL: sourceUrl,
                uri: uri
                
            ) else {
                showAlert(for: "Failed to generate recipe JSON")
                return
            }
            jsonString = generatedJson
        } else {
            guard let generatedJson = viewModel.generateRecipeJSON(
                summary: self.autherNoteTxtV.text ?? "",
                recipe_key: isPublicStr,
                cook_book: SelCookBookId,
                title: recipeTitleTF.text ?? "",
                yield: yield,
                servings: servings,
                prep_time: prepTime,
                cook_time: cookTime,
                is_public: isPublicStr,
                img: currentImageBase64 ?? "",
                createdType: type,
                uri: uri
            ) else {
                showAlert(for: "Failed to generate recipe JSON")
                return
            }
            jsonString = generatedJson
        }
        
        guard
            let jsonData = jsonString.data(using: .utf8),
            let payload = try? JSONDecoder().decode(RecipePayload.self, from: jsonData)
        else {
            showAlert(for: "Failed to decode recipe payload")
            return
        }
        logRecipeUploadPayload(imageBase64: currentImageBase64, payload: payload, mode: "create")
    
        viewModel.uploadRecipe(payload,type: "") { [weak self] json, statusCode in
            guard let self = self else { return }

            self.logRecipeUploadResponse(json: json, statusCode: statusCode, mode: "create")

            if (200...201).contains(statusCode) {
                if let dict = json.dictionaryObject,let status = (dict["success"] as? Bool ),status{
                    self.showOkAlertWithHandler(title: "", "Recipe uploaded successfully!") {
                        RecipeDraftManager.clear()
                        //  self.navigationController?.popToViewController(ofClass: HomeVC.self)
                        self.tabBarController?.tabBar.isHidden = false
                        self.tabBarController?.selectedIndex = 3
                    }
                }else{
                    self.showAlert(for: self.recipeUploadErrorMessage(from: json, statusCode: statusCode))
                }
            } else {
                self.showAlert(for: self.recipeUploadErrorMessage(from: json, statusCode: statusCode))
            }
        }
    }
    
    func editRecipe(type: String, sourceUrl: String? = nil,uri:String? = nil) {
        // Determine public/private status
        let isPublicStr = PublicBtnO.isSelected ? "0" : "1"
        
        // Prepare basic recipe data
        let yield = servingCountLbl.text?
            .removeSpaces
            .replace(string: "servings", withString: "") ?? ""
        let servings = yield
        
        let prepTime = prepTimeLbl.text?
            .removeSpaces
            .replace(string: "min", withString: "") ?? ""
        
        let cookTime = cookTimeLbl.text?
            .removeSpaces
            .replace(string: "min", withString: "") ?? ""
        
        // Generate recipe JSON string
        var jsonString: String = ""
        let currentImageBase64 = recipeImageBase64 ?? (!viewModel.imageData.isEmpty ? viewModel.imageData.base64EncodedString() : nil)
        
        if type == "import" {
            guard let generatedJson = viewModel.generateRecipeJSON(
                summary: self.autherNoteTxtV.text ?? "",
                recipe_key: isPublicStr,
                cook_book: SelCookBookId,
                title: recipeTitleTF.text ?? "",
                yield: yield,
                servings: servings,
                prep_time: prepTime,
                cook_time: cookTime,
                is_public: isPublicStr,
                img: currentImageBase64 ?? "",
                createdType: type,
                sourceURL: sourceUrl,
                uri: uri
                
            ) else {
                showAlert(for: "Failed to generate recipe JSON")
                return
            }
            jsonString = generatedJson
        } else {
            guard let generatedJson = viewModel.generateRecipeJSON(
                summary: self.autherNoteTxtV.text ?? "",
                recipe_key: isPublicStr,
                cook_book: SelCookBookId,
                title: recipeTitleTF.text ?? "",
                yield: yield,
                servings: servings,
                prep_time: prepTime,
                cook_time: cookTime,
                is_public: isPublicStr,
                img: currentImageBase64 ?? "",
                createdType: type,
                uri: uri
            ) else {
                showAlert(for: "Failed to generate recipe JSON")
                return
            }
            jsonString = generatedJson
        }
        
        guard
            let jsonData = jsonString.data(using: .utf8),
            let payload = try? JSONDecoder().decode(RecipePayload.self, from: jsonData)
        else {
            showAlert(for: "Failed to decode recipe payload")
            return
        }
        logRecipeUploadPayload(imageBase64: currentImageBase64, payload: payload, mode: "edit")
    
        viewModel.uploadRecipe(payload,type: "edit") { [weak self] json, statusCode in
            guard let self = self else { return }

            self.logRecipeUploadResponse(json: json, statusCode: statusCode, mode: "edit")

            if (200...201).contains(statusCode) {
                if let dict = json.dictionaryObject, let status = (dict["success"] as? Bool), status {
                    self.showOkAlertWithHandler(title: "", "Recipe uploaded successfully!") {
                        RecipeDraftManager.clear()
                        self.tabBarController?.selectedIndex = 3
                    }
                } else {
                    self.showAlert(for: self.recipeUploadErrorMessage(from: json, statusCode: statusCode))
                }
            } else {
                self.showAlert(for: self.recipeUploadErrorMessage(from: json, statusCode: statusCode))
            }
        }
    }

    private func logRecipeUploadPayload(imageBase64: String?, payload: RecipePayload, mode: String) {
        print("===== Recipe Upload Payload (\(mode)) =====")
        print("title:", payload.title)
        print("yield:", payload.yield)
        print("servings:", payload.servings)
        print("prep_time:", payload.prep_time)
        print("cook_time:", payload.cook_time)
        print("cook_book:", payload.cook_book)
        print("createdType:", payload.createdType)
        print("source_url:", payload.source_url ?? "")
        print("uri:", payload.uri)
        print("imageData count:", viewModel.imageData.count)
        print("recipeImageBase64 length:", recipeImageBase64?.count ?? 0)
        print("currentImageBase64 length:", imageBase64?.count ?? 0)
        print("ingredients count:", payload.ingr.count)
        print("cookware count:", payload.cookware.count)
        print("steps count:", payload.prep.count)
        print("==========================================")
    }

    private func logRecipeUploadResponse(json: JSON, statusCode: Int, mode: String) {
        print("===== Recipe Upload Response (\(mode)) =====")
        print("statusCode:", statusCode)
        print("json:", json)
        print("parsed message:", recipeUploadErrorMessage(from: json, statusCode: statusCode))
        print("===========================================")
    }

    private func recipeUploadErrorMessage(from json: JSON, statusCode: Int) -> String {
        if let message = json["message"].string, !message.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return message
        }

        if let error = json["error"].string, !error.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return error
        }

        if let errorsDictionary = json["errors"].dictionaryObject as? [String: Any], !errorsDictionary.isEmpty {
            let mergedErrors = errorsDictionary.compactMap { key, value -> String? in
                if let values = value as? [String], !values.isEmpty {
                    return "\(key): \(values.joined(separator: ", "))"
                }
                if let valueString = value as? String, !valueString.isEmpty {
                    return "\(key): \(valueString)"
                }
                return nil
            }

            if !mergedErrors.isEmpty {
                return mergedErrors.joined(separator: "\n")
            }
        }

        if let errorsArray = json["errors"].arrayObject as? [String], !errorsArray.isEmpty {
            return errorsArray.joined(separator: "\n")
        }

        if let dataErrors = json["data"].dictionaryObject as? [String: Any], !dataErrors.isEmpty {
            let mergedDataErrors = dataErrors.compactMap { key, value -> String? in
                if let values = value as? [String], !values.isEmpty {
                    return "\(key): \(values.joined(separator: ", "))"
                }
                if let valueString = value as? String, !valueString.isEmpty {
                    return "\(key): \(valueString)"
                }
                return nil
            }

            if !mergedDataErrors.isEmpty {
                return mergedDataErrors.joined(separator: "\n")
            }
        }

        return "Failed to upload recipe. Status: \(statusCode)"
    }
    
    func bindViewmodel() {
        
        viewModel.didReceiveDropDownData = { [weak self] dropDownItems, type in
            guard let self = self else { return }
            
            if type == "1" {
                
                let query = self.addIngredientTF.text?.lowercased() ?? ""
                
                // Assign API results
                self.viewModel.ingredentDropDownArr = dropDownItems
                var uniqueIngredients: [IngredientCRData] = []
                var seenNames = Set<String>()

                for item in self.viewModel.ingredentDropDownArr {
                    let name = item.name?.lowercased() ?? ""
                    
                    if !seenNames.contains(name) {
                        seenNames.insert(name)
                        uniqueIngredients.append(item)
                    }
                }

                self.viewModel.ingredentDropDownArr = uniqueIngredients
                // Improved sorting (exact → prefix → contains → alphabetical)
                self.viewModel.ingredentDropDownArr.sort { a, b in
                    
                    let aName = a.name?.lowercased() ?? ""
                    let bName = b.name?.lowercased() ?? ""
                    
                    if aName == query { return true }
                    if bName == query { return false }
                    
                    if aName.hasPrefix(query) && !bName.hasPrefix(query) { return true }
                    if bName.hasPrefix(query) && !aName.hasPrefix(query) { return false }
                    
                    if aName.contains(query) && !bName.contains(query) { return true }
                    if bName.contains(query) && !aName.contains(query) { return false }
                    
                    return aName < bName
                }
                
                DispatchQueue.main.async {
                    
                    // Close keyboard so dropdown is visible
                    self.addIngredientTF.resignFirstResponder()
                    
                    let items = self.viewModel.ingredentDropDownArr.map { $0.name ?? "" }
                    
                    if items.isEmpty {
                        self.searchInDropDown.hide()
                        return
                    }
                    
                    self.searchInDropDown.dataSource = items
                    self.searchInDropDown.width = self.addIngredientTF.frame.width
                    self.searchInDropDown.show()
                    
                    self.searchInDropDown.selectionAction = { [weak self] (index: Int, item: String) in
                        guard let self = self else { return }
                        
                        guard self.viewModel.ingredentDropDownArr.indices.contains(index) else {
                            print("DropDown index \(index) out of range")
                            return
                        }
                        
                        let selectedIngredient = self.viewModel.ingredentDropDownArr[index]
                        let imageURL = selectedIngredient.imageURL ?? ""
                        
                        DispatchQueue.main.async {
                            self.ingredientFinalLbl.text = item
                            self.addIngredientTF.text = item
                            self.addIngredientMesurementTF.text = selectedIngredient.unitName ?? ""
                            self.addIngredientImgStr = imageURL
                            self.addIngredient()
                        }
                    }
                }
                
            } else if type == "2" {
                
                self.viewModel.cookwareDropDownArr = dropDownItems
                
                DispatchQueue.main.async {
                    
                    // Correct keyboard closing
                    self.addCookWareTF.resignFirstResponder()
                    
                    let items = self.viewModel.cookwareDropDownArr.map { $0.name ?? "" }
                    
                    if items.isEmpty {
                        self.searchCookDropDown.hide()
                        return
                    }
                    
                    self.searchCookDropDown.dataSource = items
                    self.searchCookDropDown.width = self.addCookWareTF.frame.width
                    self.searchCookDropDown.show()
                    
                    self.searchCookDropDown.selectionAction = { [weak self] (index: Int, item: String) in
                        guard let self = self else { return }
                        
                        guard self.viewModel.cookwareDropDownArr.indices.contains(index) else {
                            print("DropDown index \(index) out of range")
                            return
                        }
                        
                        let selectedCookware = self.viewModel.cookwareDropDownArr[index]
                        let imageURL = selectedCookware.imageURL ?? ""
                        
                        DispatchQueue.main.async {
                            self.addCookwareImgStr = imageURL
                            self.addCookWareTF.text = item
                            self.viewModel.addCookware(name: item, img: imageURL, header: "")
                            self.searchCookDropDown.hide()
                            self.addCookWareTF.text = ""
                        }
                    }
                }
            }
        }
        
        
        // MARK: Units Dropdown
        viewModel.didReceiveImperialUnits = { [weak self] unitsArr in
            guard let self = self else { return }
            
            self.viewModel.ingredentUnitArr = unitsArr
            
            DispatchQueue.main.async {
                
                let items = unitsArr.map { $0.unitName ?? "" }
                
                if items.isEmpty {
                    self.ingredientUnitDropDown.hide()
                    return
                }
                
                self.ingredientUnitDropDown.dataSource = items
                self.ingredientUnitDropDown.direction = .bottom
                self.ingredientUnitDropDown.anchorView = self.addIngredientMesurementTF
                self.ingredientUnitDropDown.bottomOffset = CGPoint(x: 0, y: self.addIngredientMesurementTF.frame.height)
                self.ingredientUnitDropDown.width = self.addIngredientMesurementTF.frame.width
                self.ingredientUnitDropDown.show()
                
                self.ingredientUnitDropDown.selectionAction = { [weak self] (index: Int, item: String) in
                    self?.addIngredientMesurementTF.text = item
                    self?.addIngredient()
                }
            }
        }
        
        
        // MARK: CookBook Data
        viewModel.didReceiveCookBookData = { [weak self] data in
            self?.cookBooksData = data
        }
        
        
        // MARK: Error
        viewModel.didReceiveError = { [weak self] error in
            print("ViewModel API error: \(String(describing: error))")
            self?.showAlert(for: String(describing: error))
        }
    }
     
}
extension CreateRecipeNewVC{
    // MARK: - Save for local
    
    func didChangeTextFildsForlocalData(_ textField: UITextField){
        if textField == recipeTitleTF{
            viewModel.title = textField.text ?? ""
        }
    }
    func didChangeTextviewForlocalData(_ textView: UITextView){
        if textView == autherNoteTxtV{
            viewModel.description = textView.text
        }
    }
    // MARK: - Get for local
    
    func populateAllIfLocalDataAvailable(){
       
        
        recipeTitleTF.text = viewModel.title
        autherNoteTxtV.text = viewModel.description
        self.prepTimeLbl.text  = viewModel.prepTime
        self.cookTimeLbl.text  = viewModel.cookTime
        self.FavoritesTxtF.text = viewModel.selectedCookbook
        SelCookBookId = viewModel.selectedCookbookId
        self.servingCountLbl.text = viewModel.servings
        let yield = servingCountLbl.text?
            .removeSpaces
            .replace(string: "servings", withString: "") ?? ""
        self.count = Int(yield) ?? 0
        if viewModel.isPublic {
            self.PublicBtnO.isSelected = true
            self.PrivateBtnO.isSelected = false
        }else{
            self.PublicBtnO.isSelected = false
            self.PrivateBtnO.isSelected = true
        }
        guard let img = UIImage(data: viewModel.imageData)else {
            self.recipeImg.image = UIImage(named: "Camera")
      return
  }
        self.recipeImg.image = img
        self.recipeImageBase64 = viewModel.imageData.base64EncodedString()
}
    
    
}
