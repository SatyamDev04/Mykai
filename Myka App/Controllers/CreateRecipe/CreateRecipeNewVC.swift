//
//  CreateRecipeNewVC.swift
//  My Kai
//
//  Created by YATIN  KALRA on 11/09/25.
//
import UIKit
import DropDown
import IQKeyboardManager

// MARK: - CreateRecipeNewVC
class CreateRecipeNewVC: UIViewController {

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

    @IBOutlet weak var prepTimeLbl: UILabel!
    @IBOutlet weak var cookTimeLbl: UILabel!

    @IBOutlet weak var PrivateBtnO: UIButton!
    @IBOutlet weak var PublicBtnO: UIButton!

    @IBOutlet weak var FavoritesTxtF: UITextField!
    @IBOutlet weak var FavoritesBgV: UIView!
    // popups view
    
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
    
    // Data
    var cookBooksData = [FavDropDownModel]()
    var SelCookBookId = ""

    // for use on this screen only
    var isIngredientPickImg = false
    var imgIndex = 0

    var ingredientsArr = [RecipeDataModel]()
    var cookwareArr = [RecipeDataModel]()
    var recipeArr = [RecipeDataModel]()
    var ingredentDropDownArr = [IngredientCRData]()
    var ingredentUnitArr = [IngredientCRData]()
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupPopups()
        setupImagePicker()
        setupTableView()
        setupObservers()
        setupInitialUIState()

        addIngredientAmoutTF.inputAccessoryView = makeFractionToolbar()

        // ingredient label tap
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(labelTapped))
        ingredientFinalLbl.isUserInteractionEnabled = true
        ingredientFinalLbl.addGestureRecognizer(tapGesture)

