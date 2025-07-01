//
//  AddRecipeVC.swift
//  Myka App
//
//  Created by Sumit on 13/12/24.
//

import UIKit
import Alamofire
import SDWebImage
 

class AddRecipeVC: UIViewController {
    
    
    @IBOutlet weak var SearchTxtF: UITextField!
    
    @IBOutlet weak var IngredientCollV: UICollectionView!
    
    @IBOutlet weak var MealCollV: UICollectionView!
    
    @IBOutlet weak var PopularCatCollV: UICollectionView!
    
    @IBOutlet weak var PrefToggleBtnO: UIButton!
    
    @IBOutlet weak var NameLbl: UILabel!
    
    @IBOutlet weak var profileImg: UIImageView!
    
    
    
    //SearchRecipe PopUpView
    @IBOutlet var SearchRecipePopUpV: UIView!
    @IBOutlet weak var SearchRecipeTblV: UITableView!
    
    var SearchRecipeData = [AddRecipeModel(name: "Add a Recipe from Web", image: UIImage(named: "web")!), AddRecipeModel(name: "Create New Recipe", image: UIImage(named: "Create")!), AddRecipeModel(name: "Add Recipe from Image", image: UIImage(named: "Add")!)]
    //
    
  //  var model: VNCoreMLModel!
    
    var SelItem = ""
    
    var SearchRecipeSelItem = SearchListModel()
    var SearchRecipeSelItem1 = SearchListModel()
    
    var SearchbyUrlList = ByUrl_IngredientsModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.SearchRecipePopUpV.frame = self.view.bounds
        self.view.addSubview(self.SearchRecipePopUpV)
        self.SearchRecipePopUpV.isHidden = true
        
        
        IngredientCollV.register(UINib(nibName: "SearchIngredientCollVCell", bundle: nil), forCellWithReuseIdentifier: "SearchIngredientCollVCell")
        IngredientCollV.delegate = self
        IngredientCollV.dataSource = self
        
        MealCollV.register(UINib(nibName: "MealCollVCell", bundle: nil), forCellWithReuseIdentifier: "MealCollVCell")
        MealCollV.delegate = self
        MealCollV.dataSource = self
        
        PopularCatCollV.register(UINib(nibName: "MealCollVCell", bundle: nil), forCellWithReuseIdentifier: "MealCollVCell")
        PopularCatCollV.delegate = self
        PopularCatCollV.dataSource = self
        // popup view tbl
        self.SearchRecipeTblV.register(UINib(nibName: "PopupTblVCell", bundle: nil), forCellReuseIdentifier: "PopupTblVCell")
        self.SearchRecipeTblV.delegate = self
        self.SearchRecipeTblV.dataSource = self
        self.SearchRecipeTblV.separatorStyle = .none
        //
        
        self.Api_To_GetAllRecipeList()
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
        
        self.SearchTxtF.addTarget(self, action: #selector(TextSearch(sender: )), for: .editingChanged)
        
//        guard let coreMLModel = try? MobileNetV2(configuration: MLModelConfiguration()).model else {
//                    fatalError("Unable to load model")
//                }
//                // Convert to Vision model
//                model = try? VNCoreMLModel(for: coreMLModel)
    }
    
    @objc func TextSearch(sender: UITextField){
        if self.SearchTxtF.text != ""{
            SearchRecipeSelItem.ingredient = SearchRecipeSelItem1.ingredient?.filter({ (item) -> Bool in
                let value: Category = item as Category
                return ((value.name?.range(of: sender.text!, options: .caseInsensitive)) != nil)
            })
            
            SearchRecipeSelItem.mealType = SearchRecipeSelItem1.mealType?.filter({ (item) -> Bool in
                let value: Category = item as Category
                return ((value.name?.range(of: sender.text!, options: .caseInsensitive)) != nil)
            })
            
            SearchRecipeSelItem.category = SearchRecipeSelItem1.category?.filter({ (item) -> Bool in
                let value: Category = item as Category
                return ((value.name?.range(of: sender.text!, options: .caseInsensitive)) != nil)
            })
        }else{
            self.SearchRecipeSelItem.ingredient = self.SearchRecipeSelItem1.ingredient
            self.SearchRecipeSelItem.mealType = self.SearchRecipeSelItem1.mealType
            self.SearchRecipeSelItem.category = self.SearchRecipeSelItem1.category
        }
        
        if self.SearchRecipeSelItem.ingredient?.count ?? 0 > 0{
            self.IngredientCollV.setEmptyMessage("", UIImage())
        }else{
            self.IngredientCollV.setEmptyMessage("No data found.", UIImage())
        }
        
        if self.SearchRecipeSelItem.mealType?.count ?? 0 > 0{
            self.MealCollV.setEmptyMessage("", UIImage())
        }else{
            self.MealCollV.setEmptyMessage("No data found.", UIImage())
        }
          
        if self.SearchRecipeSelItem.category?.count ?? 0 > 0{
            self.PopularCatCollV.setEmptyMessage("", UIImage())
        }else{
            self.PopularCatCollV.setEmptyMessage("No data found.", UIImage())
        }
        
        self.IngredientCollV.reloadData()
        self.MealCollV.reloadData()
        self.PopularCatCollV.reloadData()
    }


    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.SearchRecipePopUpV.isHidden = false
    }
    
    
     
    
    
    @IBAction func ToggleBtn(_ sender: UIButton) {
        if PrefToggleBtnO.isSelected == true{
            PrefToggleBtnO.isSelected = false
        }else {
            PrefToggleBtnO.isSelected = true
        }
        self.Api_To_Set_Preferences()
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
    
 
}


