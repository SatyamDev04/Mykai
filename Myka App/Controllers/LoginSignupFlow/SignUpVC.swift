//
//  SignUpVC.swift
//  Myka App
//
//  Created by YES IT Labs on 03/12/24.
//

import UIKit
import GoogleSignIn
import FBSDKLoginKit
import FBSDKCoreKit
import Firebase
import AuthenticationServices
import Alamofire
import SwiftyJSON

class SignUpVC: UIViewController {
    @IBOutlet weak var Email_PhoneTxt: UITextField!
    
    @IBOutlet weak var PassTxt: UITextField!
    
    @IBOutlet weak var PassHideShowBtnO: UIButton!
    
    let appleSignIn = HSAppleSignIn()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        print("onboardingSelectedData before modification: \(String(describing: StateMangerModelClass.shared.onboardingSelectedData))")
    }
    
    @IBAction func BackBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
   
    //invisible, eye (img name).
    @IBAction func PassHideShowBtn(_ sender: UIButton) {
        if self.PassHideShowBtnO.isSelected {
            self.PassHideShowBtnO.isSelected = false
            self.PassTxt.isSecureTextEntry = true
        }else{
            self.PassHideShowBtnO.isSelected = true
            self.PassTxt.isSecureTextEntry = false
        }
    }
    
    @IBAction func SignupBtn(_ sender: UIButton) {
        guard validation() else { return }
        
        self.Api_To_Signup()
    }
    
    @IBAction func GoogleLogiinBtn(_ sender: UIButton) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { result, error in
            
            guard error == nil else {
                return
            }
            
            
            guard let user = result?.user else { return }
            
            let idToken = user.idToken?.tokenString
            
            let userId = user.userID
            
            let emailAddress = user.profile?.email ?? ""
            
            let givenName = user.profile?.givenName ?? ""
            
            let familyName = user.profile?.familyName ?? ""
       
            let profilePicUrl = user.profile?.imageURL(withDimension: 320)
          //  self.social_Prof_img = "\(profilePicUrl!)"
            
          //  self.Api_To_SocialLogin(email: emailAddress, Name: givenName, social_id: userId ?? "", socialType: "Google")
            self.Api_To_SocialLogin(email: emailAddress, social_id: userId ?? "")
        }
    }
    
    @IBAction func FacebookLogiinBtn(_ sender: UIButton) {
       // self.loginButtonClicked()
    }
    
    @IBAction func AppleLogiinBtn(_ sender: UIButton) {
        appleSignIn.didTapLoginWithApple1 { (userInfo, message) in
            if let userInfo = userInfo{
                print(userInfo.email)
                print(userInfo.userid)
                print(userInfo.firstName)
                print(userInfo.lastName)
                print(userInfo.fullName)
                let name = userInfo.firstName != "" ? userInfo.firstName : ""
                let Lastname = userInfo.lastName != "" ? userInfo.lastName : ""
                let email = userInfo.email != "" ? userInfo.email : "\(name)@gmail.com"
                
                let userId = userInfo.userid
                
                let emailAddress = email
                
                self.Api_To_SocialLogin(email: emailAddress, social_id: userId)
             //   self.Api_To_SocialLogin(email: emailAddress, Name: "\(name) \(Lastname)", social_id: userId, socialType: "Apple")
                
            }else if let message = message{
                print("Error Message: \(message)")
                AlertController.alert(title: "Alert", message: "Error Message: \(message)")
            }else{
                print("Unexpected error!")
                AlertController.alert(title: "Alert", message: "Unexpected error!")
            }
        }
    }
    
    
    
    @IBAction func LoginBtn(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        UserDetail.shared.setisSignInWith("false")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func validation() -> Bool {
        if Email_PhoneTxt.text?.count == 0 {
            self.popupAlert(title: "Error", message: "Email/Phone can't be empty.", actionTitles: ["Okay!"], actions:[{action1 in}])
            return false
        }
        else if Email_PhoneTxt.text?.isNumeric == false {
            if  !Email_PhoneTxt.text!.isValidEmail(){
                self.popupAlert(title: "Error", message: "Please enter valid email/Phone.", actionTitles: ["Okay!"], actions:[{action1 in}])
                return false
            }
            
        } else if Email_PhoneTxt.text?.isNumeric == true || self.Email_PhoneTxt.text!.count != 10 {
            if  !Email_PhoneTxt.text!.isValidPhone() == false{
                self.popupAlert(title: "Error", message: "Please enter valid phone number.", actionTitles: ["Okay!"], actions:[{action1 in}])
                return false
            }
        }else{
            if  !Email_PhoneTxt.text!.isValidPhone(){
                self.popupAlert(title: "Error", message: "Please enter valid phone number.", actionTitles: ["Okay!"], actions:[{action1 in}])
                return false
            }
        }
        
        if PassTxt.text?.count == 0 {
            self.popupAlert(title: "Error", message: "Password can't be empty", actionTitles: ["Okay!"], actions:[{action1 in}])
    return false
       
        }else if !PassTxt.text!.isPasswordValid(){
            self.popupAlert(title: "Error", message: "Password must have at least one Uppercase, one Lowercase alphabet, one spacial characters and one numeric caracters.", actionTitles: ["Okay!"], actions:[{action1 in}])
      
        return false

        }
        return true
    }
}