//        if createProgrammaticTextField {
//           setupProgrammaticTextField()
//       }
    }

    deinit {
        // Remove observers safely (match what we added)
        ingredientTblV.removeObserver(self, forKeyPath: "contentSize")
        cookwareTblV.removeObserver(self, forKeyPath: "contentSize")
        recipeTblV.removeObserver(self, forKeyPath: "contentSize")
    }

    // MARK: Setup helpers
    private func setupPopups() {
        
        self.DiscardPopupV.frame = self.view.bounds
        self.view.addSubview(self.DiscardPopupV)
        self.DiscardPopupV.isHidden = true
        self.SavePopUpV.frame = self.view.bounds
        self.view.addSubview(self.SavePopUpV)
        self.SavePopUpV.isHidden = true
        
        searchInDropDown.backgroundColor = .white
        searchInDropDown.anchorView = addIngredientTF
        searchInDropDown.bottomOffset = CGPoint(x: 0, y: addIngredientTF.frame.size.height)
        searchInDropDown.direction = .bottom
        searchInDropDown.setupCornerRadius(10)
        searchInDropDown.width = addIngredientTF.frame.width
        
        searchCookDropDown.backgroundColor = .white
        searchCookDropDown.anchorView = addCookwareV
        searchCookDropDown.bottomOffset = CGPoint(x: 0, y: addCookwareV.frame.size.height)
        searchCookDropDown.direction = .bottom
        searchCookDropDown.setupCornerRadius(10)
        searchCookDropDown.width = addCookwareV.frame.width
            
        ingredientUnitDropDown.backgroundColor = .white
        searchCookDropDown.anchorView = addCookwareV
        searchCookDropDown.bottomOffset = CGPoint(x: 0, y: addCookwareV.frame.size.height)
        searchCookDropDown.direction = .bottom
        searchCookDropDown.setupCornerRadius(10)
        searchCookDropDown.width = addCookwareV.frame.width
    }
    
    @objc func addIngredientValueChanged(_ sender:UITextField) {
        debouncedSearchIngredients(query: addIngredientTF.text ?? "")
    }
    
    func debouncedSearchIngredients(query: String) {
        // cancel previous
        textChangedWorkItem?.cancel()
        
        
        
        let workItem = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            self.apiToGetDropDownData(query: query, type: "1")
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
    }

    private func setupInitialUIState() {
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

        self.ingredientFinalLbl.isHidden = false
        self.ingredientFinalLbl.text = "Add Ingridient"
        self.addIngredientTF.isHidden = true
        self.addIngredientAmoutTF.isHidden = true
        self.addIngredientMesurementTF.isHidden = true

        addIngredientTF.delegate = self
    }

    private func setupTableView() {
        ingredientTblV.register(UINib(nibName: "IngredientsTblVCell", bundle: nil), forCellReuseIdentifier: "IngredientsTblVCell")
        ingredientTblV.delegate = self
        ingredientTblV.dataSource = self
        ingredientTblV.separatorStyle = .none

        cookwareTblV.register(UINib(nibName: "CreateRecipeTblVCell", bundle: nil), forCellReuseIdentifier: "CreateRecipeTblVCell")
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
    }

    @IBAction func ServingCountPlusBtn(_ sender: UIButton) {
        self.count += 1
        self.servingCountLbl.text =  "\(String(self.count)) servings"
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
    }

    @IBAction func PublicBtn(_ sender: UIButton) {
        self.PrivateBtnO.isSelected = false
        self.PublicBtnO.isSelected = true
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
        }
        dropDown.show()
    }

    // MARK: - Helpers
    private enum Tab { case ingredient, cookware, recipe }

    private func setActiveTab(_ tab: Tab) {
        switch tab {
        case .ingredient:
            self.IngredientLbl.backgroundColor = UIColor(red: 254/255, green: 159/255, blue: 69/255, alpha: 1)
            self.CookwareLbl.backgroundColor = UIColor(red: 255/255, green: 247/255, blue: 240/255, alpha: 1)
            self.recipeLbl.backgroundColor = UIColor(red: 255/255, green: 247/255, blue: 240/255, alpha: 1)

            self.IngredientLbl.textColor = .white
            self.CookwareLbl.textColor = UIColor(red: 60/255, green: 69/255, blue: 65/255, alpha: 1)
            self.recipeLbl.textColor = UIColor(red: 60/255, green: 69/255, blue: 65/255, alpha: 1)

            self.ingredientBgV.isHidden = false
            self.cookwareBgV.isHidden = true
            self.recipeBgV.isHidden = true

        case .cookware:
            self.IngredientLbl.backgroundColor = UIColor(red: 255/255, green: 247/255, blue: 240/255, alpha: 1)
            self.CookwareLbl.backgroundColor = UIColor(red: 254/255, green: 159/255, blue: 69/255, alpha: 1)
            self.recipeLbl.backgroundColor = UIColor(red: 255/255, green: 247/255, blue: 240/255, alpha: 1)

            self.IngredientLbl.textColor = UIColor(red: 60/255, green: 69/255, blue: 65/255, alpha: 1)
            self.CookwareLbl.textColor = .white
            self.recipeLbl.textColor = UIColor(red: 60/255, green: 69/255, blue: 65/255, alpha: 1)

            self.ingredientBgV.isHidden = true
            self.cookwareBgV.isHidden = false
            self.recipeBgV.isHidden = true

        case .recipe:
            self.IngredientLbl.backgroundColor = UIColor(red: 255/255, green: 247/255, blue: 240/255, alpha: 1)
            self.CookwareLbl.backgroundColor = UIColor(red: 255/255, green: 247/255, blue: 240/255, alpha: 1)
            self.recipeLbl.backgroundColor = UIColor(red: 254/255, green: 159/255, blue: 69/255, alpha: 1)

            self.IngredientLbl.textColor = UIColor(red: 60/255, green: 69/255, blue: 65/255, alpha: 1)
            self.CookwareLbl.textColor = UIColor(red: 60/255, green: 69/255, blue: 65/255, alpha: 1)
            self.recipeLbl.textColor = .white

            self.ingredientBgV.isHidden = true
            self.cookwareBgV.isHidden = true
            self.recipeBgV.isHidden = false
        }
    }
}

// MARK: - UITextFieldDelegate
extension CreateRecipeNewVC: UITextFieldDelegate{

    private func makeFractionToolbar() -> UIView {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()

        let fractions = ["1/2", "1/3", "1/4", "1/8", "2/3", "3/4"]

        // build fraction buttons
        var items: [UIBarButtonItem] = []
        for frac in fractions {
            let button = UIBarButtonItem(title: frac, style: .plain, target: self, action: #selector(fractionTapped(_:)))
            items.append(button)
        }

        // space + done
        items.append(UIBarButtonItem.flexibleSpace())
        let done = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneTapped))
        items.append(done)

        toolbar.items = items
        return toolbar
    }

    @objc private func fractionTapped(_ sender: UIBarButtonItem) {
        guard let text = sender.title else { return }
        // If amount TF is active, replace/append fraction
        if let tf = addIngredientAmoutTF {
            if tf.isFirstResponder {
                if let range = tf.selectedTextRange {
                    tf.replace(range, withText: text)
                } else {
                    tf.text = (tf.text ?? "") + text
                }
            } else {
                // If not first responder, set the text (original behaviour in file cleared previous text)
                tf.text = text
            }
        }
    }

    @objc private func doneTapped() {
        view.endEditing(true) // dismiss keyboard
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == addIngredientTF{
            textField.addTarget(self, action: #selector(addIngredientValueChanged(_:)), for: .editingChanged)
        }
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == addIngredientTF{
            self.addIngredientTF.isHidden = true
            self.ingredientFinalLbl.isHidden = false
            if addIngredientTF.text == ""{
                self.ingredientFinalLbl.text = "Add Ingredients"
            }else{
                self.ingredientFinalLbl.text = addIngredientTF.text
            }
            self.addIngredientAmoutTF.isHidden = false
            self.addIngredientMesurementTF.isHidden = false
        }
    }
}

