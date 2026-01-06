//
//  Cooking _for _Partners _infoVC.swift
//  Myka App
//  Created by YES IT Labs on 29/11/24.
//

import UIKit
import Alamofire
import SwiftyJSON


class Cooking__for__Partners__infoVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var ProgressLbl: UILabel!
    @IBOutlet weak var PartnersNameTxtF: UITextField!
    @IBOutlet weak var PartnersAgeTxtF: UITextField!
    @IBOutlet weak var SelectGenderTxtF: UITextField!
    @IBOutlet weak var GenderDropBtnO: UIButton!
    @IBOutlet weak var DropImg: UIImageView!
    @IBOutlet weak var MaleBgV: UIView!
    @IBOutlet weak var FemaleBgV: UIView!

    @IBOutlet weak var NextbtnStackV: UIStackView!
    @IBOutlet weak var UpdateBtnO: UIButton!

    var type = ""
    var comesfrom = ""

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        restoreDraft()

        if comesfrom != "" {
            Api_To_GetPrefrenceBodyGoals()
        }
    }

    // MARK: - Setup
    private func setupUI() {

        PartnersNameTxtF.delegate = self
        PartnersAgeTxtF.delegate = self

        ProgressLbl.text = "1/11"
        progressView.progress = Float(1) / Float(11)

        MaleBgV.isHidden = true
        FemaleBgV.isHidden = true
        DropImg.image = UIImage(named: "DropDown")

        NextbtnStackV.isHidden = comesfrom != ""
        UpdateBtnO.isHidden = comesfrom == ""
    }

    // MARK: - Restore Draft
    private func restoreDraft() {
        let draft = StateMangerModelClass.shared.onboardingSelectedData.Partnersname

        PartnersNameTxtF.text = draft.Name
        PartnersAgeTxtF.text = draft.Age
        SelectGenderTxtF.text = draft.Gender
    }

    // MARK: - Save Draft
    private func saveDraft() {
        var partner = StateMangerModelClass.shared.onboardingSelectedData.Partnersname
        partner.Name = PartnersNameTxtF.text ?? ""
        partner.Age = PartnersAgeTxtF.text ?? ""
        partner.Gender = SelectGenderTxtF.text ?? ""

        StateMangerModelClass.shared.onboardingSelectedData.Partnersname = partner
    }

    // MARK: - TextField Delegate
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {

        let current = textField.text ?? ""
        let updated = (current as NSString).replacingCharacters(in: range, with: string)
        textField.text = updated

        saveDraft()
        return false
    }

    // MARK: - Gender Dropdown
    @IBAction func GenderBtn(_ sender: UIButton) {
        GenderDropBtnO.isSelected.toggle()
        let show = GenderDropBtnO.isSelected

        MaleBgV.isHidden = !show
        FemaleBgV.isHidden = !show
        DropImg.image = UIImage(named: show ? "DropUp" : "DropDown")
    }

    @IBAction func MaleBtn(_ sender: UIButton) {
        selectGender("Male")
    }

    @IBAction func FemaleBtn(_ sender: UIButton) {
        selectGender("Female")
    }

    private func selectGender(_ gender: String) {
        GenderDropBtnO.isSelected = false
        MaleBgV.isHidden = true
        FemaleBgV.isHidden = true
        DropImg.image = UIImage(named: "DropDown")

        SelectGenderTxtF.text = gender
        saveDraft()
    }

    // MARK: - Navigation
    @IBAction func BackBtn(_ sender: UIButton) {
        navigationController?.popViewController(animated: false)
    }

    @IBAction func SkipBtn(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "CookingForMySelf", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SkipPopupVC") as! SkipPopupVC
        vc.backAction = {
            let vc = storyboard.instantiateViewController(withIdentifier: "BodyGoalsVC") as! BodyGoalsVC
            vc.type = self.type
            self.navigationController?.pushViewController(vc, animated: false)
        }
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: false)
    }

    @IBAction func NextBtn(_ sender: UIButton) {

        guard PartnersNameTxtF.text?.isEmpty == false else {
            AlertControllerOnr(title: "", message: "Enter partner's name first.")
            return
        }

        guard PartnersAgeTxtF.text?.isEmpty == false else {
            AlertControllerOnr(title: "", message: "Enter partner's age first.")
            return
        }

        guard SelectGenderTxtF.text?.isEmpty == false else {
            AlertControllerOnr(title: "", message: "Select gender first.")
            return
        }

    
        saveDraft()

        let storyboard = UIStoryboard(name: "CookingForMySelf", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "BodyGoalsVC") as! BodyGoalsVC
        vc.type = type
        navigationController?.pushViewController(vc, animated: false)
    }

    @IBAction func UpdateBtn(_ sender: UIButton) {
        Api_To_UpdatePrefrence()
    }
}

extension Cooking__for__Partners__infoVC {
    func Api_To_GetPrefrenceBodyGoals(){
        
        let params = [String: Any]()
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



