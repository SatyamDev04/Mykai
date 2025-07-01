//
//  ReasonsforTakeawayVC.swift
//  Myka App
//
//  Created by YES IT Labs on 29/11/24.
//

import UIKit
import Alamofire
import SwiftyJSON

class ReasonsforTakeawayVC: UIViewController {

    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var TblV: UITableView!
    @IBOutlet weak var ProgressLbl: UILabel!
    
    @IBOutlet weak var NextBtnO: UIButton!
    @IBOutlet weak var NextbtnStackV: UIStackView!
    @IBOutlet weak var UpdateBtnO: UIButton!
    
    var type = ""
    var comesfrom = ""
    
    var ReasonsforTakeawayArr = [ModelClass]()
    
    var ArrData = [BodyGoalsModel]()//(Name: "No food prepared", isSelected: false), BodyGoalsModel(Name: "Convenience", isSelected: false), BodyGoalsModel(Name: "Cravings", isSelected: false), BodyGoalsModel(Name: "Social  occasions", isSelected: false), BodyGoalsModel(Name: "Add Other", isSelected: false)]
    
  //  var AddOtherTxt = ""
  
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
        
        if self.type == "MySelf"{
            self.ProgressLbl.text = "10/10"
            let progressVw = Float(10) / Float(10)
            progressView.progress = Float(progressVw)
             
        }else if self.type == "Partner"{
            self.ProgressLbl.text = "11/11"
            let progressVw = Float(11) / Float(11)
            progressView.progress = Float(progressVw)
             
             
        }else{
            self.ProgressLbl.text = "11/11"
            let progressVw = Float(11) / Float(11)
            progressView.progress = Float(progressVw)
            
           
        }
        
        if comesfrom == ""{
            self.Api_To_GetReasonsForTakeaway()
        }else{
            self.Api_To_GetPrefrenceBodyGoals()
        }
    }
    
        
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
                StateMangerModelClass.shared.onboardingSelectedData.MySelfSeldata[0].Takeway.removeAll()
                
                self.NextBtnO.setBackgroundImage(UIImage(named: "ButtonGray"), for: .normal)
                self.NextBtnO.isUserInteractionEnabled = false
                self.TblV.reloadData()
                
                if UserDetail.shared.getTokenWith() == "" && UserDetail.shared.getisSignInWith() == "true"{
                    let storyboard = UIStoryboard(name: "Login", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "TurnonLocationVC") as! TurnonLocationVC
                    vc.comesFrom = "Signup"
                    self.navigationController?.pushViewController(vc, animated: true)
                }else{
                    if UserDetail.shared.getLoginSession() == false && UserDetail.shared.getisSignInWith() == "true"{
                        self.Api_To_UpdateData()
                    }else if UserDetail.shared.getLoginSession() == false && UserDetail.shared.getisSignInWith() != "true"{
                        let storyboard = UIStoryboard(name: "Login", bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: "SignUpVC") as! SignUpVC
                        self.navigationController?.pushViewController(vc, animated: false)
                    }else if UserDetail.shared.getLoginSession() == false && UserDetail.shared.getisSignInWith() != "true"{
                        let storyboard = UIStoryboard(name: "Login", bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                        self.navigationController?.pushViewController(vc, animated: false)
                    }else{
                        let storyboard = UIStoryboard(name: "Login", bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: "SignUpVC") as! SignUpVC
                        self.navigationController?.pushViewController(vc, animated: false)
                    }
                }
            }
            vc.modalPresentationStyle = .overCurrentContext
            self.present(vc, animated: false)
        }
             
   // 
        @IBAction func NextBtn(_ sender: UIButton) {
            if UserDetail.shared.getTokenWith() == "" && UserDetail.shared.getisSignInWith() == "true"{
                let storyboard = UIStoryboard(name: "Login", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "TurnonLocationVC") as! TurnonLocationVC
                vc.comesFrom = "Signup"
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                if UserDetail.shared.getLoginSession() == false && UserDetail.shared.getisSignInWith() == "true"{
                    self.Api_To_UpdateData()
                }else if UserDetail.shared.getLoginSession() == false && UserDetail.shared.getisSignInWith() != "true"{
                    let storyboard = UIStoryboard(name: "Login", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "SignUpVC") as! SignUpVC
                    self.navigationController?.pushViewController(vc, animated: false)
                }else if UserDetail.shared.getLoginSession() == false && UserDetail.shared.getisSignInWith() != "true"{
                    let storyboard = UIStoryboard(name: "Login", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                    self.navigationController?.pushViewController(vc, animated: false)
                }else{
                    let storyboard = UIStoryboard(name: "Login", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "SignUpVC") as! SignUpVC
                    self.navigationController?.pushViewController(vc, animated: false)
                }
            }
        }
    
    @IBAction func UpdateBtn(_ sender: UIButton) {
        self.Api_To_UpdatePrefrence()
    }
    }

    extension ReasonsforTakeawayVC: UITableViewDelegate, UITableViewDataSource {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return ArrData.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BodyGoalTblVCell", for: indexPath) as! BodyGoalTblVCell
            cell.NameLbl.text = ArrData[indexPath.row].Name
            
            if ArrData[indexPath.row].Name == "Add other"{
                cell.NameLbl.font = UIFont(name: "Poppins Bold", size: 16.0)
            }else{
                cell.NameLbl.font = UIFont(name: "Poppins Regular", size: 16.0)
            }
            
            cell.TickImg.image = ArrData[indexPath.row].isSelected ? UIImage(named: "Tick1") : UIImage(named: "")
            cell.selectedBgImg.image = ArrData[indexPath.row].isSelected ? UIImage(named: "YelloBorder") : UIImage(named: "Group 1171276489")
            cell.selectionStyle = .none
            
            if ArrData[indexPath.row].Name == "Add other" && ArrData[indexPath.row].isSelected == true{
                cell.AddOthherBgV.isHidden = false
                cell.AddotherTxtF.text = StateMangerModelClass.shared.onboardingSelectedData.MySelfSeldata[0].addOtherTxt
            }else {
                cell.AddOthherBgV.isHidden = true
                cell.AddotherTxtF.text = ""
               //
            }
            
            cell.delegate = self
            return cell
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            for i in 0..<ArrData.count {
                ArrData[i].isSelected = false
            }
            
                ArrData[indexPath.row].isSelected = true
            
                NextBtnO.setBackgroundImage(UIImage(named: "Button"), for: .normal)
            NextBtnO.isUserInteractionEnabled = true
            
            var Takeway = String()
            
            for i in 0..<ArrData.count {
                if ArrData[i].isSelected {
                    Takeway = ("\(ArrData[i].id ?? Int())")
                }
            }
            
            if ArrData[indexPath.row].Name == "Add other" {
                StateMangerModelClass.shared.onboardingSelectedData.MySelfSeldata[0].Takeway = Takeway
            }else{
                StateMangerModelClass.shared.onboardingSelectedData.MySelfSeldata[0].addOtherTxt = ""
                StateMangerModelClass.shared.onboardingSelectedData.MySelfSeldata[0].Takeway = Takeway
            }
            
             
            TblV.reloadData()
        }
        
        func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
            return 60
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return UITableView.automaticDimension
        }
    }

