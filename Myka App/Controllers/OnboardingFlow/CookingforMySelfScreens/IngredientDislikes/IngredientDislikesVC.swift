//
//  IngredientDislikesVC.swift
//  Myka App
//
//  Created by YES IT Labs on 28/11/24.
//

import UIKit
import Alamofire
import SwiftyJSON

class IngredientDislikesVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var TblV: UITableView!
    @IBOutlet weak var ProgressLbl: UILabel!
    @IBOutlet weak var SearchTxt: UITextField!
    @IBOutlet weak var TitleLbl: UILabel!
    @IBOutlet weak var SubTitleLbl: UILabel!
    
    @IBOutlet weak var SearchBgV: UIView!
    @IBOutlet weak var SearchBgVH: NSLayoutConstraint!
    
    @IBOutlet weak var NextBtnO: UIButton!
    @IBOutlet weak var NextbtnStackV: UIStackView!
    @IBOutlet weak var UpdateBtnO: UIButton!
    
    var type = ""
    var comesfrom = ""
    
    var DislikesIngredientArr = [ModelClass]()
    
    var ArrData = [BodyGoalsModel]()
    
    var ArrData1 = [BodyGoalsModel]()
    
    var moreCount = 10
    
    var textChangedWorkItem: DispatchWorkItem?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        if comesfrom == ""{
            self.NextbtnStackV.isHidden = false
            self.UpdateBtnO.isHidden = true
        }else{
            self.NextbtnStackV.isHidden = true
            self.UpdateBtnO.isHidden = false
        }
        
        self.TblV.register(UINib(nibName: "BodyGoalTblVCell", bundle: nil), forCellReuseIdentifier: "BodyGoalTblVCell")
        self.TblV.delegate = self
        self.TblV.dataSource = self
        
        self.TblV.separatorStyle = .none
        
        NextBtnO.setBackgroundImage(UIImage(named: "ButtonGray"), for: .normal)
        NextBtnO.isUserInteractionEnabled = false
         
        let Attributes1: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.black
        ]
        let Attributes2: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.init(red: 6/255, green: 193/255, blue: 105/255, alpha: 1)
        ]
         
        if self.type == "MySelf"{
            self.SearchBgV.isHidden = false
            self.SearchBgVH.constant = 35
            
            self.ProgressLbl.text = "4/10"
            let progressVw = Float(4) / Float(10)
            progressView.progress = Float(progressVw)
            
//            let helloString = NSAttributedString(string: "Ingredient", attributes: Attributes1)
//            let worldString = NSAttributedString(string: " Dislikes", attributes: Attributes2)
//            let fullString = NSMutableAttributedString()
//            fullString.append(helloString)
//            fullString.append(worldString)
//            self.TitleLbl.attributedText = fullString
            self.SubTitleLbl.text = "Pick or search the ingredients you dislike"
             
        }else if self.type == "Partner"{
            self.SearchBgV.isHidden = false
            self.SearchBgVH.constant = 35
            
            self.ProgressLbl.text = "4/11"
            let progressVw = Float(4) / Float(11)
            progressView.progress = progressVw
             
//            let helloString = NSAttributedString(string: "Ingredient", attributes: Attributes1)
//            let worldString = NSAttributedString(string: " Dislikes", attributes: Attributes2)
//            let fullString = NSMutableAttributedString()
//            fullString.append(helloString)
//            fullString.append(worldString)
//            self.TitleLbl.attributedText = fullString
            self.SubTitleLbl.text = "Search and select the ingredients you and your partner dislike" 
        }else{
            self.SearchBgV.isHidden = false
            self.SearchBgVH.constant = 35
            
            self.ProgressLbl.text = "4/11"
            let progressVw = Float(4) / Float(11)
            progressView.progress = progressVw
             
//            let helloString = NSAttributedString(string: "Ingredient", attributes: Attributes1)
//            let worldString = NSAttributedString(string: " Dislikes", attributes: Attributes2)
//            let fullString = NSMutableAttributedString()
//            fullString.append(helloString)
//            fullString.append(worldString)
//            self.TitleLbl.attributedText = fullString
            self.SubTitleLbl.text = "Search and select the ingredients you and your family members dislike"
        }
        
        
        
        self.SearchTxt.delegate = self
        self.SearchTxt.addTarget(self, action: #selector(TextSearch(sender: )), for: .editingChanged)
        
        if comesfrom == ""{
            self.Api_To_GetIngredientDislikes()
        }else{
            self.Api_To_GetPrefrenceBodyGoals()
        }
    }
    
    @objc func TextSearch(sender: UITextField){
        if self.SearchTxt.text == ""{
            textChangedWorkItem?.cancel()
            self.moreCount = 10
            if comesfrom == ""{
                self.Api_To_GetIngredientDislikes()
            }else{
                self.Api_To_GetPrefrenceBodyGoals()
            }
        }else{
            //let searchText = SearchTxt.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            // Cancel the previous work item
            textChangedWorkItem?.cancel()
            
            // Create a new debounced work item
            textChangedWorkItem = DispatchWorkItem { [weak self] in
                guard let self = self else { return }
                
                self.hideIndicator()
                self.moreCount = 100
                if comesfrom == ""{
                    self.Api_To_GetIngredientDislikes()
                }else{
                    self.Api_To_GetPrefrenceBodyGoals()
                }
            }
            
            // Schedule the work item to execute after a debounce time (e.g., 1 second)
            if let workItem = textChangedWorkItem {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: workItem)
            }
        }
 
    }
    
