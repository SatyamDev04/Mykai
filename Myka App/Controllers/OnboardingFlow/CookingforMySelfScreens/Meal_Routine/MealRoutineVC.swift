//
//  MealRoutineVC.swift
//  Myka App
//
//  Created by YES IT Labs on 28/11/24.
//

import UIKit
import Alamofire
import SwiftyJSON

class MealRoutineVC: UIViewController {

    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var TblV: UITableView!
    @IBOutlet weak var ProgressLbl: UILabel!
    
    @IBOutlet weak var TitleLbl: UILabel!
    @IBOutlet weak var SubTitleLbl: UILabel!
    
    @IBOutlet weak var NextBtnO: UIButton!
    @IBOutlet weak var NextbtnStackV: UIStackView!
    @IBOutlet weak var UpdateBtnO: UIButton!
    
    var type = ""
    var comesfrom = ""
    
    var MealRoutineArr = [ModelClass]()
    
        var ArrData = [BodyGoalsModel]()//(Name: "Select all", isSelected: false), BodyGoalsModel(Name: "Breakfast", isSelected: false), BodyGoalsModel(Name: "Lunch", isSelected: false), BodyGoalsModel(Name: "Dinner", isSelected: false), BodyGoalsModel(Name: "Snacks", isSelected: false)]
    
  
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
            self.ProgressLbl.text = "6/10"
            let progressVw = Float(6) / Float(10)
            progressView.progress = Float(progressVw)
            
            let helloString = NSAttributedString(string: "Meal", attributes: Attributes1)
            let worldString = NSAttributedString(string: " Routine", attributes: Attributes2)
            let fullString = NSMutableAttributedString()
            fullString.append(helloString)
            fullString.append(worldString)
            self.TitleLbl.attributedText = fullString
            self.SubTitleLbl.text = "What meals do you typically cook at home?"
             
        }else if self.type == "Partner"{
            self.ProgressLbl.text = "7/11"
            let progressVw = Float(7) / Float(11)
            progressView.progress = Float(progressVw)
             
            let helloString = NSAttributedString(string: "Meal", attributes: Attributes1)
            let worldString = NSAttributedString(string: " Routine", attributes: Attributes2)
            let fullString = NSMutableAttributedString()
            fullString.append(helloString)
            fullString.append(worldString)
            self.TitleLbl.attributedText = fullString
            self.SubTitleLbl.text = "What meals do you guys typically cook at home?"

        }else{
            self.ProgressLbl.text = "7/11"
            let progressVw = Float(7) / Float(11)
            progressView.progress = Float(progressVw)
             
            let helloString = NSAttributedString(string: "Meal", attributes: Attributes1)
            let worldString = NSAttributedString(string: " Routine", attributes: Attributes2)
            let fullString = NSMutableAttributedString()
            fullString.append(helloString)
            fullString.append(worldString)
            self.TitleLbl.attributedText = fullString
            self.SubTitleLbl.text = "What meals do you typically cook for your \nfamily?"
        }
        
        if comesfrom == ""{
            self.Api_To_GetMealRoutine()
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
                StateMangerModelClass.shared.onboardingSelectedData.MySelfSeldata[0].MealRoutine.removeAll()
                
                self.NextBtnO.setBackgroundImage(UIImage(named: "ButtonGray"), for: .normal)
                self.NextBtnO.isUserInteractionEnabled = false
                self.TblV.reloadData()
                
                    let storyboard = UIStoryboard(name: "CookingForMySelf", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "CookingFrequencyVC") as! CookingFrequencyVC
                    vc.type = self.type
                    self.navigationController?.pushViewController(vc, animated: false)
            }
            vc.modalPresentationStyle = .overCurrentContext
            self.present(vc, animated: false)
        }
        
        @IBAction func NextBtn(_ sender: UIButton) {
            let storyboard = UIStoryboard(name: "CookingForMySelf", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "CookingFrequencyVC") as! CookingFrequencyVC
            vc.type = self.type
            self.navigationController?.pushViewController(vc, animated: false)
        }
    
    @IBAction func UpdateBtn(_ sender: UIButton) {
        self.Api_To_UpdatePrefrence()
    }
    }

    extension MealRoutineVC: UITableViewDelegate, UITableViewDataSource {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return ArrData.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BodyGoalTblVCell", for: indexPath) as! BodyGoalTblVCell
            cell.NameLbl.text = ArrData[indexPath.row].Name
             
            if ArrData[indexPath.row].isSelected == true && ArrData[indexPath.row].Name == "Select all" {
                cell.TickImg.image = ArrData[indexPath.row].isSelected ? UIImage(named: "GreenTick") : UIImage(named: "")
                cell.selectedBgImg.image = ArrData[indexPath.row].isSelected ? UIImage(named: "GreenBorder") : UIImage(named: "Group 1171276489")
            }else{
                cell.TickImg.image = ArrData[indexPath.row].isSelected ? UIImage(named: "Tick1") : UIImage(named: "")
                cell.selectedBgImg.image = ArrData[indexPath.row].isSelected ? UIImage(named: "YelloBorder") : UIImage(named: "Group 1171276489")
            }
            cell.selectionStyle = .none
            return cell
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            if ArrData[indexPath.row].Name == "Select all" {
                if ArrData[indexPath.row].isSelected == true{
                    for i in 0..<ArrData.count {
                        ArrData[i].isSelected = false
                    }
                }else{
                    for i in 0..<ArrData.count {
                        ArrData[i].isSelected = true
                    }
                }
            }else {
                if ArrData[indexPath.row].isSelected {
                    for index in 0..<ArrData.count {
                        if ArrData[index].Name == "Select all" && ArrData[index].isSelected == true{
                            ArrData[index].isSelected = false
                        }
                    }
                    ArrData[indexPath.row].isSelected = false
                }else{
                    ArrData[indexPath.row].isSelected = true
                    
                    // Check if all indexes except 0 are selected
                    if ArrData.allSatisfy({ $0.isSelected || $0.Name == "Select all" }) {
                        for (index, item) in ArrData.enumerated() {
                            if item.Name == "Select all" && !item.isSelected {
                                ArrData[index].isSelected = true
                            }
                        }
                    }
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
            
            var SelMealRoutineArr = [String]()
            
            for i in 0..<ArrData.count {
                if ArrData[i].isSelected {
                    SelMealRoutineArr.append("\(ArrData[i].id ?? Int())")
                }
            }
            
            StateMangerModelClass.shared.onboardingSelectedData.MySelfSeldata[0].MealRoutine = SelMealRoutineArr
            
            TblV.reloadData()
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 60
        }
    }


extension MealRoutineVC {
    func Api_To_GetMealRoutine(){
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
                
                self.MealRoutineArr.removeAll()
                self.MealRoutineArr = ModelClass.getBodyGoalsDetails(responseArray: responseArray)
                self.ArrData.removeAll()
                
                for i in self.MealRoutineArr{
                    self.ArrData.append(contentsOf: [BodyGoalsModel(Name: i.name, id: i.id, isSelected: false)])
                }
                
                self.ArrData.insert(contentsOf: [BodyGoalsModel(Name: "Select all", id: nil, isSelected: false)], at: 0)
                
                 
                self.TblV.reloadData()
               
            }else{
                let responseMessage = dictData["message"] as! String
                self.showToast(responseMessage)
            }
        })
    }
}


