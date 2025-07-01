//
//  CookBooksVC.swift
//  Myka App
//
//  Created by Sumit on 15/12/24.
//

import UIKit
import DropDown
import Alamofire
import SDWebImage

struct CookBooksModle {
    var name: String
    var image: String
}

class CookBooksVC: UIViewController {
    
    @IBOutlet weak var TitleLbl: UILabel!
    @IBOutlet weak var TopCollV: UICollectionView!
    @IBOutlet weak var BottomCollV: UICollectionView!
    @IBOutlet var RemoveBgV: UIView!
   
    
    // Move PopUp view.
    @IBOutlet var MoveBgV: UIView!
    @IBOutlet weak var MoveDropLbl: UITextField!
    //
    
    // Disable PopUp view.
    @IBOutlet var DisableBgV: UIView!
    
    
    var CelldropDownData = [DropDownModule(name: "Remove Recipe", image: "Group 1171276393"),DropDownModule(name: "Move Recipe", image: "Group 1171275890")]
    
    let dropDown = DropDown()
    let CelldropDown = DropDown()
    
    var cookBooksData = [FavDropDownModel]()
    
    
    var type = "0"
    var selectedCookBook = ""
    
    
    var favCookBookDataArr = [Datum]()
    
    var selID = ""
    var uri = ""
    
    var cookbookID = ""
    
    var SelIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.RemoveBgV.frame = self.view.bounds
        self.view.addSubview(RemoveBgV)
        self.RemoveBgV.isHidden = true
        
        self.MoveBgV.frame = self.view.bounds
        self.view.addSubview(MoveBgV)
        self.MoveBgV.isHidden = true
        
        let topSpace: CGFloat = 100
        self.DisableBgV.frame = CGRect(x: 0, y: topSpace, width: self.view.bounds.width, height: self.view.bounds.height - topSpace)
        self.view.addSubview(DisableBgV)
        self.DisableBgV.isHidden = true
        
        
        
        TopCollV.register(UINib(nibName: "ingredientsCollVCell", bundle: nil), forCellWithReuseIdentifier: "ingredientsCollVCell")
        TopCollV.delegate = self
        TopCollV.dataSource = self
        
        BottomCollV.register(UINib(nibName: "CookBooksCollVCell", bundle: nil), forCellWithReuseIdentifier: "CookBooksCollVCell")
        BottomCollV.delegate = self
        BottomCollV.dataSource = self
         
        
        self.Api_To_GetAllCookBooks()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        let SubscriptionStatus = Int(UserDetail.shared.getSubscriptionStatus())
//        
//        if SubscriptionStatus == 0{
//            self.DisableBgV.isHidden = true
//        }
         
        
    }
    
//    @IBAction func DisableVBtn(_ sender: UIButton) {
//        SubscriptionPopUp()
//    }
    
    func SubscriptionPopUp()  {
        let storyboard = UIStoryboard(name: "Subscription", bundle: nil)
        
        let vc = storyboard.instantiateViewController(withIdentifier: "SubscriptionPopUpVC") as! SubscriptionPopUpVC
        vc.BackAction = {
            let storyboard = UIStoryboard(name: "Subscription", bundle: nil)
            
            let vc = storyboard.instantiateViewController(withIdentifier: "BupPlanVC") as! BupPlanVC
            vc.comesfrom = "Profile"
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        self.addChild(vc)
        vc.view.frame = self.view.frame
        self.view.addSubview(vc.view)
        self.view.bringSubviewToFront(vc.view)
        vc.didMove(toParent: self)
    }
    
    @IBAction func BackBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func AddRecipeBtn(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Tabbar", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "CreateRecipeVC") as! CreateRecipeVC
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // remove popup btns
    @IBAction func CancelBtn(_ sender: UIButton) {
        self.RemoveBgV.isHidden = true
    }
    
    @IBAction func RemoveBtn(_ sender: UIButton) {
        self.Api_To_RemoveFavMeal()
    }
    
    //
    
    // remove popup btns
    
    @IBAction func MoveDropBtn(_ sender: UIButton) {
        var cookBooksData1 = self.cookBooksData
        cookBooksData1.remove(at: 0)
        cookBooksData1.remove(at: 0)
        
        
        CelldropDown.dataSource = cookBooksData1.map { $0.name ?? "" }
        CelldropDown.anchorView = sender
        CelldropDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height)
        CelldropDown.show()
        CelldropDown.setupCornerRadius(10)
        CelldropDown.backgroundColor = .white
        CelldropDown.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        CelldropDown.layer.shadowOpacity = 0
        CelldropDown.layer.shadowRadius = 4
        CelldropDown.layer.shadowOffset = CGSize(width: 0, height: 0)
        CelldropDown.selectionAction = { [self] (index: Int, item: String) in
            self.MoveDropLbl.text = item
            print(index)
            self.selID = "\(favCookBookDataArr[sender.tag].id ?? 0)"
            self.cookbookID = "\(cookBooksData1[index].id ?? 0)"
        }
    }
    
    @IBAction func CrossBtn(_ sender: UIButton) {
        self.MoveBgV.isHidden = true
    }
    
    @IBAction func MoveBtn(_ sender: UIButton) {
        guard self.cookbookID != "" else {
            AlertControllerOnr(title: "", message: "Please select a cookbook.")
            return
        }
        self.Api_To_MoveMeal()
    }
    
    //
}

