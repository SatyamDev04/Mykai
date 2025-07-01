//
//  BasketDetailSuperMarketVC.swift
//  Myka App
//
//  Created by YES IT Labs on 16/12/24.
//

import UIKit
import Alamofire
import SDWebImage
struct SuperMarketModle{
    var header: String = ""
    var SectionData = [SuperMarketSectionModle]()
}

struct SuperMarketSectionModle{
    var name: String = ""
    var quantity: String = ""
    var price: String = ""
    var Count: Int = 1
}

class BasketDetailSuperMarketVC: UIViewController {
    
    @IBOutlet weak var HeaderImg: UIImageView!
    @IBOutlet weak var TblV: UITableView!
    @IBOutlet weak var PriceLbl: UILabel!
    @IBOutlet weak var TblVH: NSLayoutConstraint!
    
    
    //geting from basket screen.
    var IngArr = [Product]()
    var storeDict = Store()
    var totalPrice: String = String()
    //
 
    var SuperMarketArrdata : BasketDetailsModelData?
 
    
    // this is for Dropdown Presented Screen.
    var SuperMarketArr = [MarketModel]()
    //
    
    var isClickTag: Int = 0
    var backAction:(String, [Product]?, String)->() = {_,_,_  in }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.TblV.register(UINib(nibName: "BsktDtlSprMrktSectionTblVCell", bundle: nil), forCellReuseIdentifier: "BsktDtlSprMrktSectionTblVCell")
        self.TblV.delegate = self
        self.TblV.dataSource = self
         
