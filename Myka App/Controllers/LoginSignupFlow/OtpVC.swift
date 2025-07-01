//
//  OtpVC.swift
//  Myka App
//
//  Created by YES IT Labs on 02/12/24.
//

import UIKit
import Alamofire
import SwiftyJSON

class OtpVC: UIViewController {
    
    @IBOutlet var OTPView: DPOTPView!
    
    @IBOutlet weak var TitleLbl: UILabel!
    @IBOutlet weak var SendOtponLbl: UILabel!
    
    @IBOutlet weak var ResendBtnO: UIButton!
    @IBOutlet weak var ResendBgV: UIView!
    
    @IBOutlet weak var CountLbl: UILabel!
    @IBOutlet weak var TimerBgV: UIView!
    
    @IBOutlet var SuccessView: UIView!
    
    var isEmail_Phone: String = ""
    var timer = Timer()
    var email_Phone = ""
    
    var comefrom = ""
    
    var UserId: String = ""
    
    
    var is_cooking_complete = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // if comesfrom signup only.
        self.SuccessView.frame = self.view.bounds
        self.view.addSubview(SuccessView)
        self.SuccessView.isHidden = true
        //
        
        self.TimerBgV.isHidden = true
        
        let Attributes1: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.black
        ]
        let Attributes2: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.init(red: 6/255, green: 193/255, blue: 105/255, alpha: 1)
        ]
        
        if isEmail_Phone == "email" {
            let helloString = NSAttributedString(string: "Please check your", attributes: Attributes1)
            let worldString = NSAttributedString(string: " Email", attributes: Attributes2)
            let fullString = NSMutableAttributedString()
            fullString.append(helloString)
            fullString.append(worldString)
            self.TitleLbl.attributedText = fullString
            
            SendOtponLbl.text = "We have sent the code to email below-\n\(email_Phone)"
        }else{
            let helloString = NSAttributedString(string: "Please check your", attributes: Attributes1)
            let worldString = NSAttributedString(string: " Phone", attributes: Attributes2)
            let fullString = NSMutableAttributedString()
            fullString.append(helloString)
            fullString.append(worldString)
            self.TitleLbl.attributedText = fullString
            
            let lastFour = email_Phone.suffix(3)
            SendOtponLbl.text = "We have sent the code to phone below-\n*******\(lastFour)"
        }
    }
    
    
    
    
    @IBAction func BackBtn(_ sender: UIButton) {
        timer.invalidate()
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func ResendBtn(_ sender: UIButton) {
        if comefrom == "Signup" {
            self.Api_To_SignUpResendOTP()
        }else{
            self.Api_To_ForgetPassResendOTP()
        }
        
    }
    
    func ResentOTPTimer(){
        self.TimerBgV.isHidden = false
        ResendBtnO.isUserInteractionEnabled = false
        var runCount = 60
        var time1 = 60
        
        self.ResendBtnO.setTitleColor(UIColor(red: 6/255, green: 193/255, blue: 105/255, alpha: 0.3), for: .normal)
        self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            print("Timer fired!")
            
            runCount -= 1
            
            if runCount <= 60 {
                self.CountLbl.text = "01:\(String(runCount))"
            }
            
            if runCount < 10{
                self.CountLbl.text = "01:0\(String(runCount))"
            }
            
            if runCount == 0 {
                timer.invalidate()
                self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
                    print("Timer fired!")
                    
                    time1 -= 1
                    if time1 <= 60 {
                        self.CountLbl.text = "00:\(String(time1))"
                    }
                    
                    if time1 < 10{
                        self.CountLbl.text = "00:0\(String(time1))"
                    }
                    
                    if time1 == 0 {
                        self.ResendBtnO.setTitleColor(UIColor(red: 6/255, green: 193/255, blue: 105/255, alpha: 1), for: .normal)
                        self.ResendBtnO.isUserInteractionEnabled = true
                        self.TimerBgV.isHidden = true
                        timer.invalidate()
                    }
                }
            }
        }
    }
    
    
    @IBAction func VerifyBtn(_ sender: UIButton) {
        if comefrom == "Signup" {
            self.Api_To_SignUpVerifyOTP()
        }else{
            self.Api_To_ForgetPassVerifyOTP()
        }
    }
    
    @IBAction func OKBtn(_ sender: UIButton) {
        self.SuccessView.isHidden = true
        
        let isOnboardingStatus = UserDetail.shared.getOnboardingStatus()
        
        guard self.is_cooking_complete != 0 && isOnboardingStatus == true else{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let nextVc = storyboard.instantiateViewController(identifier: "EnterNameVC") as! EnterNameVC
            self.navigationController?.pushViewController(nextVc, animated: true)
            return
        }
        
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "TurnonLocationVC") as! TurnonLocationVC
        vc.comesFrom = comefrom
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


