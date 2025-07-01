//
//  WalletVC.swift
//  Myka App
//
//  Created by YES IT Labs on 18/12/24.
//

import UIKit
import Alamofire

class WalletVC: UIViewController, UIPopoverPresentationControllerDelegate {

    @IBOutlet weak var BalanceLbl: UILabel!
    
    @IBOutlet weak var NameLbl: UILabel!
    
    @IBOutlet weak var DateLbl: UILabel!
    
    @IBOutlet weak var EnterAmountTxtF: UITextField!
    
    @IBOutlet weak var WithdrawAmountlbl: UILabel!
    
    @IBOutlet var WithdrawPopupV: UIView!
    
    @IBOutlet weak var WithdrawBtnO: UIButton!
    
    
    var Saved_BankArrList = [ModelClass]()
    var SavedCardArrList = [ModelClass]()
    
    private var CardID: String = ""
    private var CustmID: String = ""
    
    var WalletCreated_DayCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.WithdrawPopupV.frame = self.view.bounds
        self.view.addSubview(self.WithdrawPopupV)
        self.WithdrawPopupV.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.API_TO_Get_Wallet()
        self.API_TO_Get_Cards()
        
        if StateMangerModelClass.shared.isCardAdded == true{
            let storyboard = UIStoryboard(name: "Profile", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "SavedCardBankVC") as! SavedCardBankVC
            vc.BackAction = { cardId, CustmID in
                self.CardID = cardId
                self.CustmID = CustmID
                self.WithdrawPopupV.isHidden = false
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func BackBtnAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func InfoBtn(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Fav", bundle: nil)
            let popoverContent = storyboard.instantiateViewController(withIdentifier: "InfoVC") as! InfoVC
            popoverContent.MSg = "You can withdraw the amount from your wallet after 15 days."
            popoverContent.modalPresentationStyle = .popover

            if let popover = popoverContent.popoverPresentationController {
                popover.sourceView = sender
                popover.sourceRect = sender.bounds // Attach to the button bounds
                popover.permittedArrowDirections = .up // Force the popover to show below the button
                popover.delegate = self
                popoverContent.preferredContentSize = CGSize(width: 190, height: 90)
            }

            self.present(popoverContent, animated: true, completion: nil)
    }
    
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none // Ensures the popover does not change to fullscreen on compact devices.
    }
    
    
    @IBAction func WithdrawMoneyBtn(_ sender: UIButton) {
        guard  self.WalletCreated_DayCount > 15 else{
            self.AlertControllerOnr(title: "", message: "You can only withdraw money after 15 days of creating your wallet.")
            return
        }
        
        guard self.BalanceLbl.text! != "$ 0" else{
            self.AlertControllerOnr(title: "", message: "You have no balance to withdraw.")
            return
        }
        
        if SavedCardArrList.count != 0 || Saved_BankArrList.count != 0 {
            let storyboard = UIStoryboard(name: "Profile", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "SavedCardBankVC") as! SavedCardBankVC
            vc.BackAction = { cardId, CustmID in
                self.CardID = cardId
                self.CustmID = CustmID
                self.WithdrawPopupV.isHidden = false
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            let storyboard = UIStoryboard(name: "Profile", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "AddCardBankContainerVC") as! AddCardBankContainerVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    // for popup btns
    @IBAction func CrossBtn(_ sender: UIButton) {
        self.WithdrawPopupV.isHidden = true
    }
    
    @IBAction func RequestWithdrawBtn(_ sender: UIButton) {
        guard self.BalanceLbl.text! <= self.EnterAmountTxtF.text! else{
            self.AlertControllerOnr(title: "", message: "You have not enough balance to withdraw.")
            return
        }
        self.WithdrawPopupV.isHidden = true
        self.API_TO_transfer_To_Account(BankAccId: self.CardID)
    }
    //
}

extension WalletVC {
    func API_TO_Get_Wallet(){
   
 
     showIndicator(withTitle: "", and: "")
        let loginURL = baseURL.baseURL + appEndPoints.get_wallet

        WebService.shared.postServiceURLEncoding(loginURL, VC: self, andParameter: [:], withCompletion:  { (json, statusCode) in
 
     self.hideIndicator()
     
     guard let dictData = json.dictionaryObject else{
         return
     }
 
     if dictData["success"] as? Bool == true{
          
         let val = dictData["data"] as? NSDictionary ?? NSDictionary()
         let walletbalance = val["walletbalance"] as? Double ?? 0
         let name = val["name"] as? String ?? ""
         let date = val["date"] as? String ?? ""
         let created_at = val["created_at"] as? String ?? ""
         
         let createdAtString = created_at // "2025-01-21 06:07"
         let dateFormatter = DateFormatter()
         dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
         dateFormatter.timeZone = TimeZone(abbreviation: "UTC") // Adjust timezone if needed

         let createdAtDate = dateFormatter.date(from: createdAtString) ?? Date()
         let currentDate = Date()
         let calendar = Calendar.current
             
         // Calculate the number of days between the two dates
         let components = calendar.dateComponents([.day], from: createdAtDate, to: currentDate)
         if let days = components.day {
             print("Number of days: \(days)")
             self.WalletCreated_DayCount = days
         } else {
             print("Could not calculate the number of days.")
             self.WalletCreated_DayCount = 0
         }
        
         let bal = self.formatPrice(walletbalance)
         
         self.BalanceLbl.text = "$ \(bal)"
         self.WithdrawAmountlbl.text = "$\(bal)"
         self.NameLbl.text = name.capitalizedFirst
         self.DateLbl.text = "On \(date)"
         
        }else{
            self.BalanceLbl.text = "$ 0"
            let responseMessage = dictData["message"] as? String ?? ""
            self.showToast(responseMessage)
        }
   })
  }
    
  //  transfer-To-Account
    func API_TO_transfer_To_Account(BankAccId: String){
    var params = [String: Any]()
        
        params["amount"] = self.EnterAmountTxtF.text!
        params["account_id"] = BankAccId
       
     showIndicator(withTitle: "", and: "")
        let loginURL = baseURL.baseURL + appEndPoints.transfer_To_Account

        WebService.shared.postServiceURLEncoding(loginURL, VC: self, andParameter: params, withCompletion:  { (json, statusCode) in
 
     self.hideIndicator()
     
     guard let dictData = json.dictionaryObject else{
         return
     }
 
     if dictData["success"] as? Bool == true{
         self.API_TO_Get_Wallet()
        }else{
            let responseMessage = dictData["message"] as? String ?? ""
            self.showToast(responseMessage)
        }
   })
  }
    
    //
    func API_TO_Get_Cards(){
   
        self.WithdrawBtnO.isUserInteractionEnabled = false
        
 
     showIndicator(withTitle: "", and: "")
        let loginURL = baseURL.baseURL + appEndPoints.get_card_Bank_details

        WebService.shared.postServiceURLEncoding(loginURL, VC: self, andParameter: [:], withCompletion:  { (json, statusCode) in
 
     self.hideIndicator()
     
     guard let dictData = json.dictionaryObject else{
         return
     }
 
     if dictData["success"] as? Bool == true{
          
         let val = dictData["data"] as? NSDictionary ?? NSDictionary()
         
         let BankResult = val["bank_details"] as? [[String: Any]] ?? [[String: Any]]()
         
         self.Saved_BankArrList.removeAll()
         self.Saved_BankArrList = ModelClass.Get_Saved_BankListtDetails(responseArray: BankResult)
          
         
         let CardResult = val["card_details"] as? [[String: Any]] ?? [[String: Any]]()
         
         self.SavedCardArrList.removeAll()
         self.SavedCardArrList = ModelClass.Get_Saved_CardsListtDetails(responseArray: CardResult)
          
         self.WithdrawBtnO.isUserInteractionEnabled = true
        }else{
            self.WithdrawBtnO.isUserInteractionEnabled = true
            let responseMessage = dictData["message"] as! String
            self.showToast(responseMessage)
        }
   })
  }
}
