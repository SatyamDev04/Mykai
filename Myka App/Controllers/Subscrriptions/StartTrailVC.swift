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
        NotificationCenter.default.addObserver(self, selector: #selector(listnerFunction(_:)), name: NSNotification.Name(rawValue: "PurchaseNotification"), object: nil)
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

            let loginURL = baseURL.baseURL + appEndPoints.subscription_apple
            print(loginURL,"loginURL")

        WebService.shared.postServiceURLEncoding(loginURL, VC: self, andParameter: params, withCompletion: { (json, statusCode) in

            self.hideIndicator()

             guard let dictData = json.dictionaryObject else{
                 return
             }
                if dictData["success"] as! Bool == true{
                    UserDetail.shared.setSubscriptionStatus("0")
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
        openAnnualPurchaseScreen()
    }

    @IBAction func Continue(_ sender: UIButton) {
        openAnnualPurchaseScreen()
    }


    @IBAction func SeeAllPlanBtn(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Tabbar", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "BuyPlanVC") as! BuyPlanVC
        vc.comesfrom = comesfrom
        self.navigationController?.pushViewController(vc, animated: true)

    }

    private func openAnnualPurchaseScreen() {
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
        let productIdentifier = self.productIdentifierFor(amount: self.Sel_SubsPrice)
        guard let product = IAPManager.shared.yearlyProduct else {
            print("No StoreKit product found for \(productIdentifier).")
            self.hideIndicator()
            self.showToast("Subscription is still loading. Please try again.")
            IAPManager.shared.fetchProducts()
            return
        }

        IAPManager.shared.buyProduct(product, vc: self)
    }

    func productIdentifierFor(amount: Double) -> String {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2){
            self.hideIndicator()
        }

        return ProductID.yearlyPlan.rawValue
    }
}