//    @IBAction func SearchBtn(_ sender: UIButton) {
//        self.moreCount = 10
//        if comesfrom == ""{
//            if self.SearchTxt.text?.count ?? 0 >= 3{
//                self.Api_To_GetIngredientDislikes()
//            }
//        }else{
//            if self.SearchTxt.text?.count ?? 0 >= 3{
//                self.Api_To_GetPrefrenceBodyGoals()
//            }
//        }
//    }
        
        @IBAction func BackBtn(_ sender: UIButton) {
            self.navigationController?.popViewController(animated: false)
        }
        
        @IBAction func SkipBtn(_ sender: UIButton) {
            let storyboard = UIStoryboard(name: "CookingForMySelf", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "SkipPopupVC") as! SkipPopupVC
            vc.backAction = {
                for index in 0..<self.ArrData.count {
                    self.ArrData[index].isSelected = false
                    }
                StateMangerModelClass.shared.onboardingSelectedData.MySelfSeldata[0].DislikeIngredient.removeAll()
                
                self.NextBtnO.setBackgroundImage(UIImage(named: "ButtonGray"), for: .normal)
                self.NextBtnO.isUserInteractionEnabled = false
                self.TblV.reloadData()
                
                let storyboard = UIStoryboard(name: "CookingForMySelf", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "AllergensIngredientsVC") as! AllergensIngredientsVC
                vc.type = self.type
                self.navigationController?.pushViewController(vc, animated: false)
                
            }
            vc.modalPresentationStyle = .overCurrentContext
            self.present(vc, animated: false)
        }
        
        @IBAction func NextBtn(_ sender: UIButton) {
            let storyboard = UIStoryboard(name: "CookingForMySelf", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "AllergensIngredientsVC") as! AllergensIngredientsVC
            vc.type = self.type
            self.navigationController?.pushViewController(vc, animated: false)
        }
    
    @IBAction func UpdateBtn(_ sender: UIButton) {
        self.Api_To_UpdatePrefrence()
    }
 }

    extension IngredientDislikesVC: UITableViewDelegate, UITableViewDataSource {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return ArrData.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BodyGoalTblVCell", for: indexPath) as! BodyGoalTblVCell
            cell.NameLbl.text = ArrData[indexPath.row].Name
            
            if ArrData[indexPath.row].Name == "More"{
                cell.NameLbl.font = UIFont(name: "Poppins Bold", size: 16.0)
            }else{
                cell.NameLbl.font = UIFont(name: "Poppins Regular", size: 16.0)
            }
            
            cell.TickImg.image = ArrData[indexPath.row].isSelected ? UIImage(named: "Tick1") : UIImage(named: "")
            cell.selectedBgImg.image = ArrData[indexPath.row].isSelected ? UIImage(named: "YelloBorder") : UIImage(named: "Group 1171276489")
            cell.selectionStyle = .none
            return cell
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           
            if ArrData[indexPath.row].Name == "None" {
                for i in 0..<ArrData.count {
                    ArrData[i].isSelected = false
                }
                ArrData[indexPath.row].isSelected = true
            }else{
                if ArrData[indexPath.row].isSelected {
                    ArrData[indexPath.row].isSelected = false
                }else{
                    for index in 0..<ArrData.count {
                        if ArrData[index].Name == "None" && ArrData[index].isSelected == true{
                            ArrData[index].isSelected = false
                        }
                    }
               
                    ArrData[indexPath.row].isSelected = true
                }
            }

            
            if ArrData.allSatisfy({ ($0.isSelected) == false }) {
                // All items are unselected
                print("All items are unselected.")
                NextBtnO.setBackgroundImage(UIImage(named: "ButtonGray"), for: .normal)
                NextBtnO.isUserInteractionEnabled = false
            } else {
                // At least one item is selected
                print("Some items are selected.")
                NextBtnO.setBackgroundImage(UIImage(named: "Button"), for: .normal)
                NextBtnO.isUserInteractionEnabled = true
            }
            
            var DislikeIngredientArr = [String]()
            
            for i in 0..<ArrData.count {
                if ArrData[i].isSelected {
                    DislikeIngredientArr.append("\(ArrData[i].id ?? Int())")
                }
            }
            
            if self.ArrData[indexPath.row].Name == "More"{
                //self.ArrData = self.ArrData1
               // self.TblV.reloadData()
                self.moreCount += 10
                if comesfrom == ""{
                    self.Api_To_GetIngredientDislikes()
                }else{
                    self.Api_To_GetPrefrenceBodyGoals()
                }
                
                
            }
            
            StateMangerModelClass.shared.onboardingSelectedData.MySelfSeldata[0].DislikeIngredient = DislikeIngredientArr
            
            TblV.reloadData()
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 60
        }
    }

