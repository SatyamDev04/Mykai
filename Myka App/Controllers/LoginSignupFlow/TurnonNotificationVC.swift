//
//  TurnonNotificationVC.swift
//  Myka App
//
//  Created by YES IT Labs on 03/12/24.
//

import UIKit
import Alamofire
 

class TurnonNotificationVC: UIViewController {
    
    var comesfrom = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        if comesfrom == "Signup" {
            UserDetail.shared.setiSfromSignup(true)
        }
        // Do any additional setup after loading the view.
    }
    

    @IBAction func TurnOnLocBtn(_ sender: UIButton) {
        self.Api_To_TurnonNotification(Status: "1")
    }

//    @IBAction func NotNowBtn(_ sender: UIButton) {
//        self.Api_To_TurnonNotification(Status: "0")
//    }
}

extension TurnonNotificationVC {
    func Api_To_TurnonNotification(Status: String){
        var params = [String: Any]()
        
        
        params["notification_status"] = Status
        
     
        showIndicator(withTitle: "", and: "")
        
        let loginURL = baseURL.baseURL + appEndPoints.TurnOnNotification
        print(params,"Params")
        print(loginURL,"loginURL")
        
        WebService.shared.postServiceURLEncoding(loginURL, VC: self, andParameter: params, withCompletion: { (json, statusCode) in
            
            self.hideIndicator()
            
            guard let dictData = json.dictionaryObject else{
                return
            }
            
            if dictData["success"] as? Bool == true{
                let val = dictData["data"] as? NSDictionary ?? NSDictionary()
                
                let UserType = val["cooking_for_type"] as? String ?? "1"
                UserDetail.shared.setUserType(UserType)
                
                if self.comesfrom == "Signup" {
                    let storyboard = UIStoryboard(name: "Subscription", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "SubscriptionVC") as! SubscriptionVC
                    vc.comesFrom = "Signup"
                    vc.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(vc, animated: true)
                }else{
                    let storyboard = UIStoryboard(name: "Tabbar", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "TabbarVC") as! TabbarVC
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }else{
                let responseMessage = dictData["message"] as! String
                self.showToast(responseMessage)
            }
        })
    }
}
