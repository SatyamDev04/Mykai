//
//  BodyGoalsVC.swift
//  Myka App
//
//  Created by YES IT Labs on 27/11/24.
//

import UIKit
import Alamofire
import SwiftyJSON

struct BodyGoalsModel {
    var Name: String
    var id: Int?
    var isSelected: Bool
}

class BodyGoalsVC: UIViewController {

    @IBOutlet weak var progressView: UIProgressView!
    
    @IBOutlet weak var TblV: UITableView!
    
    @IBOutlet weak var TitleLbl: UILabel!
    
    @IBOutlet weak var SubTitleLbl: UILabel!
    
    @IBOutlet weak var ProgressLbl: UILabel!

    @IBOutlet weak var NextBtnO: UIButton!
    
    @IBOutlet weak var NextbtnStackV: UIStackView!
    @IBOutlet weak var UpdateBtnO: UIButton!
    
    var type = ""
    
    var comesfrom = ""
     
    
    var bodyGoalsArr = [ModelClass]()
    
    
    var ArrData = [BodyGoalsModel]()//[BodyGoalsModel(Name: "Lose fat", isSelected: false), BodyGoalsModel(Name: "Gain Muscle", isSelected: false), BodyGoalsModel(Name: "Maintain", isSelected: false)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if comesfrom == ""{
            self.NextbtnStackV.isHidden = false
            self.UpdateBtnO.isHidden = true
        }else{
            self.NextbtnStackV.isHidden = true
            self.UpdateBtnO.isHidden = false
        }
        
        let Attributes1: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.black
        ]
        let Attributes2: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.init(red: 6/255, green: 193/255, blue: 105/255, alpha: 1)
        ]
        
        if self.type == "MySelf"{
            self.ProgressLbl.text = "1/10"
            let progressVw = Float(1) / Float(10)
            progressView.progress = progressVw
            
            let helloString = NSAttributedString(string: "Body", attributes: Attributes1)
            let worldString = NSAttributedString(string: " Goals", attributes: Attributes2)
            let fullString = NSMutableAttributedString()
            fullString.append(helloString)
            fullString.append(worldString)
            self.TitleLbl.attributedText = fullString
            self.SubTitleLbl.text = "What are your body goals?"
             
        }else if self.type == "Partner"{
            self.ProgressLbl.text = "2/11"
            let progressVw = Float(2) / Float(11)
            progressView.progress = progressVw
             
            let helloString = NSAttributedString(string: "Body", attributes: Attributes1)
            let worldString = NSAttributedString(string: " Goals", attributes: Attributes2)
            let fullString = NSMutableAttributedString()
            fullString.append(helloString)
            fullString.append(worldString)
            self.TitleLbl.attributedText = fullString
            self.SubTitleLbl.text = "You and your partner's goals?"
        }else{
            self.ProgressLbl.text = "2/11"
            let progressVw = Float(2) / Float(11)
            progressView.progress = progressVw
             
            let helloString = NSAttributedString(string: "Family Member’s", attributes: Attributes1)
            let worldString = NSAttributedString(string: " \nBody Goals", attributes: Attributes2)
            let fullString = NSMutableAttributedString()
            fullString.append(helloString)
            fullString.append(worldString)
            self.TitleLbl.attributedText = fullString
            self.SubTitleLbl.text = "What are your family's body goals?"
        }
  
        NextBtnO.setBackgroundImage(UIImage(named: "ButtonGray"), for: .normal)
        NextBtnO.isUserInteractionEnabled = false
        
        self.TblV.register(UINib(nibName: "BodyGoalTblVCell", bundle: nil), forCellReuseIdentifier: "BodyGoalTblVCell")
        self.TblV.delegate = self
        self.TblV.dataSource = self
        
        self.TblV.separatorStyle = .none
        
        if comesfrom == ""{
            self.Api_To_GetBodyGoals()
        }else{
            self.Api_To_GetPrefrenceBodyGoals()
        }
    }
    
    
    @IBAction func BackBtn(_ sender: UIButton) {
        if self.type == "MySelf"{
            self.navigationController?.popViewController(animated: true)
        }else{
            self.navigationController?.popViewController(animated: false)
        }
    }
    
    @IBAction func SkipBtn(_ sender: UIButton) {
 
        let storyboard = UIStoryboard(name: "CookingForMySelf", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SkipPopupVC") as! SkipPopupVC
        vc.backAction = {
            for index in 0..<self.ArrData.count {
                self.ArrData[index].isSelected = false
                }
            StateMangerModelClass.shared.onboardingSelectedData.MySelfSeldata[0].bodyGoals.removeAll()
            
            self.NextBtnO.setBackgroundImage(UIImage(named: "ButtonGray"), for: .normal)
            self.NextBtnO.isUserInteractionEnabled = false
            self.TblV.reloadData()
        
            
            let storyboard = UIStoryboard(name: "CookingForMySelf", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "DietaryRestrictionsVC") as! DietaryRestrictionsVC
            vc.type = self.type
            self.navigationController?.pushViewController(vc, animated: false)
           
        }
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: false)
    }
    
    @IBAction func NextBtn(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "CookingForMySelf", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "DietaryRestrictionsVC") as! DietaryRestrictionsVC
        vc.type = self.type
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    @IBAction func UpdateBtn(_ sender: UIButton) {
        self.Api_To_UpdatePrefrence()
    }
}

