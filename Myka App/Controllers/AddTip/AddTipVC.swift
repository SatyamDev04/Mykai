//
//  AddTipVC.swift
//  My-Kai
//
//  Created by YES IT Labs on 06/03/25.
//

import UIKit
import Alamofire
  
class AddTipVC: UIViewController, UITextFieldDelegate, ApplePayHelperDelegate {
     
    @IBOutlet weak var TitleDescLbl: UILabel!
    @IBOutlet weak var AddManuallyTxtF: UITextField!
    @IBOutlet weak var NotNowbgV: UIView!
    @IBOutlet weak var SevenbgV: UIView!
    @IBOutlet weak var NinebgV: UIView!
    @IBOutlet weak var TwelvebgV: UIView!
    @IBOutlet weak var FifteenbgV: UIView!
    
    @IBOutlet weak var TenPerctLbl: UILabel!
    @IBOutlet weak var FifteenPerctLbl: UILabel!
    @IBOutlet weak var TwentyPerctLbl: UILabel!
    @IBOutlet weak var TwentyfivePerctLbl: UILabel!
    
    @IBOutlet var TipPriceBtnO: [UIButton]!
    
    @IBOutlet weak var ProceedAndPayBtnO: UIButton!
    
    var totalPrice = 0.0
    var cardID = ""
    
    var SelTipPrice = ""
    
    //
    var TenPercentPrice = ""
    var FifteenPercentPrice = ""
    var twentyPercentPrice = ""
    var twentyfivePercentPrice = ""
    //
    
   
    
  //  var SecreteKey = ""
    
    var applePayHelper : ApplePayHelper!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.AddManuallyTxtF.delegate = self
        
        let FTenPercPrice = self.formatPrice(totalPrice)
        
        let desc = "100% of your tip goes to your courier. Tips are based on your order total of $\(FTenPercPrice) before any discounts or promotions."
        self.TitleDescLbl.text = desc
        
        self.ProceedAndPayBtnO.isUserInteractionEnabled = false
        self.ProceedAndPayBtnO.backgroundColor = #colorLiteral(red: 0.6470588235, green: 0.6470588235, blue: 0.6470588235, alpha: 1)
         
        self.toCalculatePercentage(price: self.totalPrice)
        
