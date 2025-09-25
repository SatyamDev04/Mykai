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
class CreateRecipeNewVC: UIViewController, UITextViewDelegate {

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
    var addIngredientImgStr: String = ""
    var addCookwareImgStr: String = ""
    // for use on this screen only
    var isIngredientPickImg = false
    var imgIndex = 0
    
    var ingredientsArr = [RecipeDataModel]()
    var cookwareArr = [RecipeDataModel]()
    var recipeArr = [RecipeDataModel]()
    var ingredentDropDownArr = [IngredientCRData]()
    var ingredentUnitArr = [UnitINData]()
    var tblVIngredientData : [RecipeDataModel] = []
    
    var cookwareDropDownArr = [IngredientCRData]()
    
    // MARK: - ViewModel
    
    private var viewModel :CreateRecipeViewModel!
    
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
        
    //    addIngredientAmoutTF.addDoneOnKeyboard(withTarget: self, action: #selector(addIngredientAmoutDoneButtonClicked(_:)))
        ingredientUnitDropDown.backgroundColor = .white
//        searchCookDropDown.anchorView = addCookwareV
//        searchCookDropDown.bottomOffset = CGPoint(x: 0, y: addCookwareV.frame.size.height)
//        searchCookDropDown.direction = .bottom
//        searchCookDropDown.setupCornerRadius(10)
//        searchCookDropDown.width = addCookwareV.frame.width
        prepTimeLbl.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showDatePrepPicker))
        prepTimeLbl.addGestureRecognizer(tapGesture)
        
        cookTimeLbl.isUserInteractionEnabled = true
        let tapGesturee = UITapGestureRecognizer(target: self, action: #selector(showDateCookPicker))
        cookTimeLbl.addGestureRecognizer(tapGesturee)
        viewModel.Api_To_GetAllCookBooks()
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
    }

    @IBAction func PublicBtn(_ sender: UIButton) {
        self.PrivateBtnO.isSelected = false
        self.PublicBtnO.isSelected = true
    }
    @IBAction func backBtnTap(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
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
    
    @objc func cookwareDoneClicked(_ sender: Any) {
        if addCookWareTF.text != "" {
            self.addCookware()
        }
    }
    
    @objc func addRecipeDoneClicked(_ sender: Any) {
        addRecipe()
    }
    
}

// MARK: - UITextFieldDelegate
extension CreateRecipeNewVC: UITextFieldDelegate{

