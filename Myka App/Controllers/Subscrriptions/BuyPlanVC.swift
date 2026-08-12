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
    private var shouldPurchaseWhenProductLoads = false


    override func viewDidLoad() {
        super.viewDidLoad()
        selectAnnualPlan()

        self.CrossBtn.isHidden = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
            self.CrossBtn.isHidden = false
        }

        NotificationCenter.default.addObserver(self, selector: #selector(listnerFunction(_:)), name: NSNotification.Name(rawValue: "PurchaseNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(storeKitProductsDidUpdate), name: IAPManager.productsDidUpdateNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(storeKitProductsDidFail), name: IAPManager.productsDidFailNotification, object: nil)
        IAPManager.shared.fetchProducts()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc private func storeKitProductsDidUpdate() {
        guard Thread.isMainThread else {
            DispatchQueue.main.async { self.storeKitProductsDidUpdate() }
            return
        }

        if shouldPurchaseWhenProductLoads {
            if IAPManager.shared.yearlyProduct != nil {
                shouldPurchaseWhenProductLoads = false
                purchaseCoins()
            } else {
                shouldPurchaseWhenProductLoads = false
                hideIndicator()
                showToast("Subscription is temporarily unavailable. Please try again.")
            }
        }
    }

    @objc private func storeKitProductsDidFail() {
        guard Thread.isMainThread else {
            DispatchQueue.main.async { self.storeKitProductsDidFail() }
            return
        }

        shouldPurchaseWhenProductLoads = false
        hideIndicator()
        showToast("Subscription is temporarily unavailable. Please try again.")
    }

    private func selectAnnualPlan() {
        self.BuyBtnO.backgroundColor = #colorLiteral(red: 0.02352941176, green: 0.7568627451, blue: 0.4117647059, alpha: 1)
        self.BuyBtnO.isUserInteractionEnabled = true
        self.BasicPlanImgO.image = UIImage(named: "Group 1171276805")
        self.PopularPlanImgO.image = UIImage(named: "Group 1171276805")
        self.BBestValuePlanImgO.image = UIImage(named: "Group 1171276682")
        self.Sel_SubsPrice = 0
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



    @IBAction func BasicPlanBtn(_ sender: UIButton) { // Weekly
        selectAnnualPlan()
    }

    @IBAction func PopularPlanBtn(_ sender: UIButton) { // Monthly
        selectAnnualPlan()
    }

    @IBAction func BestValuePlanBtn(_ sender: UIButton) { // Yearly
        selectAnnualPlan()
    }

    @IBAction func BuyNowBtn(_ sender: UIButton) {
        guard self.BuyBtnO.isUserInteractionEnabled == true else{
            AlertControllerOnr1(title: "Choose Your Plan", message: "Please choose a plan.")
            return
        }

        self.showIndicator(withTitle: "", and: "")
        print(IAPManager.shared.products)
        guard IAPManager.shared.yearlyProduct != nil else {
            shouldPurchaseWhenProductLoads = true
            IAPManager.shared.fetchProducts()
            return
        }
        purchaseCoins()
    }
}

extension BuyPlanVC{
    func purchaseCoins() {
        handleSubscriptionAttempt()
        }


    // Handle subscription attempts
    func handleSubscriptionAttempt() {
        let Sel_Identifire = self.productIdentifierFor(amount: self.Sel_SubsPrice)

        guard let product = IAPManager.shared.yearlyProduct else {
            print("No StoreKit product found for \(Sel_Identifire).")
            self.shouldPurchaseWhenProductLoads = true
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
