//
//  SwapVC.swift
//  Myka App
//
//  Created by YES IT Labs on 17/12/24.
//

import UIKit
import Alamofire
import SDWebImage

class SwapVC: UIViewController {

    @IBOutlet weak var Img: UIImageView!
    @IBOutlet weak var NameLbl: UILabel!
    @IBOutlet weak var PriceLbl: UILabel!
    @IBOutlet weak var SearchTxt: UITextField!
    @IBOutlet weak var TblV: UITableView!
    @IBOutlet weak var TblVH: NSLayoutConstraint!
    
    var IDstr = ""
    var QueryStr = ""
    var food_idStr = ""
    var sch_idStr = ""
    
    var Indx = 0 // comes from previous Screen
    var SwapData: Product?
    
    var IngArrData = [SelIngredientsModelData]()
    var IngArrData1 = [SelIngredientsModelData]()
    var selIndx = 0
    
  //  var SuperMarketArrdata = [SuperMarketSectionModle(name: "", quantity: "", price: "", Count: 1), SuperMarketSectionModle(name: "", quantity: "", price: "", Count: 1), SuperMarketSectionModle(name: "", quantity: "", price: "", Count: 1), SuperMarketSectionModle(name: "", quantity: "", price: "", Count: 1), SuperMarketSectionModle(name: "", quantity: "", price: "", Count: 1), SuperMarketSectionModle(name: "", quantity: "", price: "", Count: 1)]
    
    var BackAction:(Product?, Int)->() = {_,_ in }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.TblV.register(UINib(nibName: "SwapTblVCell", bundle: nil), forCellReuseIdentifier: "SwapTblVCell")
         
        self.TblV.delegate = self
        self.TblV.dataSource = self
        
        self.TblV.addObserver(self, forKeyPath: "contentSize", options: [.new, .old], context: nil)
         
        
        self.PriceLbl.text = self.SwapData?.pro_price ?? ""//formattedPrice
        
        self.NameLbl.text = self.SwapData?.name ?? ""
      
        let img = self.SwapData?.pro_img ?? ""
        let imgUrl = URL(string: img)
        
        self.Img.sd_imageIndicator = SDWebImageActivityIndicator.large
        self.Img.sd_setImage(with: imgUrl, placeholderImage: UIImage(named: "No_Image"))
        
        
        self.SearchTxt.addTarget(self, action: #selector(TextSearch(sender: )), for: .editingChanged)

       // self.getProductsData()
        
        self.getProductsIngredientData()
    }
    