extension ReasonsforTakeawayVC:AddOtherTxtDelegate {
    func AddOtherTxtTableViewCell(_ TxtTableViewCell: BodyGoalTblVCell, didEndEditingWithText: String?) {
        if didEndEditingWithText! == ""{
        NextBtnO.setBackgroundImage(UIImage(named: "ButtonGray"), for: .normal)
            NextBtnO.isUserInteractionEnabled = false
        }else{
            if let tableView = TxtTableViewCell.superview(ofType: UITableView.self) {
                let indexPath = tableView.indexPath(for: TxtTableViewCell)
                
                NextBtnO.setBackgroundImage(UIImage(named: "Button"), for: .normal)
                NextBtnO.isUserInteractionEnabled = true
                
                var Takeway = String()
                
                Takeway = didEndEditingWithText ?? ""
                StateMangerModelClass.shared.onboardingSelectedData.MySelfSeldata[0].addOtherTxt = Takeway
                TblV.reloadData()
            }
        }
    }
}


extension ReasonsforTakeawayVC {
    func Api_To_GetReasonsForTakeaway(){
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
        
        let loginURL = baseURL.baseURL + appEndPoints.takeAwayReason
        print(params,"Params")
        print(loginURL,"loginURL")
        
        WebService.shared.getServiceURLEncodingwithParams(loginURL, VC: self, andParameter: params, withCompletion: { (json, statusCode) in
            
            self.hideIndicator()
            
            guard let dictData = json.dictionaryObject else{
                return
            }
            
            if dictData["success"] as? Bool == true{
                let responseArray = dictData["data"] as? [[String : Any]] ?? [[String: Any]]()
                
                self.ReasonsforTakeawayArr.removeAll()
                self.ReasonsforTakeawayArr = ModelClass.getBodyGoalsDetails(responseArray: responseArray)
                self.ArrData.removeAll()
                
                for i in self.ReasonsforTakeawayArr{
                    self.ArrData.append(contentsOf: [BodyGoalsModel(Name: i.name, id: i.id, isSelected: false)])
                }
                
                self.TblV.reloadData()
               
            }else{
                let responseMessage = dictData["message"] as! String
                self.showToast(responseMessage)
            }
        })
    }
}

