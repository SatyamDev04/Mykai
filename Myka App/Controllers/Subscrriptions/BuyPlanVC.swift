//
//  BuyPlanVC.swift
//  Myka App
//
//  Created by Sumit on 09/12/24.
//

import UIKit
import StoreKit

class BuyPlanVC: UIViewController,SKRequestDelegate  {
    
    
    @IBOutlet weak var BasicPlanImgO: UIImageView!
    @IBOutlet weak var PopularPlanImgO: UIImageView!
    @IBOutlet weak var BBestValuePlanImgO: UIImageView!
    @IBOutlet weak var CrossBtn: UIButton!
    @IBOutlet weak var BuyBtnO: UIButton!
    
    var comesfrom: String = ""
    
    var Sel_SubsPrice = 0.0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.BuyBtnO.backgroundColor = #colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
        self.BuyBtnO.isUserInteractionEnabled = false
        
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
        
        params["receipt_data"] = Receipt
                   
            self.hideIndicator()
            showIndicator(withTitle: "", and: "")
          
            let loginURL = baseURL.baseURL + appEndPoints.subscription_apple
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
    
   
    
    @IBAction func BasicPlanBtn(_ sender: UIButton) { // Weekly
        self.BuyBtnO.backgroundColor = #colorLiteral(red: 0.02352941176, green: 0.7568627451, blue: 0.4117647059, alpha: 1)
        self.BuyBtnO.isUserInteractionEnabled = true
        
        self.BasicPlanImgO.image = UIImage(named: "Group 1171276682") // yellow border
        self.PopularPlanImgO.image = UIImage(named: "Group 1171276805") // Green border
        self.BBestValuePlanImgO.image = UIImage(named: "Group 1171276805") // Green border
        let Price = 2.99
        self.Sel_SubsPrice = Price
    }
    
    @IBAction func PopularPlanBtn(_ sender: UIButton) { // Monthly
        self.BuyBtnO.backgroundColor = #colorLiteral(red: 0.02352941176, green: 0.7568627451, blue: 0.4117647059, alpha: 1)
        self.BuyBtnO.isUserInteractionEnabled = true
        
        self.BasicPlanImgO.image = UIImage(named: "Group 1171276805") // Green border
        self.PopularPlanImgO.image = UIImage(named: "Group 1171276682") // yellow border
        self.BBestValuePlanImgO.image = UIImage(named: "Group 1171276805") // Green border
        let Price = 5.99
        self.Sel_SubsPrice = Price
    }
    
    @IBAction func BestValuePlanBtn(_ sender: UIButton) { // Yearly
        self.BuyBtnO.backgroundColor = #colorLiteral(red: 0.02352941176, green: 0.7568627451, blue: 0.4117647059, alpha: 1)
        self.BuyBtnO.isUserInteractionEnabled = true
        self.BasicPlanImgO.image = UIImage(named: "Group 1171276805") // Green border
        self.PopularPlanImgO.image = UIImage(named: "Group 1171276805") // yellow border
        self.BBestValuePlanImgO.image = UIImage(named: "Group 1171276682") // yellow border
        let Price = 49.99
        self.Sel_SubsPrice = Price
    }
    
    @IBAction func BuyNowBtn(_ sender: UIButton) {
        guard self.BuyBtnO.isUserInteractionEnabled == true else{
            AlertControllerOnr1(title: "Choose Your Plan", message: "Please choose a plan.")
            return
        }
        
        if self.comesfrom == "Signup" {
            let storyboard = UIStoryboard(name: "Tabbar", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "TabbarVC") as! TabbarVC
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            self.navigationController?.popViewController(animated: true)
        }
//        self.showIndicator(withTitle: "", and: "")
//        print(IAPManager.shared.products)
//       // self.Sel_SubsPrice
//        purchaseCoins()
    }
}

extension BuyPlanVC{
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
            let Sel_Identifire = self.productIdentifierFor(amount: self.Sel_SubsPrice)
               
            guard let product = IAPManager.shared.products.first(where: { $0.productIdentifier == Sel_Identifire }) else {
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
