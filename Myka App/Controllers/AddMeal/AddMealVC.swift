//
//  AddMealVC.swift
//  Myka App
//
//  Created by Sumit on 11/12/24.
//

import UIKit
import Alamofire
import SDWebImage
import DropDown

class AddMealVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var SearchTxtF: UITextField!
    
    @IBOutlet weak var DishNameLbl: UILabel!
    
    @IBOutlet weak var Img: UIImageView!
    @IBOutlet weak var TblV: UITableView!
    @IBOutlet weak var TblVH: NSLayoutConstraint!
    
    @IBOutlet weak var FridgeLbl: UILabel!
    @IBOutlet weak var FreezerLbl: UILabel!
    
    @IBOutlet weak var FridgeBtnO: UIButton!
    @IBOutlet weak var FreezerBtnO: UIButton!
    @IBOutlet weak var DateCoodedLbl: UILabel!
    @IBOutlet weak var SuccessFullLbl: UILabel!
    
    @IBOutlet weak var SearchBgV: UIView!
    @IBOutlet weak var SearchBtnO: UIButton!
    @IBOutlet weak var AddMealBtnO: UIButton!
    
    var backAction:() -> () = { }
    
    var backActionn:(Int) -> () = { _ in }
    
    var seldate: Date?
    
    var SearchAllRecipeArr = [RecipeElement]() // Main arr APi
    
    var SelSearchAllRecipeArr = [RecipeElement]() // To Show Selected in TblV.
    
    var ServCount = 1
    
    var SearchDropDown = DropDown()
    
    
    var MealTypeArr = [ModelClass]()
    
    var MealTypeDropDown = DropDown()
    
    var expandedRow: Int?
    
    var textChangedWorkItem: DispatchWorkItem?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        SearchBtnO.isHidden = true
        self.SearchTxtF.delegate = self
        
        self.Img.layer.cornerRadius = self.Img.layer.frame.height/2
        self.Img.layer.masksToBounds = true
        
        self.TblV.register(UINib(nibName: "AddMealTblVCell", bundle: nil), forCellReuseIdentifier: "AddMealTblVCell")
        self.TblV.delegate = self
        self.TblV.dataSource = self
        
        self.SuccessFullLbl.isHidden = true
        
        self.AddMealBtnO.backgroundColor = #colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
        self.AddMealBtnO.isUserInteractionEnabled = false
        
        self.FridgeLbl.backgroundColor = UIColor.init(red: 254/255, green: 159/255, blue: 69/255, alpha: 1)
        self.FreezerLbl.backgroundColor = UIColor.init(red: 255/255, green: 247/255, blue: 240/255, alpha: 1)
        
        self.FridgeLbl.textColor = UIColor.white
        self.FreezerLbl.textColor = UIColor.init(red: 60/255, green: 69/255, blue: 65/255, alpha: 1)
        
        self.FridgeLbl.font = UIFont.init(name: "Poppins Medium", size: 16)
        self.FreezerLbl.font = UIFont.init(name: "Poppins Regular", size: 16)
        
        self.FridgeBtnO.isSelected = true
        self.FridgeLbl.text = "Fridge (\(SelSearchAllRecipeArr.count))"
        self.FreezerBtnO.isSelected = false
        self.FreezerLbl.text = "Freezer (0)"
        
        self.Api_To_GetMealType()
        self.SearchTxtF.addTarget(self, action: #selector(TextSearch(sender: )), for: .editingChanged)
        //
        
        // Observe contentSize changes
        TblV.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        //
    }
    
    
    deinit {
        // Remove observer to avoid memory leaks
        TblV.removeObserver(self, forKeyPath: "contentSize")
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize" {
            updateTableViewHeight()
        }
    }
    
    private func updateTableViewHeight() {
        // Update the height constraint with the tableView's contentSize height
        TblVH.constant = TblV.contentSize.height
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.TblV.reloadData()
            self.TblV.layoutIfNeeded()
            self.TblVH.constant = self.TblV.contentSize.height
            self.TblV.layoutIfNeeded()
        }
    }
    
    
    @objc func TextSearch(sender: UITextField){
        let searchText = SearchTxtF.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
        // Check if the search text has changed
        // Cancel the previous work item
        textChangedWorkItem?.cancel()
        
        // Create a new debounced work item
        textChangedWorkItem = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            
            self.hideIndicator()
            self.Api_To_GetAllMealsRecipe(Serach: searchText)
        }
        
        // Schedule the work item to execute after a debounce time (e.g., 1 second)
        if let workItem = textChangedWorkItem {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: workItem)
        }
    }
    //    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
    //        if self.SearchTxtF.text != ""{
    //            self.SearchBtnO.isHidden == false
    //        }else{
    //            self.SearchBtnO.isHidden == true
    //        }
    //    }
    
    //    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    //        // Determine the new text after the proposed change
    //        let currentText = textField.text ?? ""
    //        guard let textRange = Range(range, in: currentText) else {
    //            return true
    //        }
    //        let updatedText = currentText.replacingCharacters(in: textRange, with: string)
    //
    //        // Update the visibility of the search button
    //         self.SearchBtnO.isHidden = updatedText.isEmpty
    //
    //        return true
    //    }
    
    
    @IBAction func BackBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    //    @IBAction func SearchBtn(_ sender: UIButton) {
    //        let txt = self.SearchTxtF.text ?? ""
    //        self.Api_To_GetAllMealsRecipe(Serach: txt)
    //    }
    
    @IBAction func AddMealBtn(_ sender: UIButton) {
        let SubscriptionStatus = Int(UserDetail.shared.getSubscriptionStatus())
        
        if SubscriptionStatus == 1{
            let addtoplanStatus = Int(UserDetail.shared.getaddmeal()) ?? 0
            guard addtoplanStatus == 0 else {
                SubscriptionPopUp ()
                return
            }
        }
        
        self.Api_For_AddMeal()
        // self.backAction()
        // self.navigationController?.popToViewController(ofClass: YourCoockedMealVC.self, animated: true)
    }
   
    
    func SubscriptionPopUp()  {
        let storyboard = UIStoryboard(name: "Subscription", bundle: nil)
        
        let vc = storyboard.instantiateViewController(withIdentifier: "SubscriptionPopUpVC") as! SubscriptionPopUpVC
        vc.BackAction = {
            let storyboard = UIStoryboard(name: "Subscription", bundle: nil)
            
            let vc = storyboard.instantiateViewController(withIdentifier: "BupPlanVC") as! BupPlanVC
            vc.comesfrom = "Profile"
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        self.addChild(vc)
        vc.view.frame = self.view.frame
        self.view.addSubview(vc.view)
        self.view.bringSubviewToFront(vc.view)
        vc.didMove(toParent: self)
    }
    
    @IBAction func FridgeBtn(_ sender: UIButton) {
        self.FridgeLbl.backgroundColor = UIColor.init(red: 254/255, green: 159/255, blue: 69/255, alpha: 1)
        self.FreezerLbl.backgroundColor = UIColor.init(red: 255/255, green: 247/255, blue: 240/255, alpha: 1)
        
        self.FridgeLbl.textColor = UIColor.white
        self.FreezerLbl.textColor = UIColor.init(red: 60/255, green: 69/255, blue: 65/255, alpha: 1)
        
        self.FridgeLbl.font = UIFont.init(name: "Poppins Medium", size: 16)
        self.FreezerLbl.font = UIFont.init(name: "Poppins Regular", size: 16)
        
        self.FridgeLbl.text = "Fridge (\(SelSearchAllRecipeArr.count))"
        self.FreezerLbl.text = "Freezer (0)"
        
        self.FridgeBtnO.isSelected = true
        self.FreezerBtnO.isSelected = false
        
    }
    
    
    
    @IBAction func FreezerBtn(_ sender: UIButton) {
        self.FridgeLbl.backgroundColor = UIColor.init(red: 255/255, green: 247/255, blue: 240/255, alpha: 1)
        self.FreezerLbl.backgroundColor = UIColor.init(red: 254/255, green: 159/255, blue: 69/255, alpha: 1)
        
        self.FridgeLbl.textColor = UIColor.init(red: 60/255, green: 69/255, blue: 65/255, alpha: 1)
        self.FreezerLbl.textColor = UIColor.white
        
        self.FreezerLbl.font = UIFont.init(name: "Poppins Medium", size: 16)
        self.FridgeLbl.font = UIFont.init(name: "Poppins Regular", size: 16)
        
        self.FridgeLbl.text = "Fridge (0)"
        self.FreezerLbl.text = "Freezer (\(SelSearchAllRecipeArr.count))"
        
        
        self.FridgeBtnO.isSelected = false
        self.FreezerBtnO.isSelected = true
    }
    
    
    @IBAction func CalanderBtn(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "Tabbar", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "CalendarVC") as! CalendarVC
        vc.seldate = self.seldate ?? Date()
        vc.backAction = {date in
            self.seldate = date
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMM yyyy"
            let formattedDate = dateFormatter.string(from: self.seldate ?? Date())
            self.DateCoodedLbl.text = formattedDate
            if self.SelSearchAllRecipeArr.count != 0 && self.seldate != nil{
                self.AddMealBtnO.backgroundColor = #colorLiteral(red: 0.02352941176, green: 0.7568627451, blue: 0.4117647059, alpha: 1)
                self.AddMealBtnO.isUserInteractionEnabled = true
            }else{
                self.AddMealBtnO.backgroundColor = #colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
                self.AddMealBtnO.isUserInteractionEnabled = false
            }
        }
        self.addChild(vc)
        vc.view.frame = self.view.frame
        self.view.addSubview(vc.view)
        self.view.bringSubviewToFront(vc.view)
        vc.didMove(toParent: self)
    }
}