extension ReasonsforTakeawayVC {
    func Api_To_GetPrefrenceBodyGoals(){
        var params = [String: Any]()
     
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
                
                let responseArray = result["takeawayreason"] as? [[String : Any]] ?? [[String: Any]]()
                
                self.ReasonsforTakeawayArr.removeAll()
                self.ReasonsforTakeawayArr = ModelClass.getBodyGoalsDetails(responseArray: responseArray)
                self.ArrData.removeAll()
                
                StateMangerModelClass.shared.onboardingSelectedData.MySelfSeldata[0].addOtherTxt = ""
                
                
                for i in self.ReasonsforTakeawayArr{
                    self.ArrData.append(contentsOf: [BodyGoalsModel(Name: i.name, id: i.id, isSelected: i.selected)])
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
        
        var Takeway = String()
        
        for i in 0..<ArrData.count {
            if ArrData[i].isSelected {
                Takeway = ("\(ArrData[i].id ?? Int())")
            }
        }

        params["take_way"] = Takeway
        params["take_way_name"] = StateMangerModelClass.shared.onboardingSelectedData.MySelfSeldata[0].addOtherTxt
        
  
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

    
    // if signup and Onboarding data not set.
    func Api_To_UpdateData(){
        var params : [String:Any] = [:]
        
        var Takeway = String()
        
        for i in 0..<ArrData.count {
            if ArrData[i].isSelected {
                Takeway = ("\(ArrData[i].id ?? Int())")
            }
        }

        params["take_way"] = Takeway
        
        params["take_way_name"] = StateMangerModelClass.shared.onboardingSelectedData.MySelfSeldata[0].addOtherTxt
        
        let onboardingData = StateMangerModelClass.shared.onboardingSelectedData
            
        if onboardingData.Cookingfortype == "MySelf"{
            params["cooking_for_type"] = 1
        }else if onboardingData.Cookingfortype == "Partner"{
            params["cooking_for_type"] = 2
        }else{
            params["cooking_for_type"] = 3
        }
        
         
        params["username"] = onboardingData.Username
        params["usergender"] = onboardingData.UserGender
        if onboardingData.MySelfSeldata.count != 0{
            params["bodygoal"] = onboardingData.MySelfSeldata[0].bodyGoals
            params["cooking_frequency"] = onboardingData.MySelfSeldata[0].CookingFrequency
            params["take_way"] = onboardingData.MySelfSeldata[0].Takeway
            params["eating_out"] = onboardingData.MySelfSeldata[0].EatingOut
        }
        params["partner_name"] = onboardingData.Partnersname.Name
        params["partner_age"] = Int(onboardingData.Partnersname.Age)
        params["partner_gender"] = onboardingData.Partnersname.Gender
        params["family_member_name"] = onboardingData.FamilyMembername.Name
        params["family_member_age"] = Int(onboardingData.FamilyMembername.Age)
        if onboardingData.FamilyMembername.ChildFriendlyMeals == true{
            params["child_friendly_meals"] = "1"
        }else{
            params["child_friendly_meals"] = "0"
        }
        
        if onboardingData.MySelfSeldata.count != 0{
            params["meal_routine_id"] = onboardingData.MySelfSeldata[0].MealRoutine
            params["spending_amount"] = onboardingData.MySelfSeldata[0].SpendingOnGroceries.Amount
            params["duration"] = onboardingData.MySelfSeldata[0].SpendingOnGroceries.duration
            params["dietary_id"] = onboardingData.MySelfSeldata[0].DietaryPreferences
            params["dislike_ingredients_id"] = onboardingData.MySelfSeldata[0].DislikeIngredient
            params["favourite"] = onboardingData.MySelfSeldata[0].FavCuisines
            params["allergies"] = onboardingData.MySelfSeldata[0].AllergensIngredients
  
       
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
                    
                    UserDetail.shared.setLoginSession(true)
                    
                    let storyboard = UIStoryboard(name: "Login", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "TurnonLocationVC") as! TurnonLocationVC
                    vc.comesFrom = "Signup"
                    self.navigationController?.pushViewController(vc, animated: true)
                    
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
}
    

