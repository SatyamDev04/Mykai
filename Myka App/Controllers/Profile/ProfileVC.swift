//
//  ProfileVC.swift
//  Myka App
//
//  Created by YES IT Labs on 17/12/24.
//

import UIKit
import DropDown
import Alamofire
import SDWebImage
import CoreLocation

class ProfileVC: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var ProgImg: UIImageView!
    @IBOutlet weak var Namelbl: UILabel!
    
    @IBOutlet weak var DescTxtV: UITextView!
    
    @IBOutlet weak var ProfileBgV: UIView!
    @IBOutlet weak var TArgetsBgV: UIView!
    
    @IBOutlet weak var CalTxtF: UITextField!
    @IBOutlet weak var FatTxtF: UITextField!
    @IBOutlet weak var CarbsTxtF: UITextField!
    @IBOutlet weak var ProtienTxtF: UITextField!
    
    @IBOutlet weak var SaveBtnO: UIButton!
    @IBOutlet weak var NameTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var EditProfileBtnTopConst: NSLayoutConstraint!
    
    @IBOutlet weak var EditTargetsBtnO: UIButton!
    @IBOutlet weak var CalImg: UIImageView!
    @IBOutlet weak var FatImg: UIImageView!
    @IBOutlet weak var CarbsImg: UIImageView!
    @IBOutlet weak var ProtineImg: UIImageView!
    
    @IBOutlet weak var PostalCodeDropImg: UIImageView!
    @IBOutlet weak var PoastCodeImgH: NSLayoutConstraint!
    @IBOutlet weak var PoastCodeImgW: NSLayoutConstraint!
    
    
    @IBOutlet weak var TermsCondBgV: UIView!
    @IBOutlet weak var PrivacyPolyBgV: UIView!
    
    @IBOutlet weak var AboutAppDropImg: UIImageView!
   
    
    @IBOutlet var AllBtnsO: [UIButton]!
    
    //popup views.
    @IBOutlet var LogOutPopupV: UIView!
    @IBOutlet var DeleteAccPopupV: UIView!
    //
    
    let dropDown = DropDown()
    
    var colorArray: [UIColor] = [#colorLiteral(red: 1, green: 0.968627451, blue: 0.9411764706, alpha: 1), #colorLiteral(red: 0.9058823529, green: 1, blue: 0.9568627451, alpha: 1)]
    
    var imageArr1: [UIImage] = [UIImage(named: "Group 1171275581")!, UIImage(named: "Group 1171275595")!, UIImage(named: "Group 11712757191")!, UIImage(named: "Group 1171275596")!]// default img.
    
    var imageArr: [UIImage] = [UIImage(named: "Group 1171275580")!, UIImage(named: "Group 1171275592")!, UIImage(named: "Group 1171276545")!, UIImage(named: "Group 1171275594")!]
    
//    var postalcodeImg: [UIImage] = [UIImage(named: "Vector (6)")!, UIImage(named: "Vector(6.1)")!]
    var DropDownImg: [String] = ["Group 1171276020", "Group 1171276021"]
    
    var isPostCodeSel = false
    
    private var HeighProtine = ""
    private var dob = ""
    private var height = ""
    private var height_type = ""
    private var gender = ""
    private var activity_level = ""
    
    let locationManager = CLLocationManager()
    
    var lat = 0.0
    var longi = 0.0
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.LogOutPopupV.frame = self.view.bounds
        self.view.addSubview(self.LogOutPopupV)
        self.LogOutPopupV.isHidden = true
        
        
        self.DeleteAccPopupV.frame = self.view.bounds
        self.view.addSubview(self.DeleteAccPopupV)
        self.DeleteAccPopupV.isHidden = true
        
        self.ProgImg.image = UIImage(named: "user")
        
        ProfileBgV.backgroundColor = colorArray[0]
        TArgetsBgV.backgroundColor = colorArray[0]
        
        self.TermsCondBgV.isHidden = true
        self.PrivacyPolyBgV.isHidden = true
        self.AboutAppDropImg.image = UIImage(named: "Vector(6.1)")
        
        
        self.CalTxtF.isUserInteractionEnabled = false
        self.FatTxtF.isUserInteractionEnabled = false
        self.CarbsTxtF.isUserInteractionEnabled = false
        self.ProtienTxtF.isUserInteractionEnabled = false
        self.SaveBtnO.isHidden = true
        self.EditTargetsBtnO.isHidden = false//true
        
        self.CalImg.image = imageArr1[0]
        self.FatImg.image = imageArr1[1]
        self.CarbsImg.image = imageArr1[2]
        self.ProtineImg.image = imageArr1[3]
        self.DescTxtV.isUserInteractionEnabled = false
        
         
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        planService.shared.Api_To_Get_ProfileData(vc: self) { result in
            
            switch result {
            case .success(let allData):
                let response = allData
                
                let Name = response?["name"] as? String ?? String()
                self.Namelbl.text = Name.capitalizedFirst
                
                let ProfImg = response?["profile_img"] as? String ?? String()
                let img = URL(string: baseURL.imageUrl + ProfImg)
                
                self.ProgImg.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
                self.ProgImg.sd_setImage(with: img, placeholderImage: UIImage(named: "user"))
                
                let bio = response?["bio"] as? String ?? ""
                if bio != ""{
                    self.DescTxtV.text = bio
                }else{
                    self.DescTxtV.text = "NA"
                }
                
                let calories = response?["calories"] as? Int ?? Int()
                self.CalTxtF.text = "\(calories)"
                
                let fat = response?["fat"] as? Int ?? Int()
                self.FatTxtF.text = "\(fat)"
                
                let carbs = response?["carbs"] as? Int ?? Int()
                self.CarbsTxtF.text = "\(carbs)"
                
                let protien = response?["protein"] as? Int ?? Int()
                self.ProtienTxtF.text = "\(protien)"
                
                let dob = response?["dob"] as? String ?? String()
                self.dob = dob
               
                
                 
                // let Email = response["email"] as? String ?? String()
                let gender = response?["gender"] as? String ?? String()
                self.gender = gender
                
                let height = response?["height"] as? String ?? String()
                self.height = height
                
                let height_type = response?["height_type"] as? String ?? String()
                self.height_type = height_type
                
                let activity_level = response?["activity_level"] as? String ?? String()
                self.activity_level = activity_level
                
                let height_protein = response?["height_protein"] as? String ?? String()
                self.HeighProtine = height_protein
            case .failure(let error):
                // Handle error
                print("Error retrieving data: \(error.localizedDescription)")
            }
        }
    }
    
    @IBAction func BackBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func OptionBtn(_ sender: UIButton) {
//        dropDown.dataSource = ["Logout","Delete Account"]
//          dropDown.anchorView = sender
//          
//          // Add trailing space (adjust x for horizontal offset)
//          let trailingSpace: CGFloat = 120 // Adjust as needed
//          dropDown.bottomOffset = CGPoint(x: -trailingSpace, y: sender.bounds.height)
//          dropDown.topOffset = CGPoint(x: -trailingSpace, y: -(dropDown.anchorView?.plainView.bounds.height ?? 0))
//          dropDown.width = 140
//          dropDown.setupCornerRadius(10)
//          
//          // Optional: You may also need to disable shadow for proper clipping
//          dropDown.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
//          dropDown.layer.shadowOpacity = 0
//          dropDown.layer.shadowRadius = 4
//          dropDown.layer.shadowOffset = CGSize(width: 0, height: 0)
//          dropDown.backgroundColor = .white
//          dropDown.cellHeight = 35
//          dropDown.textFont = UIFont.systemFont(ofSize: 16)
//
//        dropDown.selectionAction = { [weak self] (index: Int, item: String) in
//            guard let self = self else { return }
//            print(index)
//            if index == 0 {
//                self.LogOutPopupV.isHidden = false
//            }else{
//                self.DeleteAccPopupV.isHidden = false
//            }
//        }
//        
//        dropDown.show()
        
        dropDown.dataSource = ["Logout","Delete Account"]
          dropDown.anchorView = sender
          
          // Add trailing space (adjust x for horizontal offset)
        let trailingSpace: CGFloat = 145 // Adjust as needed
        dropDown.bottomOffset = CGPoint(x: -trailingSpace, y: sender.bounds.height)
        dropDown.topOffset = CGPoint(x: -trailingSpace, y: -(dropDown.anchorView?.plainView.bounds.height ?? 0))
        dropDown.width = 170
        dropDown.setupCornerRadius(10)
        
        // Optional: You may also need to disable shadow for proper clipping
        dropDown.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        dropDown.layer.shadowOpacity = 0
        dropDown.layer.shadowRadius = 4
        dropDown.layer.shadowOffset = CGSize(width: 0, height: 0)
        dropDown.backgroundColor = .white
        dropDown.cellHeight = 35
        dropDown.textFont = UIFont.systemFont(ofSize: 16)

          // Use custom cell configuration
          dropDown.cellNib = UINib(nibName: "CustomDropDownCell", bundle: nil)
          dropDown.customCellConfiguration = { [weak self] (index: Index, item: String, cell: DropDownCell) in
              guard let cell = cell as? CustomDropDownCell else { return }
              guard let self = self else { return }
              let img = DropDownImg[index]
              cell.logoImageView.image = UIImage(named: img)
          }
          
          // Handle selection
        dropDown.selectionAction = { [weak self] (index: Int, item: String) in
            guard let self = self else { return }
            print(index)
            if index == 0 {
                self.LogOutPopupV.isHidden = false
            }else {
                self.DeleteAccPopupV.isHidden = false
            }
        }
          dropDown.show()
    }
    
    // Logout popup view btns.
    
    @IBAction func LogoutCancelBtn(_ sender: UIButton) {
        self.LogOutPopupV.isHidden = true
    }
    
    @IBAction func LogoutYesBtn(_ sender: UIButton) {
        self.Api_To_LogOut()
    }
    
    //
    
    
    // Delete Acc. popup view btns.
    
    @IBAction func DeleteAccCancelBtn(_ sender: UIButton) {
        self.DeleteAccPopupV.isHidden = true
    }
    
    @IBAction func DeleteAccYesBtn(_ sender: UIButton) {
        self.Api_To_DeleteAcc()
    }
    
    //
    
    @IBAction func UploadProfileBtn(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "EditProfioeVC") as! EditProfioeVC
        vc.name = self.Namelbl.text!
        vc.image = self.ProgImg.image
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    @IBAction func EditProfileBtn(_ sender: UIButton) {
     //   self.ProfileBgV.backgroundColor = colorArray[1]
        
        //self.SaveBtnO.isHidden = false
       // self.EditTargetsBtnO.isHidden = false
       // self.DescTxtV.isUserInteractionEnabled = true
//        self.CalImg.image = imageArr[0]
//        self.FatImg.image = imageArr[1]
//        self.CarbsImg.image = imageArr[2]
//        self.ProtineImg.image = imageArr[3]
    }
    
    @IBAction func EditTargetsBtn(_ sender: UIButton) {
        self.TArgetsBgV.backgroundColor = colorArray[1]
        self.CalImg.image = imageArr[0]
        self.FatImg.image = imageArr[1]
        self.CarbsImg.image = imageArr[2]
        self.ProtineImg.image = imageArr[3]
        
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "HealthDataVC") as! HealthDataVC
        vc.comesFrom = "Profile"
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func SaveBtn(_ sender: UIButton) {
        self.Api_To_Upload_ProfileData()
    }
    
     
    
    
    @IBAction func AllBtns(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            let storyboard = UIStoryboard(name: "Profile", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "WalletVC") as! WalletVC 

            self.navigationController?.pushViewController(vc, animated: true)
            break
        case 1:
            let storyboard = UIStoryboard(name: "Profile", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "OrderHistoryVC") as! OrderHistoryVC
            vc.comesfrom = "Profile"
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case 2:
            let storyboard = UIStoryboard(name: "Profile", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "PreferencesVC") as! PreferencesVC
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case 3:
            let storyboard = UIStoryboard(name: "Profile", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "HealthDataVC") as! HealthDataVC
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case 4:
            let storyboard = UIStoryboard(name: "Profile", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "NotificationVC") as! NotificationVC
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case 5:
            if sender.isSelected{
                sender.isSelected = false
                self.TermsCondBgV.isHidden = true
                self.PrivacyPolyBgV.isHidden = true
                self.AboutAppDropImg.image = UIImage(named: "Vector(6.1)")
               
            }else{
                sender.isSelected = true
                self.TermsCondBgV.isHidden = false
                self.PrivacyPolyBgV.isHidden = false
                self.AboutAppDropImg.image = UIImage(named: "Vector(6.2)")
              
            }
            break
        case 6:
            let storyboard = UIStoryboard(name: "Profile", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "Terme_PrivacyPVC") as! Terme_PrivacyPVC
            vc.comesFrom = "TNC"
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case 7:
            let storyboard = UIStoryboard(name: "Profile", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "Terme_PrivacyPVC") as! Terme_PrivacyPVC
            vc.comesFrom = "PP"
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case 8:
            let storyboard = UIStoryboard(name: "Profile", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "FeedBackVC") as! FeedBackVC
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case 9:
            let storyboard = UIStoryboard(name: "Subscription", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "SubscriptionVC") as! SubscriptionVC
            vc.comesFrom = "Profile"
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
            break
        default:
            break
        }
    }
    
    
}


