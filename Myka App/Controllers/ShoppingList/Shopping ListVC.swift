//
//  Shopping ListVC.swift
//  Myka App
//
//  Created by Sumit on 15/12/24.
//

import UIKit
import Alamofire
import SDWebImage
import DropDown

struct ShoppingListModel {
    var name: String
    var quantity: String
    var Count: Int
    var isSelected: Bool
}

class Shopping_ListVC: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var yourRecipeCollV: UICollectionView!
    
    @IBOutlet weak var IngredientsTblV: UITableView!
    
    @IBOutlet weak var IngredientsTblVH: NSLayoutConstraint!
    
    @IBOutlet weak var YourRecipeBgV: UIView!
    
    @IBOutlet weak var SaveBtnO: UIButton!
    
    // popup outlets
    @IBOutlet var AddNewItemPopupV: UIView!
    @IBOutlet weak var CountLbl: UILabel!
    @IBOutlet weak var ItemNameTxtF: UITextField!
    @IBOutlet weak var SearchBgV: UIView!
    //
    
  
    var count = 1
    
    var textChangedWorkItem: DispatchWorkItem?
    
    var DislikesIngredientArr = [ModelClass]()
    
    var moreCount = 100
    
    var dropDown = DropDown()
    //
    
    //    var YourRecipesList = [ShoppingListModel(name: "", quantity: "", Count: 1, isSelected: false), ShoppingListModel(name: "", quantity: "", Count: 1, isSelected: false), ShoppingListModel(name: "", quantity: "", Count: 1, isSelected: false), ShoppingListModel(name: "", quantity: "", Count: 1, isSelected: false), ShoppingListModel(name: "", quantity: "", Count: 1, isSelected: false)]
    //
    //    var ShoppingList = [ShoppingListModel(name: "Tesco Mustard Seeds", quantity: "", Count: 1, isSelected: false), ShoppingListModel(name: "ketchup", quantity: "", Count: 1, isSelected: false), ShoppingListModel(name: "Milk", quantity: "", Count: 1, isSelected: false), ShoppingListModel(name: "Pasta", quantity: "", Count: 1, isSelected: false), ShoppingListModel(name: "Pizza", quantity: "", Count: 1, isSelected: false)]
    
    
    var ShoppingListArr: basketModelData?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.AddNewItemPopupV.frame = self.view.bounds
        self.view.addSubview(self.AddNewItemPopupV)
        self.AddNewItemPopupV.isHidden = true
         
        
        self.SaveBtnO.isUserInteractionEnabled = false
        self.SaveBtnO.backgroundColor = UIColor.lightGray
        
        setupCollectionView()
        
        self.IngredientsTblV.register(UINib(nibName: "Shopping_ListTblVCell", bundle: nil), forCellReuseIdentifier: "Shopping_ListTblVCell")
        self.IngredientsTblV.delegate = self
        self.IngredientsTblV.dataSource = self
        
        self.YourRecipeBgV.isHidden = true
        
        IngredientsTblV.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        
        self.ItemNameTxtF.delegate = self
        self.ItemNameTxtF.addTarget(self, action: #selector(TextSearch(sender: )), for: .editingChanged)
        
        self.getShopping_ListData()
    }
    
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize" {
            
            updateTableViewHeight(for: IngredientsTblV, heightConstraint: IngredientsTblVH)
            
        }
    }
    
    private func updateTableViewHeight(for tableView: UITableView, heightConstraint: NSLayoutConstraint) {
        // Update the height constraint with the tableView's contentSize height
        heightConstraint.constant = tableView.contentSize.height
    }
    
    deinit {
        // Remove observers for both table views to avoid memory leaks
        IngredientsTblV.removeObserver(self, forKeyPath: "contentSize")
    }
    
    
    private func setupCollectionView() {
        yourRecipeCollV.delegate = self
        yourRecipeCollV.dataSource = self
        yourRecipeCollV.register(UINib(nibName: "YouRecipeCollVCell", bundle: nil), forCellWithReuseIdentifier: "YouRecipeCollVCell")
    }
    
    
    @objc func TextSearch(sender: UITextField){
        if self.ItemNameTxtF.text == ""{
            textChangedWorkItem?.cancel()
            self.dropDown.hide()
        }else{
            // Cancel the previous work item
            textChangedWorkItem?.cancel()
            
            // Create a new debounced work item
            textChangedWorkItem = DispatchWorkItem { [weak self] in
                guard let self = self else { return }
                
                self.hideIndicator()
                
                self.Api_To_GetIngredientDislikes()
                
            }
            
            // Schedule the work item to execute after a debounce time (e.g., 1 second)
            if let workItem = textChangedWorkItem {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: workItem)
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        let SubscriptionStatus = Int(UserDetail.shared.getSubscriptionStatus())
//        
//        if SubscriptionStatus == 1{
//            self.yourRecipeCollV.isUserInteractionEnabled = false
//            self.IngredientsTblV.isUserInteractionEnabled = false
//        }else{
//            self.yourRecipeCollV.isUserInteractionEnabled = true
//            self.IngredientsTblV.isUserInteractionEnabled = true
//        }
    }
      
    
    @IBAction func BackBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    @IBAction func AddMoreBtn(_ sender: UIButton) {
        //        let storyboard = UIStoryboard(name: "Basket", bundle: nil)
        //        let vc = storyboard.instantiateViewController(withIdentifier: "AddMoreVc") as! AddMoreVc
        //        vc.hidesBottomBarWhenPushed = true
        //        navigationController?.pushViewController(vc, animated: true)
        self.AddNewItemPopupV.isHidden = false
    }
    
    
    @IBAction func Recipe_SeeAllBtn(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Basket", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "YourrecipeVC") as! YourrecipeVC
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    // popup btns.
    
    @IBAction func MinusBtn(_ sender: UIButton) {
        if self.count > 1 {
            self.count -= 1
        }
        
        self.CountLbl.text = "\(self.count)"
    }
    
    
    @IBAction func PlusBtn(_ sender: UIButton) {
        self.count += 1
        self.CountLbl.text = "\(self.count)"
    }
    
    @IBAction func CancelBtn(_ sender: UIButton) {
        self.AddNewItemPopupV.isHidden = true
    }
    
    
    @IBAction func AddBtn(_ sender: UIButton) {
        guard self.ItemNameTxtF.text != "" else{
            AlertControllerOnr(title: "", message: "Please enter item name.")
            return
        }
        self.ShoppingListArr?.ingredient?.append(contentsOf: [Product(created_at: "", deleted_at: "", food_id: "", id: nil, market_id: "", name: "", price: nil, pro_id: "", pro_img: "", pro_name: self.ItemNameTxtF.text!, pro_price: "", product_id: "", sch_id: self.count, status: nil, updated_at: "", user_id: nil)])
        
       // [DataIngredient(id: nil, userID: nil, foodID: "", schID: self.count, name: "", productID: "", price: nil, status: nil, marketID: nil, createdAt: "", updatedAt: "", deletedAt: "", proPrice: "", proName: self.ItemNameTxtF.text!, proID: "", proImg: "")]
        
        
        self.AddNewItemPopupV.isHidden = true
        self.count = 1
        self.ItemNameTxtF.text = ""
        self.IngredientsTblV.reloadData()
        
        self.SaveBtnO.isUserInteractionEnabled = true
        self.SaveBtnO.backgroundColor = #colorLiteral(red: 0.02352941176, green: 0.7568627451, blue: 0.4117647059, alpha: 1)
    }
    
    @IBAction func CrossBtn(_ sender: UIButton) {
        self.ItemNameTxtF.text = ""
        self.AddNewItemPopupV.isHidden = true
    }
    //
    
    @IBAction func SaveBtn(_ sender: UIButton) {
        self.Api_To_SaveIngedients()
    }
}


extension Shopping_ListVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ShoppingListArr?.recipe?.count ?? 0
       }
       
       func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
               let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "YouRecipeCollVCell", for: indexPath) as! YouRecipeCollVCell
           
           cell.Namelbl.text = ShoppingListArr?.recipe?[indexPath.row].data?.recipe?.label ?? ""
           
           let img = ShoppingListArr?.recipe?[indexPath.row].data?.recipe?.images?.small?.url ?? ""
           
           let imgUrl = URL(string: img)
           
           cell.Img.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
           cell.Img.sd_setImage(with: imgUrl, placeholderImage: UIImage(named: "No_Image"))
           
           cell.ServCountLbl.text = "Serves \(ShoppingListArr?.recipe?[indexPath.row].serving ?? "1")"
