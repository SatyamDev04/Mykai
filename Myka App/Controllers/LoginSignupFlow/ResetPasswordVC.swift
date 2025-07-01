//
//  ResetPasswordVC.swift
//  Myka App
//
//  Created by YES IT Labs on 03/12/24.
//

import UIKit

class ResetPasswordVC: UIViewController {
    
    
    @IBOutlet weak var CreatePassTxt: UITextField!
    
    @IBOutlet weak var ConfirmPassTxt: UITextField!
    
    @IBOutlet var SuccessView: UIView!
    
    var email_Phone = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.SuccessView.frame = self.view.bounds
        self.view.addSubview(SuccessView)
        self.SuccessView.isHidden = true
    }
    

    @IBAction func BackBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func SubmitBtn(_ sender: UIButton) {
        guard validation() else {
            return
        }
        
        self.Api_To_ResetPass()
    }
    
    
    @IBAction func OKBtn(_ sender: UIButton) {
        self.SuccessView.isHidden = true
        navigationController?.popToViewController(ofClass: LoginVC.self, animated: true)
    }
    

    
    
    func validation() -> Bool {

        if CreatePassTxt.text?.count == 0 {
            self.popupAlert(title: "Error", message: "Create password can't be empty", actionTitles: ["Okay!"], actions:[{action1 in}])
    return false
       
        }else if !CreatePassTxt.text!.isPasswordValid(){
            self.popupAlert(title: "Error", message: "Password must have at least one Uppercase, one Lowercase alphabet, one spacial characters and one numeric caracters.", actionTitles: ["Okay!"], actions:[{action1 in}])
      
        return false

        }else if ConfirmPassTxt.text?.count == 0 {
        self.popupAlert(title: "Error", message: " Confirm Password can't be empty", actionTitles: ["Okay!"], actions:[{action1 in}])
    return false
            
    } else if ConfirmPassTxt.text != CreatePassTxt.text {
        self.popupAlert(title: "Error", message: " Password not matched", actionTitles: ["Okay!"], actions:[{action1 in}])
    return false
    }
        return true
    }
}


extension ResetPasswordVC {
    func Api_To_ResetPass(){
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
        
        params["password"] = self.CreatePassTxt.text!
        params["conformpassword"] = self.ConfirmPassTxt.text!
        
        //        let delegate = AppDelegate.shared
        //        let token = delegate.deviceToken
        //        params["device_token"] = token
        
        showIndicator(withTitle: "", and: "")
        
        let loginURL = baseURL.baseURL + appEndPoints.resetPassword
        print(params,"Params")
        print(loginURL,"loginURL")
        
        WebService.shared.postServiceURLEncoding(loginURL, VC: self, andParameter: params, withCompletion: { (json, statusCode) in
            
            self.hideIndicator()
            
            guard let dictData = json.dictionaryObject else{
                return
            }
            
            if dictData["success"] as? Bool == true{
                self.SuccessView.isHidden = false
            }else{
                let responseMessage = dictData["message"] as! String
                self.showToast(responseMessage)
            }
        })
    }
}