extension IngredientDislikesVC {
    func Api_To_GetIngredientDislikes(){
        var params = [String: Any]()
        if self.type == "MySelf"{
            params["type"] = "1"
             
        }else if self.type == "Partner"{
            params["type"] = "2"
        }else{
            params["type"] = "3"
        }
//        let delegate = AppDelegate.shared
//        let token = delegate.deviceToken
//        params["device_token"] = token
         
        showIndicator(withTitle: "", and: "")
      //  https://myka.tgastaging.com/api/dislike_ingredients/40/apple
        let loginURL = baseURL.baseURL + appEndPoints.dislikeIngredients + "/\(moreCount)/\(self.SearchTxt.text!)"
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
                self.ArrData.removeAll()
                self.ArrData1.removeAll()
                
                for i in self.DislikesIngredientArr{
                    self.ArrData1.append(contentsOf: [BodyGoalsModel(Name: i.name, id: i.id, isSelected: false)])
                }
                
                self.ArrData1.insert(contentsOf: [BodyGoalsModel(Name: "None", id: nil, isSelected: false)], at: 0)
                 
//                for i in 0..<self.ArrData1.count{
//                    if i <= 2{
//                        self.ArrData.append(contentsOf: [self.ArrData1[i]])
//                    }
//                }
                
                self.ArrData = self.ArrData1
                
                if self.SearchTxt.text?.count ?? 0 == 0{
                    self.ArrData.append(contentsOf: [BodyGoalsModel(Name: "More", id: nil, isSelected: false)])
                }
                
                if self.ArrData.allSatisfy({ ($0.isSelected) == false }) {
                    // All items are unselected
                    print("All items are unselected.")
                    self.NextBtnO.setBackgroundImage(UIImage(named: "ButtonGray"), for: .normal)
                    self.NextBtnO.isUserInteractionEnabled = false
                } else {
                    // At least one item is selected
                    print("Some items are selected.")
                    self.NextBtnO.setBackgroundImage(UIImage(named: "Button"), for: .normal)
                    self.NextBtnO.isUserInteractionEnabled = true
                }
                
                self.TblV.reloadData()
               
            }else{
                let responseMessage = dictData["message"] as! String
                self.showToast(responseMessage)
            }
        })
    }
}

