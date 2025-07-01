//
//  YourrecipeVC.swift
//  Myka App
//
//  Created by Sumit on 15/12/24.
//

import UIKit
import Alamofire
import SDWebImage

class YourrecipeVC: UIViewController {
    
    @IBOutlet weak var BreakfastCollV: UICollectionView!
    @IBOutlet weak var LunchCollV: UICollectionView!
    @IBOutlet weak var DinnerCollV: UICollectionView!
    @IBOutlet weak var SnacksCollV: UICollectionView!
    @IBOutlet weak var TeatimeCollV: UICollectionView!
     
    @IBOutlet weak var NoOrderLbl: UILabel!
    
    @IBOutlet weak var BreakFastBgV: UIView!
    @IBOutlet weak var LunchBgV: UIView!
    @IBOutlet weak var DinnerBgV: UIView!
    @IBOutlet weak var SnacksBgV: UIView!
    @IBOutlet weak var TeatimeBgV: UIView!
    
    var AllRecipeSelItem = YourRecipeModel()
    
    var BackAction:()->() = {}
    var RemoveTag = 0

    override func viewDidLoad() {
        super.viewDidLoad()
 
        BreakfastCollV.register(UINib(nibName: "YouRecipeCollVCell", bundle: nil), forCellWithReuseIdentifier: "YouRecipeCollVCell")
        
        LunchCollV.register(UINib(nibName: "YouRecipeCollVCell", bundle: nil), forCellWithReuseIdentifier: "YouRecipeCollVCell")

        DinnerCollV.register(UINib(nibName: "YouRecipeCollVCell", bundle: nil), forCellWithReuseIdentifier: "YouRecipeCollVCell")
        
        SnacksCollV.register(UINib(nibName: "YouRecipeCollVCell", bundle: nil), forCellWithReuseIdentifier: "YouRecipeCollVCell")
        
        TeatimeCollV.register(UINib(nibName: "YouRecipeCollVCell", bundle: nil), forCellWithReuseIdentifier: "YouRecipeCollVCell")
        
        setupCollectionView(collectionView: BreakfastCollV)
        setupCollectionView(collectionView: LunchCollV)
        setupCollectionView(collectionView: DinnerCollV)
        setupCollectionView(collectionView: SnacksCollV)
        setupCollectionView(collectionView: TeatimeCollV)
        
        self.NoOrderLbl.isHidden = true
        
        self.Api_To_GetYourRecipe()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }

func setupCollectionView(collectionView: UICollectionView) {
       collectionView.delegate = self
       collectionView.dataSource = self
   }
     
    
    @IBAction func BackBtn(_ sender: UIButton) {
        if self.RemoveTag == 1{
            self.BackAction()
        }

        self.navigationController?.popViewController(animated: true)
    }
}

