//
//  HomeVC.swift
//  Myka App
//
//  Created by YES IT Labs on 03/12/24.
//

import UIKit
import Alamofire
import SDWebImage
import CoreLocation

 
struct SelectSuperMarketModel {
    var name: String
    var image: UIImage?
    var price: String
    var isSelected: Bool = false
}
 
class HomeVC: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var cookingDatelbl: UILabel!
    @IBOutlet weak var NameLbl: UILabel!
    @IBOutlet weak var PlanMealBgV: UIView!
    @IBOutlet weak var RecipesCollV: UICollectionView!
    @IBOutlet weak var RecipesCookedlBgV: UIView!
    @IBOutlet weak var CookedMealSeeAllBgV: UIView!
    @IBOutlet weak var StartTrailBgV: UIView!
    
    @IBOutlet weak var MonthlySavingBtn: UIView!
    @IBOutlet weak var MonthlyCheckSavingBgV: UIView!
    //select super market popup view.
    @IBOutlet weak var SuperMarketPopUpBGV: UIView!
    @IBOutlet var SelectSuperMarketPopupV: UIView!
    @IBOutlet weak var SelectSuperMarketCollV: UICollectionView!
    
    @IBOutlet weak var MonthlyCheckSavingDetailsLbl: UILabel!
    //
    
    @IBOutlet weak var FridgeBreakFastLbl: UILabel!
    @IBOutlet weak var FridgeLunchLbl: UILabel!
    @IBOutlet weak var FridgeDinnerLbl: UILabel!
    @IBOutlet weak var FridgeSnacksLbl: UILabel!
    @IBOutlet weak var FridgeTeaTimeLbl: UILabel!
    
    @IBOutlet weak var FreezerBreakFastLbl: UILabel!
    @IBOutlet weak var FreezerLunchLbl: UILabel!
    @IBOutlet weak var FreezerDinnerLbl: UILabel!
    @IBOutlet weak var FreezerSnacksLbl: UILabel!
    @IBOutlet weak var FreezerTeaTimeLbl: UILabel!
   
   
    let locationManager = CLLocationManager()
    
    var lat: Double? = nil
    var longi: Double? = nil
      
    var name: String = ""
    
    var SuperMarketArr = [MarketModel]()
    var recipeCookedData = [UserDatum]()
    var SavedAddressList = [AddressdataModel]()
     
    var SuperMarketTag: Int = 1
    var currentPage = 1
    var hasReachedEnd = false
    var lastContentOffset: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.PlanMealBgV.isHidden = false
        self.RecipesCookedlBgV.isHidden = true
        self.CookedMealSeeAllBgV.isHidden = true
        self.MonthlySavingBtn.isHidden = false
        self.MonthlyCheckSavingBgV.isHidden = true
        
        self.SelectSuperMarketPopupV.frame = self.view.bounds
        self.view.addSubview(SelectSuperMarketPopupV)
        self.SelectSuperMarketPopupV.isHidden = true
   #if DEBUG
    startSubscriptionTimer()
    #endif
      //  self.Api_To_get_SavedAddress()
        
        HomeService.shared.Api_To_get_SavedAddress(vc: self) { result in
            switch result {
            case .success(let allData):
                self.addressDataFetch(Result: allData)
            case .failure(let error):
                // Handle error
                print("Error retrieving data: \(error.localizedDescription)")
            }
        }
        
        RecipesCollV.register(UINib(nibName: "RecipesCollVCell", bundle: nil), forCellWithReuseIdentifier: "RecipesCollVCell")
        RecipesCollV.delegate = self
        RecipesCollV.dataSource = self
        
        SelectSuperMarketCollV.register(UINib(nibName: "MarketCollVCell", bundle: nil), forCellWithReuseIdentifier: "MarketCollVCell")
        SelectSuperMarketCollV.delegate = self
        SelectSuperMarketCollV.dataSource = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(listnerFunctionUserr(_:)), name: NSNotification.Name(rawValue: "notificationNameUserr"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(listnerFunctionAddRecipe(_:)), name: NSNotification.Name(rawValue: "notificationNameAddRecipeH"), object: nil)
    }
 
    
    @objc func listnerFunctionUserr(_ notification: NSNotification) {
        let ID = notification.userInfo?["CookbooksID"] as? String ?? ""
       let screen = notification.userInfo?["ScreenName"] as? String ?? ""
        let ItmName = notification.userInfo?["ItmName"] as? String ?? ""
        
        if screen == "CookBooksType"{
            let storyboard = UIStoryboard(name: "RestScreens", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "CookBooksTypeVc") as! CookBooksTypeVc
            vc.titleTxt = ItmName
            vc.type = ID
            vc.comesfromInvite = true
            navigationController?.pushViewController(vc, animated: true)
        }
    }
 
    
    @objc func listnerFunctionAddRecipe(_ notification: NSNotification) {
        if let data = notification.userInfo?["data"] as? String {
            if data == "AddRecipePopup"{
                let storyboard = UIStoryboard(name: "Tabbar", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "AddRecipePopUpVC") as! AddRecipePopUpVC
                vc.BackAction = {str in
                    self.tabBarController?.tabBar.isHidden = false
                }
                self.tabBarController?.tabBar.isHidden = true
               // self.present(vc, animated: true)
                
                self.addChild(vc)
                vc.view.frame = self.view.frame
                self.view.addSubview(vc.view)
                self.view.bringSubviewToFront(vc.view)
                vc.didMove(toParent: self)
            }
          }
        }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if StateMangerModelClass.shared.tg == "1" {
            self.PlanMealBgV.isHidden = true
            self.RecipesCookedlBgV.isHidden = false
            self.CookedMealSeeAllBgV.isHidden = false
            self.MonthlySavingBtn.isHidden = true
            self.MonthlyCheckSavingBgV.isHidden = false
        }
        
        if  StateMangerModelClass.shared.subs == "1"{
            self.StartTrailBgV.isHidden = true
        }
        
        HomeService.shared.getHomeData(vc: self) { result in
            
            switch result {
            case .success(let allData):
                self.HomeDataFetch(result: allData)
            case .failure(let error):
                // Handle error
                print("Error retrieving data: \(error.localizedDescription)")
            }
        }
         
        HomeService.shared.Api_To_Get_ProfileData(vc: self) { result in
            // Handle the result
            switch result {
            case .success(let profileData):
                // Process the profile data
                print("Successfully retrieved profile data: \(profileData)")
                self.profileDataFetch(Result: profileData)
            case .failure(let error):
                // Handle the error
                print("Error retrieving profile data: \(error.localizedDescription)")
            }
        }

      }
         
    func startSubscriptionTimer() {
        // Invalidate any existing timer to prevent duplicates
        print("Subscription details timer is started.")
        StateMangerModelClass.shared.subscriptionApiTimer?.invalidate()
        
        // Use a weak reference to avoid retain cycles
        StateMangerModelClass.shared.subscriptionApiTimer = Timer.scheduledTimer(withTimeInterval: 2.5, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            // Ensure the user is logged in
            guard UserDetail.shared.getTokenWith() != "" else {
                print("User is not logged in. Stopping timer.")
                StateMangerModelClass.shared.subscriptionApiTimer?.invalidate()
                StateMangerModelClass.shared.subscriptionApiTimer = nil
                return
            }
            
            // Perform the task asynchronously
            DispatchQueue.global(qos: .userInteractive).async {
                // self.Api_To_getSubscriptionDeltails()
                HomeService.shared.Api_To_getSubscriptionDeltails(vc: self){ result in
                    switch result {
                    case .success(let allData):
                        let val = allData
                        let urlSearch = val["urlSearch"] as? Int ?? 0
                        let favorite = val["favorite"] as? Int ?? 0
                        let addmeal = val["addmeal"] as? Int ?? 1 // 1 means limit exceed
                        let imageSearch = val["imageSearch"] as? Int ?? 0
                        let SubscriptionStatus = val["Subscription_status"] as? Int ?? 1 // 1 means no subscription.
                        
                        UserDetail.shared.setfavorite("\(favorite)")
                        UserDetail.shared.setaddmeal("\(addmeal)")
                        UserDetail.shared.seturlSearch("\(urlSearch)")
                        UserDetail.shared.setimageSearch("\(imageSearch)")
                        UserDetail.shared.setSubscriptionStatus("\(SubscriptionStatus)")
                        
                        if SubscriptionStatus == 1{// 1 means no subscription available.
                            self.StartTrailBgV.isHidden = false
                        }else{
                            self.StartTrailBgV.isHidden = true
                        }
                    case .failure(let error):
                        // Handle error
                        print("Error retrieving data: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
    @IBAction func ProfileBtn(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
     //
    @IBAction func SelectMarketDoneBtn(_ sender: UIButton) {
        if SuperMarketArr.allSatisfy({ ($0.isSlected) == 0 }) {
            // All items are unselected
            AlertControllerOnr(title: "", message: "Please select at least one market.")
        } else {
            //   self.Api_To_UpdateSuperMarket()
            var selectedStoreID  = ""
            var StoreName = ""
            
            for itm in SuperMarketArr {
                if itm.isSlected == 1 {
                    selectedStoreID  = itm.storeUUID ?? ""
                    StoreName = itm.storeName ?? ""
                }
            }
            
            
            HomeService.shared.Api_To_UpdateSuperMarket(vc: self, selectedStoreID: selectedStoreID, StoreName: StoreName) { result in
                
                switch result {
                case .success(_):
                    HomeService.shared.getHomeData(vc: self) { result in
                        switch result {
                        case .success(let allData):
                            self.HomeDataFetch(result: allData)
                        case .failure(let error):
                            // Handle error
                            print("Error retrieving data: \(error.localizedDescription)")
                        }
                    }
                case .failure(let error):
                    // Handle error
                    print("Error retrieving data: \(error.localizedDescription)")
                }
            }
        }
    }
    //
    
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
    
    @IBAction func PlanAMealBtn(_ sender: UIButton) {
        StateMangerModelClass.shared.SearchClickFromPopup = true
        if let tabBar = self.tabBarController?.tabBar,
           let items = tabBar.items,
           items.count > 4 {
            let item = items[3] // Get the UITabBarItem at index 4
            self.tabBarController?.tabBar(tabBar, didSelect: item)
            self.tabBarController?.selectedIndex = 3
        }
    }
    
    @IBAction func SeeAllBtn(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Tabbar", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "FullCookingScheduleVC") as! FullCookingScheduleVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func CookedMealSeeAllBtn(_ sender: UIButton) {
        CookedMealSeeAllBgV.isHidden = false
        if let tabBar = tabBarController?.tabBar,
           let items = tabBar.items,
           items.count > 4 {
            let item = items[4] // Get the UITabBarItem at index 4
            tabBarController?.tabBar(tabBar, didSelect: item)
            tabBarController?.selectedIndex = 4
        }
    }
    
    
    @IBAction func CookedMealAddBtn(_ sender: UIButton) {
        CookedMealSeeAllBgV.isHidden = false
        if let tabBar = tabBarController?.tabBar,
           let items = tabBar.items,
           items.count > 4 {
            let item = items[4] // Get the UITabBarItem at index 4
            tabBarController?.tabBar(tabBar, didSelect: item)
            tabBarController?.selectedIndex = 4
        }
    }
    
    @IBAction func MonthlySavingBtn(_ sender: UIButton) {
        StateMangerModelClass.shared.SearchClickFromPopup = true
        if let tabBar = tabBarController?.tabBar,
           let items = tabBar.items,
           items.count > 4 {
            let item = items[3] // Get the UITabBarItem at index 4
            tabBarController?.tabBar(tabBar, didSelect: item)
            tabBarController?.selectedIndex = 3
        }
    }
    
    
    @IBAction func MonthlySavingCheckSavingBtn(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "RestScreens", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "StatsVC") as! StatsVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func StartTrailBtn(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Subscription", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SubscriptionVC") as! SubscriptionVC
        vc.comesFrom = "Profile"
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension HomeVC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == RecipesCollV{
            return self.recipeCookedData.count
        }else{
            return SuperMarketArr.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == RecipesCollV{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecipesCollVCell", for: indexPath) as! RecipesCollVCell
            //
            
            let allRecipeData = recipeCookedData[indexPath.row].recipe
            cell.NameLbl.text = allRecipeData?.label
            cell.MinLbl.text = "0 min"
         
            let islike = recipeCookedData[indexPath.row].isLike
            
            if islike == 1{
                cell.FavBtn.setImage(UIImage(named: "Fav"), for: .normal)
            }else{
                cell.FavBtn.setImage(UIImage(named: "UnFav"), for: .normal)
            }
            
            let isMissing = recipeCookedData[indexPath.row].isMissing
            
            if isMissing == 0 {
                cell.CheckImg.image = UIImage(named: "Missing")
                cell.CheckBtn.isUserInteractionEnabled = true
                cell.CheckBtn.tag = indexPath.row
                cell.CheckBtn.addTarget(self, action: #selector(missingIngrenients(sender:)), for: .touchUpInside)
            }else{
                cell.CheckBtn.isUserInteractionEnabled = false
                cell.CheckImg.image = UIImage(named: "CheckFill")
            }
            
            let imgUrl =  allRecipeData?.images?.small?.url ?? ""
            
            cell.IMg.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
            cell.IMg.sd_setImage(with: URL(string: imgUrl), placeholderImage: UIImage(named: "No_Image"))
            
            cell.FavBtn.tag = indexPath.item
            cell.FavBtn.addTarget(self, action: #selector(AddFavBtnClick(_:)), for: .touchUpInside)
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MarketCollVCell", for: indexPath) as! MarketCollVCell
            
            let Imgurl = SuperMarketArr[indexPath.item].image ?? ""
            let URL = URL(string: Imgurl)
            
            cell.Img.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
            cell.Img.sd_setImage(with: URL, placeholderImage: UIImage(named: "Market5"))
            cell.NameLbl.text = SuperMarketArr[indexPath.item].storeName
            cell.PriceLbl.text = ""//SuperMarketArr[indexPath.item].price
            
            let Dist = SuperMarketArr[indexPath.item].distance ?? ""
            let FDist = formatQuantity(Dist)
            cell.MileLbl.text = "\(FDist) miles"
            
            if SuperMarketArr[indexPath.item].isSlected == 1 {
                cell.BgV.borderColor = #colorLiteral(red: 0.9960784314, green: 0.6235294118, blue: 0.2705882353, alpha: 1)
                cell.BgV.borderWidth = 2
            }else{
                cell.BgV.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                cell.BgV.borderWidth = 0
            }
            
            if SuperMarketArr[indexPath.item].isOpen == true{
                cell.ClosedBgV.isHidden = true
            }else{
                cell.ClosedBgV.isHidden = false
                
                let val = SuperMarketArr[indexPath.item].operationalHours ?? nil
               
                let today = Date()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "EEEE"
                let CurrentDay = dateFormatter.string(from: today)
                 
                var todayHours: String?
                
                switch CurrentDay {
                case "Sunday":
                    todayHours = val?.sunday
                case "Monday":
                    todayHours = val?.monday
                case "Tuesday":
                    todayHours = val?.tuesday
                case "Wednesday":
                    todayHours = val?.wednesday
                case "Thursday":
                    todayHours = val?.thursday
                case "Friday":
                    todayHours = val?.friday
                case "Saturday":
                    todayHours = val?.saturday
                default:
                    todayHours = nil
                }
                 
              
                if let hours = todayHours {
                       print("Today's operational hours: \(hours)")
                    let firstPart = hours.components(separatedBy: " - ").first ?? ""
                       cell.ClosedLbl.text = "Closed now\nOpen at \(firstPart)"
                   } else {
                       print("No operational hours found for \(CurrentDay).")
                   }
            }
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == RecipesCollV{
            let storyboard = UIStoryboard(name: "Tabbar", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "RecipeDetailsVC") as! RecipeDetailsVC
            vc.uri = recipeCookedData[indexPath.row].recipe?.uri ?? ""
            
            let string = recipeCookedData[indexPath.row].recipe?.mealType?.first ?? ""
            if let result = string.components(separatedBy: "/").first {
                vc.MealType = result
            }
            
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            for indx in 0..<SuperMarketArr.count{
                SuperMarketArr[indx].isSlected = 0
            }
//            if SuperMarketArr[indexPath.item].isSelected == true {
//                SuperMarketArr[indexPath.item].isSelected = false
//            }else{
                SuperMarketArr[indexPath.item].isSlected = 1
       //     }
            
            self.SelectSuperMarketCollV.reloadData()
        }
    }
    
    @objc func AddFavBtnClick(_ sender: UIButton)   {
        let index  = sender.tag
        let uri = self.recipeCookedData[index].recipe?.uri ?? ""
        let selID = "\(self.recipeCookedData[index].id ?? 0)"
        
        let islike = recipeCookedData[index].isLike
        
        let SubscriptionStatus = Int(UserDetail.shared.getSubscriptionStatus())
        
        if SubscriptionStatus == 1{
            let addtoplanStatus = Int(UserDetail.shared.getfavorite()) ?? 0
            guard addtoplanStatus <= 2 else {
                SubscriptionPopUp ()
                return
            }
        }
        
        if islike == 1{
          //  self.Api_To_UnFAv(uri: uri)
            HomeService.shared.Api_To_UnFAv(uri: uri, vc: self) { result in
                switch result {
                case .success(let respone):
                    // Process the profile data
                    print("Successfully retrieved unfav data: \(respone)")
                    HomeService.shared.getHomeData(vc: self) { result in
                        switch result {
                        case .success(let allData):
                            self.HomeDataFetch(result: allData)
                        case .failure(let error):
                            // Handle error
                            print("Error retrieving data: \(error.localizedDescription)")
                        }
                    }
                    
                case .failure(let error):
                    // Handle the error
                    print("Error retrieving profile data: \(error.localizedDescription)")
                }
            }
        }else{
            
            
            self.FavBtnClickNav(TypeClicked: "Favorite", Uri: uri, SelID: selID)
        }
    }
    
    func FavBtnClickNav(TypeClicked: String, Uri: String, SelID: String)   {
        let storyboard = UIStoryboard(name: "Tabbar", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "FavrouitPopupVC") as! FavrouitPopupVC
        vc.comesFrom = "FullCookingScheduleVC"
        vc.uri = Uri
        vc.selID = SelID
        vc.typeclicked = TypeClicked
        vc.backAction = {
            HomeService.shared.getHomeData(vc: self) { result in
                
                switch result {
                case .success(let allData):
                    self.HomeDataFetch(result: allData)
                case .failure(let error):
                    // Handle error
                    print("Error retrieving data: \(error.localizedDescription)")
                }
            }
        }
        self.addChild(vc)
        vc.view.frame = self.view.frame
        self.view.addSubview(vc.view)
        self.view.bringSubviewToFront(vc.view)
        vc.didMove(toParent: self)
    }
    
    @objc func missingIngrenients(sender: UIButton){
        var mealtype = ""
        let string = self.recipeCookedData[sender.tag].recipe?.mealType?.first ?? ""
        if let result = string.components(separatedBy: "/").first {
            mealtype = result
        }else{
            mealtype = string
        }
        
        let storyboard = UIStoryboard(name: "Tabbar", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MissingIngredientsVC") as! MissingIngredientsVC
        vc.uri = recipeCookedData[sender.tag].recipe?.uri ?? ""
        vc.sch_id = "\(recipeCookedData[sender.tag].id ?? 0)"
        vc.mealtype = mealtype
        vc.backAction = {
           // self.getHomeData()
        }
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
    
        //
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == RecipesCollV{
                return CGSize(width: collectionView.frame.width/2 - 5, height: collectionView.frame.height)
        }else{
            return CGSize(width: collectionView.frame.width/3 - 5, height: 155)
        }
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
    
    // UIScrollViewDelegate method for detecting scroll
 
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height

        // Detect scrolling direction
        let isScrollingDown = offsetY > lastContentOffset
        lastContentOffset = offsetY

        // Define a buffer to detect nearing the bottom
        let buffer: CGFloat = 0.0 // Adjust as needed

        if isScrollingDown {
            // Reached near the bottom
            if offsetY >= contentHeight - frameHeight - buffer && !hasReachedEnd {
                hasReachedEnd = true
                print("Reached bottom")
              //  self.getSuperMarketData()
                HomeService.shared.getSuperMarketData(vc: self, currentPage: self.currentPage){ result in
                    switch result {
                    case .success(let allData):
                        self.MarketDataFetch(Result: allData)
                    case .failure(let error):
                        // Handle error
                        print("Error retrieving data: \(error.localizedDescription)")
                    }
                }
            }
        } else {
            // Detect scrolling out of bottom
            if hasReachedEnd && offsetY < contentHeight - frameHeight - buffer {
                hasReachedEnd = false
                print("Scrolled out of bottom")
                // Add actions for scrolling out of bottom if needed
            }
        }
    }
}

extension HomeVC{
    func HomeDataFetch(result: DataClass?) {
        let allData = result
        
        let monthly_savings = allData?.monthly_savings
        
        let fridgeMeal = allData?.fridge
        self.FridgeLunchLbl.text = "\(fridgeMeal?.lunch ?? 0)"
        self.FridgeBreakFastLbl.text = "\(fridgeMeal?.breakfast ?? 0)"
        self.FridgeDinnerLbl.text = "\(fridgeMeal?.dinner ?? 0)"
        self.FridgeSnacksLbl.text = "\(fridgeMeal?.snacks ?? 0)"
        self.FridgeTeaTimeLbl.text = "\(fridgeMeal?.teatime ?? 0)"
        
        let freezerMeal = allData?.frezzer
        self.FreezerLunchLbl.text = "\(freezerMeal?.lunch ?? 0)"
        self.FreezerBreakFastLbl.text = "\(freezerMeal?.breakfast ?? 0)"
        self.FreezerDinnerLbl.text = "\(freezerMeal?.dinner ?? 0)"
        self.FreezerSnacksLbl.text = "\(freezerMeal?.snacks ?? 0)"
        self.FreezerTeaTimeLbl.text = "\(freezerMeal?.teatime ?? 0)"
        
        self.recipeCookedData.removeAll()
        self.recipeCookedData = allData?.userData ?? []
        
        let NextDate = allData?.date ?? ""
        if NextDate != ""{
            let fullText = "Next meal to be cooked on \(NextDate)"
            let highlightText = "\(NextDate)"
            
            // Create attributes for the full text
            let fullAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont(name: "Poppins Regular", size: 16.0) ?? UIFont.systemFont(ofSize: 16),
                .foregroundColor: #colorLiteral(red: 0.2352941176, green: 0.2705882353, blue: 0.2549019608, alpha: 1)
            ]
            
            // Create attributes for the highlighted part
            let highlightAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont(name: "Poppins SemiBold", size: 16.0) ?? UIFont.systemFont(ofSize: 16.0),
                .foregroundColor: #colorLiteral(red: 0.02352941176, green: 0.7568627451, blue: 0.4117647059, alpha: 1)
            ]
            
            // Create a mutable attributed string
            let attributedString = NSMutableAttributedString(string: fullText, attributes: fullAttributes)
            
            // Find the range of the highlight text
            if let range = fullText.range(of: highlightText) {
                let nsRange = NSRange(range, in: fullText)
                attributedString.addAttributes(highlightAttributes, range: nsRange)
            }
            
            self.cookingDatelbl.attributedText = attributedString
        }
        
        if fridgeMeal?.breakfast != 0 || fridgeMeal?.lunch != 0 || fridgeMeal?.dinner != 0 || fridgeMeal?.snacks != 0 || fridgeMeal?.teatime != 0 || freezerMeal?.breakfast != 0 || freezerMeal?.lunch != 0 || freezerMeal?.dinner != 0 || freezerMeal?.snacks != 0 || freezerMeal?.teatime != 0{
            self.CookedMealSeeAllBgV.isHidden = false
        }else{
            self.CookedMealSeeAllBgV.isHidden = true
        }
        
        if allData?.userData?.count != 0{
            self.RecipesCookedlBgV.isHidden = false
            self.PlanMealBgV.isHidden = true
            self.RecipesCollV.reloadData()
        }else{
            self.RecipesCookedlBgV.isHidden = true
            self.PlanMealBgV.isHidden = false
        }
        
        if allData?.graphValue ?? 0 == 1{
            self.MonthlyCheckSavingBgV.isHidden = true
            self.MonthlySavingBtn.isHidden = false
        }else{
            self.MonthlyCheckSavingBgV.isHidden = false
            self.MonthlySavingBtn.isHidden = true
            
            self.MonthlyCheckSavingDetailsLbl.text = "Good job \(self.name), you are on track to save \(monthly_savings ?? "$0") this month"
        }
    }
    
    func profileDataFetch(Result: NSDictionary){
        let response = Result
        let Name = response["name"] as? String ?? String()
        self.name = Name.capitalizedFirst
        
        let Attributes1: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.init(red: 6/255, green: 193/255, blue: 105/255, alpha: 1)
        ]
        
        let Attributes2: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.black
        ]
        
        let helloString = NSAttributedString(string: "Hello, ", attributes: Attributes1)
        let worldString = NSAttributedString(string: Name.capitalizedFirst, attributes: Attributes2)
        let fullString = NSMutableAttributedString()
        fullString.append(helloString)
        fullString.append(worldString)
        
        self.NameLbl.attributedText = fullString
        
        let ProfImg = response["profile_img"] as? String ?? String()
        let img = URL(string: baseURL.imageUrl + ProfImg)
        
        self.profileImg.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
        self.profileImg.sd_setImage(with: img, placeholderImage: UIImage(named: "DummyImg"))
    }
    
    
    func addressDataFetch(Result: [AddressdataModel]?){
        self.SavedAddressList = Result ?? []
        
        if let indx = self.SavedAddressList.firstIndex(where: {$0.primary == 1}){
            let latitude = self.SavedAddressList[indx].latitude ?? ""
            let longitude = self.SavedAddressList[indx].longitude ?? ""
            print("Latitude: \(latitude), Longitude: \(longitude)")
            
            AppLocation.lat = "\(latitude)"
            AppLocation.long = "\(longitude)"
            
            if UserDetail.shared.getiSfromSignup() == true{
                DispatchQueue.global(qos: .userInitiated).async {
                    if AppLocation.lat != "" && AppLocation.long != ""{
                        // self.getSuperMarketData()
                        
                        HomeService.shared.getSuperMarketData(vc: self, currentPage: self.currentPage){ result in
                            switch result {
                            case .success(let allData):
                                self.MarketDataFetch(Result: allData)
                            case .failure(let error):
                                // Handle error
                                print("Error retrieving data: \(error.localizedDescription)")
                            }
                        }
                        
                    }else{
                        self.locationManager.delegate = self
                    }
                }
            }
            
        }else{
            self.locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func MarketDataFetch(Result: [MarketModel]?){
        
        self.SuperMarketArr.append(contentsOf: Result ?? [])
        
        self.SuperMarketArr = self.SuperMarketArr.filter { store in
            store.total != nil && store.total != 0.0
        }
        
        self.hasReachedEnd = false
        
        if self.SuperMarketArr.count == 0 {
            self.SelectSuperMarketPopupV.isHidden = true
            self.showToast("There is no store available near your location.")
        }else{
            self.SelectSuperMarketPopupV.isHidden = false
        }
        
        self.SelectSuperMarketCollV.reloadData()
    }
}
 
 
extension HomeVC{
    // Delegate method to receive location updates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            print("Latitude: \(latitude), Longitude: \(longitude)")
            
            AppLocation.lat = "\(latitude)"
            AppLocation.long = "\(longitude)"
            // Stop updating to save battery (optional)
            locationManager.stopUpdatingLocation()
            
            if self.SavedAddressList.count == 0{
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5){
                    if UserDetail.shared.getiSfromSignup() == true{
                        if AppLocation.lat == "" && AppLocation.long == ""{
                           // self.getSuperMarketData()
                            HomeService.shared.getSuperMarketData(vc: self, currentPage: self.currentPage){ result in
                                switch result {
                                case .success(let allData):
                                    self.MarketDataFetch(Result: allData)
                                case .failure(let error):
                                    // Handle error
                                    print("Error retrieving data: \(error.localizedDescription)")
                                }
                            }
                        }
                        // self.SelectSuperMarketPopupV.isHidden = false
                    }
                }
            }
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
            //  DispatchQueue.main.async {
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            
            if AppLocation.lat == "" && AppLocation.long == ""{
                self.locationManager.startUpdatingLocation()
            }
        }
    }
}
 