//.recipe?.serving ?? "0")"
           
           cell.MinusBtn.tag = indexPath.item
           cell.MinusBtn.addTarget(self, action: #selector(RecipeServCountMinusBtn(_:)), for: .touchUpInside)
           
           cell.plusBtn.tag = indexPath.item
           cell.plusBtn.addTarget(self, action: #selector(RecipeServCountPlusBtn(_:)), for: .touchUpInside)
           
           cell.RemoveBtn.tag = indexPath.item
           cell.RemoveBtn.addTarget(self, action: #selector(removeBtnClick(_:)), for: .touchUpInside)
            
           return cell
       }
    
    
    @objc func RecipeServCountMinusBtn(_ sender: UIButton) {
        var ServCount = Int(ShoppingListArr?.recipe?[sender.tag].serving ?? "1") ?? 1
        guard ServCount > 1 else{
            return
        }
        ServCount -= 1
        ShoppingListArr?.recipe?[sender.tag].serving = "\(ServCount)"
        self.yourRecipeCollV.reloadData()
        
        let uri = ShoppingListArr?.recipe?[sender.tag].uri ?? ""
        self.Api_To_Plus_Minus_ServesCount(uri: uri, Quenty: "\(ServCount)")
    }
    
    @objc func RecipeServCountPlusBtn(_ sender: UIButton) {
        var ServCount = Int(ShoppingListArr?.recipe?[sender.tag].serving ?? "1") ?? 1
        ServCount += 1
        ShoppingListArr?.recipe?[sender.tag].serving = "\(ServCount)"
        self.yourRecipeCollV.reloadData()
        
        let uri = ShoppingListArr?.recipe?[sender.tag].uri ?? ""
        self.Api_To_Plus_Minus_ServesCount(uri: uri, Quenty: "\(ServCount)")
    }
    
    
    @objc func removeBtnClick(_ sender: UIButton)   {
        let storyboard = UIStoryboard(name: "Basket", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "RemoveFromBaskedPopUpVC") as! RemoveFromBaskedPopUpVC
        vc.ID = "\(ShoppingListArr?.recipe?[sender.tag].id ?? 0)"
        vc.backAction = { id in
            self.Api_To_RemoveRecipes(Id: id)
        }
        self.addChild(vc)
        vc.view.frame = self.view.frame
        self.view.addSubview(vc.view)
        self.view.bringSubviewToFront(vc.view)
        vc.didMove(toParent: self)
    }
    
    
 
  
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Tabbar", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "RecipeDetailsVC") as! RecipeDetailsVC
        vc.uri = ShoppingListArr?.recipe?[indexPath.item].uri ?? ""
        
        let string = ShoppingListArr?.recipe?[indexPath.item].type ?? ""
        if let result = string.components(separatedBy: "/").first {
            vc.MealType = result
        }
        
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
 
       func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
           return CGSize(width: collectionView.frame.width/2.3 - 5, height: collectionView.frame.height)
       }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
     
            return 5
        }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            if section == 0 {
                return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 5)
            }else{
                return UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
            }
        }
   
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 5
        }
     }