extension SignUpVC {
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        if result?.isCancelled ?? false {
            print("Cancelled")
        } else if error != nil {
            print("ERROR: Trying to get login results")
        } else {
            print("Logged in")
            self.getUserProfile(token: result?.token, userId: result?.token?.userID)
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        // Do something after the user pressed the logout button
        print("You logged out!")
    }
    
    func loginButtonClicked() {
        let loginManager = LoginManager()
        loginManager.logIn(permissions: ["public_profile", "email"], from: self, handler: { result, error in
            if error != nil {
                print("ERROR: Trying to get login results")
            } else if result?.isCancelled != nil {
                print("The token is \(result?.token?.tokenString ?? "")")
                if result?.token?.tokenString != nil {
                    print("Logged in")
                    self.getUserProfile(token: result?.token, userId: result?.token?.userID)
                    
                } else {
                    print("Cancelled")
                }
            }
        })
    }
    
    func getUserProfile(token: AccessToken?, userId: String?) {
        let graphRequest: GraphRequest = GraphRequest(graphPath: "me", parameters: ["fields": "id, first_name, middle_name, last_name, name, picture, email"])
        graphRequest.start { _, result, error in
            if error == nil {
                let data: [String: AnyObject] = result as! [String: AnyObject]
                
                // Facebook Id
                let facebookId = data["id"] as? String //{
                print("Facebook Id: \(facebookId)")
                let userId = facebookId
    
                let facebookFirstName = data["first_name"] as? String //{
         
                
                // Facebook Middle Name
                if let facebookMiddleName = data["middle_name"] as? String {
                    print("Facebook Middle Name: \(facebookMiddleName)")
                } else {
                    print("Facebook Middle Name: Not exists")
                }
                
                // Facebook Last Name
                if let facebookLastName = data["last_name"] as? String {
                    print("Facebook Last Name: \(facebookLastName)")
                } else {
                    print("Facebook Last Name: Not exists")
                }
                
                // Facebook Name
                let facebookName = data["name"] as? String ?? "" //{
                print("Facebook Name: \(facebookName)")
                
                let givenName = facebookName
                
                // Facebook Profile Pic URL
                let facebookProfilePicURL = "https://graph.facebook.com/\(userId ?? "")/picture?type=large"
                print("Facebook Profile Pic URL: \(facebookProfilePicURL)")
                
                let profilePicUrl = facebookProfilePicURL
               // self.social_Prof_img = "\(profilePicUrl)"
                
                // Facebook Email
                let facebookEmail = data["email"] as? String ?? "" //{
                print("Facebook Email: \(facebookEmail)")
                let emailAddress = facebookEmail
                
      
                print("Facebook Access Token: \(token?.tokenString ?? "")")
                self.Api_To_SocialLogin(email: emailAddress, social_id: userId ?? "")
             //   self.Api_To_SocialLogin(email: emailAddress, Name: givenName, social_id: userId ?? "", socialType: "Facebook")
            } else {
                print("Error: Trying to get user's info")
            }
        }
    }
}

@available(iOS 13.0, *)
extension SignUpVC: ASAuthorizationControllerPresentationContextProviding{
    public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor{
        return view.window!
    }
}



extension SignUpVC {
    func Api_To_Signup(){
        var params = [String: Any]()
        if Email_PhoneTxt.text?.isNumeric == true || Email_PhoneTxt.text!.count == 10 {
            let p = self.Email_PhoneTxt.text ?? ""
            let k = p.removeSpaces
            let o = k.replace(string: "(", withString: "")
            let t = o.replace(string: ")", withString: "")
            let I = t.replace(string: "-", withString: "")
            let c = I.replace(string: "+", withString: "")
            let numb = c.dropFirst()
            params["email_or_phone"] = numb
        }else{
            params["email_or_phone"] = self.Email_PhoneTxt.text!
        }
        
        params["password"] = PassTxt.text!
        
//        let delegate = AppDelegate.shared
//        let token = delegate.deviceToken
//        params["device_token"] = token
         
        showIndicator(withTitle: "", and: "")
        
        let loginURL = baseURL.baseURL + appEndPoints.getsignUp
        print(params,"Params")
        print(loginURL,"loginURL")
        
        WebService.shared.postServiceURLEncoding(loginURL, VC: self, andParameter: params, withCompletion: { (json, statusCode) in
            
            self.hideIndicator()
            
            guard let dictData = json.dictionaryObject else{
                return
            }
            
            if dictData["success"] as? Bool == true{
                let response = dictData["data"] as? NSDictionary ?? NSDictionary()
                let uid = response["id"] as? Int ?? Int()
                
                let responseMessage = dictData["message"] as? String ?? ""
                self.navigationController?.showToast(responseMessage)
                
                let storyboard = UIStoryboard(name: "Login", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "OtpVC") as! OtpVC
                vc.UserId = "\(uid)"
                
                if self.Email_PhoneTxt.text?.isNumeric == false{
                    vc.isEmail_Phone = "email"
                }else{
                    vc.isEmail_Phone = "Phone"
                }
                vc.comefrom = "Signup"
                vc.email_Phone = self.Email_PhoneTxt.text!
                
               // UserDetail.shared.setisSignInWith("true")
                
                self.navigationController?.pushViewController(vc, animated: true)
               
            }else{
                let responseMessage = dictData["message"] as? String ?? ""
                self.showToast(responseMessage)
            }
        })
    }
}