extension AddRecipeVC: UICollectionViewDelegate, UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == IngredientCollV{
            return SearchRecipeSelItem.ingredient?.count ?? 0
        }else if collectionView == MealCollV{
            return SearchRecipeSelItem.mealType?.count ?? 0
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
            
            let img = SearchRecipeSelItem.mealType?[indexPath.item].image ?? ""
            let imgUrl = URL(string: img)
            
            cell.Img.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
            cell.Img.sd_setImage(with: imgUrl, placeholderImage: UIImage(named: "No_Image"))
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MealCollVCell", for: indexPath) as! MealCollVCell
            cell.NameLbl.text = SearchRecipeSelItem.category?[indexPath.item].name ?? ""
            
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
            vc.titleTxt = SearchRecipeSelItem.mealType?[indexPath.item].name ?? ""
            self.navigationController?.pushViewController(vc, animated: true)
        }else if collectionView == PopularCatCollV{
            let storyboard = UIStoryboard(name: "Tabbar", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "DinnerVc") as! DinnerVc
            vc.titleTxt = SearchRecipeSelItem.category?[indexPath.item].name ?? ""
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == IngredientCollV{
            return CGSize(width: collectionView.frame.width/5, height: collectionView.frame.height)
        }else{
            let padding: CGFloat =  10
            let collectionViewSize = (collectionView.frame.size.height) - padding
            let collectionViewWidthSize = (collectionView.frame.size.width) - padding
           
            return CGSize(width: collectionViewWidthSize/2.5 - 5, height: collectionViewSize/2)
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


extension AddRecipeVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SearchRecipeData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PopupTblVCell", for: indexPath) as! PopupTblVCell
       
        cell.NameLbl.text = SearchRecipeData[indexPath.row].name
        cell.Img.image = SearchRecipeData[indexPath.row].image
        cell.selectionStyle = .none
        
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.SearchRecipePopUpV.isHidden = true
        
        if SearchRecipeData[indexPath.row].name == "Add a Recipe from Web" {
            let SubscriptionStatus = Int(UserDetail.shared.getSubscriptionStatus())
            
            if SubscriptionStatus == 1{
                let addtoplanStatus = Int(UserDetail.shared.geturlSearch()) ?? 0
                guard addtoplanStatus <= 2 else {
                    SubscriptionPopUp ()
                    return
                }
            }
            
            
            let storyboard = UIStoryboard(name: "Tabbar", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "AddUrlVC") as! AddUrlVC
            vc.backAction = {url in
              
                let storyboard = UIStoryboard(name: "Tabbar", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "WebViewVC") as! WebViewVC
                vc.WebUrl = url
                vc.backAction = { wubUrl in
                    self.Api_To_Get_MealByURL(url: wubUrl)
                }

                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
            self.addChild(vc)
            vc.view.frame = self.view.frame
            self.view.addSubview(vc.view)
            self.view.bringSubviewToFront(vc.view)
            vc.didMove(toParent: self)
        }else if SearchRecipeData[indexPath.row].name == "Create New Recipe" {
            let storyboard = UIStoryboard(name: "Tabbar", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "CreateRecipeVC") as! CreateRecipeVC
            vc.comesfrom = "AddRecipe"
            vc.backAction = {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3){
                    self.SearchRecipePopUpV.isHidden = true
              }
            }
            self.navigationController?.pushViewController(vc, animated: true)
            
        }else{
            let SubscriptionStatus = Int(UserDetail.shared.getSubscriptionStatus())
            
            if SubscriptionStatus == 1{
                let addtoplanStatus = Int(UserDetail.shared.getimageSearch()) ?? 0
                guard addtoplanStatus <= 2 else {
                    SubscriptionPopUp ()
                    return
                }
            }
            
            let storyboard = UIStoryboard(name: "Tabbar", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "CameraVC") as! CameraVC
            vc.hidesBottomBarWhenPushed = true
            vc.backAction = { selImg in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3){
                    self.SearchRecipePopUpV.isHidden = true
                    let imgdata = selImg
                     
                    
               //     self.recognizeTextInImage(imgdata)
                    let base64String = self.convertImageToBase64(image: imgdata) ?? ""
                    self.recognizeImage(base64Image: base64String)
                  }
                     
                }
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
 
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
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

extension AddRecipeVC{
    // Recognize Image using Vision API
        func recognizeImage(base64Image: String) {
            // Show loading indicator (implement your own method here)
            self.showIndicator(withTitle: "", and: "")
            
            // Set up Vision API request
            let features = [Feature(type: "WEB_DETECTION", maxResults: 1)]
            let image = Image(content: base64Image)
            let request1 = Request(image: image, features: features)
            let visionRequest = VisionRequest(requests: [request1])
            
            // Set up URL and API key
            let apiKey = "AIzaSyCjOLbQCG6foFlN05JOFKBpjNqV8DE9vi8"
            guard let url = URL(string: "https://vision.googleapis.com/v1/images:annotate?key=\(apiKey)") else { return }
            
            // Prepare the URLRequest
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            do {
                let jsonData = try JSONEncoder().encode(visionRequest)
                request.httpBody = jsonData
            } catch {
                print("Error encoding request body: \(error)")
                return
            }
            
            // Execute the request using URLSession
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                DispatchQueue.main.async {
                    // Dismiss loading indicator
                    self.hideIndicator()
                    
                    if let error = error {
                        print("API call failed with error: \(error.localizedDescription)")
                        self.showToast("Error: \(error.localizedDescription)")
                        return
                    }
                    
                    guard let data = data else {
                        print("No data received.")
                        self.showToast("No data received.")
                        return
                    }
                    
                    do {
                        let visionResponse = try JSONDecoder().decode(VisionResponse.self, from: data)
                       
                        if let webDetection = visionResponse.responses.first?.webDetection,
                           let webEntity = webDetection.webEntities.first?.description {
                            // Navigate to next screen with the description of the first web entity
                            let bundle = webEntity
                            
                            self.showToast(bundle)
                            
                            let storyboard = UIStoryboard(name: "Tabbar", bundle: nil)
                            let vc = storyboard.instantiateViewController(withIdentifier: "CreateRecipeVC") as! CreateRecipeVC
                            vc.comesfrom = "AddRecipeImage"
                            vc.ImgItemName = "\(bundle)"
                            vc.backAction = {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3){
                                    //  self.SearchRecipePopUpV.isHidden = true
                                }
                            }
                            self.navigationController?.pushViewController(vc, animated: true)
                            
                            
                        } else {
                            print("No web detection or web entities found.")
                            self.showToast("No similar images found.")
                        }
                    } catch {
                        print("Error decoding response: \(error)")
                        self.showToast("Failed to process response.")
                    }
                }
            }
            
            task.resume()
        }
    
    func Api_To_Get_MealByURL(url: String){
        var params = [String: Any]()
       
        params["q"] = url
       
       
        
        showIndicator(withTitle: "", and: "")
        
        let loginURL = baseURL.baseURL + appEndPoints.get_meal_by_url
        print(params,"Params")
        print(loginURL,"loginURL")
        
        WebService.shared.postServiceURLEncoding(loginURL, VC: self, andParameter: params, withCompletion: { (json, statusCode) in
            
            self.hideIndicator()
            
            let data = try! json.rawData()
            
            do{
                let d = try JSONDecoder().decode(ByUrl_IngredientsModelClass.self, from: data)
                if d.success == true {
                    let list = d.data
                    self.SearchbyUrlList = list ?? ByUrl_IngredientsModel()
                    
                    let msg = d.message ?? ""
                    
                    guard msg != "Recipe Not Found." else {
                        self.showToast(msg)
                        return
                    }
                    
 
                    let storyboard = UIStoryboard(name: "Tabbar", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "Searched_IngredientsListVC") as! Searched_IngredientsListVC
                    vc.SearchbyUrlList = self.SearchbyUrlList
                    vc.backaction = {
                        self.tabBarController?.tabBar.isHidden = false
//                        self.Api_To_GetAllRecipeList()
//                        self.Api_To_Get_ProfileData()
                    }
                    self.tabBarController?.tabBar.isHidden = true
                    self.addChild(vc)
                    vc.view.frame = self.view.frame
                    self.view.addSubview(vc.view)
                    self.view.bringSubviewToFront(vc.view)
                    vc.didMove(toParent: self)
                      //  self.present(vc, animated: true, completion: nil)
                    
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
 
extension AddRecipeVC {
    func Api_To_GetAllRecipeList(){
        var params = [String: Any]()
   
       
        showIndicator(withTitle: "", and: "")
        
        let loginURL = baseURL.baseURL + appEndPoints.for_search
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
                        self.IngredientCollV.setEmptyMessage("No data found.", UIImage())
                    }
                    
                    if self.SearchRecipeSelItem.mealType?.count ?? 0 > 0{
                        self.MealCollV.setEmptyMessage("", UIImage())
                    }else{
                        self.MealCollV.setEmptyMessage("No data found.", UIImage())
                    }
                      
                    if self.SearchRecipeSelItem.category?.count ?? 0 > 0{
                        self.PopularCatCollV.setEmptyMessage("", UIImage())
                    }else{
                        self.PopularCatCollV.setEmptyMessage("No data found.", UIImage())
                    }
                    
                    self.IngredientCollV.reloadData()
                    self.MealCollV.reloadData()
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
                self.Api_To_GetAllRecipeList()
                self.showToast("Updated successfully")
            }else{
                let responseMessage = dictData["message"] as? String ?? ""
                self.showToast(responseMessage)
            }
        })
    }
}
