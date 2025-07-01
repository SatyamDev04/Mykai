//
//  StartTrailVC.swift
//  Myka App
//
//  Created by Sumit on 09/12/24.
//

import UIKit
import StoreKit

class StartTrailVC: UIViewController, SKRequestDelegate {

    @IBOutlet weak var CrossBtn: UIButton!
    
    var comesfrom = ""
    var Sel_SubsPrice = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.CrossBtn.isHidden = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
            self.CrossBtn.isHidden = false
        }
        NotificationCenter.default.addObserver(self, selector: #selector(listnerFunction(_:)), name: NSNotification.Name(rawValue: "notificationName"), object: nil)
    }
    
    @objc func listnerFunction(_ notification: NSNotification) {
        if notification.userInfo?["data"] as? String ?? "" == "Purchase successful" {
            let Receipt = notification.userInfo?["Receipt"] as? String ?? ""
            hideIndicator()
            if Receipt != ""{
      
                hideIndicator()
                sendReceiptToServer(Receipt: Receipt)
            }
        }
            
      }
    
    func sendReceiptToServer(Receipt: String) {
        var params = [String: Any]()
        params["provider_id"] = UserDetail.shared.getUserId()
        params["type"] = "ios"
        params["receipt_data"] = Receipt
                   
            self.hideIndicator()
            showIndicator(withTitle: "", and: "")
          
            let loginURL = baseURL.baseURL// + appEndPoints.payinapp_Subscription
            print(loginURL,"loginURL")

        WebService.shared.postServiceURLEncoding(loginURL, VC: self, andParameter: params, withCompletion: { (json, statusCode) in

            self.hideIndicator()
             
             guard let dictData = json.dictionaryObject else{
                 return
             }
                if dictData["success"] as! Bool == true{
                    if self.comesfrom == "Signup" {
                        let storyboard = UIStoryboard(name: "Tabbar", bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: "TabbarVC") as! TabbarVC
                        self.navigationController?.pushViewController(vc, animated: true)
                    }else{
                        self.navigationController?.popViewController(animated: true)
                    }
                }else{
                  
                }
            })
          }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IAPManager.shared.fetchProducts()
    }
    

    @IBAction func CrossBtn(_ sender: UIButton) {
        if comesfrom == "Signup" {
            let storyboard = UIStoryboard(name: "Tabbar", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "TabbarVC") as! TabbarVC
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func StartTrailBtn(_ sender: UIButton) {
        StateMangerModelClass.shared.subs = "1"
        if comesfrom == "Signup" {
            let storyboard = UIStoryboard(name: "Tabbar", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "BuyPlanVC") as! BuyPlanVC
            vc.comesfrom = comesfrom
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func Continue(_ sender: UIButton) {
//        let Price = 5.99
//        self.Sel_SubsPrice = Price
//        
//        self.showIndicator(withTitle: "", and: "")
//        print(IAPManager.shared.products)
//        purchaseCoins()
        if self.comesfrom == "Signup" {
            let storyboard = UIStoryboard(name: "Tabbar", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "TabbarVC") as! TabbarVC
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    
    @IBAction func SeeAllPlanBtn(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Tabbar", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "BuyPlanVC") as! BuyPlanVC
        vc.comesfrom = comesfrom
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}

extension StartTrailVC{
    func purchaseCoins() {
        handleSubscriptionAttempt()
        }
     
    
    // Handle subscription attempts
    func handleSubscriptionAttempt() {
        clearSubscriptionDataIfNeeded()
        
        checkExistingSubscription { isActive in
//            if isActive {
//                DispatchQueue.main.asyncAfter(deadline: .now()){
//                    self.hideIndicator()
//                }
//                self.showAlertForExistingSubscription()
//            } else {
//                DispatchQueue.main.asyncAfter(deadline: .now() + 2){
//                    self.hideIndicator()
//                }
              
            guard let product = IAPManager.shared.products.first(where: { $0.productIdentifier == self.productIdentifierFor(amount: self.Sel_SubsPrice) }) else {
                print("No product found for the specified amount.")
                return
            }
       
            IAPManager.shared.buyProduct(product, vc: self)
          
        }
    }
    

    // Check if a subscription already exists
    func checkExistingSubscription(completion: @escaping (Bool) -> Void) {
        validateReceipt { isValid in
            print("Receipt validation result: \(isValid)")
            completion(isValid)
        }
    }
    
    // Validate the receipt to check for active subscriptions
    func validateReceipt(completion: @escaping (Bool) -> Void) {
        guard let receiptURL = Bundle.main.appStoreReceiptURL else {
            print("No receipt found")
            completion(false)
            return
        }
        
        do {
            let receiptData = try Data(contentsOf: receiptURL)
            let receiptString = receiptData.base64EncodedString(options: [])
            
            print("Receipt data: \(receiptString)")
            
            // Replace with your server-side validation logic or use Apple’s validation
            let isValid = serverSideValidation(receiptString: receiptString)
            
            print("Server-side validation result: \(isValid)")
            
            completion(isValid)
        } catch {
            print("Failed to load receipt data: \(error)")
            completion(false)
        }
    }

    
    // Server-side validation placeholder
    func serverSideValidation(receiptString: String) -> Bool {
        // Replace this with your actual server-side validation logic
        if UserDetail.shared.getSubscriptionStatus() == "true"{//true
            return true
        }else{
            return false
        }
    }
    
    // Clear any cached subscription data
    func clearSubscriptionDataIfNeeded() {
        // Clear any cached data related to the subscription
        UserDefaults.standard.removeObject(forKey: "isSubscribed")
        // Add other cache-clearing logic as needed
    }
    
    // Show an alert if an existing subscription is detected
    func showAlertForExistingSubscription() {
        let alert = UIAlertController(title: "Subscription Active",
                                      message: "You already have an active subscription with this Apple ID. Please use the same account.",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            SKPaymentQueue.default().restoreCompletedTransactions()
        }))
        
        if let topController = UIApplication.shared.keyWindow?.rootViewController {
            topController.present(alert, animated: true, completion: nil)
        }
    }
    
    func productIdentifierFor(amount: Double) -> String {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2){
            self.hideIndicator()
        }
        
        switch amount {
        case 2.99:
            return ProductID.WeeklyPlan.rawValue
        case 5.99:
            return ProductID.MonthlyPlan.rawValue
        case 49.99:
            return ProductID.yearlyPlan.rawValue
        default:
            return ProductID.WeeklyPlan.rawValue  // Default to 2.99 coins for simplicity
        }
    }
}
