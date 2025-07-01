//
//  CreateRecipeVC.swift
//  Myka App
//
//  Created by Sumit on 13/12/24.
//

import UIKit
import Alamofire
import SDWebImage
import DropDown

struct Innstructions {
    var txt: String
}

struct Ingredients {
    var txt: String
    var food: String
    var Quantity: String
    var Unit: String
    var img: String?
}

class CreateRecipeVC: UIViewController, UITextFieldDelegate, UITextViewDelegate{
    
    
    @IBOutlet weak var Img: UIImageView!
    
    @IBOutlet weak var RecipeTitleBgV: UIView!
    @IBOutlet weak var RecipeTitleTxtF: UITextField!
    @IBOutlet weak var ServingCountLbl: UILabel!
    
    @IBOutlet weak var IngredientsTblV: UITableView!
    @IBOutlet weak var IngredientsTblVH: NSLayoutConstraint!
    
    @IBOutlet weak var CookingInsTblV: UITableView!
    @IBOutlet weak var CookingInsTblVH: NSLayoutConstraint!
    
    @IBOutlet weak var NotesBgV: UIView!
    @IBOutlet weak var NotesTxtV: UITextView!
    @IBOutlet weak var NotesTxtVH: NSLayoutConstraint!
    
    @IBOutlet weak var TotalTimeTxtF: UITextField!
    
    @IBOutlet weak var PrivateBtnO: UIButton!
    @IBOutlet weak var PublicBtnO: UIButton!
    
    @IBOutlet weak var FavoritesTxtF: UITextField!
    
    @IBOutlet weak var FavoritesBgV: UIView!
    
    // popups view
    @IBOutlet var DiscardPopupV: UIView!
    @IBOutlet var SavePopUpV: UIView!
    //
    
    var imagePicker1: ImagePicker1!
    
    
    var count = 1
    
    var IngredientsArr = [Ingredients(txt: "", food: "", Quantity: "", Unit: "pounds", img: "")]
    var CookingInsArr = [Innstructions(txt: "")]
    
    var dropDown = DropDown()
    
    let textViewMaxHeight: CGFloat = 120
    
    var comesfrom = ""
     
    var ImgItemName = ""
 
    
    var AllDataList = [CreateRecipeModel]()
    
    var cookBooksData = [FavDropDownModel]()
    
    var unitArr = ["tsp", "tbsp", "cup", "ml", "liter",
                    "fl oz", "Pint", "quart", "gallon",
                    "gram", "kg", "mg", "ounce", "pounds",
                    "pinch", "dash", "drop", "handful", "slice", "stick", "clove", "piece",
                    "can", "bottle", "jar", "packet", "bunch", "sprig",
                    "inch", "cm", "feet"]
    
    
    
    var backAction:() -> () = { }
    