extension BodyGoalsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ArrData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BodyGoalTblVCell", for: indexPath) as! BodyGoalTblVCell
        cell.NameLbl.text = ArrData[indexPath.row].Name
        cell.TickImg.image = ArrData[indexPath.row].isSelected ? UIImage(named: "Tick1") : UIImage(named: "")
        cell.selectedBgImg.image = ArrData[indexPath.row].isSelected ? UIImage(named: "YelloBorder") : UIImage(named: "Group 1171276489")
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        for index in 0..<ArrData.count {
            ArrData[index].isSelected = false
        }
            ArrData[indexPath.row].isSelected = true
        NextBtnO.setBackgroundImage(UIImage(named: "Button"), for: .normal)
        NextBtnO.isUserInteractionEnabled = true
            TblV.reloadData()
        
        let Bodygoalselid = ArrData[indexPath.row].id ?? Int()
     
        StateMangerModelClass.shared.onboardingSelectedData.MySelfSeldata.removeAll()
            
        StateMangerModelClass.shared.onboardingSelectedData.MySelfSeldata.append(
            MyselfModelClass(
                bodyGoals: "\(Bodygoalselid)",
                DietaryPreferences: [],
                FavCuisines: [],
                DislikeIngredient: [],
                AllergensIngredients: [],
                MealRoutine: [],
                CookingFrequency: "",
                SpendingOnGroceries: SpendingOnGroceriesModelClass(Amount: "", duration: ""),
                EatingOut: "",
                Takeway: ""
            )
        )
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

extension BodyGoalsVC {
    func Api_To_GetBodyGoals(){
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
        
        let loginURL = baseURL.baseURL + appEndPoints.bodygoals
        print(params,"Params")
        print(loginURL,"loginURL")
        
        WebService.shared.getServiceURLEncodingwithParams(loginURL, VC: self, andParameter: params, withCompletion: { (json, statusCode) in
            
            self.hideIndicator()
            
            guard let dictData = json.dictionaryObject else{
                return
            }
            
            if dictData["success"] as? Bool == true{
                let responseArray = dictData["data"] as? [[String : Any]] ?? [[String: Any]]()
                
                self.bodyGoalsArr.removeAll()
                self.bodyGoalsArr = ModelClass.getBodyGoalsDetails(responseArray: responseArray)
                self.ArrData.removeAll()
                
                for i in self.bodyGoalsArr{
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

extension BodyGoalsVC {
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
                
                let responseArray = result["bodygoal"] as? [[String : Any]] ?? [[String: Any]]()
                
                self.bodyGoalsArr.removeAll()
                self.bodyGoalsArr = ModelClass.getBodyGoalsDetails(responseArray: responseArray)
                self.ArrData.removeAll()
                
                for i in self.bodyGoalsArr{
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
         
        var Bodygoalselid = String()
        
        for i in 0..<ArrData.count {
            if ArrData[i].isSelected {
                Bodygoalselid = "\(ArrData[i].id ?? Int())"
            }
        }
         
        params["bodygoal"] = Bodygoalselid
       
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
