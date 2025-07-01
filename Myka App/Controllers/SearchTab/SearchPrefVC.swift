//
//  SearchPrefVC.swift
//  Myka App
//
//  Created by Sumit on 12/12/24.
//

import UIKit
import Alamofire
import SDWebImage

class SearchPrefVC: UIViewController {

    @IBOutlet weak var profileImg: UIImageView!
    
    @IBOutlet weak var NameLbl: UILabel!
    
    @IBOutlet weak var SearchTxtF: UITextField!
    
    @IBOutlet weak var IngredientCollV: UICollectionView!
    
    @IBOutlet weak var MealCollV: UICollectionView!
    
    @IBOutlet weak var PopularCatCollV: UICollectionView!
    
    @IBOutlet weak var SearchByRecipeCollV: UICollectionView!
    
    @IBOutlet weak var PrefToggleBtnO: UIButton!
    //SearchRecipe PopUpView
    @IBOutlet weak var SearchByMealBgV: UIView!
    @IBOutlet weak var SearchByPopularCatBgV: UIView!
    @IBOutlet weak var SearchByRecipeBgV: UIView!
    
    
    var SearchRecipeSelItem = SearchListModel()
    var SearchRecipeSelItem1 = SearchListModel()
    
    var textChangedWorkItem: DispatchWorkItem?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        IngredientCollV.register(UINib(nibName: "SearchIngredientCollVCell", bundle: nil), forCellWithReuseIdentifier: "SearchIngredientCollVCell")
        IngredientCollV.delegate = self
        IngredientCollV.dataSource = self
        
        MealCollV.register(UINib(nibName: "MealCollVCell", bundle: nil), forCellWithReuseIdentifier: "MealCollVCell")
        MealCollV.delegate = self
        MealCollV.dataSource = self
        
        SearchByRecipeCollV.register(UINib(nibName: "MealCollVCell", bundle: nil), forCellWithReuseIdentifier: "MealCollVCell")
        SearchByRecipeCollV.delegate = self
        SearchByRecipeCollV.dataSource = self
         
        self.SearchByRecipeBgV.isHidden = true
        
        PopularCatCollV.register(UINib(nibName: "MealCollVCell", bundle: nil), forCellWithReuseIdentifier: "MealCollVCell")
        PopularCatCollV.delegate = self
        PopularCatCollV.dataSource = self
       
