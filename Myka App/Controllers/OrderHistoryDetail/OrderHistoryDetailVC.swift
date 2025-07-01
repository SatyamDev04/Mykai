//
//  OrderHistoryDetailVC.swift
//  My-Kai
//
//  Created by YES IT Labs on 28/02/25.
//

import UIKit
import SDWebImage
import StripePayments
import StripePaymentsUI

struct itemOrderHistoryDetail {
    var itemName: String
    var itemQty: String
    var itemPrice: String
}

class OrderHistoryDetailVC: UIViewController {
    
    @IBOutlet weak var OrderIdLbl: UILabel!
    @IBOutlet weak var ImgV: UIImageView!
    @IBOutlet weak var OrderCompDateLbl: UILabel!
    @IBOutlet weak var OrderTblV: UITableView!
    @IBOutlet weak var OrderTblVH: NSLayoutConstraint!
    @IBOutlet weak var SubTotalPriceLbl: UILabel!
    @IBOutlet weak var ServiceFeePriceLbl: UILabel!
    @IBOutlet weak var DeliveryPriceLbl: UILabel!
    @IBOutlet weak var SalesTaxPriceLbl: UILabel!
    @IBOutlet weak var TotalPriceLbl: UILabel!
    @IBOutlet weak var PaymentTblV: UITableView!
    @IBOutlet weak var PaymentTblVH: NSLayoutConstraint!
    
   var comesfrom = ""
    
    var OrderHistoryArrList = OrderHistoryModelData()
    
    var StateOrderHistoryArrList = OrderElement()

