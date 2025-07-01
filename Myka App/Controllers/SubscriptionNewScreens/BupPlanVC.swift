//
//  BupPlanVC.swift
//  My Kai
//
//  Created by YES IT Labs on 08/04/25.
//

import UIKit
import StoreKit
import Alamofire

struct PlanModel{
    var planName:String
    var userType:String
    var originalPrice:String
    var discountPrice:String
    var isSelected:Bool = false
    var planNameBgColor:UIColor
}

class BupPlanVC: UIViewController, SKRequestDelegate {
    
    @IBOutlet weak var ProfileImg: UIImageView!
    @IBOutlet weak var TitleLbl: UILabel!
    @IBOutlet weak var UserCookBookLbl: UILabel!
    @IBOutlet weak var TblV: UITableView!
    @IBOutlet weak var BuyBtnO: UIButton!
    
    var PlanArr = [PlanModel(planName: "Starter", userType: "New to Kai", originalPrice: "$3.99/ Weekly", discountPrice: "$1.99/ Weekly", isSelected: true, planNameBgColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)), PlanModel(planName: "Popular", userType: "Pro Kai User", originalPrice: "$11.99/ Monthly", discountPrice: "$5.99/ Monthly", isSelected: false, planNameBgColor: #colorLiteral(red: 0.02352941176, green: 0.7568627451, blue: 0.4117647059, alpha: 1)), PlanModel(planName: "Best value", userType: "Love Kai", originalPrice: "$99.99/ Yearly", discountPrice: "$49.99/ Yearly", isSelected: false, planNameBgColor: #colorLiteral(red: 0.9764705882, green: 0.8352941176, blue: 0.05098039216, alpha: 1))]
    
    var Sel_SubsPrice = 1.99
   
    var comesfrom = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.TblV.register(UINib(nibName: "PlanTblVCell", bundle: nil), forCellReuseIdentifier: "PlanTblVCell")
        self.TblV.delegate = self
        self.TblV.dataSource = self

        let Attributes1: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "Inter Medium", size: 20.0) ?? UIFont.systemFont(ofSize: 20)
        ]
        let Attributes2: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "Inter Semi Bold", size: 20.0) ?? UIFont.systemFont(ofSize: 20)
        ]
         
            let helloString = NSAttributedString(string: "You’ve got a gift from", attributes: Attributes1)
        
        var worldString = NSAttributedString()
        
        if UserDetail.shared.getiSfromSignup() == true{
            let imgUrl = URL(string: StateMangerModelClass.shared.ProviderImg) ?? nil
            self.ProfileImg.sd_setImage(with: imgUrl, placeholderImage: UIImage(named: "Prof"))
            
            if StateMangerModelClass.shared.ProviderName != ""{
                if let firstName = StateMangerModelClass.shared.ProviderName.split(separator: " ").first {
                    self.UserCookBookLbl.text = "\(firstName)’s secret cookbook"
                }else{
                    self.UserCookBookLbl.text = "\(StateMangerModelClass.shared.ProviderName)’s special cookbook"
                }
            }else{
                self.UserCookBookLbl.text = "Kai’s special cookbook"
            }
            
            worldString = NSAttributedString(string: "\n\(StateMangerModelClass.shared.ProviderName)", attributes: Attributes2)
        }else{
            self.ProfileImg.image = UIImage(named: "Prof")
            
            self.UserCookBookLbl.text = "Kai’s special cookbook"
            
            worldString = NSAttributedString(string: "\nKai", attributes: Attributes2)
        }
         
            let fullString = NSMutableAttributedString()
            fullString.append(helloString)
            fullString.append(worldString)
        self.TitleLbl.attributedText = fullString
        
        self.Api_To_fetchSubscription()
        
        NotificationCenter.default.addObserver(self, selector: #selector(listnerFunction(_:)), name: NSNotification.Name(rawValue: "notificationName"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
            self.TblV.reloadData()
        }
        IAPManager.shared.fetchProducts()
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
                    self.navigationController?.popToRootViewController(animated: true)
                }
            }else{
              
            }
        })
      }
 
    
    @IBAction func CloseBtn(_ sender: UIButton) {
        if comesfrom == "Profile"{
            self.navigationController?.popViewController(animated: true)
        }else{
            let storyboard = UIStoryboard(name: "Tabbar", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "TabbarVC") as! TabbarVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    @IBAction func PurchaseBtn(_ sender: UIButton) {
//        let storyboard = UIStoryboard(name: "Tabbar", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "TabbarVC") as! TabbarVC
//        self.navigationController?.pushViewController(vc, animated: true)
        
        self.showIndicator(withTitle: "", and: "")
        print(IAPManager.shared.products)
        // self.Sel_SubsPrice
        purchaseCoins()
    }
}

extension BupPlanVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PlanArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlanTblVCell", for: indexPath) as! PlanTblVCell
        
        cell.PlanTypeBgV.backgroundColor = PlanArr[indexPath.row].planNameBgColor
        cell.TypeTxtLbl.text = PlanArr[indexPath.row].planName
        
        cell.TypeOfUserLbl.text = PlanArr[indexPath.row].userType
        
        cell.OriginalPriceLbl.text = PlanArr[indexPath.row].originalPrice
        
        cell.DiscountedPriceLbl.text = PlanArr[indexPath.row].discountPrice
         
   
        cell.TypeTxtLbl.textColor = #colorLiteral(red: 0.07058823529, green: 0.07058823529, blue: 0.07058823529, alpha: 1)
       
        
        if PlanArr[indexPath.row].isSelected == true {
            
            if PlanArr[indexPath.row].planName == "Popular"{
                cell.TypeTxtLbl.textColor = #colorLiteral(red: 0.07058823529, green: 0.07058823529, blue: 0.07058823529, alpha: 1)
                cell.PlanTypeBgV.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            }else if PlanArr[indexPath.row].planName == "Best value"{
                cell.TypeTxtLbl.textColor = #colorLiteral(red: 0.07058823529, green: 0.07058823529, blue: 0.07058823529, alpha: 1)
                cell.PlanTypeBgV.backgroundColor = #colorLiteral(red: 0.9764705882, green: 0.8352941176, blue: 0.05098039216, alpha: 1)
            }else{
                cell.TypeTxtLbl.textColor = #colorLiteral(red: 0.07058823529, green: 0.07058823529, blue: 0.07058823529, alpha: 1)
                cell.PlanTypeBgV.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            }
             
            cell.BgV.shadowOffset = CGSize(width: 0, height: 4)
            cell.BgV.shadowRadius = 4
            cell.BgV.shadowOpacity = 0.5
            cell.BgV.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            let insetAmount: CGFloat = 4 // Adjust this value as needed
            let smallerRect = cell.BgV.bounds.insetBy(dx: insetAmount, dy: insetAmount)
            cell.BgV.layer.shadowPath = UIBezierPath(roundedRect: smallerRect, cornerRadius: cell.BgV.layer.cornerRadius).cgPath
           // cell.BgV.shadowCornerRadius = 10
            
            cell.BgV.backgroundColor = #colorLiteral(red: 0.02352941176, green: 0.7568627451, blue: 0.4117647059, alpha: 1)
            cell.OriginalPriceLbl.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            cell.DiscountView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            cell.RadioIMg.image = UIImage(named: "RadioTick")
            cell.DiscountedPriceLbl.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            cell.TypeOfUserLbl.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }else{
            if PlanArr[indexPath.row].planName == "Popular"{
                cell.TypeTxtLbl.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                cell.PlanTypeBgV.backgroundColor = #colorLiteral(red: 0.02352941176, green: 0.7568627451, blue: 0.4117647059, alpha: 1)
            }else if PlanArr[indexPath.row].planName == "Best value"{
                cell.TypeTxtLbl.textColor = #colorLiteral(red: 0.07058823529, green: 0.07058823529, blue: 0.07058823529, alpha: 1)
                cell.PlanTypeBgV.backgroundColor = #colorLiteral(red: 0.9764705882, green: 0.8352941176, blue: 0.05098039216, alpha: 1)
            }else{
                cell.TypeTxtLbl.textColor = #colorLiteral(red: 0.07058823529, green: 0.07058823529, blue: 0.07058823529, alpha: 1)
                cell.PlanTypeBgV.backgroundColor = #colorLiteral(red: 0.02352941176, green: 0.7568627451, blue: 0.4117647059, alpha: 1)
            }
         
            
            cell.BgV.shadowOffset = CGSize(width: 0, height: 0)
            cell.BgV.shadowRadius = 0
            cell.BgV.shadowOpacity = 0
            cell.BgV.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
           // cell.BgV.shadowCornerRadius = 10
            
            cell.BgV.backgroundColor = #colorLiteral(red: 0.7215686275, green: 0.9019607843, blue: 0.800728729, alpha: 1)
            cell.RadioIMg.image = UIImage(named: "RadioWhite")
            cell.OriginalPriceLbl.textColor = #colorLiteral(red: 0.4588235294, green: 0.4588235294, blue: 0.4588235294, alpha: 1)
            cell.DiscountView.backgroundColor = #colorLiteral(red: 0.4588235294, green: 0.4588235294, blue: 0.4588235294, alpha: 1)
            cell.DiscountedPriceLbl.textColor = #colorLiteral(red: 0.1215686275, green: 0.1176470588, blue: 0.1176470588, alpha: 1)
            cell.TypeOfUserLbl.textColor = #colorLiteral(red: 0.1215686275, green: 0.1176470588, blue: 0.1176470588, alpha: 1)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        for i in 0..<PlanArr.count{
            PlanArr[i].isSelected = false
        }
        PlanArr[indexPath.row].isSelected = true
     
        if PlanArr[indexPath.row].discountPrice == "$1.99/ Weekly"{
            self.Sel_SubsPrice = 1.99
        }else if PlanArr[indexPath.row].discountPrice == "$5.99/ Monthly"{
            self.Sel_SubsPrice = 5.99
        }else{
            self.Sel_SubsPrice = 49.99
        }
         
        self.TblV.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}