// MARK: - ImagePickerDelegate1
extension CreateRecipeNewVC: ImagePickerDelegate1{
    func didSelect1(image: UIImage?, tag: Int, info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = image else { return }

        recipeImg.image = image
        recipeImg.contentMode = .scaleToFill

        image.resizeByByte(maxMB: 1) { (data) in
            DispatchQueue.main.async {
                //self.sendImage(data: data) // kept commented as original
            }
        }
    }
}

// MARK: - UITableViewDelegate & DataSource

extension CreateRecipeNewVC: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.ingredientTblV{ return ingredientsArr.count }
        else if tableView == self.cookwareTblV{ return cookwareArr.count }
        else { return recipeArr.count }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Default to ingredients cell where original code used it; preserved original (commented) logic
        let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientsTblVCell", for: indexPath) as! IngredientsTblVCell

        // Original logic was heavily commented out; preserved cell return and existing comments.

        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // kept intentionally blank as original
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}


extension CreateRecipeNewVC {
    private func apiToGetDropDownData(query: String,type:String) {
        guard !query.isEmpty else { return }
        let loginURL = baseURL.baseURL + appEndPoints.ingredientAndCookware + "/\(query)/\(type)"
        self.showIndicator(withTitle: "", and: "")
        WebService.shared.getServiceURLEncodingwithParams(loginURL, VC: self, andParameter: nil, withCompletion: { [weak self] (json, statusCode) in
            let jsonString = "\(json)"
            if let data = jsonString.data(using: .utf8) {
              do {
                    let response = try JSONDecoder().decode(IngredientCRModel.self, from: data)
                  guard let self else {return}
                    if response.success ?? false{
                        self.ingredentDropDownArr = response.data ?? []
                        
                       
                            DispatchQueue.main.async {
                             
                                let items = self.ingredentDropDownArr.map { $0.name ?? "" }
                                let units = self.ingredentDropDownArr.map { $0.unitName ?? "" }
                                
                            if items.isEmpty {
                              self.searchInDropDown.hide()
                                } else {
                                    self.searchInDropDown.dataSource = items
                                    self.searchInDropDown.show()
                                    self.searchInDropDown.width = self.addIngredientTF.frame.width
                                    self.searchInDropDown.selectionAction = { [weak self] (index: Int, item: String) in
                                        self?.ingredientFinalLbl.text = item
                                        self?.addIngredientTF.text = item
                                        self?.addIngredientMesurementTF.text = units[index]
                                    }
                                }
                            }
                            return
                        
                    }else{
                        self.ingredentDropDownArr.removeAll()
                    }
                 
                } catch {
                    print("Decoding error: \(error)")
                }
            }})
    }
    
   func getImpirialUnitApi(){
       
       let loginURL = baseURL.baseURL + appEndPoints.imperialUnitList
       WebService.shared.getServiceURLEncodingwithParams(loginURL, VC: self, andParameter: nil, withCompletion: { [weak self] (json, statusCode) in
           let jsonString = "\(json)"
           if let data = jsonString.data(using: .utf8) {
             do {
                   let response = try JSONDecoder().decode(IngredientCRModel.self, from: data)
                 guard let self else {return}
                   if response.success ?? false{
                       self.ingredentDropDownArr = response.data ?? []
                       
                      
                           DispatchQueue.main.async {
                            
                               let items = self.ingredentDropDownArr.map { $0.name ?? "" }
                               let units = self.ingredentDropDownArr.map { $0.unitName ?? "" }
                               
                           if items.isEmpty {
                             self.searchInDropDown.hide()
                               } else {
                                   self.ingredientUnitDropDown.dataSource = items
                                   self.ingredientUnitDropDown.show()
                                   self.ingredientUnitDropDown.width = self.addIngredientMesurementTF.frame.width
                                   self.searchInDropDown.selectionAction = { [weak self] (index: Int, item: String) in
                                       self?.addIngredientMesurementTF.text = item
                                   }
                               }
                           }
                           return
                       
                   }else{
                       self.ingredentDropDownArr.removeAll()
                   }
                
               } catch {
                   print("Decoding error: \(error)")
               }
           }})

    }
}
