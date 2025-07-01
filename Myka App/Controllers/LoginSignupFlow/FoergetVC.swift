//
//  FoergetVC.swift
//  Myka App
//
//  Created by YES IT Labs on 02/12/24.
//

import UIKit

class FoergetVC: UIViewController {

    @IBOutlet weak var Email_PhoneTxt: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func BackBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func SubmitBtn(_ sender: UIButton) {
        guard validation() else { return }
        
        self.Api_To_ForgetPass()
         
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
            
        } else if Email_PhoneTxt.text?.isNumeric == true || Email_PhoneTxt.text!.count != 10 {
            if  !Email_PhoneTxt.text!.isValidPhone(){
                self.popupAlert(title: "Error", message: "Please enter valid phone number.", actionTitles: ["Okay!"], actions:[{action1 in}])
                return false
            }
        }else{
            if  !Email_PhoneTxt.text!.isValidPhone(){
                self.popupAlert(title: "Error", message: "Please enter valid phone number.", actionTitles: ["Okay!"], actions:[{action1 in}])
                return false
            }
        }
        return true
    }
}

extension FoergetVC {
    func Api_To_ForgetPass(){
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
                 
                let storyboard = UIStoryboard(name: "Login", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "OtpVC") as! OtpVC
                if self.Email_PhoneTxt.text?.isNumeric == false{
                    vc.isEmail_Phone = "email"
                }else{
                    vc.isEmail_Phone = "Phone"
                }
                vc.comefrom = "Forget"
                vc.email_Phone = self.Email_PhoneTxt.text!
                self.navigationController?.pushViewController(vc, animated: true)
               
            }else{
                let responseMessage = dictData["message"] as! String
                self.showToast(responseMessage)
            }
        })
    }
}
