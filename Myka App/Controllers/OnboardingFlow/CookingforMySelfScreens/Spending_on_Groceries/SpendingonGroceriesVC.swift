//
//  SpendingonGroceriesVC.swift
//  Myka App
//
//  Created by YES IT Labs on 28/11/24.
//

import UIKit
import Alamofire
import SwiftyJSON

class SpendingonGroceriesVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var ProgressLbl: UILabel!
    
    @IBOutlet weak var amountTxtF: UITextField!
    
    @IBOutlet weak var DurationTxtF: UITextField!
    @IBOutlet weak var SelectDurationBtnO: UIButton!
    @IBOutlet weak var DropImg: UIImageView!
    
    @IBOutlet weak var WeekBgV: UIView!
    @IBOutlet weak var WeekTickImg: UIImageView!
    @IBOutlet weak var WeekBtnO: UIButton!
    @IBOutlet weak var WeekBgImg: UIImageView!
    
    @IBOutlet weak var MonthlyBgV: UIView!
    @IBOutlet weak var MonthlyTickImg: UIImageView!
    @IBOutlet weak var MonthlyBtnO: UIButton!
    @IBOutlet weak var MonthlyBgImg: UIImageView!
    
    @IBOutlet weak var TitleLbl: UILabel!
    @IBOutlet weak var SubTitleLbl: UILabel!
    
    @IBOutlet weak var NextBtnO: UIButton!
    @IBOutlet weak var NextbtnStackV: UIStackView!
    @IBOutlet weak var UpdateBtnO: UIButton!
    
    var type = ""
    var comesfrom = ""
    
    var Duration = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if comesfrom == ""{
            self.NextbtnStackV.isHidden = false
            self.UpdateBtnO.isHidden = true
        }else{
            self.NextbtnStackV.isHidden = true
            self.UpdateBtnO.isHidden = false
        }
        
        self.WeekBgV.isHidden = true
        self.MonthlyBgV.isHidden = true
        
        self.amountTxtF.delegate = self
       
         NextBtnO.backgroundColor = UIColor.lightGray
        NextBtnO.isUserInteractionEnabled = false
        
        let Attributes1: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.black
        ]
        let Attributes2: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.init(red: 6/255, green: 193/255, blue: 105/255, alpha: 1)
        ]
         
        if self.type == "MySelf"{
            self.ProgressLbl.text = "8/10"
            let progressVw = Float(8) / Float(10)
            progressView.progress = Float(progressVw)
            
            let helloString = NSAttributedString(string: "Spending on", attributes: Attributes1)
            let worldString = NSAttributedString(string: " Groceries", attributes: Attributes2)
            let fullString = NSMutableAttributedString()
            fullString.append(helloString)
            fullString.append(worldString)
            self.TitleLbl.attributedText = fullString
            self.SubTitleLbl.text = "How much do you typically spend on \ngroceries per  week/month?"
             
        }else if self.type == "Partner"{
            self.ProgressLbl.text = "9/11"
            let progressVw = Float(9) / Float(11)
            progressView.progress = Float(progressVw)
             
            let helloString = NSAttributedString(string: "Spending on", attributes: Attributes1)
            let worldString = NSAttributedString(string: " Groceries", attributes: Attributes2)
            let fullString = NSMutableAttributedString()
            fullString.append(helloString)
            fullString.append(worldString)
            self.TitleLbl.attributedText = fullString
            self.SubTitleLbl.text = "How much do you normally spend on \ngroceries each week or month?"
        }else{
            self.ProgressLbl.text = "9/11"
            let progressVw = Float(9) / Float(11)
            progressView.progress = Float(progressVw)
            
            let helloString = NSAttributedString(string: "Spending on", attributes: Attributes1)
            let worldString = NSAttributedString(string: " Groceries", attributes: Attributes2)
            let fullString = NSMutableAttributedString()
            fullString.append(helloString)
            fullString.append(worldString)
            self.TitleLbl.attributedText = fullString
            self.SubTitleLbl.text = "How much do you normally spend on \ngroceries each week or month?"
        }
        
        if comesfrom != ""{
            self.Api_To_GetPrefrenceBodyGoals()
        }
    }
    
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        if textField == self.amountTxtF{
//            if textField.text!.count == 0 || string == "" {
//                NextBtnO.backgroundColor = UIColor.lightGray
//                NextBtnO.isUserInteractionEnabled = false
//            }else if textField.text!.count != 0 && self.DurationTxtF.text!.count != 0 {
//                NextBtnO.backgroundColor = #colorLiteral(red: 0.02352941176, green: 0.7568627451, blue: 0.4117647059, alpha: 1)
//                NextBtnO.isUserInteractionEnabled = true
//            }
//        }
//        return true
//    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == self.amountTxtF {
            // Get the current text
            let currentText = textField.text ?? ""
            
            // Calculate the new text after the change
            let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
           
            if newText.isEmpty {
                // If the text is empty, clear the field
                textField.text = ""
                NextBtnO.backgroundColor = UIColor.lightGray
                NextBtnO.isUserInteractionEnabled = false
                UpdateBtnO.backgroundColor = UIColor.lightGray
                UpdateBtnO.isUserInteractionEnabled = false
            } else {
                // Add the "$" symbol at the beginning
                let textWithoutDollar = newText.replacingOccurrences(of: "$", with: "")
                textField.text = "$" + textWithoutDollar
                
                // Adjust the cursor position
                if let newPosition = textField.position(from: textField.beginningOfDocument, offset: range.location + string.count + 1) {
                    textField.selectedTextRange = textField.textRange(from: newPosition, to: newPosition)
                }
                
                // Enable or disable the button based on the conditions
                if textWithoutDollar.isEmpty || self.DurationTxtF.text!.isEmpty {
                    NextBtnO.backgroundColor = UIColor.lightGray
                    NextBtnO.isUserInteractionEnabled = false
                    UpdateBtnO.backgroundColor = UIColor.lightGray
                    UpdateBtnO.isUserInteractionEnabled = false
                } else {
                    NextBtnO.backgroundColor = #colorLiteral(red: 0.02352941176, green: 0.7568627451, blue: 0.4117647059, alpha: 1)
                    NextBtnO.isUserInteractionEnabled = true
                    UpdateBtnO.backgroundColor = #colorLiteral(red: 0.02352941176, green: 0.7568627451, blue: 0.4117647059, alpha: 1)
                    UpdateBtnO.isUserInteractionEnabled = true
                }
            }
            return false // Prevent the default behavior as we are updating the text manually
        }
        return true
    }

    
    
     
        @IBAction func BackBtn(_ sender: UIButton) {
            self.navigationController?.popViewController(animated: false)
        }
    
    
    @IBAction func DropdownBtn(_ sender: UIButton) {
        view.endEditing(true) // Dismisses the keyboard
        if self.SelectDurationBtnO.isSelected == true {
            self.SelectDurationBtnO.isSelected = false
            self.DropImg.image = UIImage(named: "DropDownDark")
            self.WeekBgV.isHidden = true
            self.MonthlyBgV.isHidden = true
        }else{
            self.SelectDurationBtnO.isSelected = true
            self.DropImg.image = UIImage(named: "DropUpDark")
            self.WeekBgV.isHidden = false
            self.MonthlyBgV.isHidden = false
        }
    }
    
    @IBAction func WeekBtn(_ sender: UIButton) {
            self.Duration = "Weekly"
            self.DurationTxtF.text = "Weekly"
            self.WeekBtnO.isSelected = true
            self.WeekBgImg.image = UIImage(named: "YelloBorder")
            self.WeekTickImg.image = UIImage(named: "Tick")
            self.MonthlyBtnO.isSelected = false
            self.MonthlyBgImg.image = UIImage(named: "Group 1171276489")
            self.MonthlyTickImg.image = UIImage(named: "")
            NextBtnO.isUserInteractionEnabled = true
            NextBtnO.backgroundColor = #colorLiteral(red: 0.02352941176, green: 0.7568627451, blue: 0.4117647059, alpha: 1)
        
            self.SelectDurationBtnO.isSelected = false
            self.DropImg.image = UIImage(named: "DropDownDark")
            self.WeekBgV.isHidden = true
            self.MonthlyBgV.isHidden = true
    }
    
    @IBAction func MonthlyBtn(_ sender: UIButton) {
            self.Duration = "Monthly"
            self.DurationTxtF.text = "Monthly"
            self.MonthlyBtnO.isSelected = true
            self.MonthlyBgImg.image = UIImage(named: "YelloBorder")
            self.MonthlyTickImg.image = UIImage(named: "Tick")
            self.WeekBtnO.isSelected = false
            self.WeekBgImg.image = UIImage(named: "Group 1171276489")
            self.WeekTickImg.image = UIImage(named: "")
            NextBtnO.isUserInteractionEnabled = true
            NextBtnO.backgroundColor = #colorLiteral(red: 0.02352941176, green: 0.7568627451, blue: 0.4117647059, alpha: 1)
        
        self.SelectDurationBtnO.isSelected = false
        self.DropImg.image = UIImage(named: "DropDownDark")
        self.WeekBgV.isHidden = true
        self.MonthlyBgV.isHidden = true

    }
    
        @IBAction func SkipBtn(_ sender: UIButton) {
            let storyboard = UIStoryboard(name: "CookingForMySelf", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "SkipPopupVC") as! SkipPopupVC
            vc.backAction = {
                let storyboard = UIStoryboard(name: "CookingForMySelf", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "EatingOutVC") as! EatingOutVC
                vc.Duration = self.Duration
                vc.type = self.type
                self.navigationController?.pushViewController(vc, animated: false)
            }
            vc.modalPresentationStyle = .overCurrentContext
            self.present(vc, animated: false)
        }
        
        @IBAction func NextBtn(_ sender: UIButton) {
            guard self.amountTxtF.text! != "" else {
                AlertControllerOnr(title: "", message: "Please type an amount.")
                return
            }
            
            guard self.Duration != "" else {
                AlertControllerOnr(title: "", message: "Please select the duration first.")
                return
            }
             
    //        if self.type == "MySelf"{
            StateMangerModelClass.shared.onboardingSelectedData.MySelfSeldata[0].SpendingOnGroceries.Amount = self.amountTxtF.text ?? ""
            StateMangerModelClass.shared.onboardingSelectedData.MySelfSeldata[0].SpendingOnGroceries.duration = self.Duration
            
            let storyboard = UIStoryboard(name: "CookingForMySelf", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "EatingOutVC") as! EatingOutVC
            vc.Duration = self.Duration
            vc.type = self.type
            self.navigationController?.pushViewController(vc, animated: false)
        }
    
    @IBAction func UpdateBtn(_ sender: UIButton) {
        self.Api_To_UpdatePrefrence()
    }
    }

