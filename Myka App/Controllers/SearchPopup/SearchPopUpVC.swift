//
//  SearchPopUpVC.swift
//  My Kai
//
//  Created by YES IT Labs on 28/04/25.
//

import UIKit
import Alamofire

class SearchPopUpVC: UIViewController {
     
    @IBOutlet var SearchRecipePopUpBgV: UIView!
    
    @IBOutlet weak var SearchRecipeTblV: UITableView!
    
    var SelItem = ""
    
    var SearchRecipeData = [BodyGoalsModel(Name: "Recipe search", isSelected: false), BodyGoalsModel(Name: "Favorite Recipes", isSelected: false), BodyGoalsModel(Name: "Add Recipe From Web", isSelected: false), BodyGoalsModel(Name: "Add your own recipe", isSelected: false), BodyGoalsModel(Name: "Taking a picture", isSelected: false)]
    //
    
    var SearchbyUrlList = ByUrl_IngredientsModel()

    override func viewDidLoad() {
        super.viewDidLoad()
  
        // popup view tbl
        self.SearchRecipeTblV.register(UINib(nibName: "ChooseDaysTblVCell", bundle: nil), forCellReuseIdentifier: "ChooseDaysTblVCell")
        self.SearchRecipeTblV.delegate = self
        self.SearchRecipeTblV.dataSource = self
        self.SearchRecipeTblV.separatorStyle = .none
        
       
        for i in 0..<SearchRecipeData.count{
            SearchRecipeData[i].isSelected = false
        }
        
        SearchRecipeData[0].isSelected = true
         
        SelItem = SearchRecipeData[0].Name
        
        self.SearchRecipeTblV.reloadData()
        //
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        SearchRecipePopUpBgV.addGestureRecognizer(tapGesture2)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        print("View1 was tapped!")
        StateMangerModelClass.shared.SearchClickFromPopup = false
        self.willMove(toParent: nil)
        self.view.removeFromSuperview()
        self.removeFromParent()
    }
    
    
   
    // popup btn
    @IBAction func CrossbtnBtn(_ sender: UIButton) {
        StateMangerModelClass.shared.SearchClickFromPopup = false
        self.willMove(toParent: nil)
        self.view.removeFromSuperview()
        self.removeFromParent()
    }
    
    @IBAction func SearchBtn(_ sender: UIButton) {
         
        if SelItem == "Add Recipe From Web" {
            StateMangerModelClass.shared.SearchClickFromPopup = false
            let SubscriptionStatus = Int(UserDetail.shared.getSubscriptionStatus())
            
            if SubscriptionStatus == 1{
                let SearchWebStatus = Int(UserDetail.shared.geturlSearch()) ?? 0
                guard SearchWebStatus <= 2 else {
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

               // vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
            self.addChild(vc)
            vc.view.frame = self.view.frame
            self.view.addSubview(vc.view)
            self.view.bringSubviewToFront(vc.view)
            vc.didMove(toParent: self)
        }else if SelItem == "Add your own recipe" {
            StateMangerModelClass.shared.SearchClickFromPopup = false
            let storyboard = UIStoryboard(name: "Tabbar", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "CreateRecipeVC") as! CreateRecipeVC
            vc.comesfrom = "Search"
            vc.backAction = {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3){
                    self.willMove(toParent: nil)
                    self.view.removeFromSuperview()
                    self.removeFromParent()
              }
            }
            self.navigationController?.pushViewController(vc, animated: true)
            
        }else if SelItem == "Taking a picture" {
            StateMangerModelClass.shared.SearchClickFromPopup = false
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
                    self.willMove(toParent: nil)
                    self.view.removeFromSuperview()
                    self.removeFromParent()
                    let imgdata = selImg
                     
                    
               //     self.recognizeTextInImage(imgdata)
                    let base64String = self.convertImageToBase64(image: imgdata) ?? ""
                    self.recognizeImage(base64Image: base64String)
                  }
                     
                }
            self.navigationController?.pushViewController(vc, animated: true)
        }else if SelItem == "Favorite Recipes" {
            StateMangerModelClass.shared.SearchClickFromPopup = false
            let storyboard = UIStoryboard(name: "RestScreens", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "CookBooksVC") as! CookBooksVC
            self.navigationController?.pushViewController(vc, animated: true)
        }else if SelItem == "Recipe search"{
            StateMangerModelClass.shared.SearchClickFromPopup = true
            if let tabBar = self.tabBarController?.tabBar,
               let items = tabBar.items,
               items.count > 4 {
                let item = items[1] // Get the UITabBarItem at index 4
                self.tabBarController?.tabBar(tabBar, didSelect: item)
                self.tabBarController?.selectedIndex = 1
            }
        }
        
        self.willMove(toParent: nil)
        self.view.removeFromSuperview()
        self.removeFromParent()
        StateMangerModelClass.shared.SearchClickFromPopup = false
    }
    //

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

extension SearchPopUpVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return SearchRecipeData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChooseDaysTblVCell", for: indexPath) as! ChooseDaysTblVCell
            cell.ViewBottomConstant.constant = 10
        
            cell.NameLbl.text = SearchRecipeData[indexPath.row].Name
            cell.TickImg.image =  UIImage(named: "")//SearchRecipeData[indexPath.row].isSelected ? UIImage(named: "chck") : UIImage(named: "Unchck")
        
            cell.selectedBgImg.image = SearchRecipeData[indexPath.row].isSelected ? UIImage(named: "Yelloborder") : UIImage(named: "Group 1171276489")
            cell.selectionStyle = .none
            return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        for i in 0..<SearchRecipeData.count{
            SearchRecipeData[i].isSelected = false
        }
        SearchRecipeData[indexPath.row].isSelected = true
        SearchRecipeTblV.reloadData()
        
        SelItem = SearchRecipeData[indexPath.row].Name
    }
    
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 60
        }
    }

extension SearchPopUpVC{
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
}