extension CookBooksVC: UICollectionViewDelegate, UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout{
    
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            if collectionView == TopCollV{
                return cookBooksData.count
            }else{
                return favCookBookDataArr.count
            }
        }
    
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            if collectionView == TopCollV{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ingredientsCollVCell", for: indexPath) as! ingredientsCollVCell
                
                cell.NameLbl.text = cookBooksData[indexPath.row].name
                
                cell.Img.layer.cornerRadius = cell.Img.frame.height/2
                cell.Img.layer.masksToBounds = true
                
                if indexPath.row == 0{
                    cell.Img.image = UIImage(named: "add 1")
                }else if indexPath.row == 1{
                    cell.Img.image = UIImage(named: "Fav")
                    cell.bgV.layer.borderWidth = 1
                    cell.bgV.layer.borderColor = UIColor(red: 6/255, green: 193/255, blue: 105/255, alpha: 1).cgColor
                }else{
                    let imgUrl = cookBooksData[indexPath.row].image ?? ""
                    cell.Img.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
                    cell.Img.sd_setImage(with: URL(string: baseURL.imageUrl + imgUrl), placeholderImage: UIImage(named: "No_Image"))
                    cell.bgV.layer.borderWidth = 1
                    cell.bgV.layer.borderColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1).cgColor
                }
                return cell
            }else{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CookBooksCollVCell", for: indexPath) as! CookBooksCollVCell
                let data = favCookBookDataArr[indexPath.row].data?.recipe
                cell.NameLbl.text = data?.label
                cell.TimeLbl.text = "\(data?.totalTime ?? 0) min"
                let imgUrl =  data?.images?.small?.url ?? ""
                cell.img.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
                cell.img.sd_setImage(with: URL(string: imgUrl), placeholderImage: UIImage(named: "No_Image"))
                
                cell.DotBtn.tag = indexPath.row
                cell.DotBtn.addTarget(self, action: #selector(OptnsBtnTapped), for: .touchUpInside)
                
                cell.AddToPlanBtn.tag = indexPath.row
                cell.AddToPlanBtn.addTarget(self, action: #selector(AddToPlanBtnTapped), for: .touchUpInside)
                
                cell.CartBtn.tag = indexPath.row
                cell.CartBtn.addTarget(self, action: #selector(AddtoBasketBtnClick), for: .touchUpInside)
                
                
                return cell
            }
        }
    
    @objc func OptnsBtnTapped(sender: UIButton){
        dropDown.dataSource = self.CelldropDownData.map { $0.name }
          dropDown.anchorView = sender
          
          // Add trailing space (adjust x for horizontal offset)
          let trailingSpace: CGFloat = 120 // Adjust as needed
          dropDown.bottomOffset = CGPoint(x: -trailingSpace, y: sender.bounds.height)
          dropDown.topOffset = CGPoint(x: -trailingSpace, y: -(dropDown.anchorView?.plainView.bounds.height ?? 0))
          dropDown.width = 140
          dropDown.setupCornerRadius(10)
          
          // Optional: You may also need to disable shadow for proper clipping
          dropDown.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
          dropDown.layer.shadowOpacity = 0
          dropDown.layer.shadowRadius = 4
          dropDown.layer.shadowOffset = CGSize(width: 0, height: 0)
          dropDown.backgroundColor = .white
          dropDown.cellHeight = 35
          dropDown.textFont = UIFont.systemFont(ofSize: 11)

          // Use custom cell configuration
          dropDown.cellNib = UINib(nibName: "CustomDropDownCell", bundle: nil)
          dropDown.customCellConfiguration = { [weak self] (index: Index, item: String, cell: DropDownCell) in
              guard let cell = cell as? CustomDropDownCell else { return }
              guard let self = self else { return }
              let img = self.CelldropDownData[index].image
              cell.logoImageView.image = UIImage(named: img)
          }
          
          // Handle selection
          dropDown.selectionAction = { [weak self] (index: Int, item: String) in
              guard let self = self else { return }
              print(index)
              if index == 0 {
                  self.RemoveBgV.isHidden = false
                  self.uri = favCookBookDataArr[sender.tag].uri ?? ""
                  self.selID = "\(favCookBookDataArr[sender.tag].id ?? 0)"
                  self.SelIndex = sender.tag
              }else{
                  self.MoveBgV.isHidden = false
              }
          }
          
          dropDown.show()

    }
 
    @objc func AddtoBasketBtnClick(_ sender: UIButton)   {
        let data = favCookBookDataArr[sender.tag].data?.recipe
       
        guard data?.label != nil else {
            AlertControllerOnr(title: "", message: "You can view this recipe after 45 minutes")
            return
        }
        
        let uri = self.favCookBookDataArr[sender.tag].data?.recipe?.uri ?? ""
        
        let mealType = self.favCookBookDataArr[sender.tag].data?.recipe?.mealType?.first ?? ""

        let Type = mealType.components(separatedBy: "/").first ?? ""
        self.Api_To_AddToBasket_Recipe(uri: uri, type: Type)
        }
    
    @objc func AddToPlanBtnTapped(sender: UIButton){
        let uri = favCookBookDataArr[sender.tag].data?.recipe?.uri ?? ""
        
        let data = favCookBookDataArr[sender.tag].data?.recipe
       
        guard data?.label != nil else {
            AlertControllerOnr(title: "", message: "You can view this recipe after 45 minutes")
            return
        }
        
       // let Type = favCookBookDataArr[sender.tag].data?.recipe?.mealType?[0] ?? ""
       // let type = Type.prefix(while: { $0 != "/" })
        let SubscriptionStatus = Int(UserDetail.shared.getSubscriptionStatus())
        
        if SubscriptionStatus == 1{
            let addtoplanStatus = Int(UserDetail.shared.getaddmeal()) ?? 0
            guard addtoplanStatus == 0 else {
                SubscriptionPopUp ()
                return
            }
        }
        
        
        let storyboard = UIStoryboard(name: "RestScreens", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ChooseDaysVC") as! ChooseDaysVC
        vc.backActionCookbook = { Date in
            let storyboard = UIStoryboard(name: "RestScreens", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "ChooseMealTypeVC") as! ChooseMealTypeVC
            vc.SelDateArray = Date
            vc.uri = uri
            //vc.type = "\(type)"
            self.addChild(vc)
            vc.view.frame = self.view.frame
            self.view.addSubview(vc.view)
            self.view.bringSubviewToFront(vc.view)
            vc.didMove(toParent: self)
        }
        self.addChild(vc)
        vc.view.frame = self.view.frame
        self.view.addSubview(vc.view)
        self.view.bringSubviewToFront(vc.view)
        vc.didMove(toParent: self)
    }
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            
            if collectionView == TopCollV{
                if indexPath.row == 0{
                    let storyboard = UIStoryboard(name: "Fav", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "CreateCookbookVC") as! CreateCookbookVC
                    vc.comesfrom = "Cookbooks"
                    vc.ReloadBackAction = { [weak self] in
                        self?.Api_To_GetAllCookBooks()
                    }
                   
                    navigationController?.pushViewController(vc, animated: true)
                }else if indexPath.row != 0 && indexPath.row != 1{
                    var cookBooksData1 = self.cookBooksData
                    let selid = cookBooksData[indexPath.row].id ?? 0
                    cookBooksData1.remove(at: 0)
                    cookBooksData1.removeAll(where: {$0.id == selid})
                    
                    let Status = cookBooksData[indexPath.row].status ?? 1
                   // cookBooksData1.firstIndex(where: {$0.id == selid})
                    showIndicator(withTitle: "", and: "")
                    let storyboard = UIStoryboard(name: "RestScreens", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "CookBooksTypeVc") as! CookBooksTypeVc
                    vc.EditcookBooksData = cookBooksData[indexPath.row]
                    vc.DropcookBooksData = cookBooksData1
                    vc.titleTxt = cookBooksData[indexPath.row].name ?? ""
                    vc.type = "\(cookBooksData[indexPath.row].id ?? 0)"
                    vc.Private_PublicStatus = Status
                    
                    vc.backAction = { 
                        self.Api_To_GetAllCookBooks()
                    }
                 //   let cell = collectionView.cellForItem(at: indexPath) as? ingredientsCollVCell
                    
                    if let img = cookBooksData[indexPath.row].image,
                       let imgUrl = URL(string: baseURL.imageUrl + img) {
                        URLSession.shared.dataTask(with: imgUrl) { data, response, error in
                            if let data = data, let image = UIImage(data: data) {
                                DispatchQueue.main.async {
                                    let imgdata = image.pngData()
                                    let Fimage = UIImage(data: imgdata ?? Data())
                                    vc.cookBookImg = Fimage
                                    // Trigger any UI updates if needed, e.g., push to another view controller
                                    self.hideIndicator()
                                    vc.hidesBottomBarWhenPushed = true
                                    self.navigationController?.pushViewController(vc, animated: true)
                                }
                            } else {
                                print("Failed to load image: \(error?.localizedDescription ?? "Unknown error")")
                                self.showToast("Failed to load image")
                            }
                        }.resume()
                    } else {
                        print("Invalid image URL or image data")
                        showToast("Invalid image URL or image data")
                    }
                    
//                    let img = cookBooksData[indexPath.row].image ?? ""
//                    let imgUrl = URL(string: baseURL.imageUrl + img)
//                    let imgData = try? Data(contentsOf: imgUrl!)
//                    vc.cookBookImg = UIImage(data: imgData!)!
                   // vc.hidesBottomBarWhenPushed = true
                  //  navigationController?.pushViewController(vc, animated: true)
                }
            }else{
                let data = favCookBookDataArr[indexPath.row].data?.recipe
               
                guard data?.label != nil else {
                    AlertControllerOnr(title: "", message: "You can view this recipe after 45 minutes")
                    return
                }
                    
                let storyboard = UIStoryboard(name: "Tabbar", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "RecipeDetailsVC") as! RecipeDetailsVC
                let Type = favCookBookDataArr[indexPath.row].data?.recipe?.mealType?[0] ?? ""
                let type = Type.prefix(while: { $0 != "/" })
                vc.MealType = "\(type)"
                vc.uri = favCookBookDataArr[indexPath.row].data?.recipe?.uri ?? ""
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
     
        
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            if collectionView == TopCollV{
                return CGSize(width: collectionView.frame.width/4 - 5, height: collectionView.frame.height)
            }else{
                let padding: CGFloat = 10
                let itemsPerRow: CGFloat = 2
                let totalPadding = padding * (itemsPerRow + 1)
                let availableWidth = collectionView.frame.size.width - totalPadding
                let itemWidth = availableWidth / itemsPerRow
                
                return CGSize(width: itemWidth, height: 235)
            }
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
                return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        }
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 10
    }
        
        
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
                return 10
         }
    }