extension SpendingonGroceriesVC {
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
                
                let response = result["grocereisExpenses"] as?  NSDictionary ?? NSDictionary()
                let Amount = response["amount"] as? String ?? ""
                
                if Amount != ""{
                    if Amount.contains(s: "$"){
                        self.amountTxtF.text = Amount
                    }else{
                        self.amountTxtF.text = "$" + Amount
                    }
                }else{
                    self.UpdateBtnO.backgroundColor = UIColor.lightGray
                    self.UpdateBtnO.isUserInteractionEnabled = false
                    self.amountTxtF.text = Amount
                }
                
                let duration = response["duration"] as? String ?? ""
                if duration != ""{
                    self.SelectDurationBtnO.isSelected = false
                    self.DropImg.image = UIImage(named: "DropDownDark")
                    self.WeekBgV.isHidden = true
                    self.MonthlyBgV.isHidden = true
                    
                    if duration == "Weekly"{
                        self.DurationTxtF.text = "Weekly"
                        self.Duration = "Weekly"
                        self.WeekBtnO.isSelected = true
                        self.WeekBgImg.image = UIImage(named: "YelloBorder")
                        self.WeekTickImg.image = UIImage(named: "Tick")
                        self.MonthlyBtnO.isSelected = false
                        self.MonthlyBgImg.image = UIImage(named: "Group 1171276489")
                        self.MonthlyTickImg.image = UIImage(named: "")
                        self.NextBtnO.isUserInteractionEnabled = true
                        self.NextBtnO.backgroundColor = #colorLiteral(red: 0.02352941176, green: 0.7568627451, blue: 0.4117647059, alpha: 1)
                    }else{
                        self.DurationTxtF.text = "Monthly"
                        self.Duration = "Monthly"
                        self.MonthlyBtnO.isSelected = true
                        self.MonthlyBgImg.image = UIImage(named: "YelloBorder")
                        self.MonthlyTickImg.image = UIImage(named: "Tick")
                        self.WeekBtnO.isSelected = false
                        self.WeekBgImg.image = UIImage(named: "Group 1171276489")
                        self.WeekTickImg.image = UIImage(named: "")
                        self.NextBtnO.isUserInteractionEnabled = true
                        self.NextBtnO.backgroundColor = #colorLiteral(red: 0.02352941176, green: 0.7568627451, blue: 0.4117647059, alpha: 1)
                    }
                }
            }else{
                let responseMessage = dictData["message"] as! String
                self.showToast(responseMessage)
            }
        })
    }
    
    func Api_To_UpdatePrefrence(){
        var params : [String:Any] = [:]
  
        params["spending_amount"] = self.amountTxtF.text!
        params["duration"] = self.DurationTxtF.text!

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
