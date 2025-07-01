//
//  Terme_PrivacyPVC.swift
//  Myka App
//
//  Created by YES IT Labs on 17/12/24.
//

import UIKit

class Terme_PrivacyPVC: UIViewController {
    
    @IBOutlet weak var ImgV: UIImageView!
    @IBOutlet weak var TxtLbl: UILabel!
    @IBOutlet weak var TitleLbl: UILabel!
    
    var comesFrom: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        if comesFrom == "TNC"{
            TitleLbl.text = "Terms & Conditions"
            ImgV.image = UIImage(named: "Group 1171276287")
        }else{
            TitleLbl.text = "Privacy Policy"
            ImgV.image = UIImage(named: "Privacy")
        }
        
        self.Api_To_Get_Terms_and_PrivacyPolicy()
    }
    

    @IBAction func BackBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    

}


extension Terme_PrivacyPVC {
    func Api_To_Get_Terms_and_PrivacyPolicy(){
        var params = [String: Any]()
        
       
        showIndicator(withTitle: "", and: "")
        
        var loginURL = ""
        
        if comesFrom == "TNC"{
           loginURL = baseURL.baseURL + appEndPoints.terms_and_Condation
        }else{
           loginURL = baseURL.baseURL + appEndPoints.privacyPolicy
        }
            
        print(params,"Params")
        print(loginURL,"loginURL")
        
        WebService.shared.getServiceURLEncodingwithParams(loginURL, VC: self, andParameter: params, withCompletion: { (json, statusCode) in
            
            self.hideIndicator()
            
            guard let dictData = json.dictionaryObject else{
                return
            }
            
            if dictData["success"] as? Bool == true{
                let response = dictData["data"] as? NSDictionary ?? NSDictionary()
                let htmlString = response["description"] as? String ?? String()
                
                let titleStr = htmlString.htmlAttributedString()
                  
                self.TxtLbl.attributedText = titleStr
                self.TxtLbl.textColor = .black
                
            }else{
                let responseMessage = dictData["message"] as! String
                self.showToast(responseMessage)
            }
        })
    }
}