extension Shopping_ListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ShoppingListArr?.ingredient?.count ?? 0 
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
            let cell = tableView.dequeueReusableCell(withIdentifier: "Shopping_ListTblVCell", for: indexPath) as! Shopping_ListTblVCell
       
     //   cell.NameLbl.text = ShoppingListArr?.ingredient?[indexPath.row].proName ?? ""
        
        
        
        cell.Countlbl.text = "\(ShoppingListArr?.ingredient?[indexPath.row].sch_id ?? 0)"
        
        
        let img = ShoppingListArr?.ingredient?[indexPath.item].pro_img ?? ""
        let imgUrl = URL(string: img)
        
        cell.Img.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
        cell.Img.sd_setImage(with: imgUrl, placeholderImage: UIImage(named: "No_Image"))
        
        let priceValue = ShoppingListArr?.ingredient?[indexPath.row].pro_price
        
        if img == "Not available" || img == "" && priceValue == "Not available" || priceValue == ""{
            
            let text = "\(ShoppingListArr?.ingredient?[indexPath.row].pro_name ?? "")\nNot Available"

            // Create an NSMutableAttributedString
            let attributedString = NSMutableAttributedString(string: text)

            // Apply black color to "Rice"
            if let riceRange = text.range(of: ShoppingListArr?.ingredient?[indexPath.row].pro_name ?? "") {
                let nsRange = NSRange(riceRange, in: text)
                attributedString.addAttribute(.foregroundColor, value: UIColor.black, range: nsRange)
            }

            // Apply gray color to "Not Available"
            if let notAvailableRange = text.range(of: "Not Available") {
                let nsRange = NSRange(notAvailableRange, in: text)
                attributedString.addAttribute(.foregroundColor, value: UIColor.gray, range: nsRange)
            }

            // Set the attributed string to the label
            cell.NameLbl.attributedText = attributedString
             
        }else{
            cell.NameLbl.text = ShoppingListArr?.ingredient?[indexPath.row].pro_name ?? ""
        }
        
        cell.MinusBtn.tag = indexPath.row
        cell.MinusBtn.addTarget(self, action: #selector(IngServCountMinusBtn(_:)), for: .touchUpInside)
        
        cell.PlusBtn.tag = indexPath.row
        cell.PlusBtn.addTarget(self, action: #selector(IngServCountPlusBtn(_:)), for: .touchUpInside)
        
            return cell
    }
    
    
    @objc func IngServCountMinusBtn(_ sender: UIButton) {
        var ServCount = ShoppingListArr?.ingredient?[sender.tag].sch_id ?? 1
        guard ServCount > 1 else{
            return
        }
        ServCount -= 1
        self.ShoppingListArr?.ingredient?[sender.tag].sch_id = ServCount
        self.IngredientsTblV.reloadData()
        
        let foodID = self.ShoppingListArr?.ingredient?[sender.tag].food_id ?? ""
        
        if foodID != ""{
            self.Api_To_Plus_Minus_ingredientsCount(FoodID: foodID, Quenty: "\(ServCount)")
        }
    }
    
    @objc func IngServCountPlusBtn(_ sender: UIButton) {
        var ServCount = self.ShoppingListArr?.ingredient?[sender.tag].sch_id ?? 1
        ServCount += 1
        self.ShoppingListArr?.ingredient?[sender.tag].sch_id = ServCount
        self.IngredientsTblV.reloadData()
        
        let foodID = self.ShoppingListArr?.ingredient?[sender.tag].food_id ?? ""
        if foodID != ""{
            self.Api_To_Plus_Minus_ingredientsCount(FoodID: foodID, Quenty: "\(ServCount)")
        }
    }
    
//    @objc func CheckBtnAction(_ sender: UIButton) {
//        let indexPath = IndexPath(row: sender.tag, section: 0)
//        ShoppingList[indexPath.row].isSelected.toggle()
//        IngredientsTblV.reloadData()
//    }
    
    
    // MARK: - Leading Swipe Actions (Left to Right)
 
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { _, _, completionHandler in
            // Remove the item from the data source
            let foodID = self.ShoppingListArr?.ingredient?[indexPath.row].food_id ?? ""
            
            self.ShoppingListArr?.ingredient?.remove(at: indexPath.row)
             
            if foodID != ""{
                self.Api_To_Plus_Minus_ingredientsCount(FoodID: foodID, Quenty: "0")
            }
            
            // Update the table view
            tableView.performBatchUpdates({
                tableView.deleteRows(at: [indexPath], with: .fade)
            }) { completed in
                // Step 3: Call the completion handler
                completionHandler(true)
            }
        }
        
        deleteAction.image = UIImage(named: "DeleteIcon 1") // Replace with actual image name
        deleteAction.backgroundColor = .white
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    //
    
      func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
      }
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return UITableView.automaticDimension
        }
    }

 