        self.TblV.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(listnerFunction(_:)), name: NSNotification.Name(rawValue: "notificationName"), object: nil)
        
     //   self.getStoreProductsData() // fix loading, alos uncoment from home and checkout (api)
         
        
        if SuperMarketArrdata == nil {
            SuperMarketArrdata = BasketDetailsModelData(product: nil, store: nil, total: nil)
        }
        
        SuperMarketArrdata?.product = IngArr // Assign the product
        SuperMarketArrdata?.store = storeDict     // Assign the store
        SuperMarketArrdata?.total = totalPrice
        
        let img = self.SuperMarketArrdata?.store?.image ?? ""
        let imgUrl = URL(string: img)
        
        self.HeaderImg.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
        self.HeaderImg.sd_setImage(with: imgUrl, placeholderImage: UIImage(named: "No_Image"))
        
      
         
        self.PriceLbl.text = "$\(SuperMarketArrdata?.total ?? "")"
        
        self.TblV.reloadData()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize", let tableView = object as? UITableView {
            let newContentSize = tableView.contentSize
            // Update the height constraint or perform actions as needed
            
            TblVH.constant = tableView.contentSize.height
        }
    }
     
    
    deinit {
        TblV.removeObserver(self, forKeyPath: "contentSize")
    }
    
  //
     
     @objc func listnerFunction(_ notification: NSNotification) {
         if let data = notification.userInfo?["data"] as? String {
             if data == "Reload"{
                 self.getStoreProductsData()
             }
           }
         }

    
    @IBAction func BackBtn(_ sender: UIButton) {
        if isClickTag == 1{ // to reload previous screen data.
            isClickTag = 0
            self.backAction("Market", SuperMarketArrdata?.product, SuperMarketArrdata?.total ?? "")
        }else{
            self.backAction("Ingredients", SuperMarketArrdata?.product, SuperMarketArrdata?.total ?? "")
        }
    self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func DropDownBtn(_ sender: UIButton) {
        self.getSuperMarketData()
    }
    
    @IBAction func AddToBasketBtn(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Basket", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "CheckOutVC") as! CheckOutVC
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
        
//        let storyboard = UIStoryboard(name: "Basket", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "TescoVC") as! TescoVC
//        vc.hidesBottomBarWhenPushed = true
//        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension BasketDetailSuperMarketVC: UITableViewDelegate, UITableViewDataSource {
     
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 1//self.SuperMarketArrdata.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        TblV.separatorStyle = .none
//        let cell = tableView.dequeueReusableCell(withIdentifier: "BsktDtlSprMrktHeatedTblVCell") as! BsktDtlSprMrktHeatedTblVCell
////        cell.NameLbl.text = self.SuperMarketArrdata[indexPath.row].header
//        cell.SuperMarketSecArrdata = self.SuperMarketArrdata
//        cell.SectionTblV.reloadData()
//        cell.backAction = { index in
//            self.SwapBtnActionCalled(index: index)
//        }
//        return cell
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.SuperMarketArrdata?.product?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       // SectionTblV.separatorStyle = .none
        let cell = tableView.dequeueReusableCell(withIdentifier: "BsktDtlSprMrktSectionTblVCell") as! BsktDtlSprMrktSectionTblVCell
         
        let priceValue = self.SuperMarketArrdata?.product?[indexPath.row].pro_price ?? ""
 
        if priceValue == "Not available" || priceValue == ""{
            cell.Pricelbl.text = "$0"
        }else{
            cell.Pricelbl.text = self.SuperMarketArrdata?.product?[indexPath.row].pro_price ?? ""//formattedPrice
        }
        
         
        cell.Countlbl.text = "\(self.SuperMarketArrdata?.product?[indexPath.row].sch_id ?? 1)"
        
        let img = self.SuperMarketArrdata?.product?[indexPath.row].pro_img ?? ""
        let imgUrl = URL(string: img)
        
        cell.Img.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
        cell.Img.sd_setImage(with: imgUrl, placeholderImage: UIImage(named: "No_Image"))
        
        if img == "Not available" || img == "" && priceValue == "Not available" || priceValue == ""{
            
            let text = "\(self.SuperMarketArrdata?.product?[indexPath.row].pro_name ?? "")\nNot Available"

            // Create an NSMutableAttributedString
            let attributedString = NSMutableAttributedString(string: text)

            // Apply black color to "Rice"
            if let riceRange = text.range(of: self.SuperMarketArrdata?.product?[indexPath.row].pro_name ?? "") {
                let nsRange = NSRange(riceRange, in: text)
                attributedString.addAttribute(.foregroundColor, value: UIColor.black, range: nsRange)
            }

            // Apply gray color to "Not Available"
            if let notAvailableRange = text.range(of: "Not Available") {
                let nsRange = NSRange(notAvailableRange, in: text)
                attributedString.addAttribute(.foregroundColor, value: UIColor.gray, range: nsRange)
            }

            // Set the attributed string to the label
            cell.NameLbl.attributedText = attributedString
            
            cell.SwapBtn.isHidden = true
        }else{
            cell.NameLbl.text = self.SuperMarketArrdata?.product?[indexPath.row].pro_name ?? ""
            cell.SwapBtn.isHidden = false
        }
        
       
        cell.MinusBtn.tag = indexPath.row
        cell.MinusBtn.addTarget(self, action: #selector(MinusBtnAction(_:)), for: .touchUpInside)
        
        cell.PlusBtn.tag = indexPath.row
        cell.PlusBtn.addTarget(self, action: #selector(PlusBtnAction(_:)), for: .touchUpInside)
        
        cell.SwapBtn.tag = indexPath.row
        cell.SwapBtn.addTarget(self, action: #selector(SwapBtnAction(_:)), for: .touchUpInside)
        
        return cell
    }
    
    
    
    @objc func SwapBtnAction(_ sender: UIButton) {
        let ID = "\(self.SuperMarketArrdata?.product?[sender.tag].id ?? 0)"
        let ProName = self.SuperMarketArrdata?.product?[sender.tag].name ?? ""
        let FoodID = self.SuperMarketArrdata?.product?[sender.tag].food_id ?? ""
        let SChID = "\(self.SuperMarketArrdata?.product?[sender.tag].sch_id ?? 1)"
        let img = self.SuperMarketArrdata?.product?[sender.tag].pro_img ?? ""
        
        let storyboard = UIStoryboard(name: "Basket", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SwapVC") as! SwapVC
        vc.IDstr = ID
        vc.QueryStr = ProName
        vc.food_idStr = FoodID
        vc.sch_idStr = SChID
        vc.SwapData = self.SuperMarketArrdata?.product?[sender.tag]
        vc.Indx = sender.tag
        vc.hidesBottomBarWhenPushed = true
        vc.BackAction = { data, indx in
           // self.isClickTag = 1
          //  self.getStoreProductsData()
            let prevTotalPrice = self.SuperMarketArrdata?.total ?? ""
            let prevItemCount = self.SuperMarketArrdata?.product?[indx].sch_id ?? 0
           
            let ProdData = data!
            self.SuperMarketArrdata?.product?.remove(at: indx)
            self.SuperMarketArrdata?.product?.insert(ProdData, at: indx)
            
            let priceValue = self.SuperMarketArrdata?.product?[indx].pro_price ?? ""
            let count = self.SuperMarketArrdata?.product?[indx].sch_id ?? 0
            
            

            var fCount = 0
            
            if count > prevItemCount {
                print("Count is \(count - prevItemCount) greater than prevItemCount")
                fCount = count - prevItemCount
                let SelItmPrice = priceValue.replace(string: "$", withString: "")
                let ItmPriceValue = Double(SelItmPrice) ?? 0
                let fItmPriceValue = ItmPriceValue * Double(fCount)
                
                let totalPriceStr = self.SuperMarketArrdata?.total ?? ""
                let a = totalPriceStr.replace(string: "$", withString: "")
                let b = a.replace(string: ",", withString: "")
                let TotalPriceValue = Double(b) ?? 0
                
                let FTotalPriceValue = TotalPriceValue + fItmPriceValue
                let FinalTotalPriceValue = self.formatPrice(FTotalPriceValue)
                
                self.SuperMarketArrdata?.total = "$\(FinalTotalPriceValue)"
                
                self.PriceLbl.text = "$\(FinalTotalPriceValue)"
                
            } else if count < prevItemCount {
                let positiveValue = abs(count - prevItemCount)
                print("Count is \(positiveValue) smaller than prevItemCount")
                
                fCount = positiveValue
     
                let SelItmPrice = priceValue.replace(string: "$", withString: "")
                let ItmPriceValue = Double(SelItmPrice) ?? 0
                let fItmPriceValue = ItmPriceValue * Double(fCount)
                
                let totalPriceStr = self.SuperMarketArrdata?.total ?? ""
                let a = totalPriceStr.replace(string: "$", withString: "")
                let b = a.replace(string: ",", withString: "")
                let TotalPriceValue = Double(b) ?? 0
                
                let FTotalPriceValue = TotalPriceValue - fItmPriceValue
                let FinalTotalPriceValue = self.formatPrice(FTotalPriceValue)
                
                self.SuperMarketArrdata?.total = "$\(FinalTotalPriceValue)"
                
                self.PriceLbl.text = "$\(FinalTotalPriceValue)"
            }else{
                print("Count is equal to prevItemCount")
            }
            self.TblV.reloadData()
        }
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func MinusBtnAction(_ sender: UIButton) {
        var count = self.SuperMarketArrdata?.product?[sender.tag].sch_id ?? 1
        
        guard count > 1 else{return}
        
        count -= 1
        
        self.SuperMarketArrdata?.product?[sender.tag].sch_id = count
         
        let priceValue = self.SuperMarketArrdata?.product?[sender.tag].pro_price ?? ""
        
        if priceValue != "Not available" || priceValue != ""{

            let SelItmPrice = priceValue.replace(string: "$", withString: "")
            let ItmPriceValue = Double(SelItmPrice) ?? 0
            
            let totalPriceStr = self.SuperMarketArrdata?.total ?? ""
            let a = totalPriceStr.replace(string: "$", withString: "")
            let b = a.replace(string: ",", withString: "")
            let TotalPriceValue = Double(b) ?? 0
            
            let FTotalPriceValue = TotalPriceValue - ItmPriceValue
            let FinalTotalPriceValue = formatPrice(FTotalPriceValue)
            
            self.SuperMarketArrdata?.total = "$\(FinalTotalPriceValue)"
            
            self.PriceLbl.text = "$\(FinalTotalPriceValue)"
        }
        
        let FoodID = self.SuperMarketArrdata?.product?[sender.tag].food_id ?? ""
        
        self.TblV.reloadData()
        self.Api_To_Plus_Minus_ServesCount(FoodID: FoodID, Quenty:"\(count)")
    }
    
    
    @objc func PlusBtnAction(_ sender: UIButton) {
        var count = self.SuperMarketArrdata?.product?[sender.tag].sch_id ?? 1

        count += 1
        
        self.SuperMarketArrdata?.product?[sender.tag].sch_id = count
        
        let priceValue = self.SuperMarketArrdata?.product?[sender.tag].pro_price ?? ""
  
        if priceValue != "Not available" || priceValue != ""{

            let SelItmPrice = priceValue.replace(string: "$", withString: "")
            let ItmPriceValue = Double(SelItmPrice) ?? 0
            
            let totalPriceStr = self.SuperMarketArrdata?.total ?? ""
            let a = totalPriceStr.replace(string: "$", withString: "")
            let b = a.replace(string: ",", withString: "")
            let TotalPriceValue = Double(b) ?? 0
             
            let FTotalPriceValue = TotalPriceValue + ItmPriceValue
            let FinalTotalPriceValue = formatPrice(FTotalPriceValue)
            self.SuperMarketArrdata?.total = "$\(FinalTotalPriceValue)"
            self.PriceLbl.text = "$\(FinalTotalPriceValue)"
        }
        
        
        let FoodID = self.SuperMarketArrdata?.product?[sender.tag].food_id ?? ""
        
        self.TblV.reloadData()
        self.Api_To_Plus_Minus_ServesCount(FoodID: FoodID, Quenty:"\(count)")
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
//    func SwapBtnActionCalled(index: Int) {
//        let storyboard = UIStoryboard(name: "Basket", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "SwapVC") as! SwapVC
//        vc.hidesBottomBarWhenPushed = true
//        self.navigationController?.pushViewController(vc, animated: true)
//        
//    }
    
}
 
// BasketDetailsModelData
//
extension BasketDetailSuperMarketVC{
    
    func getStoreProductsData() {
        var params:JSONDictionary = [:]
        
//        params["latitude"] = AppLocation.lat
//        params["longitude"] = AppLocation.long
        
        showIndicator(withTitle: "", and: "")
        
        
        let loginURL = baseURL.baseURL + appEndPoints.store_products
        print(params,"Params")
        print(loginURL,"loginURL")
        
        
        
        WebService.shared.postServiceURLEncoding(loginURL, VC: self, andParameter: params, withCompletion: { (json, statusCode) in
            
            self.hideIndicator()
            
            let data = try! json.rawData()
            do{
                
                let d = try JSONDecoder().decode(BasketDetailsModelClass.self, from: data)
                if d.success == true {
                      
                    let allData = d.data
                    self.SuperMarketArrdata = allData ?? nil
                    
                    self.SuperMarketArr = self.SuperMarketArr.filter { store in
                        store.total != nil && store.total != 0.0
                    }
                    
                    let img = self.SuperMarketArrdata?.store?.image ?? ""
                    let imgUrl = URL(string: img)
                    
                    self.HeaderImg.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
                    self.HeaderImg.sd_setImage(with: imgUrl, placeholderImage: UIImage(named: "No_Image"))
                    
                    self.PriceLbl.text = self.SuperMarketArrdata?.total ?? ""
                    DispatchQueue.main.async {
                        self.TblV.reloadData()
                    }
                     
                }else{
                    let msg = d.message ?? ""
                    self.showToast(msg)
                }
            }catch{
                
                print(error)
            }
        })
    }
  
    func Api_To_Plus_Minus_ServesCount(FoodID:String, Quenty:String){
        
        var params:JSONDictionary = [:]
        
        params["food_id"] = FoodID
        params["quantity"] = Quenty
        
      
        showIndicator(withTitle: "", and: "")
        
        let loginURL = baseURL.baseURL + appEndPoints.change_cart
        
        print(loginURL,"loginURL")
        
        WebService.shared.postServiceURLEncoding(loginURL, VC: self, andParameter: params, withCompletion: { (json, statusCode) in
            
            self.hideIndicator()
            
            guard let dictData = json.dictionaryObject else{
                
                return
            }
            
            if dictData["success"] as? Bool == true{
                
            }else{
                let responseMessage = dictData["message"] as! String
                self.showToast(responseMessage)
            }
        })
    }
    
    //
     
        func getSuperMarketData() {
            var params:JSONDictionary = [:]
            
            params["latitude"] = AppLocation.lat
            params["longitude"] = AppLocation.long
            params["page"] = 1
            
            showIndicator(withTitle: "", and: "")
            
            
            
            let loginURL = baseURL.baseURL + appEndPoints.super_markets
            print(params,"Params")
            print(loginURL,"loginURL")
            
            
    
            WebService.shared.postServiceURLEncoding(loginURL, VC: self, andParameter: params, withCompletion: { (json, statusCode) in
                
                self.hideIndicator()
                
                let data = try! json.rawData()
                do{
                    
                    let d = try JSONDecoder().decode(MarketModelClass.self, from: data)
                    if d.success == true {
                        
                        let allData = d.data
                        self.SuperMarketArr = allData ?? []
                          
                        let storyboard = UIStoryboard(name: "Basket", bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: "SelectMarketVC") as! SelectMarketVC
                        vc.SuperMarketArr = self.SuperMarketArr
                        vc.backAction = {
                            self.isClickTag = 1
                            self.getStoreProductsData()
                        }
                            self.present(vc, animated: true, completion: nil)
                      
                    }else{
                        
                        let msg = d.message ?? ""
                        self.showToast(msg)
                    }
                }catch{
                    
                    print(error)
                }
            })
        }
}