extension MealRoutineVC {
    func Api_To_GetPrefrenceBodyGoals(){
       // var params = [String: Any]()
      
  
        showIndicator(withTitle: "", and: "")
       
        let loginURL = baseURL.baseURL + appEndPoints.Getprefrence
       // print(params,"Params")
        print(loginURL,"loginURL")
        
        WebService.shared.postServiceURLEncoding(loginURL, VC: self, andParameter: [:], withCompletion: { (json, statusCode) in
            
            self.hideIndicator()
            
            guard let dictData = json.dictionaryObject else{
                return
            }
            
            if dictData["success"] as? Bool == true{
                let result = dictData["data"] as? NSDictionary ?? NSDictionary()
                
                let responseArray = result["mealroutine"] as? [[String : Any]] ?? [[String: Any]]()
                
                self.MealRoutineArr.removeAll()
                self.MealRoutineArr = ModelClass.getBodyGoalsDetails(responseArray: responseArray)
                self.ArrData.removeAll()
                
                for i in self.MealRoutineArr{
                    self.ArrData.append(contentsOf: [BodyGoalsModel(Name: i.name, id: i.id, isSelected: i.selected)])
                }
                
                self.ArrData.insert(contentsOf: [BodyGoalsModel(Name: "Select all", id: nil, isSelected: false)], at: 0)
                
                if let selectAllIndex = self.ArrData.firstIndex(where: { $0.Name == "Select all" }),
                   !self.ArrData[selectAllIndex].isSelected,
                   self.ArrData.filter({ $0.Name != "Select all" }).allSatisfy({ $0.isSelected }) {
                    
                    self.ArrData[selectAllIndex].isSelected = true
                    print("All other items are selected, so 'Select all' is now selected.")
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
        
        var SelMealRoutineArr = [String]()
        
        for i in 0..<ArrData.count {
            if ArrData[i].isSelected {
                SelMealRoutineArr.append("\(ArrData[i].id ?? Int())")
            }
        }
 
        params["meal_routine_id"] = SelMealRoutineArr
 
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
