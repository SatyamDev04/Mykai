//
//  Cooking _for _Partners _infoVC.swift
//  Myka App
//
//  Created by YES IT Labs on 29/11/24.
//

import UIKit
import Alamofire
import SwiftyJSON

class Cooking__for__Partners__infoVC: UIViewController {
    
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var ProgressLbl: UILabel!
    
    @IBOutlet weak var PartnersNameTxtF: UITextField!
    @IBOutlet weak var PartnersAgeTxtF: UITextField!
    @IBOutlet weak var SelectGenderTxtF: UITextField!
    @IBOutlet weak var GenderDropBtnO: UIButton!
    @IBOutlet weak var DropImg: UIImageView!
    @IBOutlet weak var MaleBgV: UIView!
    @IBOutlet weak var FemaleBgV: UIView!
    @IBOutlet weak var MaleBtnO: UIButton!
    @IBOutlet weak var FemaleBtnO: UIButton!
    
    @IBOutlet weak var NextbtnStackV: UIStackView!
    @IBOutlet weak var UpdateBtnO: UIButton!
    
    var type = ""
    
    var comesfrom = ""
    
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
        
        self.MaleBgV.isHidden = true
        self.FemaleBgV.isHidden = true
        self.DropImg.image = UIImage(named: "DropDown")
        
        if comesfrom != ""{
          self.Api_To_GetPrefrenceBodyGoals()
        }
    }
    
    @IBAction func BackBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func GenderBtn(_ sender: UIButton) {
        if GenderDropBtnO.isSelected {
            GenderDropBtnO.isSelected = false
            self.MaleBgV.isHidden = true
            self.FemaleBgV.isHidden = true
            self.DropImg.image = UIImage(named: "DropDown")
        }else{
            self.GenderDropBtnO.isSelected = true
            self.MaleBgV.isHidden = false
            self.FemaleBgV.isHidden = false
            self.DropImg.image = UIImage(named: "DropUp")
        }
    }
    
    @IBAction func MaleBtn(_ sender: UIButton) {
        self.GenderDropBtnO.isSelected = false
        self.MaleBgV.isHidden = true
        self.FemaleBgV.isHidden = true
        self.DropImg.image = UIImage(named: "DropDown")
        self.SelectGenderTxtF.text = "Male"
    }
    
    @IBAction func FemaleBtn(_ sender: UIButton) {
        self.GenderDropBtnO.isSelected = false
        self.MaleBgV.isHidden = true
        self.FemaleBgV.isHidden = true
        self.DropImg.image = UIImage(named: "DropDown")
        self.SelectGenderTxtF.text = "Female"
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
        guard self.PartnersNameTxtF.text != "" else {
            AlertControllerOnr(title: "", message: "Enter partner's name first.")
            return
        }
        
        guard self.PartnersNameTxtF.text! != "" else{
            AlertControllerOnr(title: "", message: "Enter partner's age first.")
            return
        }
        
        guard self.SelectGenderTxtF.text! != "" else{
            AlertControllerOnr(title: "", message: "Select gender first.")
            return
        }
        
        StateMangerModelClass.shared.onboardingSelectedData.Partnersname.Name = self.PartnersNameTxtF.text!
        StateMangerModelClass.shared.onboardingSelectedData.Partnersname.Age = self.PartnersAgeTxtF.text!
        
        if self.SelectGenderTxtF.text! != "" {
            StateMangerModelClass.shared.onboardingSelectedData.Partnersname.Gender = self.SelectGenderTxtF.text!
        }
        
        
        let storyboard = UIStoryboard(name: "CookingForMySelf", bundle: nil)
    let vc = storyboard.instantiateViewController(withIdentifier: "BodyGoalsVC") as! BodyGoalsVC
    vc.type = self.type
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    @IBAction func UpdateBtn(_ sender: UIButton) {
        self.Api_To_UpdatePrefrence()
    }
}

extension Cooking__for__Partners__infoVC {
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
                
                let response = result["partnerDetail"] as?  NSDictionary ?? NSDictionary()
                let name = response["name"] as? String ?? ""
                self.PartnersNameTxtF.text = name
                
                let age = response["age"] as? String ?? ""
                self.PartnersAgeTxtF.text = age
                
                let gender = response["gender"] as? String ?? ""
                self.SelectGenderTxtF.text = gender
                
            }else{
                let responseMessage = dictData["message"] as! String
                self.showToast(responseMessage)
            }
        })
    }
    
    func Api_To_UpdatePrefrence(){
        var params : [String:Any] = [:]

        params["partner_name"] = self.PartnersNameTxtF.text!
        params["partner_age"] = Int(self.PartnersAgeTxtF.text!)
        params["partner_gender"] = self.SelectGenderTxtF.text!

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



