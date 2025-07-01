//
//  AddNumberVC.swift
//  My-Kai
//
//  Created by YES IT Labs on 05/03/25.
//

import UIKit
import ADCountryPicker
import Alamofire

class AddNumberVC: UIViewController, UITextFieldDelegate, ADCountryPickerDelegate {
  
    @IBOutlet weak var CountryImg: UIImageView!
    @IBOutlet weak var PhoneTxtF: UITextField!
    
    @IBOutlet weak var SentCodeonPhoneNumLbl: UILabel!
    @IBOutlet weak var OtpView: DPOTPView!
    
    @IBOutlet weak var ResendBtnO: UIButton!
    @IBOutlet weak var CountTimeLbl: UILabel!
    @IBOutlet weak var VerifyBtnO: UIButton!
    
    @IBOutlet weak var PleaseCheckPhoneBgV: UIView!
    @IBOutlet weak var OTPBgV: UIView!
    @IBOutlet weak var ResendBgV: UIView!
    @IBOutlet weak var ResendTimeBgV: UIView!
    @IBOutlet weak var WrongOtpBgV: UIView!
    
    @IBOutlet weak var UpdateBtnO: UIButton!
    
    var timer = Timer()
    
    var CurrentphoneNum = ""
    
    var CountryDialCode = "+1"
    
    var Otp = ""
    
    var backAction:(String)->() = {str in}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.PhoneTxtF.delegate = self
        
        self.PleaseCheckPhoneBgV.isHidden = true
        self.OTPBgV.isHidden = true
        self.ResendBgV.isHidden = true
        self.ResendTimeBgV.isHidden = true
        self.WrongOtpBgV.isHidden = true
        self.UpdateBtnO.backgroundColor = #colorLiteral(red: 0.6470588235, green: 0.6470588235, blue: 0.6470588235, alpha: 1)
        self.UpdateBtnO.isUserInteractionEnabled = false
        
        self.VerifyBtnO.setTitleColor(#colorLiteral(red: 0.6470588235, green: 0.6470588235, blue: 0.6470588235, alpha: 1), for: .normal)
        self.VerifyBtnO.isUserInteractionEnabled = false
        
        OtpView.dpOTPViewDelegate = self
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        timer.invalidate()
    }
    
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//            // Get the current text
//        guard let currentText = textField.text else { return true }
//            
//            // Calculate the updated text
//            let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)
//         
//        if updatedText == CurrentphoneNum && updatedText != ""{
//            self.VerifyBtnO.setTitleColor(#colorLiteral(red: 0.6470588235, green: 0.6470588235, blue: 0.6470588235, alpha: 1), for: .normal)
//            self.VerifyBtnO.isUserInteractionEnabled = false
//        }else{
//            self.VerifyBtnO.setTitleColor(#colorLiteral(red: 0, green: 0.786260426, blue: 0.4870494008, alpha: 1), for: .normal)
//            self.VerifyBtnO.isUserInteractionEnabled = true
//        }
//       
//        // Enforce a character limit of 10
//            return updatedText.count <= 10
//        }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Get the current text
        guard let currentText = textField.text else { return true }
        