extension BupPlanVC{
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
            let productID = self.productIdentifierFor(amount: self.Sel_SubsPrice)
            print("Generated Product Identifier: \(productID)")
            guard let product = IAPManager.shared.products.first(where: { $0.productIdentifier == productID }) else {
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
        case 1.99:
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

extension BupPlanVC{
    func Api_To_fetchSubscription(){
        
        var params:JSONDictionary = [:]

        
        showIndicator(withTitle: "", and: "")
        
        let loginURL = baseURL.baseURL + appEndPoints.checkSubscription
        
        print(loginURL,"loginURL")
        
        WebService.shared.postServiceURLEncoding(loginURL, VC: self, andParameter: params, withCompletion: { (json, statusCode) in
            
            self.hideIndicator()
            
            guard let dictData = json.dictionaryObject else{
                
                return
            }
            
            if dictData["success"] as? Bool == true{
                let Result = dictData["data"] as? NSDictionary ?? NSDictionary()
                
                let CanPurchaseSubscription = Result["Subscription_status"] as? Int ?? Int()
                
                let last_plan = Result["active_plan"] as? String ?? String()
                
                for i in 0..<self.PlanArr.count{
                    self.PlanArr[i].isSelected = false
                }
                
                if last_plan == "weekly_plan"{
                    self.PlanArr[0].isSelected = true
                }else if last_plan == "monthly_plan"{
                    self.PlanArr[1].isSelected = true
                }else if last_plan == "annual_plan"{
                    self.PlanArr[1].isSelected = true
                }else{
                    self.PlanArr[0].isSelected = true
                }
                
                self.TblV.reloadData()
                
                if CanPurchaseSubscription == 1{
                    self.BuyBtnO.isUserInteractionEnabled = true
                    self.BuyBtnO.backgroundColor = #colorLiteral(red: 0.02352941176, green: 0.7568627451, blue: 0.4117647059, alpha: 1)
                }else{
                    self.BuyBtnO.isUserInteractionEnabled = false
                    self.BuyBtnO.backgroundColor = UIColor.lightGray
                }
                
            }else{
                let responseMessage = dictData["message"] as! String
                self.showToast(responseMessage)
            }
        })
    }
}
