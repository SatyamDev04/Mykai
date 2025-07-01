//
//  RateYourMealVC.swift
//  Myka App
//
//  Created by Sumit on 10/12/24.
//

import UIKit
import Cosmos
import Alamofire

class RateYourMealVC: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var RatingView: CosmosView!
    @IBOutlet weak var MsgTxtV: UITextView!
    
    var uri = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MsgTxtV.delegate = self
        MsgTxtV.textColor = UIColor.black
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if(MsgTxtV.text == "Message...") {
            MsgTxtV.text = ""
            MsgTxtV.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if(MsgTxtV.text == "") {
            MsgTxtV.text = "Message..."
            MsgTxtV.textColor = UIColor.black
        }
    }
    
    @IBAction func BackBtn(_ sender: UIButton) {
        self.navigationController?.popToViewController(ofClass: RecipeDetailsVC.self)
    }
    
    @IBAction func PublishReview(_ sender: UIButton) {
        self.Api_For_AddMealRating()
    }
    
}

extension RateYourMealVC {
    func Api_For_AddMealRating(){
        var params = [String: Any]()
          
        params["uri"] = self.uri
        params["rating"] = Int(self.RatingView.rating)
        
        if MsgTxtV.text == "Message..." {
            params["comment"] = ""
        }else{
            params["comment"] = self.MsgTxtV.text ?? ""
        }
        
     
        
        showIndicator(withTitle: "", and: "")
        
        let loginURL = baseURL.baseURL + appEndPoints.meal_review
        print(params,"Params")
        print(loginURL,"loginURL")
        
        WebService.shared.postServiceURLEncoding(loginURL, VC: self, andParameter: params, withCompletion: { (json, statusCode) in
            
            self.hideIndicator()
            
            guard let dictData = json.dictionaryObject else{
                return
            }
            
            let Msg = dictData["message"] as? String ?? ""
            
            if dictData["success"] as? Bool == true{
                self.showToast(Msg)
                let data:[String: String] = ["data": ""]
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "notificationNameReloadDetails"), object: nil, userInfo: data)
                self.navigationController?.popToViewController(ofClass: RecipeDetailsVC.self)
            }else{
                self.showToast(Msg)
            }
        })
    }
    
}