    override func viewDidLoad() {
        super.viewDidLoad()
        if comesfrom == "StatesForWeekOrYearVC"{
            
            self.OrderIdLbl.text = "Order #\(StateOrderHistoryArrList.order?.orderID ?? "")"
            let Result = StateOrderHistoryArrList.order?.finalQuote?.quote
            
            let StoreImg = StateOrderHistoryArrList.storeLogo ?? ""
            let ImgURL = URL(string: StoreImg) ?? nil
            
            let CompleteDate = StateOrderHistoryArrList.date ?? ""
            
            let inputDateFormat = "yyyy-MM-dd'T'HH:mm:ssZ" // Example: "2025-01-11T11:16:00+0000"
            let outputDateFormat = "dd MMMM yyyy 'at' h:mm a"
            
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US_POSIX") // Ensures consistent parsing
            dateFormatter.dateFormat = inputDateFormat
            
            // Convert string to Date
            if let date = dateFormatter.date(from: CompleteDate) {
                // Convert Date to desired output string format
                dateFormatter.dateFormat = outputDateFormat
                let formattedDate = dateFormatter.string(from: date)
                print(formattedDate) // Outputs: "11 January 2025 at 11:16 AM"
                
                let Attributes1: [NSAttributedString.Key: Any] = [
                    .foregroundColor: UIColor.init(red: 6/255, green: 193/255, blue: 105/255, alpha: 1)
                ]
                
                let Attributes2: [NSAttributedString.Key: Any] = [
                    .foregroundColor: #colorLiteral(red: 0.5882352941, green: 0.6666666667, blue: 0.631372549, alpha: 1)
                ]
                
                let helloString = NSAttributedString(string: "Order completed", attributes: Attributes1)
                let worldString = NSAttributedString(string: " • \(formattedDate)", attributes: Attributes2)
                let fullString = NSMutableAttributedString()
                fullString.append(helloString)
                fullString.append(worldString)
                self.OrderCompDateLbl.attributedText = fullString
            } else {
                let Attributes1: [NSAttributedString.Key: Any] = [
                    .foregroundColor: UIColor.init(red: 6/255, green: 193/255, blue: 105/255, alpha: 1)
                ]
                let helloString = NSAttributedString(string: "Order completed • ", attributes: Attributes1)
                let fullString = NSMutableAttributedString()
                fullString.append(helloString)
                self.OrderCompDateLbl.attributedText = fullString
            }
            
            
            self.ImgV.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
            self.ImgV.sd_setImage(with: ImgURL, placeholderImage: UIImage(named: "No_Image"))
            
            let subtotal = (Result?.subtotal ?? 0)/100
            let Fsubtotal = formatPrice(subtotal)
            
            let serviceFee = (Result?.serviceFeeCents ?? 0)/100
            let FserviceFee = formatPrice(serviceFee)
            
            let deliveryFee = (Result?.deliveryFeeCents ?? 0)/100
            let FdeliveryFee = formatPrice(deliveryFee)
            
            let SalesTaxFee = (Result?.salesTaxCents ?? 0)/100
            let FSalesTaxFee = formatPrice(SalesTaxFee)
            
            let totalPrice = (StateOrderHistoryArrList.order?.finalQuote?.totalWithTip ?? 0)/100
            let FtotalPrice = formatPrice(totalPrice)
            
            self.SubTotalPriceLbl.text = "$\(Fsubtotal)"
            self.ServiceFeePriceLbl.text = "$\(FserviceFee)"
            self.DeliveryPriceLbl.text = "$\(FdeliveryFee)"
            self.SalesTaxPriceLbl.text = "$\(FSalesTaxFee)"
            self.TotalPriceLbl.text = "$\(FtotalPrice)"
        }else{
            
            self.OrderIdLbl.text = "Order #\(OrderHistoryArrList.order?.orderID ?? "")"
            
            let Result = OrderHistoryArrList.order?.finalQuote?.quote
            
            let StoreImg = OrderHistoryArrList.storeLogo ?? ""
            let ImgURL = URL(string: StoreImg) ?? nil
            
            let CompleteDate = OrderHistoryArrList.date ?? ""
            
            let inputDateFormat = "yyyy-MM-dd'T'HH:mm:ssZ" // Example: "2025-01-11T11:16:00+0000"
            let outputDateFormat = "dd MMMM yyyy 'at' h:mm a"
            
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US_POSIX") // Ensures consistent parsing
            dateFormatter.dateFormat = inputDateFormat
            
            // Convert string to Date
            if let date = dateFormatter.date(from: CompleteDate) {
                // Convert Date to desired output string format
                dateFormatter.dateFormat = outputDateFormat
                let formattedDate = dateFormatter.string(from: date)
                print(formattedDate) // Outputs: "11 January 2025 at 11:16 AM"
                
                let Attributes1: [NSAttributedString.Key: Any] = [
                    .foregroundColor: UIColor.init(red: 6/255, green: 193/255, blue: 105/255, alpha: 1)
                ]
                
                let Attributes2: [NSAttributedString.Key: Any] = [
                    .foregroundColor: #colorLiteral(red: 0.5882352941, green: 0.6666666667, blue: 0.631372549, alpha: 1)
                ]
                
                let helloString = NSAttributedString(string: "Order completed", attributes: Attributes1)
                let worldString = NSAttributedString(string: " • \(formattedDate)", attributes: Attributes2)
                let fullString = NSMutableAttributedString()
                fullString.append(helloString)
                fullString.append(worldString)
                self.OrderCompDateLbl.attributedText = fullString
            } else {
                let Attributes1: [NSAttributedString.Key: Any] = [
                    .foregroundColor: UIColor.init(red: 6/255, green: 193/255, blue: 105/255, alpha: 1)
                ]
                let helloString = NSAttributedString(string: "Order completed • ", attributes: Attributes1)
                let fullString = NSMutableAttributedString()
                fullString.append(helloString)
                self.OrderCompDateLbl.attributedText = fullString
            }
            
            
            self.ImgV.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
            self.ImgV.sd_setImage(with: ImgURL, placeholderImage: UIImage(named: "No_Image"))
            
            let subtotal = (Result?.subtotal ?? 0)/100
            let Fsubtotal = formatPrice(subtotal)
            
            let serviceFee = (Result?.serviceFeeCents ?? 0)/100
            let FserviceFee = formatPrice(serviceFee)
            
            let deliveryFee = (Result?.deliveryFeeCents ?? 0)/100
            let FdeliveryFee = formatPrice(deliveryFee)
            
            let SalesTaxFee = (Result?.salesTaxCents ?? 0)/100
            let FSalesTaxFee = formatPrice(SalesTaxFee)
            
            let totalPrice = (OrderHistoryArrList.order?.finalQuote?.totalWithTip ?? 0)/100
            let FtotalPrice = formatPrice(totalPrice)
            
            self.SubTotalPriceLbl.text = "$\(Fsubtotal)"
            self.ServiceFeePriceLbl.text = "$\(FserviceFee)"
            self.DeliveryPriceLbl.text = "$\(FdeliveryFee)"
            self.SalesTaxPriceLbl.text = "$\(FSalesTaxFee)"
            self.TotalPriceLbl.text = "$\(FtotalPrice)"
        }
       
        self.OrderTblV.register(UINib(nibName: "OrderHistoryDetailTblVCell", bundle: nil), forCellReuseIdentifier: "OrderHistoryDetailTblVCell")
        self.OrderTblV.delegate = self
        self.OrderTblV.dataSource = self
        
        self.PaymentTblV.register(UINib(nibName: "OrderPaymentDetailTblVCell", bundle: nil), forCellReuseIdentifier: "OrderPaymentDetailTblVCell")
        self.PaymentTblV.delegate = self
        self.PaymentTblV.dataSource = self
        
        self.OrderTblV.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        self.PaymentTblV.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize" {
            if let tableView = object as? UITableView {
                if tableView == OrderTblV {
                    OrderTblVH.constant = tableView.contentSize.height
                } else if tableView == PaymentTblV {
                    PaymentTblVH.constant = tableView.contentSize.height
                }
                view.layoutIfNeeded()
            }
        }
    }
    
    
    deinit {
        // Remove observers
        OrderTblV.removeObserver(self, forKeyPath: "contentSize")
        PaymentTblV.removeObserver(self, forKeyPath: "contentSize")
    }
    
    @IBAction func BackBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
 
}

