//
//  CookingforFamilyVC.swift
//  Myka App
//
//  Created by YES IT Labs on 02/12/24.
//

import UIKit
import Alamofire
import SwiftyJSON

class CookingforFamilyVC: UIViewController {
    
    @IBOutlet weak var MemberNameTxt: UITextField!
    @IBOutlet weak var MemberAgeTxt: UITextField!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var ProgressLbl: UILabel!
    
    @IBOutlet weak var ChildFrindlyBtnO: UIButton!
    @IBOutlet weak var NextbtnStackV: UIStackView!
    @IBOutlet weak var UpdateBtnO: UIButton!
    
    var type = ""
    
    var comesfrom = ""
    
    var ischildFrndlyMeal = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if comesfrom == ""{
            self.NextbtnStackV.isHidden = false
            self.UpdateBtnO.isHidden = true
        }else{
            self.NextbtnStackV.isHidden = true
            self.UpdateBtnO.isHidden = false
        }
        
        self.ProgressLbl.text = "1/11"
        let progressVw = Float(1) / Float(11)
        progressView.progress = Float(progressVw)
        // Do any additional setup after loading the view.
        
        if comesfrom != ""{
         self.Api_To_GetPrefrenceBodyGoals()
        }
    }
    
    @IBAction func BackBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func CheckBox(_ sender: UIButton) {
        if ChildFrindlyBtnO.isSelected {
            ChildFrindlyBtnO.isSelected = false
            ischildFrndlyMeal = false
        } else {
            ChildFrindlyBtnO.isSelected = true
            ischildFrndlyMeal = true
        }
    }
    
    
     @IBAction func SkipBtn(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "CookingForMySelf", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SkipPopupVC") as! SkipPopupVC
        vc.backAction = {
                let storyboard = UIStoryboard(name: "CookingForMySelf", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "BodyGoalsVC") as! BodyGoalsVC
            vc.type = self.type
                self.navigationController?.pushViewController(vc, animated: false)
        }
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: false)
    }
    
    @IBAction func NextBtn(_ sender: UIButton) {
        guard self.MemberNameTxt.text != "" else {
            AlertControllerOnr(title: "", message: "Enter member's name first.")
            return
        }
        
        guard self.MemberAgeTxt.text! != "" else{
            AlertControllerOnr(title: "", message: "Enter member's age first.")
            return
        }
      
        
        StateMangerModelClass.shared.onboardingSelectedData.FamilyMembername.Name = self.MemberNameTxt.text!
        StateMangerModelClass.shared.onboardingSelectedData.FamilyMembername.Age = self.MemberAgeTxt.text!
        StateMangerModelClass.shared.onboardingSelectedData.FamilyMembername.ChildFriendlyMeals = ischildFrndlyMeal
         
        let storyboard = UIStoryboard(name: "CookingForMySelf", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "BodyGoalsVC") as! BodyGoalsVC
        vc.type = self.type
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    @IBAction func UpdateBtn(_ sender: UIButton) {
        self.Api_To_UpdatePrefrence()
    }
 
}

extension CookingforFamilyVC {
    func Api_To_GetPrefrenceBodyGoals(){
        var params = [String: Any]()
      
        let token  = UserDetail.shared.getTokenWith()
        let headers: HTTPHeaders = [
                     "Authorization": "Bearer \(token)"
                   ]
         
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
                
                let response = result["familyDetail"] as?  NSDictionary ?? NSDictionary()
                let name = response["name"] as? String ?? ""
                self.MemberNameTxt.text = name
                
                let age = response["age"] as? String ?? ""
                self.MemberAgeTxt.text = age
                
                let IsChildFriendlyMeal = response["child_friendly_meals"] as? String ?? "0"
                 
                if IsChildFriendlyMeal == "0" {
                    self.ChildFrindlyBtnO.isSelected = false
                    self.ischildFrndlyMeal = false
                } else {
                    self.ChildFrindlyBtnO.isSelected = true
                    self.ischildFrndlyMeal = true
                }
            }else{
                let responseMessage = dictData["message"] as! String
                self.showToast(responseMessage)
            }
        })
    }
    
    func Api_To_UpdatePrefrence(){
        var params : [String:Any] = [:]
    
        params["family_member_name"] = self.MemberNameTxt.text!
        params["family_member_age"] = Int(self.MemberAgeTxt.text!)
         
        if ischildFrndlyMeal == true{
            params["child_friendly_meals"] = "1"
        }else{
            params["child_friendly_meals"] = "0"
        }

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