extension AddMealVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.SelSearchAllRecipeArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddMealTblVCell", for: indexPath) as! AddMealTblVCell
        
        let string = self.SelSearchAllRecipeArr[indexPath.row].recipe?.mealType?.first ?? ""
        if let result = string.components(separatedBy: "/").first {
            let type = result.capitalizedFirst
            if type == "Snack"{
                cell.NameLbl.text = "Snacks"
            }else{
                cell.NameLbl.text = result.capitalizedFirst
            }
        }
        
        let imgUrlStr = self.SelSearchAllRecipeArr[indexPath.row].recipe?.images?.small?.url ?? ""
        
        cell.Img.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
        cell.Img.sd_setImage(with: URL(string: imgUrlStr), placeholderImage: UIImage(named: "No_Image"))
        
        cell.ServiceCountLbl.text = "Serves \(ServCount)"
        
        if expandedRow == 1 {
            cell.DropImg.image = UIImage(named: "DropUpDark")
        } else {
            cell.DropImg.image = UIImage(named: "DropDownDark")
        }
        
        cell.MinusBtn.tag = indexPath.row
        cell.MinusBtn.addTarget(self, action: #selector(ServCountMinusBtn(_:)), for: .touchUpInside)
        
        cell.PlusBtn.tag = indexPath.row
        cell.PlusBtn.addTarget(self, action: #selector(ServCountPlusBtn(_:)), for: .touchUpInside)
        
        cell.DropDownBtn.tag = indexPath.row
        cell.DropDownBtn.addTarget(self, action: #selector(DropDownBtn(_:)), for: .touchUpInside)
        
        return cell
    }
     
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    
    @objc func DropDownBtn(_ sender: UIButton) {
        if expandedRow == 1 {
            expandedRow = nil // Collapse if the same row is clicked again
        } else {
            expandedRow = 1 // Expand the selected row
        }
        
        self.MealTypeDropDown.dataSource = self.MealTypeArr.map { String($0.name) }
        MealTypeDropDown.anchorView = sender
        
        // Add trailing space (adjust x for horizontal offset)
        let trailingSpace: CGFloat = 0 // Adjust as needed
        MealTypeDropDown.bottomOffset = CGPoint(x: -trailingSpace, y: sender.bounds.height + 15)
        MealTypeDropDown.topOffset = CGPoint(x: -trailingSpace, y: -(MealTypeDropDown.anchorView?.plainView.bounds.height ?? 0))
        // MealTypeDropDown.width = 140
        MealTypeDropDown.setupCornerRadius(10)
        
        // Optional: You may also need to disable shadow for proper clipping
        MealTypeDropDown.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        MealTypeDropDown.layer.shadowOpacity = 0
        MealTypeDropDown.layer.shadowRadius = 4
        MealTypeDropDown.layer.shadowOffset = CGSize(width: 0, height: 0)
        MealTypeDropDown.backgroundColor = .white
        MealTypeDropDown.cellHeight = 35
        MealTypeDropDown.textFont = UIFont(name: "Poppins Medium", size: 16.0) ??  UIFont.systemFont(ofSize: 16)
        
        // Set the cancel action
        MealTypeDropDown.cancelAction = { [unowned self] in
            print("Drop down dismissed")
            self.expandedRow = nil
            self.TblV.reloadData()
        }
        
        MealTypeDropDown.selectionAction = { [weak self] (index: Int, item: String) in
            guard let self = self else { return }
            print(index)
            self.SelSearchAllRecipeArr[sender.tag].recipe?.mealType?.removeAll()
            self.SelSearchAllRecipeArr[sender.tag].recipe?.mealType?.append(item)
            self.expandedRow = nil
            self.TblV.reloadData()
        }
        self.TblV.reloadData()
        
        MealTypeDropDown.show()
    }
    
    
    
    
    
    @objc func ServCountMinusBtn(_ sender: UIButton) {
        guard ServCount != 1 else{
            return
        }
        self.ServCount -= 1
        self.TblV.reloadData()
    }
    
    @objc func ServCountPlusBtn(_ sender: UIButton) {
        self.ServCount += 1
        self.TblV.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

//SearchModelClass
extension AddMealVC {
    func Api_To_GetAllMealsRecipe(Serach: String){
        var params = [String: Any]()
        
        params["q"] = Serach
   
        
        showIndicator(withTitle: "", and: "")
        
        let loginURL = baseURL.baseURL + appEndPoints.recipe
        print(params,"Params")
        print(loginURL,"loginURL")
        
        WebService.shared.postServiceURLEncoding(loginURL, VC: self, andParameter: params, withCompletion: { (json, statusCode) in
            
            self.hideIndicator()
            
            let data = try! json.rawData()
            
            do{
                let d = try JSONDecoder().decode(SearchModelClass.self, from: data)
                if d.success == true {
                    if let list = d.data, list.recipes != nil {
                        self.SearchAllRecipeArr  = list.recipes ?? []
                        
                        print(self.SearchAllRecipeArr.count, "count")
                        
                        if self.SearchAllRecipeArr.count == 0{
                            self.showToast("Result not found.")
                        }
                        
                        self.SearchDropDown.dataSource = self.SearchAllRecipeArr.map({$0.recipe?.label ?? ""})
                       
                        
                        self.SearchDropDown.anchorView = self.SearchBgV
                        
                        // Add trailing space (adjust x for horizontal offset)
                        let trailingSpace: CGFloat = 0// Adjust as needed
                        self.SearchDropDown.bottomOffset = CGPoint(x: -trailingSpace, y: self.SearchBtnO.bounds.height + 15)
                        self.SearchDropDown.topOffset = CGPoint(x: -trailingSpace, y: -(self.SearchDropDown.anchorView?.plainView.bounds.height ?? 0))
                        //        LevelDropDown.width = 80
                        self.SearchDropDown.setupCornerRadius(10)
                        
                        // Optional: You may also need to disable shadow for proper clipping
                        self.SearchDropDown.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
                        self.SearchDropDown.layer.shadowOpacity = 0
                        self.SearchDropDown.layer.shadowRadius = 4
                        self.SearchDropDown.layer.shadowOffset = CGSize(width: 0, height: 0)
                        self.SearchDropDown.backgroundColor = .white
                        self.SearchDropDown.cellHeight = 35
                        self.SearchDropDown.textFont = UIFont(name: "Poppins Medium", size: 16.0) ??  UIFont.systemFont(ofSize: 16)
                        
                        
                        self.SearchDropDown.selectionAction = { [weak self] (index: Int, item: String) in
                            guard let self = self else { return }
                            print(index)
                            self.SelSearchAllRecipeArr.removeAll()
                            self.SelSearchAllRecipeArr.append(self.SearchAllRecipeArr[index])
                            
                            let DishName = self.SelSearchAllRecipeArr.first?.recipe?.label ?? ""
                            
                            self.DishNameLbl.text = DishName
                            
                            let imgUrlStr = self.SelSearchAllRecipeArr.first?.recipe?.images?.small?.url ?? ""
                            
                            self.Img.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
                            self.Img.sd_setImage(with: URL(string: imgUrlStr), placeholderImage: UIImage(named: "No_Image"))
                            
                            
                            
                            self.SearchTxtF.text = ""
                            
                            self.TblV.reloadData()
                            
                            if self.SelSearchAllRecipeArr.count != 0 && self.seldate != nil{
                                self.AddMealBtnO.backgroundColor = #colorLiteral(red: 0.02352941176, green: 0.7568627451, blue: 0.4117647059, alpha: 1)
                                self.AddMealBtnO.isUserInteractionEnabled = true
                            }else{
                                self.AddMealBtnO.backgroundColor = #colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
                                self.AddMealBtnO.isUserInteractionEnabled = false
                            }
                            
                            print("Fridge", self.SelSearchAllRecipeArr.count)
                            
                            if self.FridgeBtnO.isSelected == true{
                                self.FridgeLbl.text = "Fridge (\(self.SelSearchAllRecipeArr.count))"
                                self.FreezerLbl.text = "Freezer (0)"
                            }else{
                                self.FridgeLbl.text = "Fridge (0)"
                                self.FreezerLbl.text = "Freezer (\(self.SelSearchAllRecipeArr.count))"
                            }
                        }
                        
                        
                        
                        self.SearchDropDown.show()
                    }
                }else{
                    self.SearchAllRecipeArr.removeAll()
                    let msg = d.message ?? ""
                    self.showToast(msg)
                }
            }catch{
                print(error)
            }
        })
    }
}
//
extension AddMealVC {
    func Api_For_AddMeal(){
        var params = [String: Any]()
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy-MM-dd"
        let Sdate = dateformatter.string(from: seldate ?? Date())
        
        let uri = SelSearchAllRecipeArr.first?.recipe?.uri ?? ""
        
        let meal = SelSearchAllRecipeArr.first?.recipe?.mealType?.first ?? ""
        let components = meal.components(separatedBy: "/")
        let MealType = components.first ?? ""
       // let MealType = (components.first ?? "").capitalized
        
        params["type"] = MealType
        
        if FridgeBtnO.isSelected{
            params["plan_type"] = "1"
        }else{
            params["plan_type"] = "2"
        }
        
        params["uri"] = uri
        params["date"] = Sdate
        params["serving"] = ServCount
        //
   
        
        showIndicator(withTitle: "", and: "")
        
        let loginURL = baseURL.baseURL + appEndPoints.AddMeal
        print(params,"Params")
        print(loginURL,"loginURL")
        
        WebService.shared.postServiceURLEncoding(loginURL, VC: self, andParameter: params, withCompletion: { (json, statusCode) in
            
            self.hideIndicator()
            
            guard let dictData = json.dictionaryObject else{
                return
            }
            
            let Msg = dictData["message"] as? String ?? ""
            
         //   self.navigationController?.popViewController(animated: true)
            
            if dictData["success"] as? Bool == true{
                
                self.Img.image = UIImage(named: "Group 1171276558")
                self.SuccessFullLbl.isHidden = false
                self.showToast(Msg)
                self.backActionn(0)
                DispatchQueue.main.asyncAfter(deadline: .now() + 3){
                    self.navigationController?.popViewController(animated: true)
                }
            }else{
                self.showToast(Msg)
            }
        })
    }
    
    
    func Api_To_GetMealType(){
        var params = [String: Any]()
        
        //        let delegate = AppDelegate.shared
        //        let token = delegate.deviceToken
        //        params["device_token"] = token
        
        showIndicator(withTitle: "", and: "")
        
        let loginURL = baseURL.baseURL + appEndPoints.mealRoutine
        print(params,"Params")
        print(loginURL,"loginURL")
        
        WebService.shared.getServiceURLEncodingwithParams(loginURL, VC: self, andParameter: params, withCompletion: { (json, statusCode) in
            
            self.hideIndicator()
            
            guard let dictData = json.dictionaryObject else{
                return
            }
            
            if dictData["success"] as? Bool == true{
                let responseArray = dictData["data"] as? [[String : Any]] ?? [[String: Any]]()
                
                self.MealTypeArr.removeAll()
                self.MealTypeArr = ModelClass.getBodyGoalsDetails(responseArray: responseArray)
                
            }else{
                let responseMessage = dictData["message"] as! String
                self.showToast(responseMessage)
            }
        })
    }
}