    private func makeFractionToolbar() -> UIView {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()

        let fractions = ["1/2", "1/3", "1/4", "1/8", "2/3", "3/4"]

      
        var items: [UIBarButtonItem] = []
        for frac in fractions {
            let button = UIBarButtonItem(title: frac, style: .plain, target: self, action: #selector(fractionTapped(_:)))
            items.append(button)
        }

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

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if  textField == addIngredientMesurementTF{
            self.viewModel.fetchImperialUnits()
             return false
        }
    return true
   }

    func textFieldDidEndEditing(_ textField: UITextField) {
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
           // Calculate intrinsic height
           let size = CGSize(width: addrecipeTxtV.frame.width, height: .infinity)
           let estimatedSize = addrecipeTxtV.sizeThatFits(size)
           
           // Line height calculation
           let lineHeight = addrecipeTxtV.font?.lineHeight ?? 0
           let maxHeight = lineHeight * 4   // 4 lines max
           
           // Update height constraint
           addrecipeTxtVHConstraint.constant = min(estimatedSize.height, maxHeight)
           
           // Allow scrolling only when text exceeds 4 lines
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

       

        image.resizeByByte(maxMB: 1) { (data) in
            DispatchQueue.main.async {
                self.recipeImg.image = image
                self.recipeImg.contentMode = .scaleToFill
                self.recipeImgUploadBtnO.isUserInteractionEnabled = false
                self.recipeImgEditBtnO.isHidden = false
                //self.sendImage(data: data) // kept commented as original
            }
        }
    }
}

// MARK: - UITableViewDelegate & DataSource

extension CreateRecipeNewVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == self.ingredientTblV {
            return tblVIngredientData.count
        } else if tableView == self.cookwareTblV {
            return cookwareArr.count
        } else {
            return recipeArr.count
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.ingredientTblV {
            guard section < tblVIngredientData.count else { return 0 }
            return tblVIngredientData[section].ingredients?.count ?? 0
        } else if tableView == self.cookwareTblV {
            guard section < cookwareArr.count else { return 0 }
            return cookwareArr[section].cookware?.count ?? 0
        } else {
            guard section < recipeArr.count else { return 0 }
            return recipeArr[section].recipe?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.ingredientTblV {
            let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientsTblVCell", for: indexPath) as! IngredientsTblVCell
            
            cell.checkBoxView.isHidden = true
            let section = indexPath.section
            let row = indexPath.row
            
            let header = tblVIngredientData[section].hearder ?? ""
            if header.isEmpty{
                cell.type = .normal
            }else {
                cell.type = .withHeader
            }
            if section < tblVIngredientData.count,
               let ingredients = tblVIngredientData[section].ingredients,
               row < ingredients.count {
                let ingredient = ingredients[row]
                cell.ingredientlbl?.text = ingredient.name
                cell.amout_MeasurmentLbl?.text = "\(ingredient.quantity ?? "") \(ingredient.unit ?? "")"
                cell.img.sd_setImage(with: URL(string: ingredient.img ?? ""), placeholderImage: UIImage(named: "No_Image"))
            } else {
                cell.ingredientlbl?.text = ""
                cell.amout_MeasurmentLbl?.text = ""
                cell.img.image = UIImage(named: "No_Image")
            }
            cell.selectionStyle = .none
            return cell
        }else if tableView == cookwareTblV{
            let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientsTblVCell", for: indexPath) as! IngredientsTblVCell
            cell.type = .normal
            cell.checkBoxView.isHidden = true
            let section = indexPath.section
            let row = indexPath.row
            if section < cookwareArr.count,
               let ingredients = cookwareArr[section].cookware,
               row < ingredients.count {
                let ingredient = ingredients[row]
                cell.ingredientlbl?.text = ingredient.name
                cell.img.sd_setImage(with: URL(string: ingredient.img ?? ""), placeholderImage: UIImage(named: "No_Image"))
            } else {
                cell.ingredientlbl?.text = ""
                cell.img.image = UIImage(named: "No_Image")
            }
            cell.selectionStyle = .none
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeTblVCell", for: indexPath) as! RecipeTblVCell
            let section = indexPath.section
            let row = indexPath.row
            let header = recipeArr[section].hearder ?? ""
            if header.isEmpty{
                cell.type = .normal
                cell.stepLbl.text = "Step - \(section+1)"
            }else{
                cell.type = .withHeader
                cell.stepLbl.text = "Step - \(row+1)"
            }
            
            if section < recipeArr.count,
               let recipes = recipeArr[section].recipe,
               row < recipes.count {
                let recipe = recipes[row]
                cell.recipeLbl?.text = recipe.instruction
            } else {
                cell.recipeLbl?.text = ""
            }
            cell.selectionStyle = .none

            return cell
        }
//        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView == self.ingredientTblV {
            guard section < tblVIngredientData.count else { return nil }
            let title = tblVIngredientData[section].hearder?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            guard !title.isEmpty else { return nil }
            
            let label = UILabel()
            label.text = "   \(title)"
            label.font = UIFont(name: "Poppins-SemiBold", size: 16)
            label.textColor = #colorLiteral(red: 0.2352941176, green: 0.2705882353, blue: 0.2549019608, alpha: 1)
          
            return label
        }else if tableView == recipeTblV{
            guard section < recipeArr.count else { return nil }
            let title = recipeArr[section].hearder?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            guard !title.isEmpty else { return nil }
            
            let label = UILabel()
            label.text = "\(title)"
            label.font = UIFont(name: "Poppins-SemiBold", size: 16)
            label.textColor = #colorLiteral(red: 0.2352941176, green: 0.2705882353, blue: 0.2549019608, alpha: 1)
          
            return label
        }else{
            guard section < tblVIngredientData.count else { return nil }
            let title = recipeArr[section].hearder?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            guard !title.isEmpty else { return nil }
            
            let label = UILabel()
            label.text = "   \(title)"
            label.font = UIFont.boldSystemFont(ofSize: 18)
            label.textColor = #colorLiteral(red: 0.2352941176, green: 0.2705882353, blue: 0.2549019608, alpha: 1)
          
            return label
        }
//        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == self.ingredientTblV {
            guard section < tblVIngredientData.count else { return 0 }
            let title = tblVIngredientData[section].hearder?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            return title.isEmpty ? 0 : 40
        }else if tableView == self.recipeTblV{
            guard section < recipeArr.count else { return 0 }
            let title = recipeArr[section].hearder?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            return title.isEmpty ? 0 : 40
        }
        return 0
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
        let unitText = addIngredientMesurementTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let imgStr = addIngredientImgStr.trimmingCharacters(in: .whitespacesAndNewlines)
        let headerText = ingredientHeaderTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
     