        DispatchQueue.global(qos: .background).async {
            planService.shared.Api_To_Get_ProfileData(vc: self) { result in
                
                switch result {
                case .success(let allData):
                    let response = allData
                    
                    let Name = response?["name"] as? String ?? String()
                    let Attributes1: [NSAttributedString.Key: Any] = [
                        .foregroundColor: UIColor.black
                    ]
                    let Attributes2: [NSAttributedString.Key: Any] = [
                        .foregroundColor: UIColor.init(red: 6/255, green: 193/255, blue: 105/255, alpha: 1)
                    ]
                        let helloString = NSAttributedString(string: "Hello, ", attributes: Attributes1)
                    let worldString = NSAttributedString(string: Name.capitalizedFirst, attributes: Attributes2)
                        let fullString = NSMutableAttributedString()
                        fullString.append(helloString)
                        fullString.append(worldString)
                       
                    self.NameLbl.attributedText = fullString
                    
                    let ProfImg = response?["profile_img"] as? String ?? String()
                    let img = URL(string: baseURL.imageUrl + ProfImg)
                    
                    self.profileImg.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
                    self.profileImg.sd_setImage(with: img, placeholderImage: UIImage(named: "DummyImg"))
                case .failure(let error):
                    // Handle error
                    print("Error retrieving data: \(error.localizedDescription)")
                }
            }
        }
        self.Api_To_GetAllRecipeList(Search: "")
        
        
        self.SearchTxtF.addTarget(self, action: #selector(TextSearch(sender: )), for: .editingChanged)
        
        NotificationCenter.default.addObserver(self, selector: #selector(listnerFunctionAddRecipe(_:)), name: NSNotification.Name(rawValue: "notificationNameAddRecipeS"), object: nil)
    }
    
    @objc func listnerFunctionAddRecipe(_ notification: NSNotification) {
        if let data = notification.userInfo?["data"] as? String {
            if data == "AddRecipePopup"{
                let storyboard = UIStoryboard(name: "Tabbar", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "AddRecipePopUpVC") as! AddRecipePopUpVC
                vc.BackAction = { str in
                    self.tabBarController?.tabBar.isHidden = false
                }
                self.tabBarController?.tabBar.isHidden = true
             //   self.present(vc, animated: true)
                
                self.addChild(vc)
                vc.view.frame = self.view.frame
                self.view.addSubview(vc.view)
                self.view.bringSubviewToFront(vc.view)
                vc.didMove(toParent: self)
            }
         }
        }
    
 

    @objc func TextSearch(sender: UITextField){
        let searchText = SearchTxtF.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
        // Check if the search text has changed
        // Cancel the previous work item
        textChangedWorkItem?.cancel()
        
        // Create a new debounced work item
        textChangedWorkItem = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            
            self.hideIndicator()
            Api_To_GetAllRecipeList(Search: searchText)
        }
        
        // Schedule the work item to execute after a debounce time (e.g., 1 second)
        if let workItem = textChangedWorkItem {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: workItem)
        }
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
          
    }
    
    @IBAction func ProfileBtn(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func FavBtn(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "RestScreens", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "CookBooksVC") as! CookBooksVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func CartBtn(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Basket", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "BasketVC") as! BasketVC
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func ToggleBtn(_ sender: UIButton) {
        if PrefToggleBtnO.isSelected == true{
            PrefToggleBtnO.isSelected = false
        }else {
            PrefToggleBtnO.isSelected = true
        }
        self.Api_To_Set_Preferences()
    }
    
    
    @IBAction func All_IngredientsBtn(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Tabbar", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "All_IngredientsVC") as! All_IngredientsVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func FilterBtn(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Tabbar", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "FilterVC") as! FilterVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
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
}


extension SearchPrefVC: UICollectionViewDelegate, UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout{
    
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            if collectionView == IngredientCollV{
                return SearchRecipeSelItem.ingredient?.count ?? 0
            }else if collectionView == MealCollV{
                return SearchRecipeSelItem.mealType?.count ?? 0
            }else if collectionView == SearchByRecipeCollV{
                return SearchRecipeSelItem.recipes?.count ?? 0
            }else{
                return SearchRecipeSelItem.category?.count ?? 0
            }
        }
    
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            if collectionView == IngredientCollV{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchIngredientCollVCell", for: indexPath) as! SearchIngredientCollVCell
                
                cell.NameLbl.text = SearchRecipeSelItem.ingredient?[indexPath.item].name ?? ""
                
                let img = SearchRecipeSelItem.ingredient?[indexPath.item].image ?? ""
                let imgUrl = URL(string: img)
                
                cell.Img.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
                cell.Img.sd_setImage(with: imgUrl, placeholderImage: UIImage(named: "No_Image"))
                 
                return cell
            }else if collectionView == MealCollV{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MealCollVCell", for: indexPath) as! MealCollVCell
                cell.NameLbl.text = SearchRecipeSelItem.mealType?[indexPath.item].name ?? ""
                
              //  cell.NameLblH.constant = 24
                
                let img = SearchRecipeSelItem.mealType?[indexPath.item].image ?? ""
                let imgUrl = URL(string: img)
                
                cell.Img.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
                cell.Img.sd_setImage(with: imgUrl, placeholderImage: UIImage(named: "No_Image"))
                return cell
                
            }else if collectionView == SearchByRecipeCollV{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MealCollVCell", for: indexPath) as! MealCollVCell
                cell.NameLbl.text = SearchRecipeSelItem.recipes?[indexPath.item].recipe.label ?? ""
              //  cell.NameLblH.constant = 48
                let img =  SearchRecipeSelItem.recipes?[indexPath.item].recipe.images?.small?.url ?? ""
                let imgUrl = URL(string: img)
                
                cell.Img.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
                cell.Img.sd_setImage(with: imgUrl, placeholderImage: UIImage(named: "No_Image"))
                return cell
                
            }else{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MealCollVCell", for: indexPath) as! MealCollVCell
                cell.NameLbl.text = SearchRecipeSelItem.category?[indexPath.item].name ?? ""
               // cell.NameLblH.constant = 24
                let img = SearchRecipeSelItem.category?[indexPath.item].image ?? ""
                let imgUrl = URL(string: img)
                
                cell.Img.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
                cell.Img.sd_setImage(with: imgUrl, placeholderImage: UIImage(named: "No_Image"))
                return cell
            }
        }
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            if collectionView == MealCollV{
                let storyboard = UIStoryboard(name: "Tabbar", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "DinnerVc") as! DinnerVc
                vc.comesfrom = "Mealtype"
                vc.titleTxt = SearchRecipeSelItem.mealType?[indexPath.item].name ?? ""
                self.navigationController?.pushViewController(vc, animated: true)
            }else if collectionView == PopularCatCollV{
                let storyboard = UIStoryboard(name: "Tabbar", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "DinnerVc") as! DinnerVc
                vc.comesfrom = "PopularCat"
                vc.titleTxt = SearchRecipeSelItem.category?[indexPath.item].name ?? ""
                self.navigationController?.pushViewController(vc, animated: true)
            }else if collectionView == IngredientCollV{
               
               let selectedName = SearchRecipeSelItem.ingredient?[indexPath.item].name ?? ""
                
                let storyboard = UIStoryboard(name: "Tabbar", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "DinnerVc") as! DinnerVc
                vc.SelectedIngNames = selectedName
                vc.comesfrom = "All_IngredientsVC"
                self.navigationController?.pushViewController(vc, animated: true)
             
            }else if collectionView == SearchByRecipeCollV{
                let string = SearchRecipeSelItem.recipes?[indexPath.item].recipe.mealType?.first ?? ""
         
                let storyboard = UIStoryboard(name: "Tabbar", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "RecipeDetailsVC") as! RecipeDetailsVC
                if let result = string.components(separatedBy: "/").first {
                    vc.MealType = result
                }
                vc.uri = SearchRecipeSelItem.recipes?[indexPath.item].recipe.uri ?? ""
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
        
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            if collectionView == IngredientCollV{
                return CGSize(width: collectionView.frame.width/4, height: collectionView.frame.height)
            }else{
                let padding: CGFloat =  10
                let collectionViewSize = (collectionView.frame.size.height) - padding
                let collectionViewWidthSize = (collectionView.frame.size.width) - padding
                
                if collectionView == SearchByRecipeCollV{
                    return CGSize(width: collectionViewWidthSize/2 - 5, height: collectionViewSize/2)
                }else{
                    return CGSize(width: collectionViewWidthSize/2.5 - 5, height: collectionViewSize/2)
                }
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
 


extension SearchPrefVC {
    func Api_To_GetAllRecipeList(Search: String){
        var params = [String: Any]()
        
        params["search"] = Search
   
        let token  = UserDetail.shared.getTokenWith()
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        
        showIndicator(withTitle: "", and: "")
        
        let loginURL = baseURL.baseURL + appEndPoints.ingredientRecipeSearch //for_search
        print(params,"Params")
        print(loginURL,"loginURL")
        
        WebService.shared.postServiceURLEncoding(loginURL, VC: self, andParameter: params, withCompletion: { (json, statusCode) in
            
            self.hideIndicator()
            
            let data = try! json.rawData()
            
            do{
                let d = try JSONDecoder().decode(SearchListModelClass.self, from: data)
                if d.success == true {
                    let list = d.data
                    self.SearchRecipeSelItem = list ?? SearchListModel()
                    self.SearchRecipeSelItem1 = self.SearchRecipeSelItem
                    
                    let pref_Status = self.SearchRecipeSelItem.preferenceStatus ?? 0
                    
                    if pref_Status == 0{
                        self.PrefToggleBtnO.isSelected = false
                    }else {
                        self.PrefToggleBtnO.isSelected = true
                    }
                    
                    if self.SearchRecipeSelItem.ingredient?.count ?? 0 > 0{
                        self.IngredientCollV.setEmptyMessage("", UIImage())
                    }else{
                        self.IngredientCollV.setEmptyMessage("No ingredient found.", UIImage())
                    }
                    
                    if self.SearchRecipeSelItem.mealType?.count ?? 0 > 0{
                        self.MealCollV.setEmptyMessage("", UIImage())
                    }else{
                        self.MealCollV.setEmptyMessage("No meal found.", UIImage())
                    }
                    
                    if self.SearchRecipeSelItem.category?.count ?? 0 > 0{
                        self.PopularCatCollV.setEmptyMessage("", UIImage())
                    }else{
                        self.PopularCatCollV.setEmptyMessage("No Recipe Found.", UIImage())
                    }
                    
                    if self.SearchRecipeSelItem.category?.count ?? 0 == 0 && self.SearchRecipeSelItem.mealType?.count ?? 0 == 0{
                        self.SearchByRecipeBgV.isHidden = false
                        self.SearchByMealBgV.isHidden = true
                        self.SearchByPopularCatBgV.isHidden = true
                    }else{
                        self.SearchByRecipeBgV.isHidden = true
                        self.SearchByMealBgV.isHidden = false
                        self.SearchByPopularCatBgV.isHidden = false
                    }
                    
                    self.IngredientCollV.reloadData()
                    self.MealCollV.reloadData()
                    self.SearchByRecipeCollV.reloadData()
                    self.PopularCatCollV.reloadData()
                    
                }else{
                    let msg = d.message ?? ""
                    self.showToast(msg)
                }
            }catch{
                print(error)
            }
        })
    }
   
    
    func Api_To_Set_Preferences(){
        var params = [String: Any]()
       
       // params["q"] = url
      
        showIndicator(withTitle: "", and: "")
        
        let loginURL = baseURL.baseURL + appEndPoints.for_preference_update
        print(params,"Params")
        print(loginURL,"loginURL")
        
        WebService.shared.postServiceURLEncoding(loginURL, VC: self, andParameter: params, withCompletion: { (json, statusCode) in
            
            self.hideIndicator()
            
            guard let dictData = json.dictionaryObject else{
                return
            }
            
            if dictData["success"] as? Bool == true{
                self.Api_To_GetAllRecipeList(Search: "")
                self.showToast("Updated successfully")
            }else{
                let responseMessage = dictData["message"] as? String ?? ""
                self.showToast(responseMessage)
            }
        })
    }
     
}
