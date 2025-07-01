//
//  FeedBackVC.swift
//  Myka App
//
//  Created by YES IT Labs on 17/12/24.
//

import UIKit
import Alamofire

class FeedBackVC: UIViewController, UITextViewDelegate {

    @IBOutlet weak var EmailTxtF: UITextField!
    
    @IBOutlet weak var DescTxtV: UITextView!
    
    //PopupV.
    @IBOutlet var FeedBAck_SupptPopupVPopupV: UIView!
    @IBOutlet var DiscardPopUpV: UIView!
    //
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.FeedBAck_SupptPopupVPopupV.frame = self.view.bounds
        self.view.addSubview(self.FeedBAck_SupptPopupVPopupV)
        self.FeedBAck_SupptPopupVPopupV.isHidden = true
        
        self.DiscardPopUpV.frame = self.view.bounds
        self.view.addSubview(self.DiscardPopUpV)
        self.DiscardPopUpV.isHidden = true
        
       
        
        DescTxtV.text = "Type your feedback here"
        DescTxtV.textColor = #colorLiteral(red: 0.2352941176, green: 0.2705882353, blue: 0.2549019608, alpha: 1)
        DescTxtV.delegate = self
        
        planService.shared.Api_To_Get_ProfileData(vc: self) { result in
            
            switch result {
            case .success(let allData):
                let response = allData
                
                let Email = response?["email"] as? String ?? String()
                self.EmailTxtF.text = Email
            case .failure(let error):
                // Handle error
                print("Error retrieving data: \(error.localizedDescription)")
            }
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if(DescTxtV.text == "Type your feedback here") {
            DescTxtV.text = ""
            DescTxtV.textColor = #colorLiteral(red: 0.2352941176, green: 0.2705882353, blue: 0.2549019608, alpha: 1)
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if(DescTxtV.text == "") {
            DescTxtV.text = "Type your feedback here"
            DescTxtV.textColor = #colorLiteral(red: 0.2352941176, green: 0.2705882353, blue: 0.2549019608, alpha: 1)
        }
    }
    
    
    
    @IBAction func BackBtn(_ sender: UIButton) {
        self.DiscardPopUpV.isHidden = false
    }
    
    @IBAction func SubmitBtn(_ sender: UIButton) {
        guard EmailTxtF.text! != "" else{
            AlertControllerOnr(title: "", message: "Enter your email first.")
            return
        }
        
        guard DescTxtV.text! != "Type your feedback here" else{
            AlertControllerOnr(title: "", message: "Enter your feedback first.")
            return
        }
        
        self.Api_To_Save_FeedBack()
    }
    
    // popupV Btns
    @IBAction func OkayBtn(_ sender: UIButton) {
        self.FeedBAck_SupptPopupVPopupV.isHidden = true
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func FeedBckCrossIcon(_ sender: UIButton) {
        self.FeedBAck_SupptPopupVPopupV.isHidden = true
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func CancelBtn(_ sender: UIButton) {
        self.DiscardPopUpV.isHidden = true
    }
    
    @IBAction func RemoveBtn(_ sender: UIButton) {
        self.DiscardPopUpV.isHidden = true
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func DiscardCrossIcon(_ sender: UIButton) {
        self.DiscardPopUpV.isHidden = true
    }

}


extension FeedBackVC {
    func Api_To_Save_FeedBack(){
        var params = [String: Any]()
         
        if DescTxtV.text == "Type your feedback here"{
            params["message"] = ""
        }else{
            params["message"] = DescTxtV.text!
        }
        
        params["email"] = EmailTxtF.text!
      
        showIndicator(withTitle: "", and: "")
        
        let loginURL = baseURL.baseURL + appEndPoints.saveFeedback
        print(params,"Params")
        print(loginURL,"loginURL")
        
        WebService.shared.postServiceURLEncoding(loginURL, VC: self, andParameter: params, withCompletion: { (json, statusCode) in
            
            self.hideIndicator()
            
            guard let dictData = json.dictionaryObject else{
                return
            }
            
            if dictData["success"] as? Bool == true{
           
                self.FeedBAck_SupptPopupVPopupV.isHidden = false
                
            }else{
                let responseMessage = dictData["message"] as? String ?? ""
                self.showToast(responseMessage)
            }
        })
    }

}