        if  ingredientName.isEmpty || amountText.isEmpty || !viewModel.isValidAmount(amountText) || unitText.isEmpty {
       
            return
        }
        
        let ingredient = IngredientDataModel(
            name: ingredientName,
            quantity: "\(amountText)",
            unit: "\(unitText)",
            img: imgStr
        )

        DispatchQueue.main.async {
            if headerText.isEmpty {
                let data = RecipeDataModel(hearder: "", ingredients: [ingredient])
                self.tblVIngredientData.append(data)
            } else {
                if let existingIndex = self.tblVIngredientData.firstIndex(where: {
                    ($0.hearder ?? "").trimmingCharacters(in: .whitespacesAndNewlines).caseInsensitiveCompare(headerText) == .orderedSame
                }) {
                    if self.tblVIngredientData[existingIndex].ingredients == nil {
                        self.tblVIngredientData[existingIndex].ingredients = [ingredient]
                    } else {
                        self.tblVIngredientData[existingIndex].ingredients?.append(ingredient)
                    }
                } else {
                    let data = RecipeDataModel(hearder: headerText, ingredients: [ingredient])
                    self.tblVIngredientData.append(data)
                }
            }
            print("tblVIngredientData count: \(self.tblVIngredientData.count)")
            self.printAsJSON(self.tblVIngredientData)
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
            self.ingredientTblV.reloadData()
        }
    }
    
    func addCookware() {
       
        let cookwareName = addCookWareTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
//        let amountText = addIngredientAmoutTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
//        let unitText = addIngredientMesurementTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let imgStr = addCookwareImgStr.trimmingCharacters(in: .whitespacesAndNewlines)
        let headerText = ""
     
        if  cookwareName.isEmpty {
            return
        }
        
        let ingredient = IngredientDataModel(
            name: cookwareName,
            unit: "",
            img: imgStr
        )

        DispatchQueue.main.async {
            if headerText.isEmpty {
                let data = RecipeDataModel(hearder: "", cookware: [ingredient])
                self.cookwareArr.append(data)
            } else {
                if let existingIndex = self.cookwareArr.firstIndex(where: {
                    ($0.hearder ?? "").trimmingCharacters(in: .whitespacesAndNewlines).caseInsensitiveCompare(headerText) == .orderedSame
                }) {
                    if self.cookwareArr[existingIndex].cookware == nil {
                        self.cookwareArr[existingIndex].cookware = [ingredient]
                    } else {
                        self.cookwareArr[existingIndex].cookware?.append(ingredient)
                    }
                } else {
                    let data = RecipeDataModel(hearder: headerText, cookware: [ingredient])
                    self.cookwareArr.append(data)
                }
            }
            print("cookwareArr count: \(self.cookwareArr.count)")
            self.printAsJSON(self.cookwareArr)
            self.searchCookDropDown.isHidden = true
            self.addCookWareTF.text = ""
            self.cookwareTblV.reloadData()
        }
    }
    
    func addRecipe() {
        
        let recipeName = addrecipeTxtV.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
     
        let headerText = recipeHeaderTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
     
        if  recipeName.isEmpty  {
            return
        }
        
        let recipe = StepsDataModel(instruction: recipeName)

        DispatchQueue.main.async {
            if headerText.isEmpty {
                let data = RecipeDataModel(hearder: "", recipe: [recipe])
                self.recipeArr.append(data)
            } else {
                if let existingIndex = self.recipeArr.firstIndex(where: {
                    ($0.hearder ?? "").trimmingCharacters(in: .whitespacesAndNewlines).caseInsensitiveCompare(headerText) == .orderedSame
                }) {
                    if self.recipeArr[existingIndex].recipe == nil {
                        self.recipeArr[existingIndex].recipe = [recipe]
                    } else {
                        self.recipeArr[existingIndex].recipe?.append(recipe)
                    }
                } else {
                    let data = RecipeDataModel(hearder: headerText, recipe: [recipe])
                    self.recipeArr.append(data)
                }
            }
            print("recipeArr count: \(self.recipeArr.count)")
            self.printAsJSON(self.recipeArr)
          
            self.recipeHeaderV.isHidden = true
            self.recipeHeaderTF.text = ""
            self.addrecipeTxtV.text = ""
            
            self.recipeTblV.reloadData()
        }
    }
    
    func bindViewmodel() {
        viewModel.didReceiveDropDownData = { [weak self] dropDownItems,type in
               guard let self = self else { return }
            if type == "1"{
                self.ingredentDropDownArr = dropDownItems
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
                            guard let self = self else { return }
                            guard self.ingredentDropDownArr.indices.contains(index) else {
                                print("DropDown selection index \(index) out of range for ingredentDropDownArr (count: \(self.ingredentDropDownArr.count))")
                                return
                            }
                            let selectedIngredient = self.ingredentDropDownArr[index]
                            let imageURL = selectedIngredient.imageURL ?? ""
                            DispatchQueue.main.async {
                                self.ingredientFinalLbl.text = item
                                self.addIngredientTF.text = item
                                self.addIngredientMesurementTF.text = self.ingredentDropDownArr[index].unitName ?? ""
                                self.addIngredientImgStr = imageURL
                                self.addIngredient()
                            }
                        }
                    }
                }
            }else if type == "2"{
                self.cookwareDropDownArr = dropDownItems
                DispatchQueue.main.async {
                    let items = self.cookwareDropDownArr.map { $0.name ?? "" }
                    
                    if items.isEmpty {
                        self.searchCookDropDown.hide()
                    } else {
                        self.searchCookDropDown.dataSource = items
                        self.searchCookDropDown.show()
                        self.searchCookDropDown.width = self.addCookWareTF.frame.width
                        self.searchCookDropDown.selectionAction = { [weak self] (index: Int, item: String) in
                            guard let self = self else { return }
                            guard self.cookwareDropDownArr.indices.contains(index) else {
                                print("DropDown selection index \(index) out of range for ingredentDropDownArr (count: \(self.cookwareDropDownArr.count))")
                                return
                            }
                            
                            let selectedIngredient = self.cookwareDropDownArr[index]
                            let imageURL = selectedIngredient.imageURL ?? ""
                            DispatchQueue.main.async {
                                self.addCookwareImgStr = imageURL
                                self.addCookWareTF.text = item
                                self.addCookware()
                            }
                        }
                    }
                }
            }
           }
           viewModel.didReceiveImperialUnits = { [weak self] unitsArr in
               guard let self = self else { return }
               self.ingredentUnitArr = unitsArr
               DispatchQueue.main.async {
                   let items = self.ingredentUnitArr.map { $0.unitName ?? "" }
                   if items.isEmpty {
                       self.ingredientUnitDropDown.hide()
                   } else {
                       self.ingredientUnitDropDown.dataSource = items
                       self.ingredientUnitDropDown.direction = .bottom
                       self.ingredientUnitDropDown.anchorView = self.addIngredientMesurementTF
                       self.ingredientUnitDropDown.bottomOffset = CGPoint(x: 0, y: self.addIngredientMesurementTF.frame.size.height)
                       self.ingredientUnitDropDown.show()
                       self.ingredientUnitDropDown.width = self.addIngredientMesurementTF.frame.width
                       self.ingredientUnitDropDown.selectionAction = { [weak self] (index: Int, item: String) in
                           self?.addIngredientMesurementTF.text = item
                           self?.addIngredient()
                       }
                   }
               }
           }
        viewModel.didReceiveCookBookData = { [weak self] data in
            guard let self = self else { return }
            self.cookBooksData = data
        }
       viewModel.didReceiveError = { [weak self] error in
           print("ViewModel API error: \(String(describing: error))")
           self?.showAlert(for:String(describing: error))
       }
        
    }
    
    
    func printAsJSON<T: Encodable>(_ value: T) {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        do {
            let data = try encoder.encode(value)
            if let jsonString = String(data: data, encoding: .utf8) {
                print(jsonString)
            }
        } catch {
            print("❌ Failed to encode JSON:", error)
        }
    }
   
}