extension SignUpVC {
    func Api_To_SocialLogin(email: String, social_id: String){
               
        var params : [String:Any] = [:]
           
        
        let onboardingData = StateMangerModelClass.shared.onboardingSelectedData
            
        if onboardingData.Cookingfortype == "MySelf"{
            params["cooking_for_type"] = 1
        }else if onboardingData.Cookingfortype == "Partner"{
            params["cooking_for_type"] = 2
        }else{
            params["cooking_for_type"] = 3
        }
        
        if email.isNumeric == true || email.count == 10 {
            let p = self.Email_PhoneTxt.text ?? ""
            let k = p.removeSpaces
            let o = k.replace(string: "(", withString: "")
            let t = o.replace(string: ")", withString: "")
            let I = t.replace(string: "-", withString: "")
            let c = I.replace(string: "+", withString: "")
            let numb = c.dropFirst()
            params["email_or_phone"] = numb
        }else{
            params["email_or_phone"] = email
        }
         
         
        params["social_id"] = social_id
        params["username"] = onboardingData.Username
        params["usergender"] = onboardingData.UserGender
        params["bodygoal"] = onboardingData.MySelfSeldata[0].bodyGoals
        params["cooking_frequency"] = onboardingData.MySelfSeldata[0].CookingFrequency
        params["take_way"] = onboardingData.MySelfSeldata[0].Takeway
        params["take_way_name"] = StateMangerModelClass.shared.onboardingSelectedData.MySelfSeldata[0].addOtherTxt
        
        params["eating_out"] = onboardingData.MySelfSeldata[0].EatingOut
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
        params["meal_routine_id"] = onboardingData.MySelfSeldata[0].MealRoutine
        params["spending_amount"] = onboardingData.MySelfSeldata[0].SpendingOnGroceries.Amount
        params["duration"] = onboardingData.MySelfSeldata[0].SpendingOnGroceries.duration
        params["dietary_id"] = onboardingData.MySelfSeldata[0].DietaryPreferences
        params["dislike_ingredients_id"] = onboardingData.MySelfSeldata[0].DislikeIngredient
        params["favourite"] = onboardingData.MySelfSeldata[0].FavCuisines
        params["allergies"] = onboardingData.MySelfSeldata[0].AllergensIngredients
        
        params["referral_from"] = StateMangerModelClass.shared.ReffCode
        
        let delegate = AppDelegate.shared
               let token = delegate.deviceToken
               params["fcm_token"] = token
        params["device_type"] = "iOS"
        
        let loginURL = baseURL.baseURL + appEndPoints.social_login
        
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
                           let is_cooking_complete = response["is_cooking_complete"] as? Int ?? Int()
                           let ReferralCode = response["referral_code"] as? String ?? String()
                           
                            
                           if is_cooking_complete == 1 {
                               UserDetail.shared.setLoginSession(true)
                           }
                           
                           UserDetail.shared.setUserId("\(UID)")
                           
                           UserDetail.shared.setTokenWith(token)
                           
                           UserDetail.shared.setisSignInWith("true")
                           
                           UserDetail.shared.setUserType(userType)
                           
                           UserDetail.shared.setUserRefferalCode(ReferralCode)
                           
                           guard is_cooking_complete != 0 else{
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let nextVc = storyboard.instantiateViewController(identifier: "EnterNameVC") as! EnterNameVC
                            self.navigationController?.pushViewController(nextVc, animated: true)
                               return
                           }
                           
                           let isNewuser = response["isNewuser"] as? Bool ?? Bool()
                           
                           if isNewuser == false{
                               let storyboard = UIStoryboard(name: "Tabbar", bundle: nil)
                               let vc = storyboard.instantiateViewController(withIdentifier: "TabbarVC") as! TabbarVC
                               self.navigationController?.pushViewController(vc, animated: true)
                           }else{
                               let storyboard = UIStoryboard(name: "Login", bundle: nil)
                               let vc = storyboard.instantiateViewController(withIdentifier: "TurnonLocationVC") as! TurnonLocationVC
                               vc.comesFrom = "Signup"
                               self.navigationController?.pushViewController(vc, animated: true)
                           }
                       }else{
                           let msg = dict["msg"] as? String ?? ""
                           self.showToast(msg)
                       }
                       //                print(dict["msg"] as? String ?? "","ghghgc")
                       
                   }catch {
                       self.hideIndicator()
                       print("===================== FAILURE =======================")
                       print(error.localizedDescription)
                       
                   }
               })
           }
}
