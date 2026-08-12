//
//  BupPlanVC.swift
//  My Kai
//
//  Created by YES IT Labs on 08/04/25.
//

import UIKit
import StoreKit
import Alamofire
import SafariServices

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

    var PlanArr = [PlanModel(planName: "Best value", userType: "Annual", originalPrice: "7-day free trial", discountPrice: "Loading price", isSelected: true, planNameBgColor: #colorLiteral(red: 0.9764705882, green: 0.8352941176, blue: 0.05098039216, alpha: 1))]

    private let selectedProductIdentifier = ProductID.yearlyPlan.rawValue
    private var shouldPurchaseWhenProductLoads = false

    var comesfrom = ""
    private let termsOfUseURL = URL(string: "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/")!
    private let privacyPolicyURL = URL(string: "https://www.getmykai.com/privacy/")!

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

        if !StateMangerModelClass.shared.ProviderName.isEmpty{
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

        NotificationCenter.default.addObserver(self, selector: #selector(listnerFunction(_:)), name: NSNotification.Name(rawValue: "PurchaseNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(storeKitProductsDidUpdate), name: IAPManager.productsDidUpdateNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(storeKitProductsDidFail), name: IAPManager.productsDidFailNotification, object: nil)
        updateBuyButtonState()
        IAPManager.shared.fetchProducts()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
            self.TblV.reloadData()
        }
        IAPManager.shared.fetchProducts()
    }

    @objc private func storeKitProductsDidUpdate() {
        guard Thread.isMainThread else {
            DispatchQueue.main.async { self.storeKitProductsDidUpdate() }
            return
        }

        updateAnnualPlanPriceFromStoreKit()
        updateBuyButtonState()
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
        updateBuyButtonState()
        showToast("Subscription is temporarily unavailable. Please try again.")
    }

    private func updateAnnualPlanPriceFromStoreKit() {
        guard let product = IAPManager.shared.yearlyProduct else {
            PlanArr[0].discountPrice = "Loading price"
            TblV.reloadData()
            return
        }

        let annualPrice = IAPManager.shared.localizedPrice(for: product)
        PlanArr[0].discountPrice = "\(annualPrice)/ Yearly"
        TblV.reloadData()
    }

    private func updateBuyButtonState() {
        let productIsReady = IAPManager.shared.yearlyProduct != nil
        // Keep the button tappable even while StoreKit is loading so App Review never sees a dead CTA.
        BuyBtnO.isUserInteractionEnabled = true
        BuyBtnO.backgroundColor = productIsReady ? #colorLiteral(red: 0.02352941176, green: 0.7568627451, blue: 0.4117647059, alpha: 1) : UIColor.lightGray
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

    let loginURL = baseURL.baseURL + appEndPoints.subscription_apple

    let params: [String: Any] = [
        "receipt_data": Receipt,
        "type":"ios"
    ]

    let token = UserDetail.shared.getTokenWith()

    let headers: HTTPHeaders = [
        "Authorization": "Bearer \(token)",
        "Accept": "application/json",
        "Content-Type": "application/json"
    ]

    print("================ API REQUEST ================")
    print("URL:", loginURL)
    print("HEADERS:", headers)
    print("PARAMETERS:", params)
    print("=============================================")

    self.showIndicator(withTitle: "", and: "")

    AF.request(loginURL,
               method: .post,
               parameters: params,
               encoding: JSONEncoding.default,
               headers: headers)
    .responseData { response in

        self.hideIndicator()

        print("================ API RESPONSE ================")
        print("STATUS CODE:", response.response?.statusCode ?? 0)

        if let data = response.data,
           let rawString = String(data: data, encoding: .utf8) {
            print("RAW RESPONSE:")
            print(rawString)
        }

        switch response.result {
        case .success(let data):

            do {
                if let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {

                    print("PARSED JSON:", jsonObject)

                    let success = jsonObject["success"] as? Bool ?? false
                    let message = jsonObject["message"] as? String ?? "Unknown error"

                    if success {
                        print("✅ Subscription Success")
                        UserDetail.shared.setSubscriptionStatus("0")

                        if self.comesfrom == "Signup" {
                            let storyboard = UIStoryboard(name: "Tabbar", bundle: nil)
                            let vc = storyboard.instantiateViewController(withIdentifier: "TabbarVC") as! TabbarVC
                            self.navigationController?.pushViewController(vc, animated: true)
                        } else {
                            self.navigationController?.popToRootViewController(animated: true)
                        }

                    } else {
                        print("❌ Backend Error:", message)
                        self.showToast(message)
                    }

                } else {
                    print("❌ Response is not a valid JSON object")
                    self.showToast("Server configuration error")
                }

            } catch {
                print("❌ JSON Parsing Error:", error)
                self.showToast("Invalid server response")
            }

        case .failure(let error):
            print("❌ API Failure:", error.localizedDescription)
            self.showToast("Network error. Please try again.")
        }

        print("==============================================")
    }
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


        self.showIndicator(withTitle: "", and: "")
        print(IAPManager.shared.products)
        // self.Sel_SubsPrice
        guard IAPManager.shared.yearlyProduct != nil else {
            shouldPurchaseWhenProductLoads = true
            IAPManager.shared.fetchProducts()
            return
        }
        purchaseCoins()
    }

    @IBAction private func didTapTermsOfUse(_ sender: UIButton) {
        openLegalURL(termsOfUseURL)
    }

    @IBAction private func didTapPrivacyPolicy(_ sender: UIButton) {
        openLegalURL(privacyPolicyURL)
    }

    private func openLegalURL(_ url: URL) {
        let safariVC = SFSafariViewController(url: url)
        safariVC.modalPresentationStyle = .pageSheet
        present(safariVC, animated: true)
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

        if let product = IAPManager.shared.yearlyProduct {
            let monthlyPrice = product.price.dividing(by: NSDecimalNumber(value: 12))
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.locale = product.priceLocale
            let localizedMonthlyPrice = formatter.string(from: monthlyPrice) ?? "\(monthlyPrice)"
            cell.perMonthlbl.text = "\(localizedMonthlyPrice)/month"
        } else {
            cell.perMonthlbl.text = ""
        }


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
       //     cell.RadioIMg.image = UIImage(named: "RadioTick")
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
           // cell.RadioIMg.image = UIImage(named: "RadioWhite")
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

        self.TblV.reloadData()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95
    }
}


extension BupPlanVC{
    func purchaseCoins() {
        handleSubscriptionAttempt()
        }


    // Handle subscription attempts
    func handleSubscriptionAttempt() {
        print("Selected Product Identifier: \(self.selectedProductIdentifier)")
        guard let product = IAPManager.shared.yearlyProduct else {
            print("No StoreKit product found for \(self.selectedProductIdentifier).")
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
                    self.PlanArr[i].isSelected = true
                }
                if last_plan == "annual_plan"{
                    self.PlanArr[0].isSelected = true
                }

                self.TblV.reloadData()

                if CanPurchaseSubscription != 1 {
                    print("Backend reported Subscription_status \(CanPurchaseSubscription); StoreKit purchase remains tappable for review and sandbox reliability.")
                }
                self.updateBuyButtonState()

            }else{
                let responseMessage = dictData["message"] as! String
                self.showToast(responseMessage)
                self.updateBuyButtonState()
            }
        })
    }
}