//
extension Shopping_ListVC{
    
    func getShopping_ListData() {
        var params:JSONDictionary = [:]
        
//        params["latitude"] = AppLocation.lat
//        params["longitude"] = AppLocation.long
        
        showIndicator(withTitle: "", and: "")
         
        let loginURL = baseURL.baseURL + appEndPoints.shopping_list
        print(params,"Params")
        print(loginURL,"loginURL")
       
        
        WebService.shared.postServiceURLEncoding(loginURL, VC: self, andParameter: params, withCompletion: { (json, statusCode) in
            
            self.hideIndicator()
            
            let data = try! json.rawData()
            do{
                 
                let d = try JSONDecoder().decode(basketModelClass.self, from: data)
                if d.success == true {
                    
                    let allData = d.data
                    
                    self.ShoppingListArr = allData ?? basketModelData()
                    
                    if self.ShoppingListArr?.recipe?.count ?? 0 > 0 {
                        self.YourRecipeBgV.isHidden = false
                    }else{
                        self.YourRecipeBgV.isHidden = true
                    }
                  
                    self.yourRecipeCollV.reloadData()
                    
                    self.IngredientsTblV.reloadData()
                    
                    self.SaveBtnO.isUserInteractionEnabled = false
                    self.SaveBtnO.backgroundColor = UIColor.lightGray
               
                }else{
                    
                    let msg = d.message ?? ""
                    self.showToast(msg)
                }
            }catch{
                
                print(error)
            }
        })
    }
    
    
    // for Recipes
    func Api_To_Plus_Minus_ServesCount(uri:String, Quenty:String){
        
        var params:JSONDictionary = [:]
        
        params["uri"] = uri
        params["quantity"] = Quenty
     
        
        showIndicator(withTitle: "", and: "")
        
        let loginURL = baseURL.baseURL + appEndPoints.add_to_basket
        
        print(loginURL,"loginURL")
        
        WebService.shared.postServiceURLEncoding(loginURL, VC: self, andParameter: params, withCompletion: { (json, statusCode) in
            
            self.hideIndicator()
            
            guard let dictData = json.dictionaryObject else{
                
                return
            }
            
            if dictData["success"] as? Bool == true{
              //  self.getShopping_ListData()
            }else{
                let responseMessage = dictData["message"] as! String
                self.showToast(responseMessage)
            }
        })
    }
    