extension ProfileVC {
    func Api_To_Upload_ProfileData(){
        var params = [String: Any]()
       
        params["gender"] = self.gender
        params["name"] = self.Namelbl.text!
        params["bio"] = self.DescTxtV.text!
        params["dob"] = self.dob
        params["height"] = self.height
        params["height_type"] = self.height_type
        params["activity_level"] = self.activity_level
        params["calories"] = Int(self.CalTxtF.text!) ?? 0
        params["fat"] = Int(self.FatTxtF.text!) ?? 0
        params["carbs"] = Int(self.CarbsTxtF.text!) ?? 0
        params["protien"] = Int(self.ProtienTxtF.text!) ?? 0
        params["height_protein"] = self.HeighProtine
        
        
        let imgData = self.ProgImg.image?.jpegData(compressionQuality: 0.5)
    
        
        showIndicator(withTitle: "", and: "")
        
        let loginURL = baseURL.baseURL + appEndPoints.UpdateProfile
        print(params,"Params")
        print(loginURL,"loginURL")
        
        WebService.shared.uploadImageWithParameter(request: loginURL, image: imgData, VC: self, parameters: params, imageName: "profile_img", withCompletion: { (json, statusCode) in
          
            self.hideIndicator()
            
            guard let dictData = json.dictionaryObject else{
                return
            }
            
            if dictData["success"] as? Bool == true{
               // self.DoneBtnO.isHidden = true
                let responseMessage = dictData["message"] as? String ?? ""
                self.showToast(responseMessage)
                
                planService.shared.Api_To_Get_ProfileData(vc: self) { result in
                    
                    switch result {
                    case .success(let allData):
                        let response = allData
                        
                        let Name = response?["name"] as? String ?? String()
                        self.Namelbl.text = Name.capitalizedFirst
                        
                        let ProfImg = response?["profile_img"] as? String ?? String()
                        let img = URL(string: baseURL.imageUrl + ProfImg)
                        
                        self.ProgImg.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
                        self.ProgImg.sd_setImage(with: img, placeholderImage: UIImage(named: "user"))
                        
                        let bio = response?["bio"] as? String ?? ""
                        if bio != ""{
                            self.DescTxtV.text = bio
                        }else{
                            self.DescTxtV.text = "NA"
                        }
                        
                        let calories = response?["calories"] as? Int ?? Int()
                        self.CalTxtF.text = "\(calories)"
                        
                        let fat = response?["fat"] as? Int ?? Int()
                        self.FatTxtF.text = "\(fat)"
                        
                        let carbs = response?["carbs"] as? Int ?? Int()
                        self.CarbsTxtF.text = "\(carbs)"
                        
                        let protien = response?["protein"] as? Int ?? Int()
                        self.ProtienTxtF.text = "\(protien)"
                        
                        let dob = response?["dob"] as? String ?? String()
                        self.dob = dob
                       
                        
                         
                        // let Email = response["email"] as? String ?? String()
                        let gender = response?["gender"] as? String ?? String()
                        self.gender = gender
                        
                        let height = response?["height"] as? String ?? String()
                        self.height = height
                        
                        let height_type = response?["height_type"] as? String ?? String()
                        self.height_type = height_type
                        
                        let activity_level = response?["activity_level"] as? String ?? String()
                        self.activity_level = activity_level
                        
                        let height_protein = response?["height_protein"] as? String ?? String()
                        self.HeighProtine = height_protein
                    case .failure(let error):
                        // Handle error
                        print("Error retrieving data: \(error.localizedDescription)")
                    }
                }
                 
                self.ProfileBgV.backgroundColor = self.colorArray[0]
                self.TArgetsBgV.backgroundColor = self.colorArray[0]
                self.CalTxtF.isUserInteractionEnabled = false
                self.FatTxtF.isUserInteractionEnabled = false
                self.CarbsTxtF.isUserInteractionEnabled = false
                self.ProtienTxtF.isUserInteractionEnabled = false
                self.SaveBtnO.isHidden = true
                self.EditTargetsBtnO.isHidden = true
                self.DescTxtV.isUserInteractionEnabled = false
                
                self.CalImg.image = self.imageArr1[0]
                self.FatImg.image = self.imageArr1[1]
                self.CarbsImg.image = self.imageArr1[2]
                self.ProtineImg.image = self.imageArr1[3]
                
            }else{
                let responseMessage = dictData["message"] as? String ?? ""
                self.showToast(responseMessage)
            }
        })
    }
}