extension YourrecipeVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == BreakfastCollV{
            return self.AllRecipeSelItem.breakfast?.count ?? 0
        }else if collectionView == LunchCollV{
            return self.AllRecipeSelItem.lunch?.count ?? 0
        }else if collectionView == DinnerCollV{
            return self.AllRecipeSelItem.dinner?.count ?? 0
        }else if collectionView == SnacksCollV{
            return self.AllRecipeSelItem.snacks?.count ?? 0
        }else{
            return self.AllRecipeSelItem.Teatime?.count ?? 0
       }
       }
       
       func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
           
           if collectionView == BreakfastCollV{
               let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "YouRecipeCollVCell", for: indexPath) as! YouRecipeCollVCell
               
               cell.Namelbl.text =  self.AllRecipeSelItem.breakfast?[indexPath.item].data?.recipe?.label ?? ""
           //    cell.PriceLbl.text = ""
               let img = self.AllRecipeSelItem.breakfast?[indexPath.item].data?.recipe?.images?.small?.url ?? ""
               let ImgUrl = URL(string: img)
               cell.Img.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
               cell.Img.sd_setImage(with: ImgUrl, placeholderImage: UIImage(named: "No_Image"))
               
               cell.ServCountLbl.text = "Serves \(self.AllRecipeSelItem.breakfast?[indexPath.item].serving ?? "1")"
                
               cell.RemoveBtn.tag = indexPath.item
               cell.RemoveBtn.addTarget(self, action: #selector(BreakFastremoveBtnClick(_:)), for: .touchUpInside)
               
               cell.MinusBtn.tag = indexPath.row
               cell.MinusBtn.addTarget(self, action: #selector(BraekfastServCountMinusBtn(_:)), for: .touchUpInside)
               
               cell.plusBtn.tag = indexPath.row
               cell.plusBtn.addTarget(self, action: #selector(BreakfastServCountPlusBtn(_:)), for: .touchUpInside)
               
               return cell
           }else if collectionView == LunchCollV{
               let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "YouRecipeCollVCell", for: indexPath) as! YouRecipeCollVCell
               
               cell.Namelbl.text =  self.AllRecipeSelItem.lunch?[indexPath.item].data?.recipe?.label ?? ""
           //    cell.PriceLbl.text = ""
               let img = self.AllRecipeSelItem.lunch?[indexPath.item].data?.recipe?.images?.small?.url ?? ""
               let ImgUrl = URL(string: img)
               cell.Img.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
               cell.Img.sd_setImage(with: ImgUrl, placeholderImage: UIImage(named: "No_Image"))
               
               cell.ServCountLbl.text = "Serves \(self.AllRecipeSelItem.lunch?[indexPath.item].serving ?? "1")"
                
               cell.RemoveBtn.tag = indexPath.item
               cell.RemoveBtn.addTarget(self, action: #selector(LunchremoveBtnClick(_:)), for: .touchUpInside)
               
               cell.MinusBtn.tag = indexPath.row
               cell.MinusBtn.addTarget(self, action: #selector(LunchServCountMinusBtn(_:)), for: .touchUpInside)
               
               cell.plusBtn.tag = indexPath.row
               cell.plusBtn.addTarget(self, action: #selector(LunchServCountPlusBtn(_:)), for: .touchUpInside)
               
               return cell
           }else if collectionView == DinnerCollV{
               let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "YouRecipeCollVCell", for: indexPath) as! YouRecipeCollVCell
               
               cell.Namelbl.text =  self.AllRecipeSelItem.dinner?[indexPath.item].data?.recipe?.label ?? ""
           //    cell.PriceLbl.text = ""
               let img = self.AllRecipeSelItem.dinner?[indexPath.item].data?.recipe?.images?.small?.url ?? ""
               let ImgUrl = URL(string: img)
               cell.Img.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
               cell.Img.sd_setImage(with: ImgUrl, placeholderImage: UIImage(named: "No_Image"))
               
               cell.ServCountLbl.text = "Serves \(self.AllRecipeSelItem.dinner?[indexPath.item].serving ?? "1")"
                
               cell.RemoveBtn.tag = indexPath.item
               cell.RemoveBtn.addTarget(self, action: #selector(DinnerremoveBtnClick(_:)), for: .touchUpInside)
               
               cell.MinusBtn.tag = indexPath.row
               cell.MinusBtn.addTarget(self, action: #selector(DinnerServCountMinusBtn(_:)), for: .touchUpInside)
               
               cell.plusBtn.tag = indexPath.row
               cell.plusBtn.addTarget(self, action: #selector(DinnerServCountPlusBtn(_:)), for: .touchUpInside)
               
               return cell
           }else if collectionView == SnacksCollV{
               let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "YouRecipeCollVCell", for: indexPath) as! YouRecipeCollVCell
               
               cell.Namelbl.text =  self.AllRecipeSelItem.snacks?[indexPath.item].data?.recipe?.label ?? ""
           //    cell.PriceLbl.text = ""
               let img = self.AllRecipeSelItem.snacks?[indexPath.item].data?.recipe?.images?.small?.url ?? ""
               let ImgUrl = URL(string: img)
               cell.Img.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
               cell.Img.sd_setImage(with: ImgUrl, placeholderImage: UIImage(named: "No_Image"))
               
               cell.ServCountLbl.text = "Serves \(self.AllRecipeSelItem.snacks?[indexPath.item].serving ?? "1")"
                
               cell.RemoveBtn.tag = indexPath.item
               cell.RemoveBtn.addTarget(self, action: #selector(SnacksremoveBtnClick(_:)), for: .touchUpInside)
               
               cell.MinusBtn.tag = indexPath.row
               cell.MinusBtn.addTarget(self, action: #selector(SnacksServCountMinusBtn(_:)), for: .touchUpInside)
               
               cell.plusBtn.tag = indexPath.row
               cell.plusBtn.addTarget(self, action: #selector(SnacksServCountPlusBtn(_:)), for: .touchUpInside)
               
               return cell
           }else{
               let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "YouRecipeCollVCell", for: indexPath) as! YouRecipeCollVCell
               
               cell.Namelbl.text =  self.AllRecipeSelItem.Teatime?[indexPath.item].data?.recipe?.label ?? ""
           //    cell.PriceLbl.text = ""
               let img = self.AllRecipeSelItem.Teatime?[indexPath.item].data?.recipe?.images?.small?.url ?? ""
               let ImgUrl = URL(string: img)
               cell.Img.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
               cell.Img.sd_setImage(with: ImgUrl, placeholderImage: UIImage(named: "No_Image"))
               
               cell.ServCountLbl.text = "Serves \(self.AllRecipeSelItem.Teatime?[indexPath.item].serving ?? "1")"
                
               cell.RemoveBtn.tag = indexPath.item
               cell.RemoveBtn.addTarget(self, action: #selector(TeaTimeremoveBtnClick(_:)), for: .touchUpInside)
               
               cell.MinusBtn.tag = indexPath.row
               cell.MinusBtn.addTarget(self, action: #selector(TeatimeServCountMinusBtn(_:)), for: .touchUpInside)
               
               cell.plusBtn.tag = indexPath.row
               cell.plusBtn.addTarget(self, action: #selector(TeatimeServCountPlusBtn(_:)), for: .touchUpInside)
               
               return cell
           }
        }
    
    @objc func BraekfastServCountMinusBtn(_ sender: UIButton) {
        var ServCount = Int(self.AllRecipeSelItem.breakfast?[sender.tag].serving ?? "1") ?? 1
        guard ServCount > 1 else{
            return
        }
         ServCount -= 1
        self.AllRecipeSelItem.breakfast?[sender.tag].serving = "\(ServCount)"
        self.TeatimeCollV.reloadData()
         
        let uri = self.AllRecipeSelItem.breakfast?[sender.tag].uri ?? ""
        self.Api_To_Plus_Minus_ServesCount(uri: uri, Quenty: "\(ServCount)", type: "Breakfast")
    }
    
    @objc func BreakfastServCountPlusBtn(_ sender: UIButton) {
        var ServCount = Int(self.AllRecipeSelItem.breakfast?[sender.tag].serving ?? "1") ?? 1
         ServCount += 1
        self.AllRecipeSelItem.breakfast?[sender.tag].serving = "\(ServCount)"
        self.TeatimeCollV.reloadData()
        
        let uri = self.AllRecipeSelItem.breakfast?[sender.tag].uri ?? ""
        self.Api_To_Plus_Minus_ServesCount(uri: uri, Quenty: "\(ServCount)", type: "Breakfast")
    }
    
    @objc func LunchServCountMinusBtn(_ sender: UIButton) {
        var ServCount = Int(self.AllRecipeSelItem.lunch?[sender.tag].serving ?? "1") ?? 1
        guard ServCount > 1 else{
            return
        }
         ServCount -= 1
        self.AllRecipeSelItem.lunch?[sender.tag].serving = "\(ServCount)"
        self.TeatimeCollV.reloadData()
         
        let uri = self.AllRecipeSelItem.lunch?[sender.tag].uri ?? ""
        self.Api_To_Plus_Minus_ServesCount(uri: uri, Quenty: "\(ServCount)", type: "Lunch")
    }
    
    @objc func LunchServCountPlusBtn(_ sender: UIButton) {
        var ServCount = Int(self.AllRecipeSelItem.lunch?[sender.tag].serving ?? "1") ?? 1
         ServCount += 1
        self.AllRecipeSelItem.lunch?[sender.tag].serving = "\(ServCount)"
        self.TeatimeCollV.reloadData()
        
        let uri = self.AllRecipeSelItem.lunch?[sender.tag].uri ?? ""
        self.Api_To_Plus_Minus_ServesCount(uri: uri, Quenty: "\(ServCount)", type: "Lunch")
    }
    
    @objc func DinnerServCountMinusBtn(_ sender: UIButton) {
        var ServCount = Int(self.AllRecipeSelItem.dinner?[sender.tag].serving ?? "1") ?? 1
        guard ServCount > 1 else{
            return
        }
        
         ServCount -= 1
        self.AllRecipeSelItem.dinner?[sender.tag].serving = "\(ServCount)"
        self.TeatimeCollV.reloadData()
        
        let uri = self.AllRecipeSelItem.dinner?[sender.tag].uri ?? ""
        self.Api_To_Plus_Minus_ServesCount(uri: uri, Quenty: "\(ServCount)", type: "Dinner")
    }
    
    @objc func DinnerServCountPlusBtn(_ sender: UIButton) {
        var ServCount = Int(self.AllRecipeSelItem.dinner?[sender.tag].serving ?? "1") ?? 1
         ServCount += 1
        self.AllRecipeSelItem.dinner?[sender.tag].serving = "\(ServCount)"
        self.TeatimeCollV.reloadData()
        
        let uri = self.AllRecipeSelItem.dinner?[sender.tag].uri ?? ""
        self.Api_To_Plus_Minus_ServesCount(uri: uri, Quenty: "\(ServCount)", type: "Dinner")
    }
    
    @objc func SnacksServCountMinusBtn(_ sender: UIButton) {
        var ServCount = Int(self.AllRecipeSelItem.snacks?[sender.tag].serving ?? "1") ?? 1
        guard ServCount > 1 else{
            return
        }
         ServCount -= 1
        self.AllRecipeSelItem.snacks?[sender.tag].serving = "\(ServCount)"
        self.SnacksCollV.reloadData()
         
        let uri = self.AllRecipeSelItem.snacks?[sender.tag].uri ?? ""
        self.Api_To_Plus_Minus_ServesCount(uri: uri, Quenty: "\(ServCount)", type: "Snacks")
    }
    
    @objc func SnacksServCountPlusBtn(_ sender: UIButton) {
        var ServCount = Int(self.AllRecipeSelItem.snacks?[sender.tag].serving ?? "1") ?? 1
         ServCount += 1
        self.AllRecipeSelItem.snacks?[sender.tag].serving = "\(ServCount)"
        self.SnacksCollV.reloadData()
        
        let uri = self.AllRecipeSelItem.snacks?[sender.tag].uri ?? ""
        self.Api_To_Plus_Minus_ServesCount(uri: uri, Quenty: "\(ServCount)", type: "Snacks")
    }
    
    @objc func TeatimeServCountMinusBtn(_ sender: UIButton) {
        var ServCount = Int(self.AllRecipeSelItem.Teatime?[sender.tag].serving ?? "1") ?? 1
        guard ServCount > 1 else{
            return
        }
         ServCount -= 1
        self.AllRecipeSelItem.Teatime?[sender.tag].serving = "\(ServCount)"
        self.TeatimeCollV.reloadData()
        
        let uri = self.AllRecipeSelItem.Teatime?[sender.tag].uri ?? ""
        self.Api_To_Plus_Minus_ServesCount(uri: uri, Quenty: "\(ServCount)", type: "Brunch")
    }
    
    @objc func TeatimeServCountPlusBtn(_ sender: UIButton) {
        var ServCount = Int(self.AllRecipeSelItem.Teatime?[sender.tag].serving ?? "1") ?? 1
         ServCount += 1
        self.AllRecipeSelItem.Teatime?[sender.tag].serving = "\(ServCount)"
        self.TeatimeCollV.reloadData()
        
        let uri = self.AllRecipeSelItem.Teatime?[sender.tag].uri ?? ""
        self.Api_To_Plus_Minus_ServesCount(uri: uri, Quenty: "\(ServCount)", type: "Brunch")
    }
    
    
    
    @objc func BreakFastremoveBtnClick(_ sender: UIButton)   {
        let id = self.AllRecipeSelItem.breakfast?[sender.tag].basketID ?? 0
        removeBtnClick(id: "\(id)", type: "Breakfast", indx: sender.tag)
    }
    
    @objc func LunchremoveBtnClick(_ sender: UIButton)   {
        let id = self.AllRecipeSelItem.lunch?[sender.tag].basketID ?? 0
        removeBtnClick(id: "\(id)", type: "Lunch", indx: sender.tag)
    }
    
    @objc func DinnerremoveBtnClick(_ sender: UIButton)   {
        let id = self.AllRecipeSelItem.dinner?[sender.tag].basketID ?? 0
        removeBtnClick(id: "\(id)", type: "Dinner", indx: sender.tag)
    }
    
    @objc func SnacksremoveBtnClick(_ sender: UIButton)   {
        let id = self.AllRecipeSelItem.snacks?[sender.tag].basketID ?? 0
        removeBtnClick(id: "\(id)", type: "Snacks", indx: sender.tag)
    }
    
    @objc func TeaTimeremoveBtnClick(_ sender: UIButton)   {
        let id = self.AllRecipeSelItem.Teatime?[sender.tag].basketID ?? 0
        removeBtnClick(id: "\(id)", type: "Teatime", indx: sender.tag)
    }
    
    func removeBtnClick(id: String, type: String, indx: Int){
        let storyboard = UIStoryboard(name: "Basket", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "RemoveFromBaskedPopUpVC") as! RemoveFromBaskedPopUpVC
        vc.ID = id
        vc.backAction = { id in
            self.Api_To_RemoveRecipes(Id:id, type: type, index: indx)
        }
        self.addChild(vc)
        vc.view.frame = self.view.frame
        self.view.addSubview(vc.view)
        self.view.bringSubviewToFront(vc.view)
        vc.didMove(toParent: self)
        }
    
 
        
       
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var URI: String = ""
        var MealType: String = ""
        
        if collectionView == BreakfastCollV{
            URI = self.AllRecipeSelItem.breakfast?[indexPath.item].uri ?? ""
            MealType = self.AllRecipeSelItem.breakfast?[indexPath.row].data?.recipe?.mealType?.first ?? ""
        }else if collectionView == LunchCollV{
            URI = self.AllRecipeSelItem.lunch?[indexPath.item].uri ?? ""
            MealType = self.AllRecipeSelItem.lunch?[indexPath.row].data?.recipe?.mealType?.first ?? ""
        }else if collectionView == DinnerCollV{
            URI = self.AllRecipeSelItem.dinner?[indexPath.item].uri ?? ""
            MealType = self.AllRecipeSelItem.dinner?[indexPath.row].data?.recipe?.mealType?.first ?? ""
        }else if collectionView == SnacksCollV{
            URI = self.AllRecipeSelItem.snacks?[indexPath.item].uri ?? ""
            MealType = self.AllRecipeSelItem.snacks?[indexPath.row].data?.recipe?.mealType?.first ?? ""
        }else{
            URI = self.AllRecipeSelItem.Teatime?[indexPath.item].uri ?? ""
            MealType = self.AllRecipeSelItem.Teatime?[indexPath.row].data?.recipe?.mealType?.first ?? ""
        }
        
        let storyboard = UIStoryboard(name: "Tabbar", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "RecipeDetailsVC") as! RecipeDetailsVC
        vc.uri = URI
        let string = MealType
        if let result = string.components(separatedBy: "/").first {
            vc.MealType = result
        }
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
 
       func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
           let itemCount: Int
              switch collectionView {
              case BreakfastCollV:
                  itemCount = self.AllRecipeSelItem.breakfast?.count ?? 0
                  break;
              case LunchCollV:
                  itemCount = self.AllRecipeSelItem.lunch?.count ?? 0
                  break;
              case DinnerCollV:
                  itemCount = self.AllRecipeSelItem.dinner?.count ?? 0
                  break;
              case SnacksCollV:
                  itemCount = self.AllRecipeSelItem.snacks?.count ?? 0
                  break;
              case TeatimeCollV:
                  itemCount = self.AllRecipeSelItem.Teatime?.count ?? 0
                  break;
              default: // Teatime
                  itemCount = 0
                  break;
              }

           // Calculate the cell size
             let width: CGFloat = itemCount > 2 ? collectionView.frame.width / 2.3 - 5 : collectionView.frame.width / 2 - 15
             let height: CGFloat = collectionView.frame.height
             
             return CGSize(width: width, height: height)
       }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
     
            return 5
        }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            if section == 0 {
                return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 5)
            }else{
                return UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
            }
        }
   
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 5
        }
     }

extension YourrecipeVC {
    func Api_To_GetYourRecipe(){
        var params = [String: Any]()
        
        
        
        showIndicator(withTitle: "", and: "")
        
        let loginURL = baseURL.baseURL + appEndPoints.your_recipe
        print(params,"Params")
        print(loginURL,"loginURL")
        
        WebService.shared.postServiceURLEncoding(loginURL, VC: self, andParameter: params, withCompletion: { (json, statusCode) in
            
            self.hideIndicator()
            
            let data = try! json.rawData()
            
            do{
                let d = try JSONDecoder().decode(YourRecipeModelClass.self, from: data)
                if d.success == true {
                    if let list = d.data {
                        self.AllRecipeSelItem = list
                        
                        self.ShowNoDataFoundonCollV()
                    }else{
                        self.ShowNoDataFoundonCollV()
                    }
               
                }else{
                    self.ShowNoDataFoundonCollV()
                    
                    let msg = d.message ?? ""
                    self.showToast(msg)
                }
            }catch{
                self.ShowNoDataFoundonCollV()
                print(error)
            }
        })
    }
        
        func ShowNoDataFoundonCollV(){
            if self.AllRecipeSelItem.breakfast?.count ?? 0 == 0{
                self.BreakFastBgV.isHidden = true
            }else{
                self.BreakFastBgV.isHidden = false
            }
            
            if self.AllRecipeSelItem.lunch?.count ?? 0 == 0{
                self.LunchBgV.isHidden = true
            }else{
                self.LunchBgV.isHidden = false
            }
            
          
            if self.AllRecipeSelItem.dinner?.count ?? 0 == 0{
                self.DinnerBgV.isHidden = true
            }else{
                self.DinnerBgV.isHidden = false
            }
         
            if self.AllRecipeSelItem.snacks?.count ?? 0 == 0{
                self.SnacksBgV.isHidden = true
            }else{
                self.SnacksBgV.isHidden = false
            }
                
            if self.AllRecipeSelItem.Teatime?.count ?? 0 == 0{
                self.TeatimeBgV.isHidden = true
            }else{
                self.TeatimeBgV.isHidden = false
            }
            
            if self.AllRecipeSelItem.breakfast?.count ?? 0 == 0 && self.AllRecipeSelItem.lunch?.count ?? 0 == 0 && self.AllRecipeSelItem.dinner?.count ?? 0 == 0 && self.AllRecipeSelItem.snacks?.count ?? 0 == 0 && self.AllRecipeSelItem.Teatime?.count ?? 0 == 0{
                self.NoOrderLbl.isHidden = false
            }else{
                self.NoOrderLbl.isHidden = true
            }
            
            self.BreakfastCollV.reloadData()
            self.LunchCollV.reloadData()
            self.DinnerCollV.reloadData()
            self.SnacksCollV.reloadData()
            self.TeatimeCollV.reloadData()
        }
    
    func Api_To_Plus_Minus_ServesCount(uri:String, Quenty:String, type:String){
        
        var params:JSONDictionary = [:]
        
        params["uri"] = uri
        params["quantity"] = Quenty
        params["type"] = type
        
        showIndicator(withTitle: "", and: "")
        
        let loginURL = baseURL.baseURL + appEndPoints.add_to_basket
        
        print(loginURL,"loginURL")
        
        WebService.shared.postServiceURLEncoding(loginURL, VC: self, andParameter: params, withCompletion: { (json, statusCode) in
            
            self.hideIndicator()
            
            guard let dictData = json.dictionaryObject else{
                
                return
            }
            
            if dictData["success"] as? Bool == true{
                self.Api_To_GetYourRecipe()
            }else{
                let responseMessage = dictData["message"] as! String
                self.showToast(responseMessage)
            }
        })
    }
    
    func Api_To_RemoveRecipes(Id:String, type: String, index: Int){
        
        var params:JSONDictionary = [:]
        
        params["id"] = Id
         
   
        showIndicator(withTitle: "", and: "")
        
        let loginURL = baseURL.baseURL + appEndPoints.remove_basket
        
        print(loginURL,"loginURL")
        
        WebService.shared.postServiceURLEncoding(loginURL, VC: self, andParameter: params, withCompletion: { (json, statusCode) in
            
            self.hideIndicator()
            
            guard let dictData = json.dictionaryObject else{
                
                return
            }
            
            if dictData["success"] as? Bool == true{
                self.RemoveTag = 1
                self.removeSelectedCellData(type: type, index: index)
            }else{
                let responseMessage = dictData["message"] as! String
                self.showToast(responseMessage)
            }
        })
    }
    
    func removeSelectedCellData(type: String, index: Int) {
        if type == "Breakfast"{
            self.AllRecipeSelItem.breakfast?.remove(at: index)
        }else if type == "Lunch"{
            self.AllRecipeSelItem.lunch?.remove(at: index)
        }else if type == "Dinner"{
            self.AllRecipeSelItem.dinner?.remove(at: index)
        }else if type == "Snacks"{
            self.AllRecipeSelItem.snacks?.remove(at: index)
        }else{
            self.AllRecipeSelItem.Teatime?.remove(at: index)
        }
        
        ShowNoDataFoundonCollV()
    }
}