    func Api_To_RemoveRecipes(Id:String){
        
        var params:JSONDictionary = [:]
        
        params["id"] = Id
         
      
        showIndicator(withTitle: "", and: "")
        
        let loginURL = baseURL.baseURL + appEndPoints.remove_basket
        
        print(loginURL,"loginURL")
        
        WebService.shared.postServiceURLEncoding(loginURL, VC: self, andParameter: params, withCompletion: { (json, statusCode) in
            
            self.hideIndicator()
            
            guard let dictData = json.dictionaryObject else{
                
                return
            }
            
            if dictData["success"] as? Bool == true{
              //  self.getShopping_ListData()
            }else{
                let responseMessage = dictData["message"] as! String
                self.showToast(responseMessage)
            }
        })
    }
    //
    
    // for ingredients
    func Api_To_Plus_Minus_ingredientsCount(FoodID:String, Quenty:String){
        
        var params:JSONDictionary = [:]
        
        params["food_id"] = FoodID
        params["quantity"] = Quenty
       
        showIndicator(withTitle: "", and: "")
        
        let loginURL = baseURL.baseURL + appEndPoints.change_cart
        
        print(loginURL,"loginURL")
        
        WebService.shared.postServiceURLEncoding(loginURL, VC: self, andParameter: params, withCompletion: { (json, statusCode) in
            
            self.hideIndicator()
            
            guard let dictData = json.dictionaryObject else{
                
                return
            }
            
            if dictData["success"] as? Bool == true{
              //  self.getShopping_ListData()
            }else{
                let responseMessage = dictData["message"] as! String
                self.showToast(responseMessage)
            }
        })
    }
    //
    