        // Calculate the updated text
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)
        
        // Remove any non-digit characters
        let digitsOnly = updatedText.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        self.WrongOtpBgV.isHidden = true
        // Enforce a digit limit of 10
        if digitsOnly.count > 10 {
            return false
        }
        
        // Format the text
        let formattedText = formatPhoneNumbero(digitsOnly)
        
        // Update the text field
        textField.text = formattedText
        
        let MobileNum = formattedText.replace(string: "-", withString: "")
        // Handle button state
        if MobileNum == CurrentphoneNum || MobileNum.count < 10{
            self.VerifyBtnO.setTitleColor(#colorLiteral(red: 0.6470588235, green: 0.6470588235, blue: 0.6470588235, alpha: 1), for: .normal)
            self.VerifyBtnO.isUserInteractionEnabled = false
        } else {
            self.VerifyBtnO.setTitleColor(#colorLiteral(red: 0, green: 0.786260426, blue: 0.4870494008, alpha: 1), for: .normal)
            self.VerifyBtnO.isUserInteractionEnabled = true
        }
        
        // Returning false because we manually set the text
        return false
    }
    
    
      func formatPhoneNumbero(_ number: String) -> String {
            var formattedNumber = ""
            let length = number.count
            
            // Add area code
            if length > 0 {
                formattedNumber += number.prefix(3)
            }
            if length > 3 {
                formattedNumber += "-" + number.dropFirst(3).prefix(3)
            }
            if length > 6 {
                formattedNumber += "-" + number.dropFirst(6)
            }
            
            return formattedNumber
        }

    @IBAction func CountryPickDropBtn(_ sender: UIButton) {
        let picker = ADCountryPicker(style: .grouped)
        picker.delegate = self
        picker.showCallingCodes = true
        picker.showFlags = true
        

        let pickerNavigationController = UINavigationController(rootViewController: picker)
        pickerNavigationController.modalPresentationStyle = .overCurrentContext
        self.present(pickerNavigationController, animated: true, completion: nil)
    }
    
    func countryPicker(_ picker: ADCountryPicker, didSelectCountryWithName name: String, code: String, dialCode: String) {
        if code == "IN" {
            self.CountryImg.image = UIImage(named: "IN")
        }else{
            let x =  picker.getFlag(countryCode: code)
            self.CountryImg.image = x
        }
         
        self.CountryDialCode = dialCode
        
        print(name, code, dialCode)
        //        let xx =  picker.getCountryName(countryCode: code)
        //        let xxx =  picker.getDialCode(countryCode: code)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func VerifyPhoneBtn(_ sender: UIButton) {
        guard self.PhoneTxtF.text?.count ?? 0 > 0 else {
            AlertControllerOnr(title: "", message: "Please enter phone number")
            return
        }
        
        guard self.PhoneTxtF.text?.count ?? 0 == 12 else {
            AlertControllerOnr(title: "", message: "Please enter valid phone number")
            return
        }
        
        self.Api_To_SendOtp()

    }
    
    @IBAction func ResendBtn(_ sender: UIButton) {
        ResentOTPTimer()
    }
   
    @IBAction func BackBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func UpdateBtn(_ sender: UIButton) {
        if OtpView.text != self.Otp {
            self.WrongOtpBgV.isHidden = false
        }else{
            self.WrongOtpBgV.isHidden = true
            self.Api_To_AddPhone()
        }
    }
}


extension AddNumberVC{
      
    func ResentOTPTimer(){
        self.Api_To_SendOtp()
        self.ResendTimeBgV.isHidden = false
        ResendBtnO.isUserInteractionEnabled = false
        var runCount = 60
        var time1 = 60
        
        self.ResendBtnO.setTitleColor(UIColor(red: 6/255, green: 193/255, blue: 105/255, alpha: 0.3), for: .normal)
        self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            print("Timer fired!")
            
            runCount -= 1
 
            if runCount <= 60 {
                self.CountTimeLbl.text = "01:\(String(runCount)) sec"
            }

            if runCount < 10{
                self.CountTimeLbl.text = "01:0\(String(runCount)) sec"
            }
            
            if runCount == 0 {
                timer.invalidate()
                self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
                    print("Timer fired!")
                    
                time1 -= 1
                if time1 <= 60 {
                    self.CountTimeLbl.text = "00:\(String(time1)) sec"
                }
       
                if time1 < 10{
                self.CountTimeLbl.text = "00:0\(String(time1)) sec"
                }
                
            if time1 == 0 {
                self.ResendBtnO.setTitleColor(UIColor(red: 6/255, green: 193/255, blue: 105/255, alpha: 1), for: .normal)
                self.ResendBtnO.isUserInteractionEnabled = true
                self.ResendTimeBgV.isHidden = true
                timer.invalidate()
            }
        }
    }
    }
    }
}

extension AddNumberVC: DPOTPViewDelegate {
    func dpOTPViewChangePositionAt(_ position: Int) {
        
    }
    
    func dpOTPViewBecomeFirstResponder() {
        
    }
    
    func dpOTPViewResignFirstResponder() {
        
    }
    