// if comesfrom Signup.
extension OtpVC {
    func Api_To_SignUpVerifyOTP(){
        var params : [String:Any] = [:]
        
        let onboardingData = StateMangerModelClass.shared.onboardingSelectedData
        
        if onboardingData.Cookingfortype == "MySelf"{
            params["cooking_for_type"] = 1
        }else if onboardingData.Cookingfortype == "Partner"{
            params["cooking_for_type"] = 2
        }else if onboardingData.Cookingfortype == "Family"{
            params["cooking_for_type"] = 3
        }
        
        
        params["user_id"] = Int(self.UserId)
        params["otp"] = Int(self.OTPView.text!)
        params["username"] = onboardingData.Username
        params["usergender"] = onboardingData.UserGender
        if onboardingData.MySelfSeldata.count != 0{
            params["bodygoal"] = onboardingData.MySelfSeldata[0].bodyGoals
            params["cooking_frequency"] = onboardingData.MySelfSeldata[0].CookingFrequency
            params["take_way"] = onboardingData.MySelfSeldata[0].Takeway
            params["eating_out"] = onboardingData.MySelfSeldata[0].EatingOut
            
            params["take_way_name"] = StateMangerModelClass.shared.onboardingSelectedData.MySelfSeldata[0].addOtherTxt
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
        }
        
        params["referral_from"] = StateMangerModelClass.shared.ReffCode
        
        let delegate = AppDelegate.shared
        let token = delegate.deviceToken
        params["fcm_token"] = token
        params["device_type"] = "iOS"
        
        
        
        let loginURL = baseURL.baseURL + appEndPoints.getSignUpOtpVerify
        
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
        },to: loginURL, method: .post , headers: [:])
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
                    
                    let response = dict["data"] as? NSDictionary ?? NSDictionary()
                    let UID = response["id"] as? Int ?? Int()
                    let token = response["token"] as? String ?? String()
                    let userType = response["cooking_for_type"] as? String ?? String()
                    let ReferralCode = response["referral_code"] as? String ?? String()
                    
                    
                    self.is_cooking_complete = response["is_cooking_complete"] as? Int ?? Int()
                    
                    if self.is_cooking_complete == 1 {
                        UserDetail.shared.setLoginSession(true)
                    }
                    
                    UserDetail.shared.setUserId("\(UID)")
                    
                    UserDetail.shared.setTokenWith(token)
                    
                    UserDetail.shared.setisSignInWith("true")
                    
                    UserDetail.shared.setUserType(userType)
                    
                    UserDetail.shared.setUserRefferalCode(ReferralCode)
                    
                    self.SuccessView.isHidden = false
                }else{
                    let responseMessage = dict["message"] as? String ?? ""
                    self.showToast(responseMessage)
                }
                //                print(dict["msg"] as? String ?? "","ghghgc")
                
            }catch {
                self.hideIndicator()
                print("===================== FAILURE =======================")
                print(error.localizedDescription)
                
            }
        })
    }
    
    
    func Api_To_SignUpResendOTP(){
        var params = [String: Any]()
        if self.email_Phone.isNumeric == true || self.email_Phone.count == 10 {
            let p = self.email_Phone
            let k = p.removeSpaces
            let o = k.replace(string: "(", withString: "")
            let t = o.replace(string: ")", withString: "")
            let I = t.replace(string: "-", withString: "")
            let c = I.replace(string: "+", withString: "")
            let numb = c.dropFirst()
            params["email_or_phone"] = numb
        }else{
            params["email_or_phone"] = self.email_Phone
        }
        
        
        
        //        let delegate = AppDelegate.shared
        //        let token = delegate.deviceToken
        //        params["device_token"] = token
        
        showIndicator(withTitle: "", and: "")
        
        let loginURL = baseURL.baseURL + appEndPoints.SignUpResendotp
        print(params,"Params")
        print(loginURL,"loginURL")
        
        WebService.shared.postServiceURLEncoding(loginURL, VC: self, andParameter: params, withCompletion: { (json, statusCode) in
            
            self.hideIndicator()
            
            guard let dictData = json.dictionaryObject else{
                return
            }
            
            if dictData["success"] as? Bool == true{
                let responseMessage = dictData["message"] as? String ?? ""
                self.showToast(responseMessage)
                
                self.ResentOTPTimer()
            }else{
                let responseMessage = dictData["message"] as? String ?? ""
                self.showToast(responseMessage)
            }
        })
    }
}


