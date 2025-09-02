//
//  BasketDetailVC.swift
//  My-Kai
//
//  Created by YES IT Labs on 05/03/25.
//

import UIKit
import Alamofire
import SDWebImage

class BasketDetailVC: UIViewController {
    
    @IBOutlet weak var MainImgV: UIImageView!
    @IBOutlet weak var ItemNameLbl: UILabel!
    
    @IBOutlet weak var DiscountedPriceLbl: UILabel!
    @IBOutlet weak var RealPriceLbl: UILabel!
    @IBOutlet weak var ItemQtyLbl: UILabel!
    
    //
    @IBOutlet weak var CountLbl: UILabel!
    
    //
    
    @IBOutlet weak var RemoveFromBsktBtnO: UIButton!
    
    @IBOutlet weak var DetailsBtnO: UIButton!
    @IBOutlet weak var DetailsImgV: UIImageView!
    @IBOutlet weak var DetailsTxtLbl: UILabel!
    @IBOutlet weak var DetailsTxtBgV: UIView!
    
    @IBOutlet weak var IngredientsBtnO: UIButton!
    @IBOutlet weak var IngredientsImgV: UIImageView!
    @IBOutlet weak var IngredientsTblV: UITableView!
    @IBOutlet weak var IngredientsTblVH: NSLayoutConstraint!
    @IBOutlet weak var IngredientsBgV: UIView!
    
    @IBOutlet weak var DirectionsBtnO: UIButton!
    @IBOutlet weak var DirectionsImgV: UIImageView!
    @IBOutlet weak var DirectionsTblV: UITableView!
    
    @IBOutlet weak var DirectionsTblVH: NSLayoutConstraint!
    @IBOutlet weak var DirectionsBgV: UIView!
    
   
    var IDstr = ""
    var QueryStr = ""
    var food_idStr = ""
    var sch_idStr = ""
    
    var SwapData: Product?
    var indx = 0
    
    var IngArrData = SelIngredientsModelData()
    
    var removeTag = 0
    
    //
    var comesfrom = ""
    
    
    
    var backAction:(Product?, Int)->() = {_,_ in}
    
    var backAction1:(SelIngredientsModelData?, Int)->() = {_,_ in}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if comesfrom == "TblV"{
            let img = self.IngArrData.image ?? ""
            let imgUrl = URL(string: img)
            
            self.MainImgV.sd_imageIndicator = SDWebImageActivityIndicator.large
            self.MainImgV.sd_setImage(with: imgUrl, placeholderImage: UIImage(named: "No_Image"))
            
            self.ItemNameLbl.text = self.IngArrData.name ?? ""
            
            self.DiscountedPriceLbl.text = self.IngArrData.formattedPrice ?? ""//formattedPrice
            
            self.ItemQtyLbl.text = "\(self.IngArrData.schID ?? 1)"
            
            self.CountLbl.text = "\(self.IngArrData.schID ?? 1)"
            
            self.RemoveFromBsktBtnO.isHidden = true
        }else{
            let img = self.SwapData?.pro_img ?? ""
            let imgUrl = URL(string: img)
            
            self.MainImgV.sd_imageIndicator = SDWebImageActivityIndicator.large
            self.MainImgV.sd_setImage(with: imgUrl, placeholderImage: UIImage(named: "No_Image"))
            
            self.ItemNameLbl.text = self.SwapData?.name ?? ""
            
            self.DiscountedPriceLbl.text = self.SwapData?.pro_price ?? ""//formattedPrice
            
            self.ItemQtyLbl.text = "\(self.SwapData?.sch_id ?? 1)"
            
            self.CountLbl.text = "\(self.SwapData?.sch_id ?? 1)"
            
            self.RemoveFromBsktBtnO.isHidden = false
        }
        
        self.DetailsTxtBgV.isHidden = true
        self.IngredientsBgV.isHidden = true
        self.DirectionsBgV.isHidden = true
        