    func dpOTPViewAddText(_ text: String, at position: Int) {
        // Called whenever text changes
        print("Current OTP: \(text)")
        if text.count == 6 {
            print("All fields are filled with OTP: \(text)")
            self.UpdateBtnO.backgroundColor = #colorLiteral(red: 0, green: 0.786260426, blue: 0.4870494008, alpha: 1)
            self.UpdateBtnO.isUserInteractionEnabled = true
        } else {
            print("Fields are not completely filled")
            self.UpdateBtnO.backgroundColor = #colorLiteral(red: 0.6470588235, green: 0.6470588235, blue: 0.6470588235, alpha: 1)
            self.UpdateBtnO.isUserInteractionEnabled = false
        }
    }

    func dpOTPViewRemoveText(_ text: String, at position: Int) {
        // Called when a character is removed
        print("Current OTP after deletion: \(text)")
        self.UpdateBtnO.backgroundColor = #colorLiteral(red: 0.6470588235, green: 0.6470588235, blue: 0.6470588235, alpha: 1)
        self.UpdateBtnO.isUserInteractionEnabled = false
    }
}


// send-sms
extension AddNumberVC{
    func Api_To_SendOtp(){
        
        var params:JSONDictionary = [:]
        
        let phoneNum = self.PhoneTxtF.text ?? ""
         
        let stringWithoutDashes = phoneNum.replacingOccurrences(of: "-", with: "")
        //let Fphone = phoneNum.remove
        
        params["phone"] = "\(self.CountryDialCode)\(stringWithoutDashes)"
        
     
        showIndicator(withTitle: "", and: "")
        
        let loginURL = baseURL.baseURL + appEndPoints.send_sms
        
        print(loginURL,"loginURL")
        
        WebService.shared.postServiceURLEncoding(loginURL, VC: self, andParameter: params, withCompletion: { (json, statusCode) in
            
            self.hideIndicator()
            
            guard let dictData = json.dictionaryObject else{
                
                return
            }
            
            if dictData["success"] as? Bool == true{
                let val = dictData["data"] as? Int ?? Int()
                
                self.OtpView.text = ""
                
                self.showToast("\(val)")
                self.Otp = "\(val)"

                let LastFour = stringWithoutDashes.suffix(3)
                self.SentCodeonPhoneNumLbl.text = "We have sent the code to *******\(LastFour)"
                
                self.CurrentphoneNum = self.PhoneTxtF.text ?? ""
                self.VerifyBtnO.setTitleColor(#colorLiteral(red: 0.6470588235, green: 0.6470588235, blue: 0.6470588235, alpha: 1), for: .normal)
                self.VerifyBtnO.isUserInteractionEnabled = false
                
                self.PleaseCheckPhoneBgV.isHidden = false
                self.OTPBgV.isHidden = false
                self.ResendBgV.isHidden = false
                
                let responseMessage = dictData["message"] as! String
                self.showToast(responseMessage)
            }else{
                let responseMessage = dictData["message"] as! String
                self.showToast(responseMessage)
            }
        })
    }
    
    
    func Api_To_AddPhone(){
        
        var params:JSONDictionary = [:]
        
        let phoneNum = self.PhoneTxtF.text ?? ""
         
        let stringWithoutDashes = phoneNum.replacingOccurrences(of: "-", with: "")
        //let Fphone = phoneNum.remove
        
        params["phone"] = "\(stringWithoutDashes)"
        
        //let Fphone = phoneNum.remove
        params["otp"] = self.Otp
        
        params["country_code"] = "\(self.CountryDialCode)"
  
        
        showIndicator(withTitle: "", and: "")
        
        let loginURL = baseURL.baseURL + appEndPoints.add_phone
        
        print(loginURL,"loginURL")
        
        WebService.shared.postServiceURLEncoding(loginURL, VC: self, andParameter: params, withCompletion: { (json, statusCode) in
            
            self.hideIndicator()
            
            guard let dictData = json.dictionaryObject else{
                
                return
            }
            
            if dictData["success"] as? Bool == true{
                
                let responseMessage = dictData["message"] as! String
                self.navigationController?.showToast(responseMessage)
                
                self.backAction(self.PhoneTxtF.text!)
                self.navigationController?.popViewController(animated: true)
            }else{
                let responseMessage = dictData["message"] as! String
                self.showToast(responseMessage)
            }
        })
    }
}
