//
//  AddRecipePopUpVC.swift
//  My Kai
//
//  Created by YES IT Labs on 05/05/25.
//

import UIKit
import Alamofire
import SDWebImage

struct AddRecipeModel{
    var name :String
    var image :UIImage
}


class AddRecipePopUpVC: UIViewController {
    
    //SearchRecipe PopUpView
    @IBOutlet var SearchRecipePopUpV: UIView!
    @IBOutlet weak var SearchRecipeTblV: UITableView!
    @IBOutlet weak var TblBGV: UIView!
    @IBOutlet weak var BgV: UIView!
    
    var SearchRecipeData = [AddRecipeModel(name: "Add a Recipe from Web", image: UIImage(named: "web")!), AddRecipeModel(name: "Create New Recipe", image: UIImage(named: "Create")!), AddRecipeModel(name: "Add Recipe from Image", image: UIImage(named: "Add")!)]
    //
    
    //  var model: VNCoreMLModel!
    
    var SelItem = ""
    
    var SearchbyUrlList = ByUrl_IngredientsModel()
    
    
    var BackAction:(String)->() = {_ in }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.SearchRecipeTblV.register(UINib(nibName: "PopupTblVCell", bundle: nil), forCellReuseIdentifier: "PopupTblVCell")
        self.SearchRecipeTblV.delegate = self
        self.SearchRecipeTblV.dataSource = self
        self.SearchRecipeTblV.separatorStyle = .none
        //
        
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        SearchRecipePopUpV.addGestureRecognizer(tapGesture2)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        print("BG View was tapped!")
        self.BackAction("")
        ToDismissPopUp()
    }
}


extension AddRecipePopUpVC: UITableViewDelegate, UITableViewDataSource {
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
                    self.TblBGV.isHidden = true
                    self.BgV.isHidden = true
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
                self.tabBarController?.tabBar.isHidden = false
                self.ToDismissPopUp()
                //                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3){
                //                        self.SearchRecipePopUpV.isHidden = true
            }
            //                }
            
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
    
    func ToDismissPopUp()  {
        self.willMove(toParent: nil)
        self.view.removeFromSuperview()
        self.removeFromParent()
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func SubscriptionPopUp()  {
        
        let storyboard = UIStoryboard(name: "Subscription", bundle: nil)
        
        let vc = storyboard.instantiateViewController(withIdentifier: "SubscriptionPopUpVC") as! SubscriptionPopUpVC
        vc.BackAction = {
            let storyboard = UIStoryboard(name: "Subscription", bundle: nil)
            
            let vc = storyboard.instantiateViewController(withIdentifier: "BupPlanVC") as! BupPlanVC
            vc.comesfrom = "Profile"
            self.navigationController?.pushViewController(vc, animated: true)
            self.ToDismissPopUp()
        }
        
        self.addChild(vc)
        vc.view.frame = self.view.frame
        self.view.addSubview(vc.view)
        self.view.bringSubviewToFront(vc.view)
        vc.didMove(toParent: self)
    }
}

extension AddRecipePopUpVC{
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
                            
                            self.tabBarController?.tabBar.isHidden = false
                            self.ToDismissPopUp()
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
        
        let token  = UserDetail.shared.getTokenWith()
     
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
                        self.tabBarController?.tabBar.isHidden = false
                        self.ToDismissPopUp()
                        
                        if let scene = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                            // to do
                            scene.window?.rootViewController?.showToast(msg)
                            self.TblBGV.isHidden = false
                            self.BgV.isHidden = false
                        }
                        return
                    }
                    
                    
                    let storyboard = UIStoryboard(name: "Tabbar", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "Searched_IngredientsListVC") as! Searched_IngredientsListVC
                    vc.SearchbyUrlList = self.SearchbyUrlList
                    vc.backaction = {
                        self.tabBarController?.tabBar.isHidden = false
                        self.ToDismissPopUp()
                        
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
    
    
    func getTopViewController(from viewController: UIViewController?) -> UIViewController? {
        if let navigationController = viewController as? UINavigationController {
            return getTopViewController(from: navigationController.visibleViewController)
        }
        if let tabBarController = viewController as? UITabBarController {
            return getTopViewController(from: tabBarController.selectedViewController)
        }
        if let presentedVC = viewController?.presentedViewController {
            return getTopViewController(from: presentedVC)
        }
        return viewController
    }
}