    // for use on this screen only
    var isIngredientPickImg = false
    var imgIndex = 0
    var SelCookBookId = ""
  //
    override func viewDidLoad() {
        super.viewDidLoad()
        self.DiscardPopupV.frame = self.view.bounds
        self.view.addSubview(self.DiscardPopupV)
        self.DiscardPopupV.isHidden = true
        
        self.SavePopUpV.frame = self.view.bounds
        self.view.addSubview(self.SavePopUpV)
        self.SavePopUpV.isHidden = true
        
        // to make custom PlaceHolder in TextField.
        let placeholderLabel = UILabel()
                placeholderLabel.text = "Add the total time it takes to make this recipe in mins"
                placeholderLabel.textColor = #colorLiteral(red: 0.2352941176, green: 0.2705882353, blue: 0.2549019608, alpha: 1)
                placeholderLabel.numberOfLines = 2
                placeholderLabel.font = TotalTimeTxtF.font
                placeholderLabel.translatesAutoresizingMaskIntoConstraints = false

        TotalTimeTxtF.addSubview(placeholderLabel)

                // Constraints for the placeholderLabel
                NSLayoutConstraint.activate([
                    placeholderLabel.leadingAnchor.constraint(equalTo: TotalTimeTxtF.leadingAnchor, constant: 0),
                    placeholderLabel.centerYAnchor.constraint(equalTo: TotalTimeTxtF.centerYAnchor),
                    placeholderLabel.trailingAnchor.constraint(equalTo: TotalTimeTxtF.trailingAnchor)
                ])

                // Update placeholder visibility when editing begins
        TotalTimeTxtF.addTarget(self, action: #selector(textFieldDidBeginEditing(_:)), for: .editingDidBegin)
        TotalTimeTxtF.addTarget(self, action: #selector(textFieldDidEndEditing(_:)), for: .editingDidEnd)

                placeholderLabel.isHidden = !TotalTimeTxtF.text!.isEmpty
        TotalTimeTxtF.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        //
        
        imagePicker1 = ImagePicker1(presentationController1: self, delegate1: self)
        SetupTableView()
        self.RecipeTitleTxtF.delegate = self
        self.TotalTimeTxtF.delegate = self
        
        self.NotesTxtV.delegate = self
        self.NotesTxtV.textColor = #colorLiteral(red: 0.2352941176, green: 0.2705882353, blue: 0.2549019608, alpha: 1)
        
        IngredientsTblV.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        CookingInsTblV.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        
        self.PrivateBtnO.isSelected = true
        self.PublicBtnO.isSelected = false
        
        if self.comesfrom == "AddRecipeImage"{
            self.Api_To_GetRecipesDataByImg()
        }
        
        self.Api_To_GetAllCookBooks()
    }
    
    // for Custom Placeholder of txtField.
    @objc func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == TotalTimeTxtF{
            updatePlaceholderVisibility(textField)
        }
       }

       @objc func textFieldDidEndEditing(_ textField: UITextField) {
           if textField == self.RecipeTitleTxtF {
               if self.RecipeTitleTxtF.text! != ""{
                   self.RecipeTitleBgV.backgroundColor = #colorLiteral(red: 0.9960784314, green: 0.9725490196, blue: 0.9450980392, alpha: 1)
                   self.RecipeTitleBgV.borderColor = #colorLiteral(red: 0.9960784314, green: 0.6235294118, blue: 0.2705882353, alpha: 0.8)
               }else{
                   self.RecipeTitleBgV.backgroundColor = #colorLiteral(red: 0.968627451, green: 0.968627451, blue: 0.968627451, alpha: 1)
                   self.RecipeTitleBgV.borderColor = #colorLiteral(red: 0.8823529412, green: 0.8823529412, blue: 0.8823529412, alpha: 1)
               }
           }else{
               updatePlaceholderVisibility(textField)
           }
       }

       @objc func textFieldEditingChanged(_ textField: UITextField) {
           if textField == TotalTimeTxtF{
               updatePlaceholderVisibility(textField)
           }
       }

       func updatePlaceholderVisibility(_ textField: UITextField) {
           guard let placeholderLabel = textField.subviews.first(where: { $0 is UILabel }) as? UILabel else {
               return
           }
           placeholderLabel.isHidden = !textField.text!.isEmpty
       }
    
    //
     
        override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
            if keyPath == "contentSize" {
                if let tableView = object as? UITableView {
                    if tableView == IngredientsTblV {
                        IngredientsTblVH.constant = tableView.contentSize.height
                    } else if tableView == CookingInsTblV {
                        CookingInsTblVH.constant = tableView.contentSize.height
                    }
                    view.layoutIfNeeded()
                }
            }
        }
  