//get-cook-book
extension CookBooksVC {
    func Api_To_GetAllCookBooks(){
        
        let params = [String: Any]()
        
       
        
        showIndicator(withTitle: "", and: "")
        
        let loginURL = baseURL.baseURL + appEndPoints.get_cook_book
        print(params,"Params")
        print(loginURL,"loginURL")
        
        WebService.shared.postServiceURLEncoding(loginURL, VC: self, andParameter: params, withCompletion: { (json, statusCode) in
            
            self.hideIndicator()
            
            
            let data = try! json.rawData()
            
            do{
                let d = try JSONDecoder().decode(FavDropDownModelClass.self, from: data)
                if d.success == true {
                    
                    self.cookBooksData.removeAll()
                    if let list = d.data, list.count != 0 {
                        self.cookBooksData = list
                    }
                    self.cookBooksData.insert(contentsOf: [FavDropDownModel(id: 0, userID: 0, name: "Add", image: "", status: 0, updatedAt: "", createdAt: "", deletedAt: "")], at: 0)
                    self.cookBooksData.insert(contentsOf: [FavDropDownModel(id: 0, userID: 0, name: "Favorites", image: "", status: 0, updatedAt: "", createdAt: "", deletedAt: "")], at: 1)
                    
                    self.TopCollV.reloadData()
                    self.Api_To_GetFavCookBooks()
                }else{
                    let msg = d.message ?? ""
                    self.showToast(msg)
                }
            }catch{
                print(error)
            }
        })
    }
    