        self.DirectionsBtnO.isSelected = false
        self.IngredientsBtnO.isSelected = false
        self.DirectionsBtnO.isSelected = false
        
        self.IngredientsTblV.register(UINib(nibName: "CreateRecipeIngredientTblVCell", bundle: nil), forCellReuseIdentifier: "CreateRecipeIngredientTblVCell")
        self.IngredientsTblV.delegate = self
        self.IngredientsTblV.dataSource = self
        
        self.DirectionsTblV.register(UINib(nibName: "CreateRecipeTblVCell", bundle: nil), forCellReuseIdentifier: "CreateRecipeTblVCell")
        self.DirectionsTblV.delegate = self
        self.DirectionsTblV.dataSource = self
        
        IngredientsTblV.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        DirectionsTblV.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        
    //    self.getProductsData()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize" {
            if let tableView = object as? UITableView {
                if tableView == IngredientsTblV {
                    IngredientsTblVH.constant = tableView.contentSize.height
                } else if tableView == DirectionsTblV {
                    DirectionsTblVH.constant = tableView.contentSize.height
                }
                view.layoutIfNeeded()
            }
        }
    }


 deinit {
    // Remove observers
    IngredientsTblV.removeObserver(self, forKeyPath: "contentSize")
     DirectionsTblV.removeObserver(self, forKeyPath: "contentSize")
}
    
    @IBAction func BackBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func RemoveFromBsktBtn(_ sender: UIButton) {
        self.removeTag = 1
        self.Api_To_Plus_Minus_ServesCount(FoodID: self.food_idStr, Quanty: "0")
    }
    
    
    @IBAction func DetailsBtn(_ sender: UIButton) {
        if DirectionsBtnO.isSelected == true {
            DirectionsBtnO.isSelected = false
            self.DetailsTxtBgV.isHidden = true
            self.DetailsImgV.image = UIImage(named: "plus")
        }else{
            DirectionsBtnO.isSelected = true
            self.DetailsTxtBgV.isHidden = false
            self.DetailsImgV.image = UIImage(named: "minus")
        }
    }
    
    @IBAction func IngredientsBtn(_ sender: UIButton) {
        if IngredientsBtnO.isSelected == true {
            IngredientsBtnO.isSelected = false
            self.IngredientsBgV.isHidden = true
            self.IngredientsImgV.image = UIImage(named: "plus")
        }else{
            IngredientsBtnO.isSelected = true
            self.IngredientsBgV.isHidden = true//false
            self.IngredientsImgV.image = UIImage(named: "minus")
        }
    }
    
    @IBAction func DirectionsBtn(_ sender: UIButton) {
        if DirectionsBtnO.isSelected == true {
            DirectionsBtnO.isSelected = false
            self.DirectionsBgV.isHidden = true
            self.DirectionsImgV.image = UIImage(named: "plus")
        }else{
            DirectionsBtnO.isSelected = true
            self.DirectionsBgV.isHidden = true//false
            self.DirectionsImgV.image = UIImage(named: "minus")
        }
    }
    
    @IBAction func MinusBtn(_ sender: UIButton) {
        var count = Int(self.CountLbl.text!) ?? 1
        guard count > 1 else { return }
        count -= 1
        self.CountLbl.text = "\(count)"
        
    }
    
    
    @IBAction func PlusBtn(_ sender: UIButton) {
        var count = Int(self.CountLbl.text!) ?? 1
        count += 1
        self.CountLbl.text = "\(count)"
       
    }
    
    @IBAction func UpdateBtn(_ sender: UIButton) {
        self.Api_To_Plus_Minus_ServesCount(FoodID: self.food_idStr, Quanty: self.CountLbl.text!)
    }
    
}