    @objc func TextSearch(sender: UITextField){
        if self.SearchTxt.text != ""{
            // for search with name only.
            IngArrData = IngArrData1.filter({ (item) -> Bool in
                let value: SelIngredientsModelData = item as SelIngredientsModelData
                return ((value.name!.range(of: sender.text!, options: .caseInsensitive)) != nil)
            })
        }else{
            IngArrData = IngArrData1
        }
        
        self.TblV.reloadData()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize", let tableView = object as? UITableView {
            let newContentSize = tableView.contentSize
            // Update the height constraint or perform actions as needed
            updateTableViewHeight(newContentSize.height)
        }
    }
    
    func updateTableViewHeight(_ height: CGFloat) {
        TblVH.constant = height
        view.layoutIfNeeded()
    }
    
    
    deinit {
        TblV.removeObserver(self, forKeyPath: "contentSize")
    }
    
    @IBAction func BackBtn(_ sender: UIButton) {
        self.BackAction(self.SwapData, Indx)
        self.navigationController?.popViewController(animated: true)
    }
 
    @IBAction func ViewDetailBtn(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Basket", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "BasketDetailVC") as! BasketDetailVC
        vc.SwapData = self.SwapData
        vc.indx = self.Indx
        vc.IDstr = self.IDstr
        vc.QueryStr = self.QueryStr
        vc.food_idStr = self.food_idStr
        vc.backAction = { data, indx in
            self.SwapData = data
            self.Indx = indx
            self.TblV.reloadData()
        }
        vc.sch_idStr = self.sch_idStr
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension SwapVC: UITableViewDelegate, UITableViewDataSource {
     
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.IngArrData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        TblV.separatorStyle = .none
        let cell = tableView.dequeueReusableCell(withIdentifier: "SwapTblVCell") as! SwapTblVCell
        
        let img = IngArrData[indexPath.row].image ?? ""
        let imgUrl = URL(string: img)

        cell.Img.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
        cell.Img.sd_setImage(with: imgUrl, placeholderImage: UIImage(named: "No_Image"))
       
        cell.NameLbl.text = IngArrData[indexPath.row].name ?? ""
        
        let price = IngArrData[indexPath.row].formattedPrice ?? ""
        cell.Pricelbl.text = "\(price)"
        
        cell.Countlbl.text = "\(IngArrData[indexPath.row].schID ?? 1)"
        
        cell.ViewDetailBtn.tag = indexPath.row
        cell.ViewDetailBtn.addTarget(self, action: #selector(ViewAllDetailBtnAction(_:)), for: .touchUpInside)
        
        cell.MinusBtn.tag = indexPath.row
        cell.MinusBtn.addTarget(self, action: #selector(MinusBtnAction(_:)), for: .touchUpInside)
        
        cell.PlusBtn.tag = indexPath.row
        cell.PlusBtn.addTarget(self, action: #selector(PlusBtnAction(_:)), for: .touchUpInside)
        
        return cell
    }
    
    @objc func ViewAllDetailBtnAction(_ sender: UIButton) {
        
        
        let storyboard = UIStoryboard(name: "Basket", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "BasketDetailVC") as! BasketDetailVC
          
        vc.IngArrData = self.IngArrData[sender.tag]
        vc.indx = sender.tag
        vc.IDstr = self.IDstr
        vc.QueryStr = self.QueryStr
        vc.food_idStr = IngArrData[sender.tag].foodID ?? ""
        vc.sch_idStr = "\(IngArrData[sender.tag].schID ?? 0)"
        vc.comesfrom = "TblV"
        vc.backAction1 = { data, indx in
            self.IngArrData[indx] = data ?? SelIngredientsModelData()
            self.TblV.reloadData()
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func MinusBtnAction(_ sender: UIButton) {
        var Count = self.IngArrData[sender.tag].schID ?? 1
        guard Count > 1 else{return}
        
        Count -= 1
        
        self.IngArrData[sender.tag].schID = Count
        
        let FoodID = self.IngArrData[sender.tag].foodID ?? ""
        
        self.TblV.reloadData()
        
        self.Api_To_Plus_Minus_ServesCount(FoodID: FoodID, Quenty:"\(Count)")
    }
    
    
    @objc func PlusBtnAction(_ sender: UIButton) {
        var Count = self.IngArrData[sender.tag].schID ?? 1
        Count += 1
        self.IngArrData[sender.tag].schID = Count
        self.TblV.reloadData()
        
        let FoodID = self.IngArrData[sender.tag].foodID ?? ""
        
        self.Api_To_Plus_Minus_ServesCount(FoodID: FoodID, Quenty:"\(Count)")
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let id = self.IDstr
        let Proid = self.IngArrData[indexPath.row].productID ?? ""
        let schID = "\(self.IngArrData[indexPath.row].schID ?? 1)"
        self.selIndx = indexPath.row
        self.Api_To_SelectItem(ID: id, productID: Proid, schID: schID)
    }

    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
 
 
extension SwapVC{
//    func getProductsData() {
//        var params:JSONDictionary = [:]
//        
//        params["id"] = self.IDstr
//        params["query"] = self.QueryStr
//        params["food_id"] = self.food_idStr
//        params["sch_id"] = self.sch_idStr
//        
//        showIndicator(withTitle: "", and: "")
// 
//        
//        let loginURL = baseURL.baseURL + appEndPoints.get_products
//        print(params,"Params")
//        print(loginURL,"loginURL")
//        
//        
//        let token  = UserDetail.shared.getTokenWith()
//        
//        let headers: HTTPHeaders = [
//            "Authorization": "Bearer \(token)"
//        ]
//        
//        
//        WebService.shared.postServiceURLEncoding(loginURL, VC: self, andParameter: params, headers: headers, withCompletion: { (json, statusCode) in
//            
//            self.hideIndicator()
//            
//            let data = try! json.rawData()
//            do{
//                
//                let d = try JSONDecoder().decode(SwapModelClass.self, from: data)
//                if d.success == true {
//                      
//                    let allData = d.data
//                    
//                    self.SwapData = allData ?? nil
//                     
////                    let img = self.SwapData?.image ?? ""
////                    let imgUrl = URL(string: img)
////
////                    self.Img.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
////                    self.Img.sd_setImage(with: imgUrl, placeholderImage: UIImage(named: "No_Image"))
//                     
//                    self.NameLbl.text = self.SwapData?.name ?? ""
//                    self.PriceLbl.text = self.SwapData?.formattedPrice ?? ""
// 
//                    self.getProductsIngredientData()
//                  
//                }else{
//                    
//                    let msg = d.message ?? ""
//                    self.showToast(msg)
//                }
//            }catch{
//                
//                print(error)
//            }
//        })
//    }
                     
    
    func getProductsIngredientData() {
        var params:JSONDictionary = [:]
        
        params["query"] = self.QueryStr
        params["food_id"] = self.food_idStr
        params["sch_id"] = self.sch_idStr
        
        showIndicator(withTitle: "", and: "")
        
        
        
        let loginURL = baseURL.baseURL + appEndPoints.products
        print(params,"Params")
        print(loginURL,"loginURL")
        
        
       
        WebService.shared.postServiceURLEncoding(loginURL, VC: self, andParameter: params, withCompletion: { (json, statusCode) in
            
            self.hideIndicator()
            
            let data = try! json.rawData()
            do{
                
                let d = try JSONDecoder().decode(SelIngredientsModelClass.self, from: data)
                if d.success == true {
                      
                    let allData = d.data
                    
                    self.IngArrData = allData ?? [SelIngredientsModelData]()
                    
                    self.IngArrData1 = self.IngArrData
                    
                    if self.IngArrData.count != 0{
                        self.TblV.setEmptyMessage("")
                    }else{
                        self.TblV.setEmptyMessage("No Products found")
                    }
                    
 
                    self.TblV.reloadData()
                  
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
    
    //select-product
    
    func Api_To_SelectItem(ID:String, productID:String, schID: String){
        
        var params:JSONDictionary = [:]
        
        params["id"] = ID
        params["product_id"] = productID
        params["sch_id"] = schID
    
        
        showIndicator(withTitle: "", and: "")
        
        let loginURL = baseURL.baseURL + appEndPoints.select_product
        
        print(loginURL,"loginURL")
        
        WebService.shared.postServiceURLEncoding(loginURL, VC: self, andParameter: params, withCompletion: { (json, statusCode) in
            
            self.hideIndicator()
            
            guard let dictData = json.dictionaryObject else{
                
                return
            }
            
            if dictData["success"] as? Bool == true{
             
              let ProPrice = self.IngArrData[self.selIndx].formattedPrice
                
                let id  = self.SwapData?.id
                let Mrktid  = self.SwapData?.market_id
                let pric = self.SwapData?.price
                let ProID = self.SwapData?.pro_id
                let userid = self.SwapData?.user_id
                let status = self.SwapData?.status
                
                let formatter = NumberFormatter()
                formatter.numberStyle = .currency
                formatter.locale = Locale(identifier: "en_US")
                let number = formatter.number(from: ProPrice ?? "0") ?? 0
                
                let doubleValue = number.doubleValue
                    print(doubleValue) // Output: 1595.84
                
                let prod = Product(created_at: "", deleted_at: "", food_id: self.IngArrData[self.selIndx].foodID, id: id, market_id: Mrktid, name: self.IngArrData[self.selIndx].name, price: pric, pro_id: ProID, pro_img: self.IngArrData[self.selIndx].image, pro_name: self.IngArrData[self.selIndx].name, pro_price: "\(doubleValue)", product_id: self.IngArrData[self.selIndx].productID, quantity: 0, sch_id: self.IngArrData[self.selIndx].schID, status: status, updated_at: "", user_id: userid)
                 
                self.BackAction(prod, self.Indx)
                self.navigationController?.popViewController(animated: true)
            }else{
                let responseMessage = dictData["message"] as! String
                self.showToast(responseMessage)
            }
        })
    }
}