    func Api_To_GetFavCookBooks(){
        var params = [String: Any]()
        params["type"] = "0"
       
        
        showIndicator(withTitle: "", and: "")
        
        let loginURL = baseURL.baseURL + appEndPoints.cook_book_type_list
        print(params,"Params")
        print(loginURL,"loginURL")
        
        WebService.shared.postServiceURLEncoding(loginURL, VC: self, andParameter: params, withCompletion: { (json, statusCode) in
            
            self.hideIndicator()
            
            
            let data = try! json.rawData()
            
            do{
                let d = try JSONDecoder().decode(CookBookTypeModel.self, from: data)
                if d.success == true {

                    self.favCookBookDataArr.removeAll()
                    self.favCookBookDataArr = d.data ?? []
                    if self.favCookBookDataArr.count == 0 {
                        self.BottomCollV.setEmptyMessage("No recipe yet", UIImage())
                    }else{
                        self.BottomCollV.setEmptyMessage("", UIImage())
                    }
                    
                    self.BottomCollV.reloadData()
                }else{
                    let msg = d.message ?? ""
                    self.showToast(msg)
                }
            }catch{
                print(error)
            }
        })
    }
    
    func Api_To_RemoveFavMeal(){
        var params = [String: Any]()
 
        params["uri"] = self.uri
        params["type"] = 0
        params["cook_book"] = self.selID
          
      
        showIndicator(withTitle: "", and: "")
        
        let loginURL = baseURL.baseURL + appEndPoints.add_to_favorite
        print(params,"Params")
        print(loginURL,"loginURL")
        
        WebService.shared.postServiceURLEncoding(loginURL, VC: self, andParameter: params, withCompletion: { (json, statusCode) in
            
            self.hideIndicator()
            
            guard let dictData = json.dictionaryObject else{
                return
            }
            
            if dictData["success"] as? Bool == true{
                let MSG = dictData["message"] as? String ?? ""
                self.showToast(MSG)
                self.RemoveBgV.isHidden = true
               // self.Api_To_GetFavCookBooks()
                self.favCookBookDataArr.remove(at: self.SelIndex)
                self.BottomCollV.reloadData()
                 
                    if self.favCookBookDataArr.count == 0 {
                        self.BottomCollV.setEmptyMessage("No recipe yet", UIImage())
                    }else{
                        self.BottomCollV.setEmptyMessage("", UIImage())
                    }
               
              
            }else{
                let responseMessage = dictData["message"] as! String
                self.showToast(responseMessage)
            }
        })
    }
    
 
    
