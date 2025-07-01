//
//  NotificationVC.swift
//  Myka App
//
//  Created by Sumit on 18/12/24.
//

import UIKit
import Alamofire

class NotificationVC: UIViewController {
    
    @IBOutlet weak var AllNotificationBtnO: UIButton!
    
    @IBOutlet var NotifCollectionBtnsO: [UIButton]!
    
    var isFristTime: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.API_TO_Get_Update_Notifications()
    }
    
    @IBAction func BackBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func EnableAllNotifBtn(_ sender: UIButton) {
        isFristTime = false
        
        if AllNotificationBtnO.isSelected == true{
            AllNotificationBtnO.isSelected = false
            for i in NotifCollectionBtnsO{
                i.isSelected = false
            }
        }else{
            AllNotificationBtnO.isSelected = true
            
            for i in NotifCollectionBtnsO{
                i.isSelected = true
            }
            isFristTime = false
        }
        
        self.API_TO_Get_Update_Notifications()
    }
    
    
    @IBAction func NotifCollectionBtns(_ sender: UIButton) {
        isFristTime = false
        
        switch sender.tag {
        case 0:
            if NotifCollectionBtnsO[sender.tag].isSelected == true{
                NotifCollectionBtnsO[sender.tag].isSelected = false
            }else{
                NotifCollectionBtnsO[sender.tag].isSelected = true
            }
            break
        case 1:
            if NotifCollectionBtnsO[sender.tag].isSelected == true{
                NotifCollectionBtnsO[sender.tag].isSelected = false
            }else{
                NotifCollectionBtnsO[sender.tag].isSelected = true
            }
            break
        case 2:
            if NotifCollectionBtnsO[sender.tag].isSelected == true{
                NotifCollectionBtnsO[sender.tag].isSelected = false
            }else{
                NotifCollectionBtnsO[sender.tag].isSelected = true
            }
            break
        case 3:
            if NotifCollectionBtnsO[sender.tag].isSelected == true{
                NotifCollectionBtnsO[sender.tag].isSelected = false
            }else{
                NotifCollectionBtnsO[sender.tag].isSelected = true
            }
            break
        default:
            break
        }
        
        
        if NotifCollectionBtnsO.allSatisfy({ $0.isSelected == true }) {
            AllNotificationBtnO.isSelected = true
        } else {
            AllNotificationBtnO.isSelected = false
        }
        
            self.API_TO_Get_Update_Notifications()
    }
}

extension NotificationVC {
    func API_TO_Get_Update_Notifications(){
        var params = [String: Any]()
        if isFristTime == false{
            if AllNotificationBtnO.isSelected == true{
                params["push_notification"] = "1"
                params["recipe_recommendations"] = "1"
                params["product_updates"] = "1"
                params["promotional_updates"] = "1"
            }else{
                if NotifCollectionBtnsO[0].isSelected == true{
                    params["push_notification"] = "1"
                }else{
                    params["push_notification"] = "0"
                }
                
                if NotifCollectionBtnsO[1].isSelected == true{
                    params["recipe_recommendations"] = "1"
                }else{
                    params["recipe_recommendations"] = "0"
                }
                
                if NotifCollectionBtnsO[2].isSelected == true{
                    params["product_updates"] = "1"
                }else{
                    params["product_updates"] = "0"
                }
                
                if NotifCollectionBtnsO[3].isSelected == true{
                    params["promotional_updates"] = "1"
                }else{
                    params["promotional_updates"] = "0"
                }
            }
        }else{
            params["push_notification"] = ""
            params["recipe_recommendations"] = ""
            params["product_updates"] = ""
            params["promotional_updates"] = ""
        }
        
        print("params", params)
      
        
        showIndicator(withTitle: "", and: "")
        let loginURL = baseURL.baseURL + appEndPoints.update_notification
        
        WebService.shared.postServiceURLEncoding(loginURL, VC: self, andParameter: params, withCompletion:  { (json, statusCode) in
            
            self.hideIndicator()
            
            guard let dictData = json.dictionaryObject else{
                return
            }
            
            if dictData["success"] as? Bool == true{
                let result = dictData["data"] as? NSDictionary ?? NSDictionary()
                
                let push_notification = result["push_notification"] as? String ?? "0"
                if push_notification == "0"{
                    self.NotifCollectionBtnsO[0].isSelected = false
                }else{
                    self.NotifCollectionBtnsO[0].isSelected = true
                }
                
                
                let recipe_recommendations = result["recipe_recommendations"] as? String ?? "0"
                if recipe_recommendations == "0"{
                    self.NotifCollectionBtnsO[1].isSelected = false
                }else{
                    self.NotifCollectionBtnsO[1].isSelected = true
                }
                 
                let product_updates = result["product_updates"] as? String ?? "0"
                if product_updates == "0"{
                    self.NotifCollectionBtnsO[2].isSelected = false
                }else{
                    self.NotifCollectionBtnsO[2].isSelected = true
                }
                
                let promotional_updates = result["promotional_updates"] as? String ?? "0"
                if promotional_updates == "0"{
                    self.NotifCollectionBtnsO[3].isSelected = false
                }else{
                    self.NotifCollectionBtnsO[3].isSelected = true
                }
                
                if self.NotifCollectionBtnsO.allSatisfy({ $0.isSelected == true }) {
                    self.AllNotificationBtnO.isSelected = true
                } else {
                    self.AllNotificationBtnO.isSelected = false
                }
                
            }else{
                let responseMessage = dictData["message"] as? String ?? ""
                self.showToast(responseMessage)
            }
        })
    }
}