// if comesfrom forget.
extension OtpVC {
    func Api_To_ForgetPassVerifyOTP(){
        var params = [String: Any]()
        if self.email_Phone.isNumeric == true || self.email_Phone.count == 10 {
            let p = self.email_Phone
            let k = p.removeSpaces
            let o = k.replace(string: "(", withString: "")
            let t = o.replace(string: ")", withString: "")
            let I = t.replace(string: "-", withString: "")
            let c = I.replace(string: "+", withString: "")
            let numb = c.dropFirst()
            params["email_or_phone"] = numb
        }else{
            params["email_or_phone"] = self.email_Phone
        }
        
        params["otp"] = self.OTPView.text!
        
        //        let delegate = AppDelegate.shared
        //        let token = delegate.deviceToken
        //        params["device_token"] = token
        
        showIndicator(withTitle: "", and: "")
        
        let loginURL = baseURL.baseURL + appEndPoints.forget_otp_verify
        print(params,"Params")
        print(loginURL,"loginURL")
        
        WebService.shared.postServiceURLEncoding(loginURL, VC: self, andParameter: params, withCompletion: { (json, statusCode) in
            
            self.hideIndicator()
            
            guard let dictData = json.dictionaryObject else{
                return
            }
            
            if dictData["success"] as? Bool == true{
                
                let storyboard = UIStoryboard(name: "Login", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "ResetPasswordVC") as! ResetPasswordVC
                vc.email_Phone = self.email_Phone
                self.navigationController?.pushViewController(vc, animated: true)
                
            }else{
                let responseMessage = dictData["message"] as! String
                self.showToast(responseMessage)
            }
        })
    }
    
    func Api_To_ForgetPassResendOTP(){
        var params = [String: Any]()
        if self.email_Phone.isNumeric == true || self.email_Phone.count == 10 {
            let p = self.email_Phone
            let k = p.removeSpaces
            let o = k.replace(string: "(", withString: "")
            let t = o.replace(string: ")", withString: "")
            let I = t.replace(string: "-", withString: "")
            let c = I.replace(string: "+", withString: "")
            let numb = c.dropFirst()
            params["email_or_phone"] = numb
        }else{
            params["email_or_phone"] = self.email_Phone
        }
        
        
        
        //        let delegate = AppDelegate.shared
        //        let token = delegate.deviceToken
        //        params["device_token"] = token
        
        showIndicator(withTitle: "", and: "")
        
        let loginURL = baseURL.baseURL + appEndPoints.forgetPassword
        print(params,"Params")
        print(loginURL,"loginURL")
        
        WebService.shared.postServiceURLEncoding(loginURL, VC: self, andParameter: params, withCompletion: { (json, statusCode) in
            
            self.hideIndicator()
            
            guard let dictData = json.dictionaryObject else{
                return
            }
            
            if dictData["success"] as? Bool == true{
                let responseMessage = dictData["message"] as! String
                self.showToast(responseMessage)
                self.ResentOTPTimer()
            }else{
                let responseMessage = dictData["message"] as! String
                self.showToast(responseMessage)
            }
        })
    }
}