      //  self.Api_To_Tips_PercentPrice()
       
    }
    
    func toCalculatePercentage(price: Double) {
        let TotalPrice = price
        let tenPercent = TotalPrice * 0.10
        let fifteenPercent = TotalPrice * 0.15
        let twentyPercent = TotalPrice * 0.20
        let twentyFivePercent = TotalPrice * 0.25
        
        let FTenPercPrice = Int(round(tenPercent))
        let FFifteenPercPrice = Int(round(fifteenPercent))
        let FTwentyPercPrice = Int(round(twentyPercent))
        let FTwentyFivePercPrice = Int(round(twentyFivePercent))
        
        self.TenPercentPrice = "\(FTenPercPrice)"
        self.FifteenPercentPrice = "\(FFifteenPercPrice)"
        self.twentyPercentPrice = "\(FTwentyPercPrice)"
        self.twentyfivePercentPrice = "\(FTwentyFivePercPrice)"
        
        let Attributes1: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.black
        ]
        let Attributes2: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.init(red: 6/255, green: 193/255, blue: 105/255, alpha: 1)
        ]
        
        let TenPerc = NSAttributedString(string: "10%", attributes: Attributes1)
        let TenPercPr = NSAttributedString(string: "\n$\(FTenPercPrice)", attributes: Attributes2)
        let fullString = NSMutableAttributedString()
        fullString.append(TenPerc)
        fullString.append(TenPercPr)
        self.TenPerctLbl.attributedText = fullString
        
        let fifteenPerc = NSAttributedString(string: "15%", attributes: Attributes1)
        let fifteenPercPr = NSAttributedString(string: "\n$\(FFifteenPercPrice)", attributes: Attributes2)
        let fullString2 = NSMutableAttributedString()
        fullString2.append(fifteenPerc)
        fullString2.append(fifteenPercPr)
        self.FifteenPerctLbl.attributedText = fullString2
        
        
        let TwentyPerc = NSAttributedString(string: "20%", attributes: Attributes1)
        let TwentyPercPr = NSAttributedString(string: "\n$\(FTwentyPercPrice)", attributes: Attributes2)
        let fullString3 = NSMutableAttributedString()
        fullString3.append(TwentyPerc)
        fullString3.append(TwentyPercPr)
        self.TwentyPerctLbl.attributedText = fullString3
        
        let TwentyfivePerc = NSAttributedString(string: "25%", attributes: Attributes1)
        let TwentyfivePercPr = NSAttributedString(string: "\n$\(FTwentyFivePercPrice)", attributes: Attributes2)
        let fullString4 = NSMutableAttributedString()
        fullString4.append(TwentyfivePerc)
        fullString4.append(TwentyfivePercPr)
        self.TwentyfivePerctLbl.attributedText = fullString4
    }
  
       
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            // Get the current text
        guard let currentText = textField.text else { return true }
            
            // Calculate the updated text
            let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)
         
        self.SelTipPrice = updatedText
       
        if updatedText.count > 0{
            self.NotNowbgV.borderColor = #colorLiteral(red: 0.862745098, green: 0.862745098, blue: 0.862745098, alpha: 1)
            self.SevenbgV.borderColor = #colorLiteral(red: 0.862745098, green: 0.862745098, blue: 0.862745098, alpha: 1)
            self.NinebgV.borderColor = #colorLiteral(red: 0.862745098, green: 0.862745098, blue: 0.862745098, alpha: 1)
            self.TwelvebgV.borderColor = #colorLiteral(red: 0.862745098, green: 0.862745098, blue: 0.862745098, alpha: 1)
            self.FifteenbgV.borderColor = #colorLiteral(red: 0.862745098, green: 0.862745098, blue: 0.862745098, alpha: 1)
        }
        
        if updatedText.count == 0{
            self.ProceedAndPayBtnO.isUserInteractionEnabled = false
            self.ProceedAndPayBtnO.backgroundColor = #colorLiteral(red: 0.6470588235, green: 0.6470588235, blue: 0.6470588235, alpha: 1)
        }else{
            self.ProceedAndPayBtnO.isUserInteractionEnabled = true
            self.ProceedAndPayBtnO.backgroundColor = #colorLiteral(red: 0.02352941176, green: 0.7568627451, blue: 0.4117647059, alpha: 1)
        }
         
        return true
        }
    
    @IBAction func BackBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func TipPriceBtn(_ sender: UIButton) {
        self.ProceedAndPayBtnO.isUserInteractionEnabled = true
        self.ProceedAndPayBtnO.backgroundColor = #colorLiteral(red: 0.02352941176, green: 0.7568627451, blue: 0.4117647059, alpha: 1)
        
        switch sender.tag {
        case 0:
            print("0")
            self.NotNowbgV.borderColor = #colorLiteral(red: 0.02352941176, green: 0.7568627451, blue: 0.4117647059, alpha: 1)
            self.SevenbgV.borderColor = #colorLiteral(red: 0.862745098, green: 0.862745098, blue: 0.862745098, alpha: 1)
            self.NinebgV.borderColor = #colorLiteral(red: 0.862745098, green: 0.862745098, blue: 0.862745098, alpha: 1)
            self.TwelvebgV.borderColor = #colorLiteral(red: 0.862745098, green: 0.862745098, blue: 0.862745098, alpha: 1)
            self.FifteenbgV.borderColor = #colorLiteral(red: 0.862745098, green: 0.862745098, blue: 0.862745098, alpha: 1)
            self.SelTipPrice = "0"
            self.AddManuallyTxtF.text = ""
            break;
        case 1:
            print("1")
            self.NotNowbgV.borderColor = #colorLiteral(red: 0.862745098, green: 0.862745098, blue: 0.862745098, alpha: 1)
            self.SevenbgV.borderColor = #colorLiteral(red: 0.02352941176, green: 0.7568627451, blue: 0.4117647059, alpha: 1)
            self.NinebgV.borderColor = #colorLiteral(red: 0.862745098, green: 0.862745098, blue: 0.862745098, alpha: 1)
            self.TwelvebgV.borderColor = #colorLiteral(red: 0.862745098, green: 0.862745098, blue: 0.862745098, alpha: 1)
            self.FifteenbgV.borderColor = #colorLiteral(red: 0.862745098, green: 0.862745098, blue: 0.862745098, alpha: 1)
            self.SelTipPrice = self.TenPercentPrice
            self.AddManuallyTxtF.text = ""
            break;
        case 2:
            print("2")
            self.NotNowbgV.borderColor = #colorLiteral(red: 0.862745098, green: 0.862745098, blue: 0.862745098, alpha: 1)
            self.SevenbgV.borderColor = #colorLiteral(red: 0.862745098, green: 0.862745098, blue: 0.862745098, alpha: 1)
            self.NinebgV.borderColor = #colorLiteral(red: 0.02352941176, green: 0.7568627451, blue: 0.4117647059, alpha: 1)
            self.TwelvebgV.borderColor = #colorLiteral(red: 0.862745098, green: 0.862745098, blue: 0.862745098, alpha: 1)
            self.FifteenbgV.borderColor = #colorLiteral(red: 0.862745098, green: 0.862745098, blue: 0.862745098, alpha: 1)
            self.SelTipPrice = self.FifteenPercentPrice
            self.AddManuallyTxtF.text = ""
            break;
        case 3:
            print("3")
            self.NotNowbgV.borderColor = #colorLiteral(red: 0.862745098, green: 0.862745098, blue: 0.862745098, alpha: 1)
            self.SevenbgV.borderColor = #colorLiteral(red: 0.862745098, green: 0.862745098, blue: 0.862745098, alpha: 1)
            self.NinebgV.borderColor = #colorLiteral(red: 0.862745098, green: 0.862745098, blue: 0.862745098, alpha: 1)
            self.TwelvebgV.borderColor = #colorLiteral(red: 0.02352941176, green: 0.7568627451, blue: 0.4117647059, alpha: 1)
            self.FifteenbgV.borderColor = #colorLiteral(red: 0.862745098, green: 0.862745098, blue: 0.862745098, alpha: 1)
            self.SelTipPrice = self.twentyPercentPrice
            self.AddManuallyTxtF.text = ""
            break;
        case 4:
            print("4")
            self.NotNowbgV.borderColor = #colorLiteral(red: 0.862745098, green: 0.862745098, blue: 0.862745098, alpha: 1)
            self.SevenbgV.borderColor = #colorLiteral(red: 0.862745098, green: 0.862745098, blue: 0.862745098, alpha: 1)
            self.NinebgV.borderColor = #colorLiteral(red: 0.862745098, green: 0.862745098, blue: 0.862745098, alpha: 1)
            self.TwelvebgV.borderColor = #colorLiteral(red: 0.862745098, green: 0.862745098, blue: 0.862745098, alpha: 1)
            self.FifteenbgV.borderColor = #colorLiteral(red: 0.02352941176, green: 0.7568627451, blue: 0.4117647059, alpha: 1)
            self.SelTipPrice = self.twentyfivePercentPrice
            self.AddManuallyTxtF.text = ""
            break;
        default:
            print("0")
            self.NotNowbgV.borderColor = #colorLiteral(red: 0.02352941176, green: 0.7568627451, blue: 0.4117647059, alpha: 1)
            self.SevenbgV.borderColor = #colorLiteral(red: 0.862745098, green: 0.862745098, blue: 0.862745098, alpha: 1)
            self.NinebgV.borderColor = #colorLiteral(red: 0.862745098, green: 0.862745098, blue: 0.862745098, alpha: 1)
            self.TwelvebgV.borderColor = #colorLiteral(red: 0.862745098, green: 0.862745098, blue: 0.862745098, alpha: 1)
            self.FifteenbgV.borderColor = #colorLiteral(red: 0.862745098, green: 0.862745098, blue: 0.862745098, alpha: 1)
            self.SelTipPrice = "0"
            self.AddManuallyTxtF.text = ""
            break;
        }
    }
    
    @IBAction func UpdateBtn(_ sender: UIButton) {
        if self.cardID == "ApplePay"{
            self.setupApplePay()
            
        }else if self.cardID == "GPay"{
            //self.startGooglePayTransaction()
        }else{
            self.Api_To_Send_Tips_order_product(isApple: false, Token: "")
        }
    }
}