extension ProfileVC {
    func Api_To_LogOut(){
        var params = [String: Any]()
        
      
        showIndicator(withTitle: "", and: "")
        
        let loginURL = baseURL.baseURL + appEndPoints.user_Logout
        print(params,"Params")
        print(loginURL,"loginURL")
        
        WebService.shared.postServiceURLEncoding(loginURL, VC: self, andParameter: params, withCompletion: { (json, statusCode) in
            
            self.hideIndicator()
            
            guard let dictData = json.dictionaryObject else{
                return
            }
            
            if dictData["success"] as? Bool == true{
                self.LogOutPopupV.isHidden = true
                UserDetail.shared.removeUserId()
                UserDetail.shared.removeTokenWith()
                UserDetail.shared.removeUserType()
                UserDetail.shared.setLoginSession(false)
                UserDetail.shared.setisSignInWith("false")
                UserDetail.shared.setiSfromSignup(false)
                UserDetail.shared.setLogoutStatus(true)
                
                StateMangerModelClass.shared.onboardingSelectedData = OnboardingSelectedDataModelClass()
                 
                StateMangerModelClass.shared.onboardingSelectedData.MySelfSeldata.append(
                MyselfModelClass(
                    bodyGoals: "",
                    DietaryPreferences: [],
                    FavCuisines: [],
                    DislikeIngredient: [],
                    AllergensIngredients: [],
                    MealRoutine: [],
                    CookingFrequency: "",
                    SpendingOnGroceries: SpendingOnGroceriesModelClass(Amount: "", duration: ""),
                    EatingOut: "",
                    Takeway: ""
                )
            )
                
                let storyboard = UIStoryboard(name: "Login", bundle: nil)
                   let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                loginVC.hidesBottomBarWhenPushed = true
                   // Set the LoginVC as the root view controller
                   if let navigationController = self.navigationController {
                       navigationController.setViewControllers([loginVC], animated: true)
                   }
            }else{
                let responseMessage = dictData["message"] as? String ?? ""
                self.showToast(responseMessage)
            }
        })
    }
    
    
    func Api_To_DeleteAcc(){
        var params = [String: Any]()
        
  
        showIndicator(withTitle: "", and: "")
        
        let loginURL = baseURL.baseURL + appEndPoints.user_delete
        print(params,"Params")
        print(loginURL,"loginURL")
        
        WebService.shared.postServiceURLEncoding(loginURL, VC: self, andParameter: params, withCompletion: { (json, statusCode) in
            
            self.hideIndicator()
            
            guard let dictData = json.dictionaryObject else{
                return
            }
            
            if dictData["success"] as? Bool == true{
                self.DeleteAccPopupV.isHidden = true
                
                UserDetail.shared.removeUserId()
                UserDetail.shared.removeTokenWith()
                UserDetail.shared.removeUserType()
                UserDetail.shared.setLoginSession(false)
                UserDetail.shared.setisSignInWith("false")
                UserDetail.shared.setLogoutStatus(true)
                UserDetail.shared.setiSfromSignup(false)
                UserDetail.shared.removeUserEmail_Phone()
                UserDetail.shared.removeUserPass()
                
                StateMangerModelClass.shared.onboardingSelectedData = OnboardingSelectedDataModelClass()
                
                
                StateMangerModelClass.shared.onboardingSelectedData.MySelfSeldata.append(
                MyselfModelClass(
                    bodyGoals: "",
                    DietaryPreferences: [],
                    FavCuisines: [],
                    DislikeIngredient: [],
                    AllergensIngredients: [],
                    MealRoutine: [],
                    CookingFrequency: "",
                    SpendingOnGroceries: SpendingOnGroceriesModelClass(Amount: "", duration: ""),
                    EatingOut: "",
                    Takeway: ""
                )
            )
                
                let storyboard = UIStoryboard(name: "Login", bundle: nil)
                   let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                loginVC.hidesBottomBarWhenPushed = true
                   // Set the LoginVC as the root view controller
                   if let navigationController = self.navigationController {
                       navigationController.setViewControllers([loginVC], animated: true)
                   }
 
            }else{
                let responseMessage = dictData["message"] as? String ?? ""
                self.showToast(responseMessage)
            }
        })
    }
}

extension ProfileVC{
    // Delegate method to receive location updates
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            if let location = locations.first {
                let latitude = location.coordinate.latitude
                let longitude = location.coordinate.longitude
                print("Latitude: \(latitude), Longitude: \(longitude)")
                
                self.lat = latitude
                self.longi = longitude
                // Stop updating to save battery (optional)
                locationManager.stopUpdatingLocation()
            }
        }
        
        // Handle location manager errors
        func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            print("Failed to find location: \(error.localizedDescription)")
        }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // Check the authorization status first
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            // Safe to start location updates
            DispatchQueue.main.async {
                self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
                self.locationManager.startUpdatingLocation()
            }
        }
    }

    // Check if location services are enabled before requesting location
    func requestLocationPermission() {
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.delegate = self
            self.locationManager.requestWhenInUseAuthorization() // or requestAlwaysAuthorization depending on your needs
        }
    }
}