    func Api_To_MoveMeal(){
        var params = [String: Any]()
        
        params["id"] = self.selID
        params["cook_book"] = self.cookbookID
      
        
        showIndicator(withTitle: "", and: "")
        
        let loginURL = baseURL.baseURL + appEndPoints.move_recipe
        print(params,"Params")
        print(loginURL,"loginURL")
        
        WebService.shared.postServiceURLEncoding(loginURL, VC: self, andParameter: params, withCompletion: { (json, statusCode) in
            
            self.hideIndicator()
            
            guard let dictData = json.dictionaryObject else{
                return
            }
        
            if dictData["success"] as? Bool == true{
                let MSG = dictData["message"] as? String ?? ""
                self.cookbookID = ""
                self.showToast(MSG)
                self.MoveBgV.isHidden = true
                self.Api_To_GetFavCookBooks()
               }else{
                   let responseMessage = dictData["message"] as? String ?? ""
                   self.showToast(responseMessage)
               }
          })
         }
     }




extension CookBooksVC {
    func Api_To_AddToBasket_Recipe(uri: String, type: String){
        var params = [String: Any]()
            params["uri"] = uri
            params["quantity"] = ""
            params["type"] = type
        
        
        
        showIndicator(withTitle: "", and: "")
        
        let loginURL = baseURL.baseURL + appEndPoints.add_to_basket
        print(params,"Params")
        print(loginURL,"loginURL")
        
        WebService.shared.postServiceURLEncoding(loginURL, VC: self, andParameter: params, withCompletion: { (json, statusCode) in
            
            self.hideIndicator()
            self.hideIndicator()
            
            guard let dictData = json.dictionaryObject else{
                return
            }
        
            if dictData["success"] as? Bool == true{
                self.showToast("Added to basket.")
               }else{
                   let responseMessage = dictData["message"] as? String ?? ""
                   self.showToast(responseMessage)
               }
          })
         }
}