extension AddTipVC{
    func setupApplePay() {
        let amount = self.totalPrice
        let Famount = self.formatPrice(amount).replace(string: ",", withString: "")
        
        let tipAmount = (Double(SelTipPrice) ?? 0)
        let ftipAmount = self.formatPrice(tipAmount).replace(string: ",", withString: "")
        
        let total = self.totalPrice + (Double(self.SelTipPrice) ?? 0)
        let Ftotal = self.formatPrice(total).replace(string: ",", withString: "")
        
        self.applePayHelper = ApplePayHelper()
        self.applePayHelper.delegate = self
        self.applePayHelper.subtotalAmount = Famount
        self.applePayHelper.tipAmount = ftipAmount
        self.applePayHelper.totalAmount = Ftotal
        self.applePayHelper.presentApplePay(onVC: self)
    }
    
    func applePayDidComplete(isSuccess: Bool, error: String?) {
            if isSuccess {
                // Apple Pay success
                self.Api_To_Send_Tips_order_product(isApple: true, Token: PaymentIntent)
            } else if let error = error{
                 print(error)
                self.showToast("Payment Failed")
                PaymentIntent = ""
            }
        }
}


extension AddTipVC{
    func Api_To_Send_Tips_order_product(isApple: Bool, Token: String){
        
        var params:JSONDictionary = [:]
        
        params["tip"] = self.SelTipPrice
        params["type"] = "iOS"
       
        if isApple == false{
            params["card_id"] = self.cardID
        }else{
            params["token"] = Token // ApplePay Payment Intent
        }
       
        showIndicator(withTitle: "", and: "")
        
        let loginURL = baseURL.baseURL + appEndPoints.order_product
        
        print(loginURL,"loginURL")
        
        WebService.shared.postServiceURLEncoding(loginURL, VC: self, andParameter: params, withCompletion: { (json, statusCode) in
            
            self.hideIndicator()
            
            let data = try! json.rawData()
            do{
                
                let d = try JSONDecoder().decode(AddTipModelClass.self, from: data)
                if d.success == true {
                    
                    let responseMessage = d.message ?? ""
                    self.showToast(responseMessage)
                    
                    let allData = d.response
                    
                    let trackingLink = allData?.trackingLink ?? ""
                    
                    
                    let storyboard = UIStoryboard(name: "Basket", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "TrackingVC") as! TrackingVC
                    vc.WebUrl = trackingLink
                    self.navigationController?.pushViewController(vc, animated: true)
                     
                }else{
                    
                    let msg = d.message ?? "Failed to create order"
                    self.showToast(msg)
                }
            }catch{
                
                print(error)
            }
        })
    }
    
}