extension BasketDetailVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == IngredientsTblV{
            return 5
        }else{
            return 4
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == IngredientsTblV{
            let cell = tableView.dequeueReusableCell(withIdentifier: "CreateRecipeIngredientTblVCell", for: indexPath) as! CreateRecipeIngredientTblVCell
            cell.QntTxtF.isUserInteractionEnabled = false
            cell.TxtField.isUserInteractionEnabled = false
            cell.ImgBtn.isUserInteractionEnabled = false
            cell.UnitLbl.isUserInteractionEnabled = false
            cell.DropBtn.isUserInteractionEnabled = false
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "CreateRecipeTblVCell", for: indexPath) as! CreateRecipeTblVCell
            cell.TxtField.isUserInteractionEnabled = false
            cell.TitleTxt.isUserInteractionEnabled = false
        
            return cell
        }
    }
}


extension BasketDetailVC{
    
//        func getProductsData() {
//            var params:JSONDictionary = [:]
//            
//            params["id"] = self.IDstr
//            params["query"] = self.QueryStr
//            params["food_id"] = self.food_idStr
//            params["sch_id"] = self.sch_idStr
//            
//            showIndicator(withTitle: "", and: "")
//     
//            
//            let loginURL = baseURL.baseURL + appEndPoints.get_products
//            print(params,"Params")
//            print(loginURL,"loginURL")
//            
//            
//            let token  = UserDetail.shared.getTokenWith()
//            
//            let headers: HTTPHeaders = [
//                "Authorization": "Bearer \(token)"
//            ]
//            
//            
//            WebService.shared.postServiceURLEncoding(loginURL, VC: self, andParameter: params, headers: headers, withCompletion: { (json, statusCode) in
//                
//                self.hideIndicator()
//                
//                let data = try! json.rawData()
//                do{
//                    
//                    let d = try JSONDecoder().decode(SwapModelClass.self, from: data)
//                    if d.success == true {
//                          
//                        let allData = d.data
//                        
//                        self.SwapData = allData ?? nil
//                         
//                        let img = self.SwapData?.image ?? ""
//                        let imgUrl = URL(string: img)
//
//                        self.MainImgV.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
//                        self.MainImgV.sd_setImage(with: imgUrl, placeholderImage: UIImage(named: "No_Image"))
//                         
//                        self.ItemNameLbl.text = self.SwapData?.name ?? ""
//                        self.DiscountedPriceLbl.text = self.SwapData?.formattedPrice ?? ""
//                        
//                        self.ItemQtyLbl.text = "\(self.SwapData?.unitSize ?? 0)"
//                        
//                         
//                    }else{
//                        let msg = d.message ?? ""
//                        self.showToast(msg)
//                    }
//                }catch{
//                    
//                    print(error)
//                }
//            })
//        }
    
    func Api_To_Plus_Minus_ServesCount(FoodID:String, Quanty:String){
        
        var params:JSONDictionary = [:]
        
        params["food_id"] = FoodID
        params["quantity"] = Quanty
    
        showIndicator(withTitle: "", and: "")
        
        let loginURL = baseURL.baseURL + appEndPoints.change_cart
        
        print(loginURL,"loginURL")
        
        WebService.shared.postServiceURLEncoding(loginURL, VC: self, andParameter: params, withCompletion: { (json, statusCode) in
            
            self.hideIndicator()
            
            guard let dictData = json.dictionaryObject else{
                
                return
            }
            
            if dictData["success"] as? Bool == true{
                if self.comesfrom == "TblV"{
                    let img = self.IngArrData.image ?? ""
                    let count = Int(self.CountLbl.text!) ?? 1
                    self.IngArrData.schID = count
                    self.backAction1(self.IngArrData, self.indx)
                    self.navigationController?.popViewController(animated: true)
                }else{
                    if self.removeTag == 1{
                        self.removeTag = 0
                        let data:[String: String] = ["data": "Reload"]
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "notificationName"), object: nil, userInfo: data)
                        self.navigationController?.popToViewController(ofClass: BasketDetailSuperMarketVC.self)
                    }else{
                        let count = Int(self.CountLbl.text!) ?? 1
                        self.SwapData?.sch_id = count
                        self.backAction(self.SwapData, self.indx)
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }else{
                let responseMessage = dictData["message"] as! String
                self.showToast(responseMessage)
            }
        })
    }
}