extension IngredientDislikesVC {
    func Api_To_GetPrefrenceBodyGoals(){
        var params = [String: Any]()
        
        params["dislike_num"] = "\(self.moreCount)"
        params["dislike_search"] = self.SearchTxt.text!
     
         
        showIndicator(withTitle: "", and: "")
        
        let loginURL = baseURL.baseURL + appEndPoints.Getprefrence
        print(params,"Params")
        print(loginURL,"loginURL")
        
        WebService.shared.postServiceURLEncoding(loginURL, VC: self, andParameter: params, withCompletion: { (json, statusCode) in
            
            self.hideIndicator()
            
            guard let dictData = json.dictionaryObject else{
                return
            }
            
            if dictData["success"] as? Bool == true{
                let result = dictData["data"] as? NSDictionary ?? NSDictionary()
                
                let responseArray = result["ingredientdislike"] as? [[String : Any]] ?? [[String: Any]]()
                
                self.DislikesIngredientArr.removeAll()
                self.DislikesIngredientArr = ModelClass.getBodyGoalsDetails(responseArray: responseArray)
                self.ArrData1.removeAll()
                self.ArrData.removeAll()
                
                for i in self.DislikesIngredientArr{
                    self.ArrData1.append(contentsOf: [BodyGoalsModel(Name: i.name, id: i.id, isSelected: i.selected)])
                }
                
                self.ArrData1.insert(contentsOf: [BodyGoalsModel(Name: "None", id: nil, isSelected: false)], at: 0)
                
//                for i in 0..<self.ArrData1.count{
//                    if i <= 2{
//                        self.ArrData.append(contentsOf: [self.ArrData1[i]])
//                    }
//                }
                
                self.ArrData = self.ArrData1
                
                if self.SearchTxt.text?.count ?? 0 == 0{
                    self.ArrData.append(contentsOf: [BodyGoalsModel(Name: "More", id: nil, isSelected: false)])
                }
                
                if self.ArrData.allSatisfy({ ($0.isSelected) == false }) {
                    // All items are unselected
                    print("All items are unselected.")
                    self.NextBtnO.setBackgroundImage(UIImage(named: "ButtonGray"), for: .normal)
                    self.NextBtnO.isUserInteractionEnabled = false
                } else {
                    // At least one item is selected
                    print("Some items are selected.")
                    self.NextBtnO.setBackgroundImage(UIImage(named: "Button"), for: .normal)
                    self.NextBtnO.isUserInteractionEnabled = true
                }
                
                self.TblV.reloadData()
               
            }else{
                let responseMessage = dictData["message"] as! String
                self.showToast(responseMessage)
            }
        })
    }
    
    func Api_To_UpdatePrefrence(){
        var params : [String:Any] = [:]
        
        var DislikeIngredientArr = [String]()
        
        for i in 0..<ArrData.count {
            if ArrData[i].isSelected {
                DislikeIngredientArr.append("\(ArrData[i].id ?? Int())")
            }
        }
  
        params["dislike_ingredients_id"] = DislikeIngredientArr
 
        let token  = UserDetail.shared.getTokenWith()
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        
        
        
        let loginURL = baseURL.baseURL + appEndPoints.Updateprefrence
        
        showIndicator(withTitle: "", and: "")
        
        AF.upload(multipartFormData: { multipartFormData in
            for (key, value) in params {
                if let temp = value as? String {
                    multipartFormData.append(temp.data(using: .utf8)!, withName: key)
                }
                if let temp = value as? Int {
                    multipartFormData.append("\(temp)".data(using: .utf8)!, withName: key)
                }
                if let temp = value as? NSArray {
                    temp.forEach({ element in
                        let keyObj = key + "[]"
                        if let string = element as? String {
                            multipartFormData.append(string.data(using: .utf8)!, withName: keyObj)
                        } else
                        if let num = element as? Int {
                            let value = "\(num)"
                            multipartFormData.append(value.data(using: .utf8)!, withName: keyObj)
                        }
                    })
                }
            }
        },to: loginURL, method: .post , headers: headers)
        .responseJSON(completionHandler: { (encodingResult) in
            self.hideIndicator()
            
            do {
                if let err = encodingResult.error{
                    //                    if loader { CommonFunctions.hideActivityLoader() }
                    
                    if (err as NSError).code == NSURLErrorNotConnectedToInternet {
                        
                    }
                    print(err as NSError)
                    if let f = encodingResult.data {
                        print("Print Server Error: " + String(data: f, encoding: String.Encoding.utf8)!)
                    }
                    
                    return
                }
                
                //                if loader { CommonFunctions.hideActivityLoader() }
                
                print(encodingResult.data!)
                let value = try JSON(data: encodingResult.data!)
                print(JSON(value))
                
                guard  let dict = value.dictionaryObject else {
                    return
                }
                if (dict["success"] as? Bool) == true {
                    self.navigationController?.popViewController(animated: true)
                }else{
                   let msg = dict["msg"] as? String ?? ""
                    self.showToast(msg)
                }
            }catch {
                self.hideIndicator()
                print("===================== FAILURE =======================")
                print(error.localizedDescription)
                
            }
        })
    }
}