extension OrderHistoryDetailVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.OrderTblV {
            if comesfrom == "StatesForWeekOrYearVC"{
                return StateOrderHistoryArrList.order?.finalQuote?.items?.count ?? 0
            }else{
                return OrderHistoryArrList.order?.finalQuote?.items?.count ?? 0
            }
        }else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.OrderTblV {
            let cell = self.OrderTblV.dequeueReusableCell(withIdentifier: "OrderHistoryDetailTblVCell", for: indexPath) as! OrderHistoryDetailTblVCell
            if comesfrom == "StatesForWeekOrYearVC"{
                let Result = StateOrderHistoryArrList.order?.finalQuote?.items?[indexPath.row]
                cell.ItemNameLbl.text = "\(Result?.name ?? ""), \(Result?.quantity ?? 0)"
                cell.ItemCountLbl.text = "\(indexPath.row + 1)"
                
                let price = (Result?.basePrice ?? 0)/100
                let Fprice = self.formatPrice(price)
                
                cell.PriceLbl.text = "$\(Fprice)"
            }else{
            let val = OrderHistoryArrList.order?.finalQuote?.items?[indexPath.row]
            
            cell.ItemNameLbl.text = "\(val?.name ?? ""), \(val?.quantity ?? 0)"
            cell.ItemCountLbl.text = "\(indexPath.row + 1)"
            
            let price = (val?.basePrice ?? 0)/100
            let Fprice = self.formatPrice(price)
            
            cell.PriceLbl.text = "$\(Fprice)"
        }
            return cell
        }else{
            let cell = self.PaymentTblV.dequeueReusableCell(withIdentifier: "OrderPaymentDetailTblVCell", for: indexPath) as! OrderPaymentDetailTblVCell
            
            if OrderHistoryArrList.card?.cardType == "GPay" {
                cell.CardTyp_NumberLbl.text = "\(OrderHistoryArrList.card?.cardType ?? "") \(OrderHistoryArrList.card?.cardBrand ?? "") ••••\(OrderHistoryArrList.card?.cardNo ?? "")"
                cell.CardImg.image = UIImage(named: "Google pay")
                
            }else if OrderHistoryArrList.card?.cardType == "ApplePay" {
                cell.CardTyp_NumberLbl.text = "\(OrderHistoryArrList.card?.cardType ?? "") \(OrderHistoryArrList.card?.cardBrand ?? "") ••••\(OrderHistoryArrList.card?.cardNo ?? "")"
                
                cell.CardImg.image = UIImage(named: "ApplePay")
            }else{
                cell.CardTyp_NumberLbl.text = "\(OrderHistoryArrList.card?.cardBrand ?? "") ••••\(OrderHistoryArrList.card?.cardNo ?? "")"
                let card = OrderHistoryArrList.card?.cardBrand ?? ""
                let crdbrnd = STPCard.brand(from: card)
                
                let cardImage = STPImageLibrary.cardBrandImage(for: crdbrnd)
                cell.CardImg.image = cardImage
            }
            
            let dateString = OrderHistoryArrList.date ?? ""
            let inputFormat = DateFormatter()
            inputFormat.dateFormat = "yyyy-MM-dd HH:mm:ss"
            inputFormat.locale = Locale(identifier: "en_US")

            let outputFormat = DateFormatter()
            outputFormat.dateFormat = "dd/MM/yyyy hh:mm a"
            outputFormat.locale = Locale(identifier: "en_US")
 
            // Convert the date string
            if let date = inputFormat.date(from: dateString) {
                let formattedDate = outputFormat.string(from: date)
                print(formattedDate) // Output: 29/05/2025 01:01 PM
                cell.Datelbl.text = "\(formattedDate)"
            }
            
            
            
            let Result = OrderHistoryArrList.order?.finalQuote?.totalWithTip ?? 0
            let price = (Result)/100
            let Fprice = self.formatPrice(price)
            
            cell.Pricelbl.text = "$\(Fprice)"
            
           
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == OrderTblV{
            return UITableView.automaticDimension
        }else{
            return UITableView.automaticDimension
        }
    }
}