        func Api_To_GetIngredientDislikes(){
            var params = [String: Any]()
           let type = UserDetail.shared.getUserType()
            
            if type == "MySelf"{
                params["type"] = "1"
                 
            }else if type == "Partner"{
                params["type"] = "2"
            }else{
                params["type"] = "3"
            }
    //        let delegate = AppDelegate.shared
    //        let token = delegate.deviceToken
    //        params["device_token"] = token
             
            showIndicator(withTitle: "", and: "")
          //  https://myka.tgastaging.com/api/dislike_ingredients/40/apple
            let loginURL = baseURL.baseURL + appEndPoints.dislikeIngredients + "/\(moreCount)/\(self.ItemNameTxtF.text!)"
            print(params,"Params")
            print(loginURL,"loginURL")
            
            WebService.shared.getServiceURLEncodingwithParams(loginURL, VC: self, andParameter: params, withCompletion: { (json, statusCode) in
                
                self.hideIndicator()
                
                guard let dictData = json.dictionaryObject else{
                    return
                }
                
                if dictData["success"] as? Bool == true{
                    let responseArray = dictData["data"] as? [[String : Any]] ?? [[String: Any]]()
                    
                    self.DislikesIngredientArr.removeAll()
                    self.DislikesIngredientArr = ModelClass.getBodyGoalsDetails(responseArray: responseArray)
                    
                    DispatchQueue.main.async {
                        if self.DislikesIngredientArr.isEmpty{
                            self.dropDown.hide()
                        }else{
                            self.dropDown.dataSource = self.DislikesIngredientArr.map { $0.name }
                            self.dropDown.anchorView = self.SearchBgV
                            self.dropDown.bottomOffset = CGPoint(x: 0, y: self.SearchBgV.frame.size.height)
                            self.dropDown.width = self.SearchBgV.frame.width
                            self.dropDown.direction = .bottom
                            self.dropDown.show()
                            self.dropDown.setupCornerRadius(10)
                            self.dropDown.backgroundColor = .white
                            self.dropDown.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
                            self.dropDown.layer.shadowOpacity = 0
                            self.dropDown.layer.shadowRadius = 4
                            self.dropDown.layer.shadowOffset = CGSize(width: 0, height: 0)
                            self.dropDown.selectionAction = { [self] (index: Int, item: String) in
                                print(index)
                                self.ItemNameTxtF.text = item
                            }
                         
                            self.dropDown.show()
                        }
                    }
                    
                }else{
                    let responseMessage = dictData["message"] as! String
                    self.showToast(responseMessage)
                }
            })
        }
    
    
    func Api_To_SaveIngedients(){
        var params = [String: Any]()
        
        var foodIds : [String] = []
        var names : [String] = []
        var Status : [String] = []
        var schID : [String] = []
        
        for indx in 0..<(self.ShoppingListArr?.ingredient?.count ?? 0) {
            let ServCount = self.ShoppingListArr?.ingredient?[indx].quantity ?? 1
            let name = self.ShoppingListArr?.ingredient?[indx].pro_name  ?? ""
            let foodid = self.ShoppingListArr?.ingredient?[indx].food_id ?? ""
            
            if foodid == ""{
                let uniqueNumber = generateUniqueFiveDigitNumber()
                foodIds.append("\(uniqueNumber)")
                names.append(name)
                schID.append("\(ServCount)")
                Status.append("3")
            }
        }
        
        params["food_ids"] = foodIds
        params["sch_id"] = schID
        params["names"] = names
        params["status"] = Status
      
        
        showIndicator(withTitle: "", and: "")
        let loginURL = baseURL.baseURL + appEndPoints.add_to_cart
        
        print("Parameters:", params)
        
        WebService.shared.postServiceURLEncoding(loginURL, VC: self, andParameter: params, withCompletion: { (json, statusCode) in
            
            self.hideIndicator()
            
            guard let dictData = json.dictionaryObject else{
                return
            }
        
            if dictData["success"] as? Bool == true{
              //  let responseMessage = dictData["message"] as? String ?? ""
                self.showToast("Saved successfully.")
                self.getShopping_ListData()
               }else{
                   let responseMessage = dictData["message"] as? String ?? ""
                   self.showToast(responseMessage)
               }
          })
         }
    
    func generateUniqueFiveDigitNumber() -> Int {
        // Generate a random 5-digit number between 10000 and 99999
        return Int.random(in: 10000...99999)
    }
    }