     deinit {
        // Remove observers
        IngredientsTblV.removeObserver(self, forKeyPath: "contentSize")
        CookingInsTblV.removeObserver(self, forKeyPath: "contentSize")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    private func SetupTableView() {
        self.IngredientsTblV.register(UINib(nibName: "CreateRecipeIngredientTblVCell", bundle: nil), forCellReuseIdentifier: "CreateRecipeIngredientTblVCell")
        self.IngredientsTblV.delegate = self
        self.IngredientsTblV.dataSource = self
        self.IngredientsTblV.separatorStyle = .none
        
        self.CookingInsTblV.register(UINib(nibName: "CreateRecipeTblVCell", bundle: nil), forCellReuseIdentifier: "CreateRecipeTblVCell")
        self.CookingInsTblV.delegate = self
        self.CookingInsTblV.dataSource = self
        self.CookingInsTblV.separatorStyle = .none
    }
 
    
    
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        if self.RecipeTitleTxtF.text! != ""{
//            self.RecipeTitleBgV.backgroundColor = #colorLiteral(red: 0.9960784314, green: 0.9725490196, blue: 0.9450980392, alpha: 1)
//            self.RecipeTitleBgV.borderColor = #colorLiteral(red: 0.9960784314, green: 0.6235294118, blue: 0.2705882353, alpha: 0.8)
//        }else{
//            self.RecipeTitleBgV.backgroundColor = #colorLiteral(red: 0.968627451, green: 0.968627451, blue: 0.968627451, alpha: 1)
//            self.RecipeTitleBgV.borderColor = #colorLiteral(red: 0.8823529412, green: 0.8823529412, blue: 0.8823529412, alpha: 1)
//        }
//    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if(NotesTxtV.text == "Add your notes about recipe") {
            NotesTxtV.text = ""
            NotesTxtV.textColor = #colorLiteral(red: 0.2352941176, green: 0.2705882353, blue: 0.2549019608, alpha: 1)
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if(NotesTxtV.text == "") {
            NotesTxtV.text = "Add your notes about recipe"
            NotesTxtV.textColor = #colorLiteral(red: 0.2352941176, green: 0.2705882353, blue: 0.2549019608, alpha: 1)
        }
        
        if self.NotesTxtV.text! != "Add your notes about recipe"{
            self.NotesBgV.backgroundColor = #colorLiteral(red: 0.9960784314, green: 0.9725490196, blue: 0.9450980392, alpha: 1)
            self.NotesBgV.borderColor = #colorLiteral(red: 0.9960784314, green: 0.6235294118, blue: 0.2705882353, alpha: 0.8)
        }else{
            self.NotesBgV.backgroundColor = #colorLiteral(red: 0.968627451, green: 0.968627451, blue: 0.968627451, alpha: 1)
            self.NotesBgV.borderColor = #colorLiteral(red: 0.8823529412, green: 0.8823529412, blue: 0.8823529412, alpha: 1)
        }
    }
    
    func textViewDidChange(_ textView: UITextView)
    {
        if NotesTxtV.contentSize.height >= textViewMaxHeight
        {
            self.NotesTxtVH.constant = 120
            NotesTxtV.isScrollEnabled = true
        }
        else
        {
            let h = NotesTxtV.contentSize.height
            NotesTxtV.frame.size.height = h
            // BGtextview.constant = h + 105
            NotesTxtV.isScrollEnabled = false
        }
    }
    
   
    @IBAction func Back_Btn(_ sender:UIButton){
        self.DiscardPopupV.isHidden = false
    }

    
    @IBAction func UploadImage_Btn(_ sender:UIButton){
//        imagePicker1.present(from: sender)
        let alertController = UIAlertController(title: "Select Image", message: nil, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Choose from gallery ", style: .default, handler: { (s) in
            self.imagePicker1.presentGallery(from: sender)
        }))
        alertController.addAction(UIAlertAction(title: "Take a photo ", style: .default, handler: { (s) in
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
    
    @IBAction func ServingCountMinusBtn(_ sender: UIButton) {
        if self.count > 1{
            self.count -= 1
        }
        
        self.ServingCountLbl.text = String(self.count)
    }
    
    @IBAction func ServingCountPlusBtn(_ sender: UIButton) {
        self.count += 1
        self.ServingCountLbl.text = String(self.count)
    }
    
    @IBAction func AddIngredientsBtn(_ sender: UIButton) {
        let lastIndex = self.IngredientsArr.count - 1
        guard self.IngredientsArr[lastIndex].txt != "" && self.IngredientsArr[lastIndex].Quantity != "" && self.IngredientsArr[lastIndex].Unit != ""  else{
            AlertControllerOnr(title: "", message: "Please fill all the fields first.")
            return
        }
        self.IngredientsArr.append(contentsOf: [Ingredients(txt: "", food: "", Quantity: "", Unit: "pound", img: "")])
        self.IngredientsTblV.reloadData()
    }
    
    @IBAction func AddCookInsBtn(_ sender: UIButton) {
        let lastIndex = self.CookingInsArr.count - 1
        guard self.CookingInsArr[lastIndex].txt != "" else{
            AlertControllerOnr(title: "", message: "Please fill the field first.")
            return
        }
        self.CookingInsArr.append(contentsOf: [Innstructions(txt: "")])
        self.CookingInsTblV.reloadData()
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
        dropDown.show()
        dropDown.setupCornerRadius(10)
        dropDown.backgroundColor = .white
        dropDown.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        dropDown.layer.shadowOpacity = 0
        dropDown.layer.shadowRadius = 4
        dropDown.layer.shadowOffset = CGSize(width: 0, height: 0)
        dropDown.selectionAction = { [self] (index: Int, item: String) in
            self.FavoritesTxtF.text = item
            print(index)
            self.SelCookBookId = "\(cookBooksData[index].id ?? 0)"
        }
     
          dropDown.show()
    }
    
    @IBAction func SaveBtn_Btn(_ sender:UIButton){
        guard validation() else { return }
        
        self.Api_CreateCookbook()
    }
    
    
    
    // for popups btn.
    
    @IBAction func OkayBtn(_ sender: UIButton) {
        self.SavePopUpV.isHidden = true
//        if self.comesfrom == "AddRecipeImage"{
//            if let tabBar = self.tabBarController?.tabBar,
//               let items = tabBar.items,
//               items.count > 4 {
//                let item = items[0] // Get the UITabBarItem at index 4
//                self.tabBarController?.tabBar(tabBar, didSelect: item)
//                self.tabBarController?.selectedIndex = 0
//                self.backAction()
//            }
//        }else{
            self.backAction()
            self.navigationController?.popToRootViewController(animated: true)
 //       }
    }
    
    
    @IBAction func DiscardNoBtn(_ sender: UIButton) {
        self.DiscardPopupV.isHidden = true
    }
    
    @IBAction func DiscardYesBtn(_ sender: UIButton) {
        self.backAction()
        self.DiscardPopupV.isHidden = true
        self.navigationController?.popViewController(animated: true)
    }
    //
    
    func validation() -> Bool {
        
        if RecipeTitleTxtF.text?.count == 0 {
            self.popupAlert(title: "Error", message: "Add recipe title first.", actionTitles: ["Okay!"], actions:[{action1 in}])
            return false
        
        } else if TotalTimeTxtF.text?.count == 0 {
            self.popupAlert(title: "Error", message: "Add total time first.", actionTitles: ["Okay!"], actions:[{action1 in}])
            return false
        } else if FavoritesTxtF.text?.count == 0 {
            self.popupAlert(title: "Error", message: "Select Cookbook first.", actionTitles: ["Okay!"], actions:[{action1 in}])
            return false
        } else if CookingInsArr.count >= 1 {
            for item in CookingInsArr {
                if item.txt.count == 0 {
                    self.popupAlert(title: "Error", message: "Add cookbook instructions first.", actionTitles: ["Okay!"], actions:[{action1 in}])
                    return false
                }else{
                    if IngredientsArr.count >= 1 {
                        for item in IngredientsArr {
                            if item.txt.count == 0 || item.Quantity.count == 0 || item.Unit.count == 0{
                                self.popupAlert(title: "Error", message: "Add ingredients first, all fields are required.", actionTitles: ["Okay!"], actions:[{action1 in}])
                                return false
                            }
                        }
                    }
                }
            }
        } else if IngredientsArr.count >= 1 {
            for item in IngredientsArr {
                if item.txt.count == 0 || item.Quantity.count == 0 || item.Unit.count == 0{
                    self.popupAlert(title: "Error", message: "Add ingredients first, all fields are required.", actionTitles: ["Okay!"], actions:[{action1 in}])
                    return false
                }
            }
        }
        return true
    }
}

extension CreateRecipeVC:ImagePickerDelegate1{
     
    func didSelect1(image: UIImage?, tag: Int, info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = image else {
            return
        }
        
        if isIngredientPickImg == false{
            Img.image = image
            Img.contentMode = .scaleToFill
        }else{
            let base64String = convertImageToBase64(image: image)
            print("Base64 String: \(base64String ?? "")")
            self.IngredientsArr[self.imgIndex].img = base64String
            
            self.imgIndex = 0
            isIngredientPickImg = false
//            let img = self.IngredientsArr[self.imgIndex].img
//            let Unit = self.IngredientsArr[self.imgIndex].Unit
//            self.IngredientsArr.remove(at: self.imgIndex)
//            self.IngredientsArr.insert(contentsOf: [Ingredients(txt: didEndEditingWithText!, Quantity: QntText!, Unit: Unit, img: img)], at: self.imgIndex)
            self.IngredientsTblV.reloadData()
            
            
            
            
        }
        
        image.resizeByByte(maxMB: 1) { (data) in
            DispatchQueue.main.async {
                //self.sendImage(data: data)
            }
        }
    }
 
}


extension CreateRecipeVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.IngredientsTblV{
            return IngredientsArr.count
        }else{
            return CookingInsArr.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.IngredientsTblV{
            let cell = tableView.dequeueReusableCell(withIdentifier: "CreateRecipeIngredientTblVCell", for: indexPath) as! CreateRecipeIngredientTblVCell
            cell.TxtField.text = IngredientsArr[indexPath.row].txt
            
            let quantity = IngredientsArr[indexPath.row].Quantity
            let fQuantity = formatQuantity(quantity)
            
            if fQuantity != "Invalid input"{
                cell.QntTxtF.text = "\(fQuantity)"
            }
            
              
            let unit = IngredientsArr[indexPath.row].Unit
            let Funit = unit.capitalizedFirst
            if Funit == "Unit" || Funit == ""{
                cell.UnitLbl.text = ""
            }else{
                cell.UnitLbl.text = Funit
            }
            
            if let base64String = IngredientsArr[indexPath.row].img , base64String != "" {
                if let imageData = Data(base64Encoded: base64String, options: .ignoreUnknownCharacters){
                    let image = UIImage(data: imageData)
                    cell.Img.image = image
                }else{
                    cell.Img.image = UIImage(named: "UploadImage")
                }
            }else{
                cell.Img.image = UIImage(named: "UploadImage")//No_Image
            }
            
            cell.selectionStyle = .none
            cell.delegate = self
            if IngredientsArr[indexPath.row].txt != "" && IngredientsArr[indexPath.row].Quantity != "" && IngredientsArr[indexPath.row].Unit != "" && IngredientsArr[indexPath.row].img != ""{
                cell.BgV.backgroundColor = #colorLiteral(red: 0.9960784314, green: 0.9725490196, blue: 0.9450980392, alpha: 1)
                cell.BgV.borderColor = #colorLiteral(red: 0.9960784314, green: 0.6235294118, blue: 0.2705882353, alpha: 0.8)
            }else{
                cell.BgV.backgroundColor = #colorLiteral(red: 0.968627451, green: 0.968627451, blue: 0.968627451, alpha: 1)
                cell.BgV.borderColor = #colorLiteral(red: 0.8823529412, green: 0.8823529412, blue: 0.8823529412, alpha: 1)
            }
            
            cell.DropBtn.tag = indexPath.row
            cell.DropBtn.addTarget(self, action: #selector(DropBtn(_:)), for: .touchUpInside)
            
            cell.ImgBtn.tag = indexPath.row
            cell.ImgBtn.addTarget(self, action: #selector(ImgPickBtn(_:)), for: .touchUpInside)
            
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "CreateRecipeTblVCell", for: indexPath) as! CreateRecipeTblVCell
            cell.TxtField.text = CookingInsArr[indexPath.row].txt
            
            if CookingInsArr.count == 1 &&  CookingInsArr[0].txt == ""{
                cell.TxtField.placeholder = "Add Cooking Instructions"
                cell.TitleBgV.isHidden = true
            }else{
                cell.TitleTxt.text = "Step- \(indexPath.row + 1)"
                cell.TitleBgV.isHidden = false
            }
            
            
            
            cell.selectionStyle = .none
            cell.delegate = self
            return cell
        }
    }
    
    
    @objc func ImgPickBtn(_ sender: UIButton) {
        self.imgIndex = sender.tag
        isIngredientPickImg = true
        let alertController = UIAlertController(title: "Select Image", message: nil, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Choose from gallery ", style: .default, handler: { (s) in
            self.imagePicker1.presentGallery(from: sender)
        }))
        alertController.addAction(UIAlertAction(title: "Take a photo ", style: .default, handler: { (s) in
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
    
    @objc func DropBtn(_ sender: UIButton) {
        let indexPath = sender.tag
        let unit = IngredientsArr[indexPath].Unit
        let Funit = unit.capitalizedFirst
        if Funit == "Unit" || Funit == ""{
            
        }else{
            dropDown.dataSource = unitArr.map { $0}
            dropDown.anchorView = sender
            dropDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height)
            
            dropDown.direction = .bottom // Allows dropdown to expand upward or downward
            
            //     dropDown.show()
            dropDown.setupCornerRadius(10)
            dropDown.backgroundColor = .white
            dropDown.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            dropDown.layer.shadowOpacity = 0
            dropDown.layer.shadowRadius = 4
            dropDown.layer.shadowOffset = CGSize(width: 0, height: 0)
            dropDown.selectionAction = { [self] (index: Int, item: String) in
                
                self.IngredientsArr[indexPath].Unit = item
                
                self.IngredientsTblV.reloadData()
                print(index)
            }
            
            dropDown.show()
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
       
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == self.IngredientsTblV{
            return 75
        }else{
            return UITableView.automaticDimension
        }
    }
     
}

extension CreateRecipeVC:CreateIngredientsDelegate {
    func IngredientsTxtTableViewCell(_ TxtTableViewCell: CreateRecipeIngredientTblVCell, didEndEditingWithText: String?, QntText: String?) {
        
        if didEndEditingWithText! == "" || QntText ==  "" {
            if didEndEditingWithText != ""{
                if let tableView = TxtTableViewCell.superview(ofType: UITableView.self) {
                    let indexPath = tableView.indexPath(for: TxtTableViewCell)
                    let img = self.IngredientsArr[indexPath!.row].img
                    let Unit = self.IngredientsArr[indexPath!.row].Unit
                    self.IngredientsArr.remove(at: indexPath!.row)
                    self.IngredientsArr.insert(contentsOf: [Ingredients(txt: didEndEditingWithText!, food: "\(QntText!) \(Unit) \(didEndEditingWithText!)", Quantity: QntText!, Unit: Unit, img: img)], at: indexPath!.row)
                }
            }
            self.IngredientsTblV.isScrollEnabled = false
        }else{
            self.IngredientsTblV.isScrollEnabled = true
            
            if let tableView = TxtTableViewCell.superview(ofType: UITableView.self) {
                let indexPath = tableView.indexPath(for: TxtTableViewCell)
                let img = self.IngredientsArr[indexPath!.row].img
                let Unit = self.IngredientsArr[indexPath!.row].Unit
                self.IngredientsArr.remove(at: indexPath!.row)
                self.IngredientsArr.insert(contentsOf: [Ingredients(txt: didEndEditingWithText!, food: "\(QntText!) \(Unit) \(didEndEditingWithText!)", Quantity: QntText!, Unit: Unit, img: img)], at: indexPath!.row)
                self.IngredientsTblV.reloadData()
            }
        }
    }
}

extension CreateRecipeVC: CreateRecipeDelegate {
    func TxtTableViewCell(_ TxtTableViewCell: CreateRecipeTblVCell, didEndEditingWithText: String?) {
        // Determine which table view the cell belongs to
        if didEndEditingWithText! == "" {
            self.CookingInsTblV.isScrollEnabled = false
        }else{
            self.CookingInsTblV.isScrollEnabled = true
            
            if let tableView = TxtTableViewCell.superview(ofType: UITableView.self) {
                let indexPath = tableView.indexPath(for: TxtTableViewCell)

                print("Text: \(didEndEditingWithText ?? "")", "IndexPath: \(indexPath ?? IndexPath())")
                if tableView == CookingInsTblV {
                    self.CookingInsArr.remove(at: indexPath!.row)
                    self.CookingInsArr.insert(contentsOf: [Innstructions(txt: didEndEditingWithText!)], at: indexPath!.row)
                    self.CookingInsTblV.reloadData()
                }
            }
        }
        
        
    }
}



extension CreateRecipeVC {
    func Api_To_GetRecipesDataByImg(){
        var params = [String: Any]()
        
        params["q"] = self.ImgItemName
  
        
        showIndicator(withTitle: "", and: "")
        let loginURL = baseURL.baseURL + appEndPoints.recipes
        
        WebService.shared.postServiceURLEncoding(loginURL, VC: self, andParameter: params, withCompletion: { (json, statusCode) in
            
            self.hideIndicator()
            
            let data = try! json.rawData()
            
            do{
                let d = try JSONDecoder().decode(CreateRecipeModelClass.self, from: data)
                if d.success == true {
                    let list = d.data
                    
                    self.AllDataList  = list ?? []
                    
                    let imgurl = self.AllDataList.first?.recipe?.images?.small?.url ?? ""
                    self.Img.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
                    self.Img.sd_setImage(with: URL(string: imgurl), placeholderImage: UIImage(named: "No_Image"))
                    self.Img.contentMode = .scaleToFill
                    
                    self.RecipeTitleTxtF.text  = self.AllDataList.first?.recipe?.label ?? ""
                    
                    let ingredients = self.AllDataList.first?.recipe?.ingredients ?? []
                    
                    self.showIndicator(withTitle: "", and: "")
                    self.IngredientsArr.removeAll()
                    if ingredients.count != 0{
                        self.processIngredients(ingredients, index: 0)
                    }
                    
                    let instructions = self.AllDataList.first?.recipe?.instructionLines ?? []
                    self.CookingInsArr.removeAll()
                    for itm in instructions {
                        self.CookingInsArr.append(Innstructions(txt: itm))
                    }
                    
                    self.IngredientsTblV.reloadData()
                    self.CookingInsTblV.reloadData()
                    
                }else{
                    
                    let msg = d.message ?? ""
                    self.showToast(msg)
                }
            }catch{
                print(error)
            }
        })
    }
    
    
    func processIngredients(_ ingredients: [Ingredient], index: Int = 0) {
        // Check if we've processed all ingredients
        guard index < ingredients.count else {
            print("All ingredients processed")
            DispatchQueue.main.async {
                self.hideIndicator()
                self.IngredientsTblV.reloadData()
            }
            return
        }
        
        let itm = ingredients[index]
        let urlString = itm.image ?? ""
        
        let MeasureUnit =  itm.measure ?? ""
        let UnitString = MeasureUnit.replacingOccurrences(of: "<", with: "").replacingOccurrences(of: ">", with: "")
        
        self.convertURLToBase64(urlString: urlString) { base64String in
            if let base64String = base64String {
                print("Base64 Encoded String: \(base64String)")
                self.IngredientsArr.append(Ingredients(txt: itm.food ?? "", food: itm.food ?? "",
                                                       Quantity: "\(itm.quantity ?? 0)",
                                                       Unit: UnitString,
                                                       img: base64String))
            } else {
                print("Failed to encode URL to Base64")
            }
            
            // Recursively process the next ingredient
            self.processIngredients(ingredients, index: index + 1)
        }
    }
    
    func convertURLToBase64(urlString: String, completion: @escaping (String?) -> Void) {
        // Validate the URL
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        // Use URLSession to fetch data asynchronously
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching data: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                print("No data received")
                completion(nil)
                return
            }
            
            // Convert data to Base64 string
//          
//                let base64String =  data.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters)
//                let base64ImgStr  = base64String.replacingOccurrences(of: "\r\n", with: "")
            
            let base64 =  data.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters)
                                  
            let base64String = base64.replacingOccurrences(of: "\r\n", with: "")
            completion(base64String)
        }
        
        task.resume() // Start the network call
    }
    
    
    func Api_To_GetAllCookBooks(){
        
        let params = [String: Any]()
   
        
        showIndicator(withTitle: "", and: "")
        
        let loginURL = baseURL.baseURL + appEndPoints.get_cook_book
        print(params,"Params")
        print(loginURL,"loginURL")
        
        WebService.shared.postServiceURLEncoding(loginURL, VC: self, andParameter: params, withCompletion: { (json, statusCode) in
            
            if self.comesfrom != "AddRecipeImage"{
                self.hideIndicator()
            }
            
            let data = try! json.rawData()
            
            do{
                let d = try JSONDecoder().decode(FavDropDownModelClass.self, from: data)
                if d.success == true {
                    
                    self.cookBooksData.removeAll()
                    if let list = d.data, list.count != 0 {
                        self.cookBooksData = list
                    }
                    
                    self.cookBooksData.insert(contentsOf: [FavDropDownModel(id: 0, userID: 0, name: "Favorites", image: "", status: 0, updatedAt: "", createdAt: "", deletedAt: "")], at: 0)
                    
                }else{
                    let msg = d.message ?? ""
                    self.showToast(msg)
                }
            }catch{
                print(error)
            }
        })
    }
    
    
    func Api_CreateCookbook() {
        let img = Data()
        // Prepare Ingredients Array
        var ingredientsArray = [String]()
        for item in IngredientsArr {
           // let img = item.img ?? ""
            let Qnty = item.Quantity
            let unit = item.Unit
            if unit == "" {
                ingredientsArray.append("\(item.Quantity) \(item.txt)")
            }else{
                ingredientsArray.append("\(item.Quantity) \(item.Unit) \(item.txt)")
            }
        }
          
        print("Ingredients Array: \(ingredientsArray)")
        
        // Prepare Cooking Instructions Array
        var cookingInstructionsArray = [String]()
        for item in CookingInsArr {
            cookingInstructionsArray.append(item.txt)
        }
        print("Cooking Instructions Array: \(cookingInstructionsArray)")
        
        // Convert image to Base64
        let base64String = convertImageToBase64(image: self.Img.image ?? UIImage()) ?? ""
       
        print("Base64 String: \(base64String)")
        
        // Determine Privacy
        let privacy = self.PublicBtnO.isSelected ? 1 : 0
        
        // Notes Validation
        let notes = (self.NotesTxtV.text == "Add your notes about recipe") ? "" : self.NotesTxtV.text ?? ""
        
        // Prepare Parameters
        let paramsDict: [String: Any] = [
            "recipe_key": privacy,
            "cook_book": Int(self.SelCookBookId) ?? 0,
            "title": self.RecipeTitleTxtF.text!,
            "ingr": ingredientsArray,
            "summary": notes,
            "yield": String(self.count), // Ensure yield is a string
            "totalTime": TotalTimeTxtF.text!,
            "prep": cookingInstructionsArray,
            "img": base64String
        ]
        
        print("Params Dictionary: \(paramsDict)")
    
        
        // API URL
        let loginURL = baseURL.baseURL + appEndPoints.create_meal
        print("API URL: \(loginURL)")
        
        // Show Loading Indicator
        showIndicator(withTitle: "", and: "")
        
        // Encode JSON and Send API Request
        if let jsonData = JSONStringEncoder().encode(paramsDict) {
            WebService.shared.postServiceRaw(loginURL, VC: self, jsonData: jsonData) { (json, statusCode) in
                self.hideIndicator()
                
                guard let dictData = json.dictionaryObject else {
                    self.showToast("Unexpected response from server.")
                    return
                }
                
                let message = dictData["message"] as? String ?? "An error occurred."
                
                if dictData["success"] as? Bool == true {
                    self.SavePopUpV.isHidden = false
                    DispatchQueue.main.async {
                        self.navigationController?.showToast(message)
                    }
                } else {
                    DispatchQueue.main.async {
                        self.showToast(message)
                    }
                }
            }
        } else {
            print("Failed to encode JSON.")
            self.hideIndicator()
            self.showToast("An error occurred while preparing the request.")
        }
    }

}
 
