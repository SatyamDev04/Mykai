//
//  PlanVc.swift
//  Myka App
//
//  Created by Sumit on 13/12/24.
//

import UIKit
import CustomBlurEffectView
import Alamofire
import SDWebImage
import SwiftyJSON

class PlanVc: UIViewController {
    
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var NameLbl: UILabel!
    @IBOutlet weak var FromDateToLbl: UILabel!
    @IBOutlet weak var CalanderCollV: UICollectionView!
    @IBOutlet weak var weekLabel: UILabel!
    @IBOutlet weak var BreakFastCollV: UICollectionView!
    @IBOutlet weak var LunchCollV: UICollectionView!
    @IBOutlet weak var DinnerCollV: UICollectionView!
    @IBOutlet weak var TeaTimeCollV: UICollectionView!
    @IBOutlet weak var SnacksCollV: UICollectionView!
    
    @IBOutlet var BreakFastCollVBgV: UIView!
    @IBOutlet var LunchCollVBgV: UIView!
    @IBOutlet var DinnerCollVBgV: UIView!
    @IBOutlet var TeaTimeCollVBgV: UIView!
    @IBOutlet var SnacksCollVBgV: UIView!
    
    @IBOutlet weak var BreakFastBtnBgV: UIView!
    @IBOutlet weak var LunchBtnBgV: UIView!
    @IBOutlet weak var DinnerBtnBgV: UIView!
    @IBOutlet weak var SnacksBtnBgV: UIView!
    @IBOutlet weak var TeaTimeBtnBgV: UIView!
    
    
    
    @IBOutlet weak var BreakFastDishCollV: UICollectionView!
    @IBOutlet weak var LunchDishCollV: UICollectionView!
    @IBOutlet weak var DinnerDishCollV: UICollectionView!
    @IBOutlet weak var TeaTimeDishCollV: UICollectionView!
    @IBOutlet weak var SnacksDishCollV: UICollectionView!
    
    @IBOutlet var BreakFastDishCollVBgV: UIView!
    @IBOutlet var LunchDishCollVBgV: UIView!
    @IBOutlet var DinnerDishCollVBgV: UIView!
    @IBOutlet var TeaTimeDishCollVBgV: UIView!
    @IBOutlet var SnacksDishCollVBgV: UIView!
     
    
    @IBOutlet weak var DailyNutritionCountBgV: UIView!
    
    @IBOutlet weak var CalculateBMRBgV: UIView!
    
    @IBOutlet var BreakfastCookedMealAddBtnO: [UIButton]!
    
    @IBOutlet weak var AddtoBasketBtnO: UIButton!
    
    @IBOutlet weak var CaloriesLbl: UILabel!
    @IBOutlet weak var FatLbl: UILabel!
    @IBOutlet weak var CarbsLbl: UILabel!
    @IBOutlet weak var ProtienLbl: UILabel!
    
    @IBOutlet weak var ScrollV: UIScrollView!
    
    
    // for Choosedays popup
    @IBOutlet var ChoosedaysPopupV: UIView!
    @IBOutlet weak var ChoosedaysTblV: UITableView!
    @IBOutlet weak var ChooseDayWeekLabel: UILabel!
    @IBOutlet weak var ChoosedaysBgV: UIView!
    //
    
    // for ChooseMeal popup
    @IBOutlet var ChooseMealTypePopupV: UIView!
    @IBOutlet weak var ChooseMealTypeTblV: UITableView!
    @IBOutlet weak var ChooseMealTypeBgV: UIView!
    //
    
    // for AddAnotherMeal popup
    @IBOutlet var AddAnotherMealPopupV: UIView!
    @IBOutlet weak var AddAnotherMealBgV: UIView!
    @IBOutlet weak var AddAnotherMeal_Img: UIImageView!
    @IBOutlet weak var AddAnotherMealNameLbl: UILabel!
    @IBOutlet weak var AddAnotherMealTblV: UITableView!
    @IBOutlet weak var AddAnotherMealTblVH: NSLayoutConstraint!
    @IBOutlet weak var AddAnotherMealTypeBtn: UIButton!
    
    
    var isAddAnotherMealPopupVClicked: Bool = false
    //
    
    var typeclicked: String = ""
    //
    
    var currentWeekDates: [Date] = []
    var calendar = Calendar.current
    
    var selectedIndex: IndexPath?
    
    var seldate = Date()
    
    var longPressedEnabled = false
    
    
    
    var BreakfastData = ["Pasta", "BBQ", "stawberry"]
    var LunchData = ["Lasagne", "Pasta", "Bar-B-Q"]
    var DinnerData = ["Lasagne", "stawberry", "Pizza"]
    
    // for popUps
    
    var ChooseDayData = [BodyGoalsModel(Name: "Monday", isSelected: false), BodyGoalsModel(Name: "Tuesday", isSelected: false), BodyGoalsModel(Name: "Wednesday", isSelected: false), BodyGoalsModel(Name: "Thursday", isSelected: false), BodyGoalsModel(Name: "Friday", isSelected: false), BodyGoalsModel(Name: "Saturday", isSelected: false), BodyGoalsModel(Name: "Sunday", isSelected: false)]
    
    var ChooseMealTypeyData = [BodyGoalsModel(Name: "Breakfast", isSelected: false), BodyGoalsModel(Name: "Lunch", isSelected: false), BodyGoalsModel(Name: "Dinner", isSelected: false), BodyGoalsModel(Name: "Snacks", isSelected: false), BodyGoalsModel(Name: "Brunch", isSelected: false)]
    
    // var AddAnotherMealArr = [BodyGoalsModel(Name: "Snacks", isSelected: false), BodyGoalsModel(Name: "Teatime", isSelected: false)]
    //
    
    var AllRecipeSelItem = PlanDataClass()
    
    var AllDataList = YourCookedMealModel() // for by date Api data
    
    // for api use only.
    var uri = ""
    var mealType = ""
    
    // for add AnotherMeal.
    var MealRoutineArr = [ModelClass]()
    var ArrData = [BodyGoalsModel]()
    //
    
    var veryFirstLoading = 0
    
    var SwipeID = ""
    var SwapMealType = ""
    
    // for lazy loading
    var indx = Int()
    var Seltype = ""
    //
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.AddtoBasketBtnO.isUserInteractionEnabled = false
        self.AddtoBasketBtnO.backgroundColor = UIColor.lightGray
        
        self.ChoosedaysPopupV.frame = self.view.bounds
        self.view.addSubview(self.ChoosedaysPopupV)
        self.ChoosedaysPopupV.isHidden = true
        
        self.ChooseMealTypePopupV.frame = self.view.bounds
        self.view.addSubview(self.ChooseMealTypePopupV)
        self.ChooseMealTypePopupV.isHidden = true
        
        self.AddAnotherMealPopupV.frame = self.view.bounds
        self.view.addSubview(self.AddAnotherMealPopupV)
        self.AddAnotherMealPopupV.isHidden = true
        
        
        let customBlurEffectView = CustomBlurEffectView()
        
        if UIDevice.current.hasNotch {
            //... consider notch
            let modelName = UIDevice.modelName
            if modelName.contains(find: "mini"){//"iPhone 12 mini"{
                customBlurEffectView.frame = CGRect(x: 0, y: 0, width: CalculateBMRBgV.frame.width - 15, height: CalculateBMRBgV.frame.height)//BlurView.frame
            }else if modelName.contains(find: "Max"){
                customBlurEffectView.frame = CGRect(x: 0, y: 0, width: CalculateBMRBgV.frame.width + 50, height: CalculateBMRBgV.frame.height)//BlurView.frame
            }else if modelName.contains(find: "Pro"){
                customBlurEffectView.frame = CGRect(x: 0, y: 0, width: CalculateBMRBgV.frame.width + 50, height: CalculateBMRBgV.frame.height)//BlurView.frame
            }else{
                customBlurEffectView.frame = CGRect(x: 0, y: 0, width: CalculateBMRBgV.frame.width + 20, height: CalculateBMRBgV.frame.height)//BlurView.frame
            }
        }else{
            customBlurEffectView.frame = CGRect(x: 0, y: 0, width: CalculateBMRBgV.frame.width + 20, height: CalculateBMRBgV.frame.height)//BlurView.frame
        }
        
        customBlurEffectView.blurRadius = 1.5
        customBlurEffectView.colorTint = .black
        customBlurEffectView.colorTintAlpha = 0.3
        customBlurEffectView.cornerRadius = 10
        customBlurEffectView.layer.masksToBounds = true
        CalculateBMRBgV.addSubview(customBlurEffectView)
        CalculateBMRBgV.sendSubviewToBack(customBlurEffectView)
        
        self.BreakFastCollVBgV.isHidden = false
        self.LunchCollVBgV.isHidden = false
        self.DinnerCollVBgV.isHidden = false
        self.SnacksCollVBgV.isHidden = false
        self.TeaTimeCollVBgV.isHidden = false
        
        self.BreakFastDishCollVBgV.isHidden = true
        self.LunchDishCollVBgV.isHidden = true
        self.DinnerDishCollVBgV.isHidden = true
        self.SnacksDishCollVBgV.isHidden = true
        self.TeaTimeDishCollVBgV.isHidden = true
        
        self.DailyNutritionCountBgV.isHidden = true
        self.CalculateBMRBgV.isHidden = true
        
        calendar.firstWeekday = 2 // Start the week on Monday
        setupInitialWeek()
        setupCollectionView()
        setupTableView()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        ChoosedaysBgV.addGestureRecognizer(tapGesture)
        
        let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(handleTap1(_:)))
        ChooseMealTypeBgV.addGestureRecognizer(tapGesture1)
        
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(handleTap2(_:)))
        AddAnotherMealBgV.addGestureRecognizer(tapGesture2)

        NotificationCenter.default.addObserver(self, selector: #selector(listnerFunction(_:)), name: NSNotification.Name(rawValue: "notificationName"), object: nil)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(listnerFunctionAddRecipe(_:)), name: NSNotification.Name(rawValue: "notificationNameAddRecipeP"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(listnerFunctionRealoadData(_:)), name: NSNotification.Name(rawValue: "notificationNameReloadData"), object: nil)
        
       // self.Api_To_GetAllRecipe()
        planService.shared.Api_To_GetAllRecipe(vc: self) { result in
        
                switch result {
                case .success(let allData):
                    if let list = allData, list.recipes != nil {
                        self.AllRecipeSelItem = list
                       
                        self.ShowNoDataFoundonCollV()
                    }else{
                        self.ShowNoDataFoundonCollV()
                    }
                    
    //                    if self.veryFirstLoading == 1{
    //                        self.veryFirstLoading = 0
                        DispatchQueue.global().asyncAfter(deadline: .now()) {
                                    let dateformatter = DateFormatter()
                                    dateformatter.dateFormat = "yyyy-MM-dd"
                            let Sdate = dateformatter.string(from: self.seldate)
                            planService.shared.Api_To_GetAllRecipeByDate(Sdate: Sdate,vc: self) { result in
                            
                                    switch result {
                                    case .success(let allData):
                                        self.fetchPlanDataByDate(list: allData)
                                    case .failure(let error):
                                        // Handle error
                                        self.ShowNoDataFoundonCollV1()
                                        print("Error retrieving data: \(error.localizedDescription)")
                                    }
                            }
                            
                        }
                case .failure(let error):
                    // Handle error
                    self.ShowNoDataFoundonCollV()
                    print("Error retrieving data: \(error.localizedDescription)")
                }
        }
      //
    }
     
     
     @objc func listnerFunction(_ notification: NSNotification) {
         if let data = notification.userInfo?["data"] as? String {
             if data == "SearchPopup"{
                 let storyboard = UIStoryboard(name: "Tabbar", bundle: nil)
                 let vc = storyboard.instantiateViewController(withIdentifier: "SearchPopUpVC") as! SearchPopUpVC
                 
                 self.addChild(vc)
                 vc.view.frame = self.view.frame
                 self.view.addSubview(vc.view)
                 self.view.bringSubviewToFront(vc.view)
                 vc.didMove(toParent: self)
             }
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
//                self.present(vc, animated: true)
                
                self.addChild(vc)
                vc.view.frame = self.view.frame
                self.view.addSubview(vc.view)
                self.view.bringSubviewToFront(vc.view)
                vc.didMove(toParent: self)
            }
         }
        }
    
    @objc func listnerFunctionRealoadData(_ notification: NSNotification) {
        if let data = notification.userInfo?["data"] as? String {
            print(data)
            planService.shared.Api_To_GetAllRecipe(vc: self) { result in
            
                    switch result {
                    case .success(let allData):
                        if let list = allData, list.recipes != nil {
                            self.AllRecipeSelItem = list
                           
                            self.ShowNoDataFoundonCollV()
                        }else{
                            self.ShowNoDataFoundonCollV()
                        }
                        
        //                    if self.veryFirstLoading == 1{
        //                        self.veryFirstLoading = 0
                            DispatchQueue.global().asyncAfter(deadline: .now()) {
                                let dateformatter = DateFormatter()
                                dateformatter.dateFormat = "yyyy-MM-dd"
                        let Sdate = dateformatter.string(from: self.seldate)
                        planService.shared.Api_To_GetAllRecipeByDate(Sdate: Sdate,vc: self) { result in
                        
                                switch result {
                                case .success(let allData):
                                    self.fetchPlanDataByDate(list: allData)
                                case .failure(let error):
                                    // Handle error
                                    self.ShowNoDataFoundonCollV1()
                                    print("Error retrieving data: \(error.localizedDescription)")
                                }
                        }
                            }
                    case .failure(let error):
                        // Handle error
                        self.ShowNoDataFoundonCollV()
                        print("Error retrieving data: \(error.localizedDescription)")
                    }
            }
        }
        }

    
    
    // Action method called when the view is tapped
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        print("View was tapped!")
        ChoosedaysPopupV.isHidden = true
        for indx in 0..<ChooseDayData.count{
            ChooseDayData[indx].isSelected = false
        }
        
        for indx in 0..<ChooseMealTypeyData.count{
            ChooseMealTypeyData[indx].isSelected = false
        }
        
        ChoosedaysTblV.reloadData()
        ChooseMealTypeTblV.reloadData()
    }
    
    @objc func handleTap1(_ sender: UITapGestureRecognizer) {
        print("View1 was tapped!")
        ChooseMealTypePopupV.isHidden = true
        
        for indx in 0..<ChooseDayData.count{
            ChooseDayData[indx].isSelected = false
        }
        
        for indx in 0..<ChooseMealTypeyData.count{
            ChooseMealTypeyData[indx].isSelected = false
        }
        
        for j in 0..<ChooseDayData.count {
            ChooseDayData[j].isSelected = false
        }
        
        ChoosedaysTblV.reloadData()
        ChooseMealTypeTblV.reloadData()
    }
    
    @objc func handleTap2(_ sender: UITapGestureRecognizer) {
        print("View1 was tapped!")
        AddAnotherMealPopupV.isHidden = true
    }
    
    func reloadTabViewController() {
        guard let tabBarController = self.tabBarController else { return }
        
        // Get the index of the current view controller in the tab bar
        guard let index = tabBarController.viewControllers?.firstIndex(of: self) else { return }
        
        // Create a new instance of the view controller
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let newViewController = storyboard.instantiateViewController(withIdentifier: "PlanVc") as? PlanVc {
            
            // Replace the current view controller in the tab bar
            var viewControllers = tabBarController.viewControllers
            viewControllers?[index] = newViewController
            
            tabBarController.viewControllers = viewControllers
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ScrollV.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        DispatchQueue.global().asyncAfter(deadline: .now()) {
       
            planService.shared.Api_To_Get_ProfileData(vc: self) { result in
                
                switch result {
                case .success(let allData):
                    let response = allData
                    
                    let Name = response?["name"] as? String ?? String()
                    
                    if Name != ""{
                        self.NameLbl.text = "\(Name.capitalizedFirst)'s week"
                    }
                     
                    let ProfImg = response?["profile_img"] as? String ?? String()
                    let img = URL(string: baseURL.imageUrl + ProfImg)
                    
                    self.profileImg.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
                    self.profileImg.sd_setImage(with: img, placeholderImage: UIImage(named: "DummyImg"))
                case .failure(let error):
                    // Handle error
                    print("Error retrieving data: \(error.localizedDescription)")
                }
            }
           
            planService.shared.Api_To_GetPrefrenceBodyGoals(vc: self) { result in
                
                switch result {
                case .success(let allData):
                    self.fetchBodyGoalsData(responseArray: allData)
                case .failure(let error):
                    // Handle error
                    print("Error retrieving data: \(error.localizedDescription)")
                }
            }
        }
    }
    
 
    
    private func setupInitialWeek() {
        let today = Date()
        let CalculateWeekDates = calculateWeekDates(for: today)
        currentWeekDates = CalculateWeekDates
        updateWeekLabel()
        //
        selectCurrentDate()
        //
    }
    
    
    private func selectCurrentDate() {
        let today = Date()
        let calendar = Calendar.current
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1){
        // Find the index of today's date in currentWeekDates
            if let todayIndex = self.currentWeekDates.firstIndex(where: { calendar.isDate($0, inSameDayAs: today) }) {
                let indexPath = IndexPath(item: todayIndex, section: 0)
                
                // Select the cell programmatically
                
                let currentCell = self.CalanderCollV.cellForItem(at: indexPath) as? CalendarCell
                currentCell?.updateSelection(isSelected: true)
                
                // Update the selected index
                self.selectedIndex = indexPath
                
                self.seldate = self.currentWeekDates[indexPath.item]
                // Trigger API for current date
                self.veryFirstLoading = 1
//                     self.Api_To_GetAllRecipeByDate()
            }
        }
    }

    
        private func setupCollectionView() {
            CalanderCollV.delegate = self
            CalanderCollV.dataSource = self
            CalanderCollV.register(UINib(nibName: "CalendarCell", bundle: nil), forCellWithReuseIdentifier: "CalendarCell")
            
            BreakFastCollV.delegate = self
            BreakFastCollV.dataSource = self
            BreakFastCollV.register(UINib(nibName: "PlanRecipeCollVCell", bundle: nil), forCellWithReuseIdentifier: "PlanRecipeCollVCell")
            
            LunchCollV.delegate = self
            LunchCollV.dataSource = self
            LunchCollV.register(UINib(nibName: "PlanRecipeCollVCell", bundle: nil), forCellWithReuseIdentifier: "PlanRecipeCollVCell")
            
            DinnerCollV.delegate = self
            DinnerCollV.dataSource = self
            DinnerCollV.register(UINib(nibName: "PlanRecipeCollVCell", bundle: nil), forCellWithReuseIdentifier: "PlanRecipeCollVCell")
            
            TeaTimeCollV.delegate = self
            TeaTimeCollV.dataSource = self
            TeaTimeCollV.register(UINib(nibName: "PlanRecipeCollVCell", bundle: nil), forCellWithReuseIdentifier: "PlanRecipeCollVCell")
            
            SnacksCollV.delegate = self
            SnacksCollV.dataSource = self
            SnacksCollV.register(UINib(nibName: "PlanRecipeCollVCell", bundle: nil), forCellWithReuseIdentifier: "PlanRecipeCollVCell")
            
            //
            BreakFastDishCollV.delegate = self
            BreakFastDishCollV.dataSource = self
            BreakFastDishCollV.register(UINib(nibName: "DishCollVCell", bundle: nil), forCellWithReuseIdentifier: "DishCollVCell")
            
            LunchDishCollV.delegate = self
            LunchDishCollV.dataSource = self
            LunchDishCollV.register(UINib(nibName: "DishCollVCell", bundle: nil), forCellWithReuseIdentifier: "DishCollVCell")
            
            DinnerDishCollV.delegate = self
            DinnerDishCollV.dataSource = self
            DinnerDishCollV.register(UINib(nibName: "DishCollVCell", bundle: nil), forCellWithReuseIdentifier: "DishCollVCell")
            
            TeaTimeDishCollV.delegate = self
            TeaTimeDishCollV.dataSource = self
            TeaTimeDishCollV.register(UINib(nibName: "DishCollVCell", bundle: nil), forCellWithReuseIdentifier: "DishCollVCell")
            
            SnacksDishCollV.delegate = self
            SnacksDishCollV.dataSource = self
            SnacksDishCollV.register(UINib(nibName: "DishCollVCell", bundle: nil), forCellWithReuseIdentifier: "DishCollVCell")
        }
    
    // for popups
    private func setupTableView() {
        self.ChoosedaysTblV.register(UINib(nibName: "ChooseDaysTblVCell", bundle: nil), forCellReuseIdentifier: "ChooseDaysTblVCell")
        self.ChoosedaysTblV.delegate = self
        self.ChoosedaysTblV.dataSource = self
        self.ChoosedaysTblV.separatorStyle = .none
        
        self.ChooseMealTypeTblV.register(UINib(nibName: "ChooseDaysTblVCell", bundle: nil), forCellReuseIdentifier: "ChooseDaysTblVCell")
        self.ChooseMealTypeTblV.delegate = self
        self.ChooseMealTypeTblV.dataSource = self
        self.ChooseMealTypeTblV.separatorStyle = .none
        
        self.AddAnotherMealTblV.register(UINib(nibName: "BodyGoalTblVCell", bundle: nil), forCellReuseIdentifier: "BodyGoalTblVCell") //ChooseDaysTblVCell
        self.AddAnotherMealTblV.delegate = self
        self.AddAnotherMealTblV.dataSource = self
        self.AddAnotherMealTblV.separatorStyle = .none
        
        // Observe contentSize changes
        AddAnotherMealTblV.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        //
    }
    
    
    deinit {
        // Remove observer to avoid memory leaks
        AddAnotherMealTblV.removeObserver(self, forKeyPath: "contentSize")
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize" {
            updateTableViewHeight()
        }
    }
    
    private func updateTableViewHeight() {
        // Update the height constraint with the tableView's contentSize height
        AddAnotherMealTblVH.constant = AddAnotherMealTblV.contentSize.height
    }
    //
    
        func setupCurrentWeek() {
            let today = Date()
            currentWeekDates = calculateWeekDates(for: today)
            updateWeekLabel()
            CalanderCollV.reloadData()
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
    
     
    
    @IBAction func ProfileBtn(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
  
    
    @IBAction func CalculateBMRBtn(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "HealthDataVC") as! HealthDataVC
        vc.isComesFromPlanTab = true
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    

    @IBAction func CalanderDropBtn(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "Tabbar", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "CalendarVC") as! CalendarVC
        vc.seldate = seldate
        vc.backAction = {date in
            self.seldate = date
            self.currentWeekDates = self.calculateWeekDates(for: date)
            self.updateWeekLabel()
            for indx in 0..<self.currentWeekDates.count{
                let currentCell = self.CalanderCollV.cellForItem(at: IndexPath(item: indx, section: 0)) as? CalendarCell
                currentCell?.updateSelection(isSelected: false)
            }
            // Update the selected index
            self.selectedIndex = nil
            self.CalanderCollV.reloadData()
        }
        self.addChild(vc)
        vc.view.frame = self.view.frame
        self.view.addSubview(vc.view)
        self.view.bringSubviewToFront(vc.view)
        vc.didMove(toParent: self)
    }
    
    // for custome calander.
    @IBAction func previousWeekTapped(_ sender: UIButton) {
        let today = Date()
        let VfirstDate = currentWeekDates.first ?? Date()
        guard VfirstDate >= today else{
                 return // Exit if the previous week's start date is earlier than today
             }
        
        if let firstDate = currentWeekDates.first {
                currentWeekDates = calculateWeekDates(for: calendar.date(byAdding: .day, value: -7, to: firstDate)!)
                updateWeekLabel()
            for i in 0..<currentWeekDates.count {
                let previousIndex = IndexPath(item: i, section: 0)
                let previousCell = CalanderCollV.cellForItem(at: previousIndex) as? CalendarCell
                previousCell?.updateSelection(isSelected: false)
            }
            CalanderCollV.reloadData()
            }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
            self.toCheckLastSelDate()
        }
       }

       @IBAction func nextWeekTapped(_ sender: UIButton) {
           if let lastDate = currentWeekDates.last {
                 currentWeekDates = calculateWeekDates(for: calendar.date(byAdding: .day, value: 7, to: lastDate)!)
                 updateWeekLabel()
               for i in 0..<currentWeekDates.count {
                   let previousIndex = IndexPath(item: i, section: 0)
                   let previousCell = CalanderCollV.cellForItem(at: previousIndex) as? CalendarCell
                   previousCell?.updateSelection(isSelected: false)
               }
               CalanderCollV.reloadData()
             }
           
           DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
               self.toCheckLastSelDate()
           }
       }
    
    func toCheckLastSelDate() {
       
        let SelDate = seldate
         
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone.current // Use the local time zone
        // Convert to string
        let dateString = formatter.string(from: SelDate)
        // Convert back to date
        formatter.dateFormat = "yyyy-MM-dd"
        let reconvertedDate = formatter.date(from: dateString)
        
        let formatter1 = DateFormatter()
        formatter1.dateFormat = "yyyy-MM-dd"
        formatter1.timeZone = TimeZone.current // Use the local time zone
        // Convert to string
        let dateString1 = formatter1.string(from: SelDate)
        // Convert back to date
        formatter1.dateFormat = "yyyy-MM-dd"
        let TodayreconvertedDate = formatter1.date(from: dateString1) ?? Date()
        
        guard reconvertedDate! >= TodayreconvertedDate else{
                 return // Exit if the previous week's start date is earlier than today
             }
        
        // Deselect the previously selected item, if any
        if let previousIndex = selectedIndex {
            let previousCell = CalanderCollV.cellForItem(at: previousIndex) as? CalendarCell
            previousCell?.updateSelection(isSelected: false)
        }
        
        if let index = currentWeekDates.firstIndex(where: {$0 == SelDate}){
            let indexPath = IndexPath(item: index, section: 0)
            
            // Select the current item
 
            let currentCell = CalanderCollV.cellForItem(at: indexPath) as? CalendarCell
            currentCell?.updateSelection(isSelected: true)
            
            // Update the selected index
            selectedIndex = indexPath
            
            // self.Api_To_GetAllRecipeByDate()
        }
    }
    
    
    @IBAction func AddnotherMealBtn(_ sender: UIButton) {
        StateMangerModelClass.shared.SearchClickFromPopup = true

        if let tabBar = tabBarController?.tabBar,
           let items = tabBar.items,
           items.count > 1 {
            let item = items[1] // Get the UITabBarItem at index 1
            
            // Retrieve the corresponding view controller
            if let viewControllerToSelect = tabBarController?.viewControllers?[1],
               let delegate = tabBarController?.delegate {
                
                // Check if shouldSelect allows the selection
                let canSelect = delegate.tabBarController?(tabBarController!, shouldSelect: viewControllerToSelect) ?? true
                if canSelect {
                    // Call didSelect if shouldSelect permits it
                    tabBarController?.tabBar(tabBar, didSelect: item)
                    tabBarController?.selectedIndex = 1
                }
            }
        }
    }
    
    @IBAction func AddtoBasketBtnO(_ sender: UIButton) {
        planService.shared.Api_To_AddAllRecipeToBasket(seldate: self.seldate, vc: self) {result in
            switch result {
            case .success(_):
                self.AddtoBasketBtnO.isUserInteractionEnabled = false
                self.AddtoBasketBtnO.backgroundColor = UIColor.lightGray
            case .failure(let error):
                // Handle error
                print("Error retrieving data: \(error.localizedDescription)")
            }
        }
    }
    
    
    
    @IBAction func AddAnotherBtn(_ sender: UIButton) {
        self.AddAnotherMealPopupV.isHidden = false
        self.AddAnotherMealTblV.reloadData()
    }
    
    @IBAction func ConfirmBtn(_ sender: UIButton) {

    }
    
    
    // for popUps btns
    // for popups
    @IBAction func ChoosedaysDoneBtn(_ sender: UIButton) {
        guard ChooseDayData.contains(where: {$0.isSelected == true}) else{
            AlertControllerOnr(title: "", message: "Please select at least one day.")
            return
        }
        self.ChoosedaysPopupV.isHidden = true
      //  if isAddAnotherMealPopupVClicked == false{
            self.ChooseMealTypePopupV.isHidden = false
      //  }
   
    }
    
    @IBAction func ChooseMealDoneBtn(_ sender: UIButton) {
        guard ChooseMealTypeyData.contains(where: { $0.isSelected }) else {
            AlertControllerOnr(title: "", message: "Please select meal type.")
            return
        }
        self.ChooseMealTypePopupV.isHidden = true
         
                let dateformatter = DateFormatter()
        
                var SerArray = [[String: String]]()
                for i in 0..<self.currentWeekDates.count {
                    let date = self.currentWeekDates[i]
                    dateformatter.dateFormat = "yyyy-MM-dd"
                    let Sdate = dateformatter.string(from: date)
        
                    dateformatter.dateFormat = "EEEE" // Full day name, e.g., "Monday"
                    let dayOfWeek = dateformatter.string(from: date)
        
                    let matchingDays = self.ChooseDayData.filter { $0.isSelected && $0.Name == dayOfWeek }
                    if !matchingDays.isEmpty {
                        print("\(dayOfWeek), \(Sdate) is selected!")
        
                        let dictionary1: [String: String] = ["date": Sdate, "day": dayOfWeek]
                        SerArray.append(dictionary1)
                    }
                }
        
                print(SerArray)
        
        planService.shared.Api_For_AddToPlan(uri: self.uri, type: self.mealType, SerArray: SerArray, vc: self) { result in
        
            switch result {
            case .success(_):
  
                for i in 0..<self.ChooseDayData.count {
                    self.ChooseDayData[i].isSelected = false
                }
                
                for i in 0..<self.ChooseMealTypeyData.count {
                    self.ChooseMealTypeyData[i].isSelected = false
                }
                
                self.ChoosedaysTblV.reloadData()
                self.ChooseMealTypeTblV.reloadData()
                
                self.mealType = ""
                self.uri = ""
                
                let dateformatter = DateFormatter()
                dateformatter.dateFormat = "yyyy-MM-dd"
        let Sdate = dateformatter.string(from: self.seldate)
        planService.shared.Api_To_GetAllRecipeByDate(Sdate: Sdate,vc: self) { result in
        
                switch result {
                case .success(let allData):
                    self.fetchPlanDataByDate(list: allData)
                case .failure(let error):
                    // Handle error
                    self.ShowNoDataFoundonCollV1()
                    print("Error retrieving data: \(error.localizedDescription)")
                }
        }
                
            case .failure(let error):
                // Handle error
                print("Error retrieving data: \(error.localizedDescription)")
            }
        }
    }
    
    @IBAction func PoppUpreviousWeekTapped(_ sender: UIButton) {

        let today = Date()
        let VfirstDate = currentWeekDates.first ?? Date()
        guard VfirstDate >= today else{
                 return // Exit if the previous week's start date is earlier than today
             }
        
        if let firstDate = currentWeekDates.first {
                currentWeekDates = calculateWeekDates(for: calendar.date(byAdding: .day, value: -7, to: firstDate)!)
                updateWeekLabel()
            for i in 0..<currentWeekDates.count {
                let previousIndex = IndexPath(item: i, section: 0)
                let previousCell = CalanderCollV.cellForItem(at: previousIndex) as? CalendarCell
                previousCell?.updateSelection(isSelected: false)
            }
            CalanderCollV.reloadData()
            }
       }

       @IBAction func PopUpnextWeekTapped(_ sender: UIButton) {

           if let lastDate = currentWeekDates.last {
                 currentWeekDates = calculateWeekDates(for: calendar.date(byAdding: .day, value: 7, to: lastDate)!)
                 updateWeekLabel()
               for i in 0..<currentWeekDates.count {
                   let previousIndex = IndexPath(item: i, section: 0)
                   let previousCell = CalanderCollV.cellForItem(at: previousIndex) as? CalendarCell
                   previousCell?.updateSelection(isSelected: false)
               }
               CalanderCollV.reloadData()
             }
       }
    
    @IBAction func AddToPlanBtn(_ sender: UIButton) {

        let allDeselected = ArrData.allSatisfy { !$0.isSelected }

        if allDeselected {
            print("All items are deselected")
            AlertControllerOnr(title: "", message: "Select at least one meal type.")
        } else {
            print("Some items are selected")
            self.isAddAnotherMealPopupVClicked = true
   
            var SelMealRoutineArr = [String]()
            
            for i in 0..<ArrData.count {
                if ArrData[i].isSelected {
                    SelMealRoutineArr.append("\(ArrData[i].id ?? Int())")
                }
            }
            
            
            planService.shared.Api_To_UpdatePrefrence(SelMealRoutineArr: SelMealRoutineArr, vc: self) { result in
                
                switch result {
                case .success(_):
                    self.isAddAnotherMealPopupVClicked = false
                    self.AddAnotherMealPopupV.isHidden = true
                    self.veryFirstLoading = 1
                    planService.shared.Api_To_GetAllRecipe(vc: self) { result in
                        
                        switch result {
                        case .success(let allData):
                            if let list = allData, list.recipes != nil {
                                self.AllRecipeSelItem = list
                                
                                self.ShowNoDataFoundonCollV()
                            }else{
                                self.ShowNoDataFoundonCollV()
                            }
                            
                            //                    if self.veryFirstLoading == 1{
                            //                        self.veryFirstLoading = 0
                            DispatchQueue.global().asyncAfter(deadline: .now()) {
                                let dateformatter = DateFormatter()
                                dateformatter.dateFormat = "yyyy-MM-dd"
                                let Sdate = dateformatter.string(from: self.seldate)
                                planService.shared.Api_To_GetAllRecipeByDate(Sdate: Sdate,vc: self) { result in
                                    
                                    switch result {
                                    case .success(let allData):
                                        self.fetchPlanDataByDate(list: allData)
                                    case .failure(let error):
                                        // Handle error
                                        self.ShowNoDataFoundonCollV1()
                                        print("Error retrieving data: \(error.localizedDescription)")
                                    }
                                }
                                
                            }
                        case .failure(let error):
                            // Handle error
                            self.ShowNoDataFoundonCollV()
                            print("Error retrieving data: \(error.localizedDescription)")
                        }
                    }
                case .failure(let error):
                    // Handle error
                    self.ShowNoDataFoundonCollV1()
                    print("Error retrieving data: \(error.localizedDescription)")
                }
            }
        }
    }

}

extension PlanVc: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == CalanderCollV{
            return currentWeekDates.count
        }else if collectionView == BreakFastCollV{
            return self.AllRecipeSelItem.recipes?.breakfast?.count ?? 0//BreakfastData.count
        }else if collectionView == LunchCollV{
            return self.AllRecipeSelItem.recipes?.lunch?.count ?? 0//LunchData.count
        }else if collectionView == DinnerCollV{
            return self.AllRecipeSelItem.recipes?.dinner?.count ?? 0//DinnerData.count
        }else if collectionView == SnacksCollV{
            return self.AllRecipeSelItem.recipes?.Snack?.count ?? 0
        }else if collectionView == TeaTimeCollV{
            return self.AllRecipeSelItem.recipes?.Teatime?.count ?? 0
        }else if collectionView == BreakFastDishCollV{
            return self.AllDataList.breakfast?.count ?? 0
        }else if collectionView == LunchDishCollV{
            return self.AllDataList.lunch?.count ?? 0
        }else if collectionView == DinnerDishCollV{
            return self.AllDataList.dinner?.count ?? 0
        }else if collectionView == TeaTimeDishCollV{
            return self.AllDataList.teatime?.count ?? 0
        }else{
            return self.AllDataList.snacks?.count ?? 0
        }
       }
       
       func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            
           if collectionView == CalanderCollV{
               let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CalendarCell", for: indexPath) as! CalendarCell
               let date = currentWeekDates[indexPath.item]
               cell.configure(with: date)
               return cell
           }else if collectionView == BreakFastCollV{
               let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlanRecipeCollVCell", for: indexPath) as! PlanRecipeCollVCell
              cell.NameLbl.text =  self.AllRecipeSelItem.recipes?.breakfast?[indexPath.item].recipe?.label ?? ""
           //    cell.PriceLbl.text = ""
               cell.RAtingLbl.text = "\(self.AllRecipeSelItem.recipes?.breakfast?[indexPath.item].review ?? 0)(\(self.AllRecipeSelItem.recipes?.breakfast?[indexPath.item].review_number ?? 0))"
               
               let img = self.AllRecipeSelItem.recipes?.breakfast?[indexPath.item].recipe?.images?.small?.url ?? ""
               let ImgUrl = URL(string: img)
               cell.ImgV.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
               cell.ImgV.sd_setImage(with: ImgUrl, placeholderImage: UIImage(named: "No_Image"))
               
               cell.TimeLbl.text = "\(self.AllRecipeSelItem.recipes?.breakfast?[indexPath.item].recipe?.totalTime ?? 0) min"
               
               let islike = self.AllRecipeSelItem.recipes?.breakfast?[indexPath.item].isLike
               
               if islike == 1{
                   cell.FavBtn.setImage(UIImage(named: "Fav"), for: .normal)
               }else{
                   cell.FavBtn.setImage(UIImage(named: "UnFav"), for: .normal)
               }
 
               cell.AddToPlanBtn.tag = indexPath.item
               cell.AddToPlanBtn.addTarget(self, action: #selector(BreakAddtoPlanBtnClick(_:)), for: .touchUpInside)
               
               cell.FavBtn.tag = indexPath.item
               cell.FavBtn.addTarget(self, action: #selector(FavBreakfastBtnClick(_:)), for: .touchUpInside)
               
               cell.CartBtn.tag = indexPath.item
               cell.CartBtn.addTarget(self, action: #selector(BreakAddtoBasketBtnClick(_:)), for: .touchUpInside)
               
               
               
               return cell
           }else if collectionView == LunchCollV{
               let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlanRecipeCollVCell", for: indexPath) as! PlanRecipeCollVCell
               cell.NameLbl.text =  self.AllRecipeSelItem.recipes?.lunch?[indexPath.item].recipe?.label ?? ""
          //     cell.PriceLbl.text = ""
               cell.RAtingLbl.text = "\(self.AllRecipeSelItem.recipes?.lunch?[indexPath.item].review ?? 0)(\(self.AllRecipeSelItem.recipes?.lunch?[indexPath.item].review_number ?? 0))"
               
               let img = self.AllRecipeSelItem.recipes?.lunch?[indexPath.item].recipe?.images?.small?.url ?? ""
               let ImgUrl = URL(string: img)
               cell.ImgV.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
               cell.ImgV.sd_setImage(with: ImgUrl, placeholderImage: UIImage(named: "No_Image"))
               
               cell.TimeLbl.text = "\(self.AllRecipeSelItem.recipes?.lunch?[indexPath.item].recipe?.totalTime ?? 0) min"
               
               cell.AddToPlanBtn.tag = indexPath.item
               cell.AddToPlanBtn.addTarget(self, action: #selector(LunchAddtoPlanBtnClick(_:)), for: .touchUpInside)
              
               let islike = self.AllRecipeSelItem.recipes?.lunch?[indexPath.item].isLike
               
               if islike == 1{
                   cell.FavBtn.setImage(UIImage(named: "Fav"), for: .normal)
               }else{
                   cell.FavBtn.setImage(UIImage(named: "UnFav"), for: .normal)
               }
               
              
               cell.FavBtn.tag = indexPath.item
               cell.FavBtn.addTarget(self, action: #selector(FavLunchBtnClick(_:)), for: .touchUpInside)
               
               cell.CartBtn.tag = indexPath.item
               cell.CartBtn.addTarget(self, action: #selector(LunchAddtoBasketBtnClick(_:)), for: .touchUpInside)
               
               return cell
           }else if collectionView == DinnerCollV{
               let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlanRecipeCollVCell", for: indexPath) as! PlanRecipeCollVCell
               cell.NameLbl.text =  self.AllRecipeSelItem.recipes?.dinner?[indexPath.item].recipe?.label ?? ""
             //  cell.PriceLbl.text = ""
               cell.RAtingLbl.text = "\(self.AllRecipeSelItem.recipes?.dinner?[indexPath.item].review ?? 0)(\(self.AllRecipeSelItem.recipes?.dinner?[indexPath.item].review_number ?? 0))"
               
               let img = self.AllRecipeSelItem.recipes?.dinner?[indexPath.item].recipe?.images?.small?.url ?? ""
               let ImgUrl = URL(string: img)
               cell.ImgV.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
               cell.ImgV.sd_setImage(with: ImgUrl, placeholderImage: UIImage(named: "No_Image"))
               
               cell.TimeLbl.text = "\(self.AllRecipeSelItem.recipes?.dinner?[indexPath.item].recipe?.totalTime ?? 0) min"
               
               let islike = self.AllRecipeSelItem.recipes?.dinner?[indexPath.item].isLike
               
               if islike == 1{
                   cell.FavBtn.setImage(UIImage(named: "Fav"), for: .normal)
               }else{
                   cell.FavBtn.setImage(UIImage(named: "UnFav"), for: .normal)
               }
               
               cell.AddToPlanBtn.tag = indexPath.item
               cell.AddToPlanBtn.addTarget(self, action: #selector(DinnerAddtoPlanBtnClick(_:)), for: .touchUpInside)
             
               cell.FavBtn.tag = indexPath.item
               cell.FavBtn.addTarget(self, action: #selector(FavDinnerBtnClick(_:)), for: .touchUpInside)
               
               cell.CartBtn.tag = indexPath.item
               cell.CartBtn.addTarget(self, action: #selector(DinnerAddtoBasketBtnClick(_:)), for: .touchUpInside)
               
               return cell
           }else if collectionView == SnacksCollV{
               let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlanRecipeCollVCell", for: indexPath) as! PlanRecipeCollVCell
               cell.NameLbl.text =  self.AllRecipeSelItem.recipes?.Snack?[indexPath.item].recipe?.label ?? ""
          //     cell.PriceLbl.text = ""
               cell.RAtingLbl.text = "\(self.AllRecipeSelItem.recipes?.Snack?[indexPath.item].review ?? 0)(\(self.AllRecipeSelItem.recipes?.Snack?[indexPath.item].review_number ?? 0))"
               
               let img = self.AllRecipeSelItem.recipes?.Snack?[indexPath.item].recipe?.images?.small?.url ?? ""
               let ImgUrl = URL(string: img)
               cell.ImgV.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
               cell.ImgV.sd_setImage(with: ImgUrl, placeholderImage: UIImage(named: "No_Image"))
               
               cell.TimeLbl.text = "\(self.AllRecipeSelItem.recipes?.Snack?[indexPath.item].recipe?.totalTime ?? 0) min"
               
               let islike = self.AllRecipeSelItem.recipes?.Snack?[indexPath.item].isLike
               
               if islike == 1{
                   cell.FavBtn.setImage(UIImage(named: "Fav"), for: .normal)
               }else{
                   cell.FavBtn.setImage(UIImage(named: "UnFav"), for: .normal)
               }
               
               cell.AddToPlanBtn.tag = indexPath.item
               cell.AddToPlanBtn.addTarget(self, action: #selector(SnacksAddtoPlanBtnClick(_:)), for: .touchUpInside)
             
               cell.FavBtn.tag = indexPath.item
               cell.FavBtn.addTarget(self, action: #selector(FavSnacksBtnClick(_:)), for: .touchUpInside)
               
               cell.CartBtn.tag = indexPath.item
               cell.CartBtn.addTarget(self, action: #selector(SnacksAddtoBasketBtnClick(_:)), for: .touchUpInside)
               
               return cell
           }else if collectionView == TeaTimeCollV{
               let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlanRecipeCollVCell", for: indexPath) as! PlanRecipeCollVCell
               cell.NameLbl.text =  self.AllRecipeSelItem.recipes?.Teatime?[indexPath.item].recipe?.label ?? ""
               
               cell.TimeLbl.text = "\(self.AllRecipeSelItem.recipes?.Teatime?[indexPath.item].recipe?.totalTime ?? 0) min"
        //       cell.PriceLbl.text = ""
               cell.RAtingLbl.text = "\(self.AllRecipeSelItem.recipes?.Teatime?[indexPath.item].review ?? 0)(\(self.AllRecipeSelItem.recipes?.Teatime?[indexPath.item].review_number ?? 0))"
               
               let img = self.AllRecipeSelItem.recipes?.Teatime?[indexPath.item].recipe?.images?.small?.url ?? ""
               let ImgUrl = URL(string: img)
               cell.ImgV.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
               cell.ImgV.sd_setImage(with: ImgUrl, placeholderImage: UIImage(named: "No_Image"))
               
               let islike = self.AllRecipeSelItem.recipes?.Teatime?[indexPath.item].isLike
               
               if islike == 1{
                   cell.FavBtn.setImage(UIImage(named: "Fav"), for: .normal)
               }else{
                   cell.FavBtn.setImage(UIImage(named: "UnFav"), for: .normal)
               }
               
               cell.AddToPlanBtn.tag = indexPath.item
               cell.AddToPlanBtn.addTarget(self, action: #selector(TeaTimeAddtoPlanBtnClick(_:)), for: .touchUpInside)
             
               cell.FavBtn.tag = indexPath.item
               cell.FavBtn.addTarget(self, action: #selector(FavTeaTimeBtnClick(_:)), for: .touchUpInside)
               
               cell.CartBtn.tag = indexPath.item
               cell.CartBtn.addTarget(self, action: #selector(TeaTimeAddtoBasketBtnClick(_:)), for: .touchUpInside)
               
               return cell
           }else if collectionView == BreakFastDishCollV{
               let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DishCollVCell", for: indexPath) as! DishCollVCell
               
               cell.MealNameLbl.text = self.AllDataList.breakfast?[indexPath.item].recipe?.label ?? ""
               cell.TotalTimeLbl.text = "\(self.AllDataList.breakfast?[indexPath.item].recipe?.totalTime ?? 0) min"
               
               cell.PrepTimelbl.text = "0 min"//self.AllDataList.breakfast[indexPath.item].
               cell.Calorieslbl.text = "\(Int(self.AllDataList.breakfast?[indexPath.item].recipe?.calories ?? 0))"
               
               let Fat = self.AllDataList.breakfast?[indexPath.item].recipe?.totalNutrients?.first(where: {$0.key == "FAT"})
               cell.Fatlbl.text = "\(Int(Fat?.value.quantity ?? 0))"

               let Protine = self.AllDataList.breakfast?[indexPath.item].recipe?.totalNutrients?.first(where: {$0.key == "PROCNT"})
               cell.Protienlbl.text = "\(Int(Protine?.value.quantity ?? 0))"
                          
               let carbs = self.AllDataList.breakfast?[indexPath.item].recipe?.totalNutrients?.first(where: {$0.key == "CHOCDF"})
               cell.Carbslbl.text = "\(Int(carbs?.value.quantity ?? 0))"

 
               cell.ServCountLbl.text = "\(self.AllDataList.breakfast?[indexPath.item].servings ?? 0) Servings"
                
               let img = self.AllDataList.breakfast?[indexPath.item].recipe?.images?.small?.url ?? ""
               cell.MealIMg.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
               cell.MealIMg.sd_setImage(with: URL(string: img), placeholderImage: UIImage(named: "No_Image"))
             
              
 
               cell.MinusBtn.tag = indexPath.item
               cell.MinusBtn.addTarget(self, action: #selector(BreakDishServecountMinusBtnClick(_:)), for: .touchUpInside)
               
               cell.PlusBtn.tag = indexPath.item
               cell.PlusBtn.addTarget(self, action: #selector(BreakDishServecountPlusBtnClick(_:)), for: .touchUpInside)
               
               cell.SwapBtn.tag = indexPath.item
               cell.SwapBtn.addTarget(self, action: #selector(BreakFastSwipBtnClicked(_:)), for: .touchUpInside)
               return cell
           }else if collectionView == LunchDishCollV{
               let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DishCollVCell", for: indexPath) as! DishCollVCell
               cell.MealNameLbl.text = self.AllDataList.lunch?[indexPath.item].recipe?.label ?? ""
               cell.TotalTimeLbl.text = "\(self.AllDataList.lunch?[indexPath.item].recipe?.totalTime ?? 0) min"
               
               cell.PrepTimelbl.text = "0 min"//self.AllDataList.breakfast[indexPath.item].
               cell.Calorieslbl.text = "\(Int(self.AllDataList.lunch?[indexPath.item].recipe?.calories ?? 0))"
               
               let Fat = self.AllDataList.lunch?[indexPath.item].recipe?.totalNutrients?.first(where: {$0.key == "FAT"})
               cell.Fatlbl.text = "\(Int(Fat?.value.quantity ?? 0))"

               let Protine = self.AllDataList.lunch?[indexPath.item].recipe?.totalNutrients?.first(where: {$0.key == "PROCNT"})
               cell.Protienlbl.text = "\(Int(Protine?.value.quantity ?? 0))"
                          
               let carbs = self.AllDataList.lunch?[indexPath.item].recipe?.totalNutrients?.first(where: {$0.key == "CHOCDF"})
               cell.Carbslbl.text = "\(Int(carbs?.value.quantity ?? 0))"

 
               cell.ServCountLbl.text = "\(self.AllDataList.lunch?[indexPath.item].servings ?? 0) Servings"
                
               let img = self.AllDataList.lunch?[indexPath.item].recipe?.images?.small?.url ?? ""
               cell.MealIMg.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
               cell.MealIMg.sd_setImage(with: URL(string: img), placeholderImage: UIImage(named: "No_Image"))
               
               cell.MinusBtn.tag = indexPath.item
               cell.MinusBtn.addTarget(self, action: #selector(LunchDishServecountMinusBtnClick(_:)), for: .touchUpInside)
               
               cell.PlusBtn.tag = indexPath.item
               cell.PlusBtn.addTarget(self, action: #selector(LunchDishServecountPlusBtnClick(_:)), for: .touchUpInside)
               
               cell.SwapBtn.tag = indexPath.item
               cell.SwapBtn.addTarget(self, action: #selector(LunchSwipBtnClicked(_:)), for: .touchUpInside)
               return cell
           }else if collectionView == DinnerDishCollV{
               let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DishCollVCell", for: indexPath) as! DishCollVCell
               
               cell.MealNameLbl.text = self.AllDataList.dinner?[indexPath.item].recipe?.label ?? ""
               cell.TotalTimeLbl.text = "\(self.AllDataList.dinner?[indexPath.item].recipe?.totalTime ?? 0) min"
               
               cell.PrepTimelbl.text = "0 min"//self.AllDataList.breakfast[indexPath.item].
               cell.Calorieslbl.text = "\(Int(self.AllDataList.dinner?[indexPath.item].recipe?.calories ?? 0))"
               
               let Fat = self.AllDataList.dinner?[indexPath.item].recipe?.totalNutrients?.first(where: {$0.key == "FAT"})
               cell.Fatlbl.text = "\(Int(Fat?.value.quantity ?? 0))"

               let Protine = self.AllDataList.dinner?[indexPath.item].recipe?.totalNutrients?.first(where: {$0.key == "PROCNT"})
               cell.Protienlbl.text = "\(Int(Protine?.value.quantity ?? 0))"
                          
               let carbs = self.AllDataList.dinner?[indexPath.item].recipe?.totalNutrients?.first(where: {$0.key == "CHOCDF"})
               cell.Carbslbl.text = "\(Int(carbs?.value.quantity ?? 0))"

 
               cell.ServCountLbl.text = "\(self.AllDataList.dinner?[indexPath.item].servings ?? 0) Servings"
                
               let img = self.AllDataList.dinner?[indexPath.item].recipe?.images?.small?.url ?? ""
               cell.MealIMg.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
               cell.MealIMg.sd_setImage(with: URL(string: img), placeholderImage: UIImage(named: "No_Image"))
               
               cell.MinusBtn.tag = indexPath.item
               cell.MinusBtn.addTarget(self, action: #selector(DinnerDishServecountMinusBtnClick(_:)), for: .touchUpInside)
               
               cell.PlusBtn.tag = indexPath.item
               cell.PlusBtn.addTarget(self, action: #selector(DinnerDishServecountPlusBtnClick(_:)), for: .touchUpInside)
               
               cell.SwapBtn.tag = indexPath.item
               cell.SwapBtn.addTarget(self, action: #selector(DinnerSwipBtnClicked(_:)), for: .touchUpInside)
               return cell
           }else if collectionView == TeaTimeDishCollV{
               let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DishCollVCell", for: indexPath) as! DishCollVCell
               
               cell.MealNameLbl.text = self.AllDataList.teatime?[indexPath.item].recipe?.label ?? ""
               cell.TotalTimeLbl.text = "\(self.AllDataList.teatime?[indexPath.item].recipe?.totalTime ?? 0) min"
               
               cell.PrepTimelbl.text = "0 min"//self.AllDataList.breakfast[indexPath.item].
               cell.Calorieslbl.text = "\(Int(self.AllDataList.teatime?[indexPath.item].recipe?.calories ?? 0))"
               
               let Fat = self.AllDataList.teatime?[indexPath.item].recipe?.totalNutrients?.first(where: {$0.key == "FAT"})
               cell.Fatlbl.text = "\(Int(Fat?.value.quantity ?? 0))"

               let Protine = self.AllDataList.teatime?[indexPath.item].recipe?.totalNutrients?.first(where: {$0.key == "PROCNT"})
               cell.Protienlbl.text = "\(Int(Protine?.value.quantity ?? 0))"
                          
               let carbs = self.AllDataList.teatime?[indexPath.item].recipe?.totalNutrients?.first(where: {$0.key == "CHOCDF"})
               cell.Carbslbl.text = "\(Int(carbs?.value.quantity ?? 0))"

 
               cell.ServCountLbl.text = "\(self.AllDataList.teatime?[indexPath.item].servings ?? 0) Servings"
                
               let img = self.AllDataList.teatime?[indexPath.item].recipe?.images?.small?.url ?? ""
               cell.MealIMg.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
               cell.MealIMg.sd_setImage(with: URL(string: img), placeholderImage: UIImage(named: "No_Image"))
               
               cell.MinusBtn.tag = indexPath.item
               cell.MinusBtn.addTarget(self, action: #selector(TeaTimeDishServecountMinusBtnClick(_:)), for: .touchUpInside)
               
               cell.PlusBtn.tag = indexPath.item
               cell.PlusBtn.addTarget(self, action: #selector(TeaTimeDishServecountPlusBtnClick(_:)), for: .touchUpInside)
               
               cell.SwapBtn.tag = indexPath.item
               cell.SwapBtn.addTarget(self, action: #selector(TeatimeSwipBtnClicked(_:)), for: .touchUpInside)
               return cell
           }else{
               let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DishCollVCell", for: indexPath) as! DishCollVCell
               
               cell.MealNameLbl.text = self.AllDataList.snacks?[indexPath.item].recipe?.label ?? ""
               cell.TotalTimeLbl.text = "\(self.AllDataList.snacks?[indexPath.item].recipe?.totalTime ?? 0) min"
               
               cell.PrepTimelbl.text = "0 min"//self.AllDataList.breakfast[indexPath.item].
               cell.Calorieslbl.text = "\(Int(self.AllDataList.snacks?[indexPath.item].recipe?.calories ?? 0))"
               
               let Fat = self.AllDataList.snacks?[indexPath.item].recipe?.totalNutrients?.first(where: {$0.key == "FAT"})
               cell.Fatlbl.text = "\(Int(Fat?.value.quantity ?? 0))"

               let Protine = self.AllDataList.snacks?[indexPath.item].recipe?.totalNutrients?.first(where: {$0.key == "PROCNT"})
               cell.Protienlbl.text = "\(Int(Protine?.value.quantity ?? 0))"
                          
               let carbs = self.AllDataList.snacks?[indexPath.item].recipe?.totalNutrients?.first(where: {$0.key == "CHOCDF"})
               cell.Carbslbl.text = "\(Int(carbs?.value.quantity ?? 0))"

 
               cell.ServCountLbl.text = "\(self.AllDataList.snacks?[indexPath.item].servings ?? 0) Servings"
                
               let img = self.AllDataList.snacks?[indexPath.item].recipe?.images?.small?.url ?? ""
               cell.MealIMg.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
               cell.MealIMg.sd_setImage(with: URL(string: img), placeholderImage: UIImage(named: "No_Image"))
               
               cell.MinusBtn.tag = indexPath.item
               cell.MinusBtn.addTarget(self, action: #selector(SnacksDishServecountMinusBtnClick(_:)), for: .touchUpInside)
               
               cell.PlusBtn.tag = indexPath.item
               cell.PlusBtn.addTarget(self, action: #selector(SnacksDishServecountPlusBtnClick(_:)), for: .touchUpInside)
               
               cell.SwapBtn.tag = indexPath.item
               cell.SwapBtn.addTarget(self, action: #selector(SnacksSwipBtnClicked(_:)), for: .touchUpInside)
               return cell
           }
       }
    
    //
    
    @objc func BreakAddtoPlanBtnClick(_ sender: UIButton)   {
        let SubscriptionStatus = Int(UserDetail.shared.getSubscriptionStatus())
        
        if SubscriptionStatus == 1{
            let addtoplanStatus = Int(UserDetail.shared.getaddmeal()) ?? 0
            guard addtoplanStatus == 0 else {
                SubscriptionPopUp ()
                return
            }
        }
        
        let index = sender.tag
        let uri = self.AllRecipeSelItem.recipes?.breakfast?[index].recipe?.uri ?? ""
        if self.SwapMealType == "Breakfast"{
            planService.shared.Api_To_Swap(uri: uri, swipeID: self.SwipeID, vc: self) { result in
                switch result {
                case .success(_):
                    self.SwipeID = ""
                    self.SwapMealType = ""
                    
                    let dateformatter = DateFormatter()
                    dateformatter.dateFormat = "yyyy-MM-dd"
                    let Sdate = dateformatter.string(from: self.seldate)
                    planService.shared.Api_To_GetAllRecipeByDate(Sdate: Sdate,vc: self) { result in
                        
                        switch result {
                        case .success(let allData):
                            self.fetchPlanDataByDate(list: allData)
                        case .failure(let error):
                            // Handle error
                            self.ShowNoDataFoundonCollV1()
                            print("Error retrieving data: \(error.localizedDescription)")
                        }
                    }
                case .failure(let error):
                    // Handle error
                    print("Error retrieving data: \(error.localizedDescription)")
                }
            }
        }else{
            self.uri = uri
            self.ChoosedaysPopupV.isHidden = false
        }
        }
    
    @objc func LunchAddtoPlanBtnClick(_ sender: UIButton)   {
        let SubscriptionStatus = Int(UserDetail.shared.getSubscriptionStatus())
        
        if SubscriptionStatus == 1{
            let addtoplanStatus = Int(UserDetail.shared.getaddmeal()) ?? 0
            guard addtoplanStatus == 0 else {
                SubscriptionPopUp ()
                return
            }
        }
        
        let index = sender.tag
        let uri = self.AllRecipeSelItem.recipes?.lunch?[index].recipe?.uri ?? ""
        if self.SwapMealType == "Lunch"{
            planService.shared.Api_To_Swap(uri: uri, swipeID: self.SwipeID, vc: self) { result in
                switch result {
                case .success(_):
                    self.SwipeID = ""
                    self.SwapMealType = ""
                    
                    let dateformatter = DateFormatter()
                    dateformatter.dateFormat = "yyyy-MM-dd"
                    let Sdate = dateformatter.string(from: self.seldate)
                    planService.shared.Api_To_GetAllRecipeByDate(Sdate: Sdate,vc: self) { result in
                        
                        switch result {
                        case .success(let allData):
                            self.fetchPlanDataByDate(list: allData)
                        case .failure(let error):
                            // Handle error
                            self.ShowNoDataFoundonCollV1()
                            print("Error retrieving data: \(error.localizedDescription)")
                        }
                    }
                case .failure(let error):
                    // Handle error
                    print("Error retrieving data: \(error.localizedDescription)")
                }
            }
        }else{
            self.uri = uri
            self.ChoosedaysPopupV.isHidden = false
        }
        }
    
    @objc func DinnerAddtoPlanBtnClick(_ sender: UIButton)   {
        let SubscriptionStatus = Int(UserDetail.shared.getSubscriptionStatus())
        
        if SubscriptionStatus == 1{
            let addtoplanStatus = Int(UserDetail.shared.getaddmeal()) ?? 0
            guard addtoplanStatus == 0 else {
                SubscriptionPopUp ()
                return
            }
        }
        
        let index = sender.tag
        let uri = self.AllRecipeSelItem.recipes?.dinner?[index].recipe?.uri ?? ""
        if self.SwapMealType == "Dinner"{
            planService.shared.Api_To_Swap(uri: uri, swipeID: self.SwipeID, vc: self) { result in
                switch result {
                case .success(_):
                    self.SwipeID = ""
                    self.SwapMealType = ""
                    
                    let dateformatter = DateFormatter()
                    dateformatter.dateFormat = "yyyy-MM-dd"
                    let Sdate = dateformatter.string(from: self.seldate)
                    planService.shared.Api_To_GetAllRecipeByDate(Sdate: Sdate,vc: self) { result in
                        
                        switch result {
                        case .success(let allData):
                            self.fetchPlanDataByDate(list: allData)
                        case .failure(let error):
                            // Handle error
                            self.ShowNoDataFoundonCollV1()
                            print("Error retrieving data: \(error.localizedDescription)")
                        }
                    }
                case .failure(let error):
                    // Handle error
                    print("Error retrieving data: \(error.localizedDescription)")
                }
            }
        }else{
            self.uri = uri
            self.ChoosedaysPopupV.isHidden = false
        }
        }
   
    @objc func SnacksAddtoPlanBtnClick(_ sender: UIButton)   {
        let SubscriptionStatus = Int(UserDetail.shared.getSubscriptionStatus())
        
        if SubscriptionStatus == 1{
            let addtoplanStatus = Int(UserDetail.shared.getaddmeal()) ?? 0
            guard addtoplanStatus == 0 else {
                SubscriptionPopUp ()
                return
            }
        }
        
        let index = sender.tag
        let uri = self.AllRecipeSelItem.recipes?.Snack?[index].recipe?.uri ?? ""
        if self.SwapMealType == "Snacks"{
            planService.shared.Api_To_Swap(uri: uri, swipeID: self.SwipeID, vc: self) { result in
                switch result {
                case .success(_):
                    self.SwipeID = ""
                    self.SwapMealType = ""
                    
                    let dateformatter = DateFormatter()
                    dateformatter.dateFormat = "yyyy-MM-dd"
                    let Sdate = dateformatter.string(from: self.seldate)
                    planService.shared.Api_To_GetAllRecipeByDate(Sdate: Sdate,vc: self) { result in
                        
                        switch result {
                        case .success(let allData):
                            self.fetchPlanDataByDate(list: allData)
                        case .failure(let error):
                            // Handle error
                            self.ShowNoDataFoundonCollV1()
                            print("Error retrieving data: \(error.localizedDescription)")
                        }
                    }
                case .failure(let error):
                    // Handle error
                    print("Error retrieving data: \(error.localizedDescription)")
                }
            }
        }else{
            self.uri = uri
            self.ChoosedaysPopupV.isHidden = false
        }
        }
    
    @objc func TeaTimeAddtoPlanBtnClick(_ sender: UIButton)   {
        let SubscriptionStatus = Int(UserDetail.shared.getSubscriptionStatus())
        
        if SubscriptionStatus == 1{
            let addtoplanStatus = Int(UserDetail.shared.getaddmeal()) ?? 0
            guard addtoplanStatus == 0 else {
                SubscriptionPopUp ()
                return
            }
        }
        
        let index = sender.tag
        
        let uri = self.AllRecipeSelItem.recipes?.Teatime?[index].recipe?.uri ?? ""
        
        if self.SwapMealType == "Brunch"{
            planService.shared.Api_To_Swap(uri: uri, swipeID: self.SwipeID, vc: self) { result in
                switch result {
                case .success(_):
                    self.SwipeID = ""
                    self.SwapMealType = ""
                    
                    let dateformatter = DateFormatter()
                    dateformatter.dateFormat = "yyyy-MM-dd"
                    let Sdate = dateformatter.string(from: self.seldate)
                    planService.shared.Api_To_GetAllRecipeByDate(Sdate: Sdate,vc: self) { result in
                        
                        switch result {
                        case .success(let allData):
                            self.fetchPlanDataByDate(list: allData)
                        case .failure(let error):
                            // Handle error
                            self.ShowNoDataFoundonCollV1()
                            print("Error retrieving data: \(error.localizedDescription)")
                        }
                    }
                case .failure(let error):
                    // Handle error
                    print("Error retrieving data: \(error.localizedDescription)")
                }
            }
        }else{
            self.uri = uri
            self.ChoosedaysPopupV.isHidden = false
        }
    }
    
    
    
    //basketBtn
    @objc func BreakAddtoBasketBtnClick(_ sender: UIButton)   {
        let index = sender.tag
        let uri = self.AllRecipeSelItem.recipes?.breakfast?[index].recipe?.uri ?? ""
        
        planService.shared.Api_To_AddToBasket_Recipe(uri: uri, type: "Breakfast", vc: self) { result in
            
            switch result {
            case .success(_):
                print("Successfully Added to basket")
            case .failure(let error):
                // Handle error
                print("Error retrieving data: \(error.localizedDescription)")
            }
        }
        
    }
    
    @objc func LunchAddtoBasketBtnClick(_ sender: UIButton)   {
        let index = sender.tag
        let uri = self.AllRecipeSelItem.recipes?.lunch?[index].recipe?.uri ?? ""

        planService.shared.Api_To_AddToBasket_Recipe(uri: uri, type: "Lunch", vc: self) { result in
            
            switch result {
            case .success(_):
                print("Successfully Added to basket")
            case .failure(let error):
                // Handle error
                print("Error retrieving data: \(error.localizedDescription)")
            }
        }
        }
    
    @objc func DinnerAddtoBasketBtnClick(_ sender: UIButton)   {
        let index = sender.tag
        let uri = self.AllRecipeSelItem.recipes?.dinner?[index].recipe?.uri ?? ""
  
        planService.shared.Api_To_AddToBasket_Recipe(uri: uri, type: "Dinner", vc: self) { result in
            
            switch result {
            case .success(_):
                print("Successfully Added to basket")
            case .failure(let error):
                // Handle error
                print("Error retrieving data: \(error.localizedDescription)")
            }
        }
        }
    
    @objc func SnacksAddtoBasketBtnClick(_ sender: UIButton)   {
        let index = sender.tag
        let uri = self.AllRecipeSelItem.recipes?.Snack?[index].recipe?.uri ?? ""
        
        planService.shared.Api_To_AddToBasket_Recipe(uri: uri, type: "Snacks", vc: self) { result in
            
            switch result {
            case .success(_):
                print("Successfully Added to basket")
            case .failure(let error):
                // Handle error
                print("Error retrieving data: \(error.localizedDescription)")
            }
        }
    }
    
    @objc func TeaTimeAddtoBasketBtnClick(_ sender: UIButton)   {
        let index = sender.tag
        let uri = self.AllRecipeSelItem.recipes?.Teatime?[index].recipe?.uri ?? ""
       
        planService.shared.Api_To_AddToBasket_Recipe(uri: uri, type: "Brunch", vc: self) { result in
            
            switch result {
            case .success(_):
                print("Successfully Added to basket")
            case .failure(let error):
                // Handle error
                print("Error retrieving data: \(error.localizedDescription)")
            }
        }
        }
    
    //favBtn
    @objc func FavBreakfastBtnClick(_ sender: UIButton)   {
        let SubscriptionStatus = Int(UserDetail.shared.getSubscriptionStatus())
        
        if SubscriptionStatus == 1{
            let addtoplanStatus = Int(UserDetail.shared.getfavorite()) ?? 0
            guard addtoplanStatus <= 2 else {
                SubscriptionPopUp ()
                return
            }
        }
        
        let index = sender.tag
        let uri = self.AllRecipeSelItem.recipes?.breakfast?[index].recipe?.uri ?? ""
        let islike = self.AllRecipeSelItem.recipes?.breakfast?[index].isLike
        if islike == 1{
            self.AllRecipeSelItem.recipes?.breakfast?[index].isLike = 0
           // self.Api_To_Like_UnlikeRecipe(uri: uri, type: "0")
            planService.shared.Api_To_Like_UnlikeRecipe(uri: uri, type: "0", vc: self) { result in
            
                switch result {
                case .success(_):
                    let dateformatter = DateFormatter()
                    dateformatter.dateFormat = "yyyy-MM-dd"
            let Sdate = dateformatter.string(from: self.seldate)
            planService.shared.Api_To_GetAllRecipeByDate(Sdate: Sdate,vc: self) { result in
            
                    switch result {
                    case .success(let allData):
                        self.fetchPlanDataByDate(list: allData)
                    case .failure(let error):
                        // Handle error
                        self.ShowNoDataFoundonCollV1()
                        print("Error retrieving data: \(error.localizedDescription)")
                    }
            }
                case .failure(let error):
                    // Handle error
                    print("Error retrieving data: \(error.localizedDescription)")
                }
        }
        }else{
//            self.AllRecipeSelItem.recipes?.breakfast?[index].isLike = 1
//            self.Api_To_Like_UnlikeRecipe(uri: uri, type: "1")
            self.FavBtnClickNav(TypeClicked: "Breakfast", Uri: uri, SelID: "", index: index)
        }
        self.BreakFastCollV.reloadData()
    }
    
    @objc func FavLunchBtnClick(_ sender: UIButton)   {
        let SubscriptionStatus = Int(UserDetail.shared.getSubscriptionStatus())
        
        if SubscriptionStatus == 1{
            let addtoplanStatus = Int(UserDetail.shared.getfavorite()) ?? 0
            guard addtoplanStatus <= 2 else {
                SubscriptionPopUp ()
                return
            }
        }
        
        let index = sender.tag
        let uri = self.AllRecipeSelItem.recipes?.lunch?[index].recipe?.uri ?? ""
        let islike = self.AllRecipeSelItem.recipes?.lunch?[index].isLike
        if islike == 1{
            self.AllRecipeSelItem.recipes?.lunch?[index].isLike = 0
            
            planService.shared.Api_To_Like_UnlikeRecipe(uri: uri, type: "0", vc: self) { result in
            
                switch result {
                case .success(_):
                    let dateformatter = DateFormatter()
                    dateformatter.dateFormat = "yyyy-MM-dd"
            let Sdate = dateformatter.string(from: self.seldate)
            planService.shared.Api_To_GetAllRecipeByDate(Sdate: Sdate,vc: self) { result in
            
                    switch result {
                    case .success(let allData):
                        self.fetchPlanDataByDate(list: allData)
                    case .failure(let error):
                        // Handle error
                        self.ShowNoDataFoundonCollV1()
                        print("Error retrieving data: \(error.localizedDescription)")
                    }
            }
                case .failure(let error):
                    // Handle error
                    print("Error retrieving data: \(error.localizedDescription)")
                }
        }
        }else{
//            self.AllRecipeSelItem.recipes?.lunch?[index].isLike = 1
//            self.Api_To_Like_UnlikeRecipe(uri: uri, type: "1")
            self.FavBtnClickNav(TypeClicked: "Lunch", Uri: uri, SelID: "", index: index)
        }
        
        self.LunchCollV.reloadData()
    }
    
    @objc func FavDinnerBtnClick(_ sender: UIButton)   {
        let SubscriptionStatus = Int(UserDetail.shared.getSubscriptionStatus())
        
        if SubscriptionStatus == 1{
            let addtoplanStatus = Int(UserDetail.shared.getfavorite()) ?? 0
            guard addtoplanStatus <= 2 else {
                SubscriptionPopUp ()
                return
            }
        }
        
        let index = sender.tag
        let uri = self.AllRecipeSelItem.recipes?.dinner?[index].recipe?.uri ?? ""
        let islike = self.AllRecipeSelItem.recipes?.dinner?[index].isLike
        if islike == 1{
            self.AllRecipeSelItem.recipes?.dinner?[index].isLike = 0
            planService.shared.Api_To_Like_UnlikeRecipe(uri: uri, type: "0", vc: self) { result in
            
                switch result {
                case .success(_):
                    let dateformatter = DateFormatter()
                    dateformatter.dateFormat = "yyyy-MM-dd"
            let Sdate = dateformatter.string(from: self.seldate)
            planService.shared.Api_To_GetAllRecipeByDate(Sdate: Sdate,vc: self) { result in
            
                    switch result {
                    case .success(let allData):
                        self.fetchPlanDataByDate(list: allData)
                    case .failure(let error):
                        // Handle error
                        self.ShowNoDataFoundonCollV1()
                        print("Error retrieving data: \(error.localizedDescription)")
                    }
            }
                case .failure(let error):
                    // Handle error
                    print("Error retrieving data: \(error.localizedDescription)")
                }
        }
        }else{
//            self.AllRecipeSelItem.recipes?.dinner?[index].isLike = 1
//            self.Api_To_Like_UnlikeRecipe(uri: uri, type: "1")
            self.FavBtnClickNav(TypeClicked: "Dinner", Uri: uri, SelID: "", index: index)
        }
        self.DinnerCollV.reloadData()
    }
    
    @objc func FavSnacksBtnClick(_ sender: UIButton)   {
        let SubscriptionStatus = Int(UserDetail.shared.getSubscriptionStatus())
        
        if SubscriptionStatus == 1{
            let addtoplanStatus = Int(UserDetail.shared.getfavorite()) ?? 0
            guard addtoplanStatus <= 2 else {
                SubscriptionPopUp ()
                return
            }
        }
        
        let index = sender.tag
        let uri = self.AllRecipeSelItem.recipes?.Snack?[index].recipe?.uri ?? ""
        let islike = self.AllRecipeSelItem.recipes?.Snack?[index].isLike
        if islike == 1{
            self.AllRecipeSelItem.recipes?.Snack?[index].isLike = 0
            planService.shared.Api_To_Like_UnlikeRecipe(uri: uri, type: "0", vc: self) { result in
            
                    switch result {
                    case .success(_):
                        let dateformatter = DateFormatter()
                        dateformatter.dateFormat = "yyyy-MM-dd"
                let Sdate = dateformatter.string(from: self.seldate)
                planService.shared.Api_To_GetAllRecipeByDate(Sdate: Sdate,vc: self) { result in
                
                        switch result {
                        case .success(let allData):
                            self.fetchPlanDataByDate(list: allData)
                        case .failure(let error):
                            // Handle error
                            self.ShowNoDataFoundonCollV1()
                            print("Error retrieving data: \(error.localizedDescription)")
                        }
                }
                    case .failure(let error):
                        // Handle error
                        print("Error retrieving data: \(error.localizedDescription)")
                    }
            }
        }else{
           // self.AllRecipeSelItem.recipes?.Snack?[index].isLike = 1
          //  self.Api_To_Like_UnlikeRecipe(uri: uri, type: "1")
            self.FavBtnClickNav(TypeClicked: "Snacks", Uri: uri, SelID: "", index: index)
        }
        self.SnacksCollV.reloadData()
    }
    
    @objc func FavTeaTimeBtnClick(_ sender: UIButton)   {
        let SubscriptionStatus = Int(UserDetail.shared.getSubscriptionStatus())
        
        if SubscriptionStatus == 1{
            let addtoplanStatus = Int(UserDetail.shared.getfavorite()) ?? 0
            guard addtoplanStatus <= 2 else {
                SubscriptionPopUp ()
                return
            }
        }
        
        let index = sender.tag
        let uri = self.AllRecipeSelItem.recipes?.Teatime?[index].recipe?.uri ?? ""
      
        let islike = self.AllRecipeSelItem.recipes?.Teatime?[index].isLike
        if islike == 1{
            self.AllRecipeSelItem.recipes?.Teatime?[index].isLike = 0
            planService.shared.Api_To_Like_UnlikeRecipe(uri: uri, type: "0", vc: self) { result in
            
                    switch result {
                    case .success(_):
                        let dateformatter = DateFormatter()
                        dateformatter.dateFormat = "yyyy-MM-dd"
                let Sdate = dateformatter.string(from: self.seldate)
                planService.shared.Api_To_GetAllRecipeByDate(Sdate: Sdate,vc: self) { result in
                
                        switch result {
                        case .success(let allData):
                            self.fetchPlanDataByDate(list: allData)
                        case .failure(let error):
                            // Handle error
                            self.ShowNoDataFoundonCollV1()
                            print("Error retrieving data: \(error.localizedDescription)")
                        }
                }
                    case .failure(let error):
                        // Handle error
                        print("Error retrieving data: \(error.localizedDescription)")
                    }
            }
        }else{
          //  self.AllRecipeSelItem.recipes?.Teatime?[index].isLike = 1
            self.FavBtnClickNav(TypeClicked: "Brunch", Uri: uri, SelID: "", index: index)
        }
        self.TeaTimeCollV.reloadData()
    }
  
  
    
    func FavBtnClickNav(TypeClicked: String, Uri: String, SelID: String, index: Int)   {
         indx = index
         Seltype = TypeClicked
        
        let storyboard = UIStoryboard(name: "Tabbar", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "FavrouitPopupVC") as! FavrouitPopupVC
        vc.comesFrom = "FullCookingScheduleVC"
        vc.uri = Uri
        vc.selID = SelID
        vc.typeclicked = TypeClicked
        vc.backAction = {
            
            //Breakfast Lunch Dinner Snacks Brunch
            if self.Seltype == "Breakfast"{
                self.AllRecipeSelItem.recipes?.breakfast?[self.indx].isLike = 1
                self.BreakFastCollV.reloadData()
            }else if self.Seltype == "Lunch"{
                self.AllRecipeSelItem.recipes?.lunch?[self.indx].isLike = 1
                self.LunchCollV.reloadData()
            }else if self.Seltype == "Dinner"{
                self.AllRecipeSelItem.recipes?.dinner?[self.indx].isLike = 1
                self.DinnerCollV.reloadData()
            }else if self.Seltype == "Snacks"{
                self.AllRecipeSelItem.recipes?.Snack?[self.indx].isLike = 1
                self.SnacksCollV.reloadData()
            }else if self.Seltype == "Brunch"{
                self.AllRecipeSelItem.recipes?.breakfast?[self.indx].isLike = 1
                self.TeaTimeCollV.reloadData()
            }
          //  self.Api_To_GetAllRecipe()
        }
        self.addChild(vc)
        vc.view.frame = self.view.frame
        self.view.addSubview(vc.view)
        self.view.bringSubviewToFront(vc.view)
        vc.didMove(toParent: self)
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
    
    // for dish colllView for plus btns..
    @objc func BreakDishServecountPlusBtnClick(_ sender: UIButton)   {
        let index = sender.tag
        let uri = self.AllDataList.breakfast?[index].recipe?.uri ?? ""
        self.AllDataList.breakfast?[index].servings! += 1
        self.BreakFastDishCollV.reloadData()
         
        let count = self.AllDataList.breakfast?[index].servings ?? 0
    
        planService.shared.Api_For_AddServingcount(uri: uri, type: "Breakfast", servingCount: count, seldate: self.seldate,vc: self) { result in
            
            switch result {
            case .success(_):
                print("count added successfully")
            case .failure(let error):
                // Handle error
                print("Error retrieving data: \(error.localizedDescription)")
            }
        }
        
        }
    
    @objc func LunchDishServecountPlusBtnClick(_ sender: UIButton)   {
        let index = sender.tag
        let uri = self.AllDataList.lunch?[index].recipe?.uri ?? ""
        self.AllDataList.lunch?[index].servings! += 1
        self.LunchDishCollV.reloadData()
        
        let count = self.AllDataList.lunch?[index].servings ?? 0
    
        planService.shared.Api_For_AddServingcount(uri: uri, type: "Lunch", servingCount: count, seldate: self.seldate,vc: self) { result in
            
            switch result {
            case .success(_):
                print("count added successfully")
            case .failure(let error):
                // Handle error
                print("Error retrieving data: \(error.localizedDescription)")
            }
        }
        }
    
    @objc func DinnerDishServecountPlusBtnClick(_ sender: UIButton)   {
        let index = sender.tag
        let uri = self.AllDataList.dinner?[index].recipe?.uri ?? ""
        self.AllDataList.dinner?[index].servings! += 1
        self.DinnerDishCollV.reloadData()
        
        let count = self.AllDataList.dinner?[index].servings ?? 0
        
        planService.shared.Api_For_AddServingcount(uri: uri, type: "Dinner", servingCount: count, seldate: self.seldate,vc: self) { result in
            
            switch result {
            case .success(_):
                print("count added successfully")
            case .failure(let error):
                // Handle error
                print("Error retrieving data: \(error.localizedDescription)")
            }
        }
        }
    
    @objc func SnacksDishServecountPlusBtnClick(_ sender: UIButton)   {
        let index = sender.tag
        let uri = self.AllDataList.snacks?[index].recipe?.uri ?? ""
        self.AllDataList.snacks?[index].servings! += 1
        self.SnacksDishCollV.reloadData()
        
        let count = self.AllDataList.snacks?[index].servings ?? 0

        planService.shared.Api_For_AddServingcount(uri: uri, type: "Snacks", servingCount: count, seldate: self.seldate,vc: self) { result in
            
            switch result {
            case .success(_):
                print("count added successfully")
            case .failure(let error):
                // Handle error
                print("Error retrieving data: \(error.localizedDescription)")
            }
        }
        }
    
    @objc func TeaTimeDishServecountPlusBtnClick(_ sender: UIButton)   {
        let index = sender.tag
        let uri = self.AllDataList.teatime?[index].recipe?.uri ?? ""
        self.AllDataList.teatime?[index].servings! += 1
        self.TeaTimeDishCollV.reloadData()
        
        let count = self.AllDataList.snacks?[index].servings ?? 0

        planService.shared.Api_For_AddServingcount(uri: uri, type: "Brunch", servingCount: count, seldate: self.seldate,vc: self) { result in
            
            switch result {
            case .success(_):
                print("count added successfully")
            case .failure(let error):
                // Handle error
                print("Error retrieving data: \(error.localizedDescription)")
            }
        }
        }
    
    // for dish colllView for minus btns.
    @objc func BreakDishServecountMinusBtnClick(_ sender: UIButton)   {
        let index = sender.tag
        let uri = self.AllDataList.breakfast?[index].recipe?.uri ?? ""
        
        guard self.AllDataList.breakfast?[index].servings ?? 0 > 1 else{
            return
        }
        
        self.AllDataList.breakfast?[index].servings! -= 1
        self.BreakFastDishCollV.reloadData()
                 
        let count = self.AllDataList.breakfast?[index].servings ?? 0
 
        planService.shared.Api_For_AddServingcount(uri: uri, type: "Breakfast", servingCount: count, seldate: self.seldate,vc: self) { result in
            
            switch result {
            case .success(_):
                print("count added successfully")
            case .failure(let error):
                // Handle error
                print("Error retrieving data: \(error.localizedDescription)")
            }
        }
        }
    
    @objc func LunchDishServecountMinusBtnClick(_ sender: UIButton)   {
        let index = sender.tag
        let uri = self.AllDataList.lunch?[index].recipe?.uri ?? ""
        
        guard self.AllDataList.lunch?[index].servings ?? 0 > 1 else{
            return
        }
        
        self.AllDataList.lunch?[index].servings! -= 1
        self.LunchDishCollV.reloadData()
         
        let count = self.AllDataList.lunch?[index].servings ?? 0
        
        planService.shared.Api_For_AddServingcount(uri: uri, type: "Lunch", servingCount: count, seldate: self.seldate,vc: self) { result in
            
            switch result {
            case .success(_):
                print("count added successfully")
            case .failure(let error):
                // Handle error
                print("Error retrieving data: \(error.localizedDescription)")
            }
        }
        }
    
    @objc func DinnerDishServecountMinusBtnClick(_ sender: UIButton)   {
        let index = sender.tag
        let uri = self.AllDataList.dinner?[index].recipe?.uri ?? ""
        
        guard self.AllDataList.dinner?[index].servings ?? 0 > 1 else{
            return
        }
        
        self.AllDataList.dinner?[index].servings! -= 1
        self.DinnerDishCollV.reloadData()
        
        let count = self.AllDataList.dinner?[index].servings ?? 0
 
        planService.shared.Api_For_AddServingcount(uri: uri, type: "Dinner", servingCount: count, seldate: self.seldate,vc: self) { result in
            
            switch result {
            case .success(_):
                print("count added successfully")
            case .failure(let error):
                // Handle error
                print("Error retrieving data: \(error.localizedDescription)")
            }
        }
        }
    
    @objc func SnacksDishServecountMinusBtnClick(_ sender: UIButton)   {
        let index = sender.tag
        let uri = self.AllDataList.snacks?[index].recipe?.uri ?? ""
        
        guard self.AllDataList.snacks?[index].servings ?? 0 > 1 else{
            return
        }
        
        self.AllDataList.snacks?[index].servings! -= 1
        self.SnacksDishCollV.reloadData()
        
        let count = self.AllDataList.snacks?[index].servings ?? 0
  
        planService.shared.Api_For_AddServingcount(uri: uri, type: "Snacks", servingCount: count, seldate: self.seldate,vc: self) { result in
            
            switch result {
            case .success(_):
                print("count added successfully")
            case .failure(let error):
                // Handle error
                print("Error retrieving data: \(error.localizedDescription)")
            }
        }
        }
    
    @objc func TeaTimeDishServecountMinusBtnClick(_ sender: UIButton)   {
        let index = sender.tag
        let uri = self.AllDataList.teatime?[index].recipe?.uri ?? ""
        
        guard self.AllDataList.teatime?[index].servings ?? 0 > 1 else{
            return
        }
        
        self.AllDataList.teatime?[index].servings! -= 1
        self.TeaTimeDishCollV.reloadData()
        
        let count = self.AllDataList.snacks?[index].servings ?? 0
 
        planService.shared.Api_For_AddServingcount(uri: uri, type: "Brunch", servingCount: count, seldate: self.seldate,vc: self) { result in
            
            switch result {
            case .success(_):
                print("count added successfully")
            case .failure(let error):
                // Handle error
                print("Error retrieving data: \(error.localizedDescription)")
            }
        }
        }
    
    //
       
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == CalanderCollV{
            let today = Date()
            print(indexPath.row)
            
            let SelDate = currentWeekDates[indexPath.row]
             
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            formatter.timeZone = TimeZone.current // Use the local time zone
            // Convert to string
            let dateString = formatter.string(from: SelDate)
            // Convert back to date
            formatter.dateFormat = "yyyy-MM-dd"
            let reconvertedDate = formatter.date(from: dateString)
            
            let formatter1 = DateFormatter()
            formatter1.dateFormat = "yyyy-MM-dd"
            formatter1.timeZone = TimeZone.current // Use the local time zone
            // Convert to string
            let dateString1 = formatter1.string(from: today)
            // Convert back to date
            formatter1.dateFormat = "yyyy-MM-dd"
            let TodayreconvertedDate = formatter1.date(from: dateString1) ?? Date()
            
            guard reconvertedDate! >= TodayreconvertedDate else{
                     return // Exit if the previous week's start date is earlier than today
                 }
            
            // Deselect the previously selected item, if any
            if let previousIndex = selectedIndex {
                let previousCell = collectionView.cellForItem(at: previousIndex) as? CalendarCell
                previousCell?.updateSelection(isSelected: false)
            }
            
            // Select the current item
            let currentCell = collectionView.cellForItem(at: indexPath) as? CalendarCell
            currentCell?.updateSelection(isSelected: true)
            
            // Update the selected index
            selectedIndex = indexPath
            
            seldate = currentWeekDates[indexPath.item]
           // self.Api_To_GetAllRecipeByDate()
            planService.shared.Api_To_GetAllRecipe(vc: self) { result in
            
                    switch result {
                    case .success(let allData):
                        if let list = allData, list.recipes != nil {
                            self.AllRecipeSelItem = list
                           
                            self.ShowNoDataFoundonCollV()
                        }else{
                            self.ShowNoDataFoundonCollV()
                        }
                        
        //                    if self.veryFirstLoading == 1{
        //                        self.veryFirstLoading = 0
                            DispatchQueue.global().asyncAfter(deadline: .now()) {
                                let dateformatter = DateFormatter()
                                dateformatter.dateFormat = "yyyy-MM-dd"
                        let Sdate = dateformatter.string(from: self.seldate)
                        planService.shared.Api_To_GetAllRecipeByDate(Sdate: Sdate,vc: self) { result in
                        
                                switch result {
                                case .success(let allData):
                                    self.fetchPlanDataByDate(list: allData)
                                case .failure(let error):
                                    // Handle error
                                    self.ShowNoDataFoundonCollV1()
                                    print("Error retrieving data: \(error.localizedDescription)")
                                }
                        }
                            }
                       // }
                    case .failure(let error):
                        // Handle error
                        self.ShowNoDataFoundonCollV()
                        print("Error retrieving data: \(error.localizedDescription)")
                    }
            }
        }
        else if collectionView == BreakFastCollV{
            let storyboard = UIStoryboard(name: "Tabbar", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "RecipeDetailsVC") as! RecipeDetailsVC
            vc.MealType = "Breakfast"
            vc.uri = self.AllRecipeSelItem.recipes?.breakfast?[indexPath.item].recipe?.uri ?? ""
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }else if collectionView == LunchCollV{
            let storyboard = UIStoryboard(name: "Tabbar", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "RecipeDetailsVC") as! RecipeDetailsVC
            vc.MealType = "Lunch"
            vc.uri = self.AllRecipeSelItem.recipes?.lunch?[indexPath.item].recipe?.uri ?? ""
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }else if collectionView == DinnerCollV{
            let storyboard = UIStoryboard(name: "Tabbar", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "RecipeDetailsVC") as! RecipeDetailsVC
            vc.MealType = "Dinner"
            vc.uri = self.AllRecipeSelItem.recipes?.dinner?[indexPath.item].recipe?.uri ?? ""
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }else if collectionView == SnacksCollV{
            let storyboard = UIStoryboard(name: "Tabbar", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "RecipeDetailsVC") as! RecipeDetailsVC
            vc.MealType = "Snacks"
            vc.uri = self.AllRecipeSelItem.recipes?.Snack?[indexPath.item].recipe?.uri ?? ""
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }else if collectionView == TeaTimeCollV{
            let storyboard = UIStoryboard(name: "Tabbar", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "RecipeDetailsVC") as! RecipeDetailsVC
            vc.MealType = "Brunch"
            vc.uri = self.AllRecipeSelItem.recipes?.Teatime?[indexPath.item].recipe?.uri ?? ""
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
 
       func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
           _ = collectionView.frame.width // Full width for each cell, adjust as needed
           let height = collectionView.frame.height // Full height for each cell, adjust if needed
           
           if collectionView == CalanderCollV{
               let width = collectionView.frame.width / 7
               return CGSize(width: width, height: collectionView.frame.height)
           }else if collectionView == BreakFastCollV{
               return CGSize(width: 197, height: collectionView.frame.height)
           }else if collectionView == LunchCollV{
               return CGSize(width: 197, height: collectionView.frame.height)
           }else if collectionView == DinnerCollV{
               return CGSize(width: 197, height: collectionView.frame.height)
           }else if collectionView == TeaTimeCollV{
               return CGSize(width: 197, height: collectionView.frame.height)
           }else if collectionView == SnacksCollV{
               return CGSize(width: 197, height: collectionView.frame.height)
           } else {
               return CGSize(width: self.view.frame.width - 50, height: height)
           }
       }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == CalanderCollV{
            return 0
        }else{
            return 5
        }
        }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == CalanderCollV{
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }else if collectionView == BreakFastCollV{
            if section == 0 {
                return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 5)
            }else{
                return UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
            }
        }else if collectionView == LunchCollV{
            if section == 0 {
                return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 5)
            }else{
                return UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
            }
        }else if collectionView == DinnerCollV{
            if section == 0 {
                return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 5)
            }else{
                return UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
            }
        }else if collectionView == TeaTimeCollV{
            if section == 0 {
                return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 5)
            }else{
                return UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
            }
        }else if collectionView == SnacksCollV{
            if section == 0 {
                return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 5)
            }else{
                return UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
            }
        }else{
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == CalanderCollV{
            return 0
        }else{
            return 5
        }
     }
     
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        guard let collectionView = scrollView as? UICollectionView,
              collectionView == BreakFastDishCollV ||
                collectionView == LunchDishCollV ||
                collectionView == DinnerDishCollV ||
                collectionView == SnacksDishCollV ||
                collectionView == TeaTimeDishCollV else { return }
        
        targetContentOffset.pointee = scrollView.contentOffset
        
        var indexes = collectionView.indexPathsForVisibleItems
        indexes.sort()
        var index = indexes.first!
        let cell = collectionView.cellForItem(at: index)!
        let position = collectionView.contentOffset.x - cell.frame.origin.x
        if position > cell.frame.size.width/2{
           index.row = index.row+1
        }
        collectionView.scrollToItem(at: index, at: .left, animated: true )
     }
    }


extension PlanVc: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == ChoosedaysTblV {
            return ChooseDayData.count
        }else if tableView == ChooseMealTypeTblV{
            return ChooseMealTypeyData.count
        }else{
            return ArrData.count// for add another meal.
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == ChoosedaysTblV {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChooseDaysTblVCell", for: indexPath) as! ChooseDaysTblVCell
            cell.NameLbl.text = ChooseDayData[indexPath.row].Name
            cell.TickImg.image = ChooseDayData[indexPath.row].isSelected ? UIImage(named: "chck") : UIImage(named: "Unchck")
            cell.selectedBgImg.image = ChooseDayData[indexPath.row].isSelected ? UIImage(named: "Yelloborder") : UIImage(named: "Group 1171276489")
            cell.DropIMg.isHidden = true
            cell.selectionStyle = .none
            return cell
        }else if tableView == ChooseMealTypeTblV{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChooseDaysTblVCell", for: indexPath) as! ChooseDaysTblVCell
            cell.NameLbl.text = ChooseMealTypeyData[indexPath.row].Name
            cell.TickImg.image = ChooseMealTypeyData[indexPath.row].isSelected ? UIImage(named: "RadioOn") : UIImage(named: "RadioOff")
            cell.DropIMg.isHidden = true
            cell.selectionStyle = .none
            return cell
        }else if tableView == AddAnotherMealTblV{
            let cell = tableView.dequeueReusableCell(withIdentifier: "BodyGoalTblVCell", for: indexPath) as! BodyGoalTblVCell
            cell.NameLbl.text = ArrData[indexPath.row].Name
             
            if ArrData[indexPath.row].isSelected == true && ArrData[indexPath.row].Name == "Select all" {
                cell.TickImg.image = ArrData[indexPath.row].isSelected ? UIImage(named: "GreenTick") : UIImage(named: "")
                cell.selectedBgImg.image = ArrData[indexPath.row].isSelected ? UIImage(named: "GreenBorder") : UIImage(named: "Group 1171276489")
            }else{
                cell.TickImg.image = ArrData[indexPath.row].isSelected ? UIImage(named: "Tick1") : UIImage(named: "")
                cell.selectedBgImg.image = ArrData[indexPath.row].isSelected ? UIImage(named: "YelloBorder") : UIImage(named: "Group 1171276489")
            }
            cell.selectionStyle = .none
            return cell
        }
        return UITableViewCell()
    }
    
    
    @objc func BreakFastSwipBtnClicked(_ sender: UIButton){
//        let storyboard = UIStoryboard(name: "Tabbar", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "DailyInspirationsVC") as! DailyInspirationsVC
//        
//        self.addChild(vc)
//        vc.view.frame = self.view.frame
//        self.view.addSubview(vc.view)
//        self.view.bringSubviewToFront(vc.view)
//        vc.didMove(toParent: self)
        
        self.SwipeID = "\(self.AllDataList.breakfast?[sender.tag].id ?? 0)"
        self.SwapMealType = "Breakfast"
           
            self.BreakFastCollVBgV.isHidden = false
            self.BreakFastDishCollVBgV.isHidden = true
        
        if self.AllRecipeSelItem.recipes?.breakfast?.count ?? 0 == 0{
            self.BreakFastCollVBgV.isHidden = true
            self.BreakFastBtnBgV.isHidden = true
        }else{
            self.BreakFastCollVBgV.isHidden = false
            self.BreakFastBtnBgV.isHidden = false
        }
    }
    
    
    @objc func LunchSwipBtnClicked(_ sender: UIButton){
        self.SwipeID = "\(self.AllDataList.lunch?[sender.tag].id ?? 0)"
        self.SwapMealType = "Lunch"
         
        self.LunchCollVBgV.isHidden = false
        self.LunchDishCollVBgV.isHidden = true
        
        if self.AllRecipeSelItem.recipes?.lunch?.count ?? 0 == 0{
            self.LunchCollVBgV.isHidden = true
            self.LunchBtnBgV.isHidden = true
        }else{
            self.LunchCollVBgV.isHidden = false
            self.LunchBtnBgV.isHidden = false
        }
    }
    
    @objc func DinnerSwipBtnClicked(_ sender: UIButton){
        self.SwipeID = "\(self.AllDataList.dinner?[sender.tag].id ?? 0)"
        self.SwapMealType = "Dinner"
         
        self.DinnerCollVBgV.isHidden = false
        self.DinnerDishCollVBgV.isHidden = true
        
        if self.AllRecipeSelItem.recipes?.dinner?.count ?? 0 == 0{
            self.DinnerCollVBgV.isHidden = true
            self.DinnerBtnBgV.isHidden = true
        }else{
            self.DinnerCollVBgV.isHidden = false
            self.DinnerBtnBgV.isHidden = false
        }
    }
    
    @objc func SnacksSwipBtnClicked(_ sender: UIButton){
        self.SwipeID = "\(self.AllDataList.snacks?[sender.tag].id ?? 0)"
        self.SwapMealType = "Snacks"
        
        self.SnacksCollVBgV.isHidden = false
        self.SnacksDishCollVBgV.isHidden = true
        
        if self.AllRecipeSelItem.recipes?.Snack?.count ?? 0 == 0{
            self.SnacksCollVBgV.isHidden = true
            self.SnacksBtnBgV.isHidden = true
        }else{
            self.SnacksCollVBgV.isHidden = false
            self.SnacksBtnBgV.isHidden = false
        }
    }
    
    @objc func TeatimeSwipBtnClicked(_ sender: UIButton){
        self.SwipeID = "\(self.AllDataList.teatime?[sender.tag].id ?? 0)"
        self.SwapMealType = "Brunch"
         
        self.TeaTimeCollVBgV.isHidden = false
        self.TeaTimeDishCollVBgV.isHidden = true
        
        if self.AllRecipeSelItem.recipes?.Teatime?.count ?? 0 == 0{
            self.TeaTimeCollVBgV.isHidden = true
            self.TeaTimeBtnBgV.isHidden = true
        }else{
            self.TeaTimeCollVBgV.isHidden = false
            self.TeaTimeBtnBgV.isHidden = false
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == ChoosedaysTblV {
            if ChooseDayData[indexPath.row].isSelected {
                ChooseDayData[indexPath.row].isSelected = false
            }else{
                
                let dateformatter = DateFormatter()
                    let date = self.currentWeekDates[indexPath.row]
                    dateformatter.dateFormat = "yyyy-MM-dd"
                    let Sdate = dateformatter.string(from: date)
                dateformatter.dateFormat = "yyyy-MM-dd"
                let ReconvertDate = dateformatter.date(from: Sdate)!
                    
                    dateformatter.dateFormat = "EEEE" // Full day name, e.g., "Monday"
                    let dayOfWeek = dateformatter.string(from: date)
                let selDay = ChooseDayData[indexPath.row].Name
                
                guard selDay == dayOfWeek else { return }
                
                dateformatter.dateFormat = "yyyy-MM-dd"
                let Cdate = dateformatter.string(from: Date())
                dateformatter.dateFormat = "yyyy-MM-dd"
                let cReconvertDate = dateformatter.date(from: Cdate)!
                
                guard ReconvertDate >= cReconvertDate else { return }
                
                ChooseDayData[indexPath.row].isSelected = true
            }
            ChoosedaysTblV.reloadData()
        }else if tableView == ChooseMealTypeTblV{
            for i in 0..<ChooseMealTypeyData.count{
                ChooseMealTypeyData[i].isSelected = false
            }
            ChooseMealTypeyData[indexPath.row].isSelected = true
            
            if ChooseMealTypeyData[indexPath.row].Name == "Snacks"{
                self.mealType = "Snacks"
            }else if ChooseMealTypeyData[indexPath.row].Name == "Brunch"{
                self.mealType = "Brunch"
            }else{
                self.mealType = ChooseMealTypeyData[indexPath.row].Name
            }
          
            ChooseMealTypeTblV.reloadData()
        }else if tableView == AddAnotherMealTblV{
            if ArrData[indexPath.row].isSelected {
                if ArrData[indexPath.row].Name == "Select all" && ArrData[indexPath.row].isSelected == true{
                    ArrData[indexPath.row].isSelected = false
                }
                ArrData[indexPath.row].isSelected = false
            }else{
                ArrData[indexPath.row].isSelected = true
                
                // Check if all indexes except 0 are selected
                if ArrData.enumerated().allSatisfy({ index, item in
                    item.Name == "Select all" || item.isSelected
                }) {
                    ArrData[indexPath.row].isSelected = true
                }
            }
        
            self.AddAnotherMealTblV.reloadData()
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == ChoosedaysTblV {
            return 50
        }else if tableView == ChoosedaysTblV {
            return 50
        }else if tableView == ChooseMealTypeTblV{
            return 50
        }else{
            return 50
        }
    }
}
   

extension PlanVc {
    func calculateWeekDates(for date: Date) -> [Date] {
        // Ensure the first day of the week is Monday
        guard let weekInterval = calendar.dateInterval(of: .weekOfYear, for: date) else { return [] }
        let startOfWeek = calendar.date(byAdding: .day, value: -(calendar.component(.weekday, from: weekInterval.start) - 2), to: weekInterval.start)!

        // Return all dates from Monday to Sunday
        return (0..<7).compactMap { calendar.date(byAdding: .day, value: $0, to: startOfWeek) }
    }
    
   
    
    func updateWeekLabel() {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM"
        if let start = currentWeekDates.first, let end = currentWeekDates.last {
            
            weekLabel.text = "\(formatter.string(from: start)) - \(formatter.string(from: end))"
            
            ChooseDayWeekLabel.text = "\(formatter.string(from: start)) - \(formatter.string(from: end))"
            
            let formatter1 = DateFormatter()
            formatter1.dateFormat = "d" // For the day number
            
            formatter1.dateFormat = "MMM, yyyy"
            let Monthyear = formatter1.string(from: start)
            FromDateToLbl.text = "\(Monthyear)"
            
            for j in 0..<ChooseDayData.count {
                ChooseDayData[j].isSelected = false
            }
            ChoosedaysTblV.reloadData()
            
        }
    }
}

extension PlanVc {
    
    func fetchPlanDataByDate(list:YourCookedMealModel?){
        self.AllDataList  = list ?? YourCookedMealModel()
        
        //                    if self.AllDataList.fat != 0 || self.AllDataList.protein != 0 || self.AllDataList.carbs != 0 || self.AllDataList.kcal != 0{
        if self.AllDataList.show == 1{
            self.CalculateBMRBgV.isHidden = true
            self.DailyNutritionCountBgV.isHidden = false
            
            let cal = self.roundedFormattedValue(self.AllDataList.kcal ?? 0, decimalPlaces: 2)
            let pro = self.roundedFormattedValue(self.AllDataList.protein ?? 0, decimalPlaces: 2)
            let car = self.roundedFormattedValue(self.AllDataList.carbs ?? 0, decimalPlaces: 2)
            let fat = self.roundedFormattedValue(self.AllDataList.fat ?? 0, decimalPlaces: 2)
            
            self.CaloriesLbl.text = "\(cal)"
            self.ProtienLbl.text = "\(pro)"
            self.CarbsLbl.text = "\(car)"
            self.FatLbl.text = "\(fat)"
            
        }else{
            self.CaloriesLbl.text = "0"
            self.ProtienLbl.text = "0"
            self.CarbsLbl.text = "0"
            self.FatLbl.text = "0"
            self.CalculateBMRBgV.isHidden = false
            self.DailyNutritionCountBgV.isHidden = false
        }
        
        if self.AllDataList.breakfast?.count ?? 0 != 0 || self.AllDataList.lunch?.count ?? 0 != 0 || self.AllDataList.dinner?.count ?? 0 != 0 || self.AllDataList.snacks?.count ?? 0 != 0 ||
            self.AllDataList.teatime?.count ?? 0 != 0{
            self.AddtoBasketBtnO.isUserInteractionEnabled = true
            self.AddtoBasketBtnO.backgroundColor = #colorLiteral(red: 0, green: 0.786260426, blue: 0.4870494008, alpha: 1)
        }else{
            
            self.AddtoBasketBtnO.isUserInteractionEnabled = false
            self.AddtoBasketBtnO.backgroundColor = UIColor.lightGray
        }
        self.ShowNoDataFoundonCollV1()
    }
    
    func fetchBodyGoalsData(responseArray: [[String : Any]]){
        self.MealRoutineArr.removeAll()
        self.MealRoutineArr = ModelClass.getBodyGoalsDetails(responseArray: responseArray)
        self.ArrData.removeAll()
        
        for i in self.MealRoutineArr{
            self.ArrData.append(contentsOf: [BodyGoalsModel(Name: i.name, id: i.id, isSelected: i.selected)])
        }
        
        self.AddAnotherMealTblV.reloadData()
    }
    
    
    // for All Recipe.
    func ShowNoDataFoundonCollV(){
        if self.AllRecipeSelItem.recipes?.breakfast?.count ?? 0 == 0{
            self.BreakFastCollVBgV.isHidden = true
            self.BreakFastBtnBgV.isHidden = true
        }else{
            self.BreakFastCollVBgV.isHidden = false
            self.BreakFastBtnBgV.isHidden = false
        }
        
        if self.AllRecipeSelItem.recipes?.lunch?.count ?? 0 == 0{
            self.LunchCollVBgV.isHidden = true
            self.LunchBtnBgV.isHidden = true
        }else{
            self.LunchCollVBgV.isHidden = false
            self.LunchBtnBgV.isHidden = false
        }
        
        
        if self.AllRecipeSelItem.recipes?.dinner?.count ?? 0 == 0{
            self.DinnerCollVBgV.isHidden = true
            self.DinnerBtnBgV.isHidden = true
        }else{
            self.DinnerCollVBgV.isHidden = false
            self.DinnerBtnBgV.isHidden = false
        }
        
        if self.AllRecipeSelItem.recipes?.Snack?.count ?? 0 == 0{
            self.SnacksCollVBgV.isHidden = true
            self.SnacksBtnBgV.isHidden = true
        }else{
            self.SnacksCollVBgV.isHidden = false
            self.SnacksBtnBgV.isHidden = false
        }
        
        if self.AllRecipeSelItem.recipes?.Teatime?.count ?? 0 == 0{
            self.TeaTimeCollVBgV.isHidden = true
            self.TeaTimeBtnBgV.isHidden = true
        }else{
            self.TeaTimeCollVBgV.isHidden = false
            self.TeaTimeBtnBgV.isHidden = false
        }
        
        
        self.BreakFastCollV.reloadData()
        self.LunchCollV.reloadData()
        self.DinnerCollV.reloadData()
        self.SnacksCollV.reloadData()
        self.TeaTimeCollV.reloadData()
    }
    
    // for Recipe by Date
    func ShowNoDataFoundonCollV1(){
        if self.AllDataList.breakfast?.count ?? 0 == 0{
            // self.BreakFastCollVBgV.isHidden = false
            self.BreakFastDishCollVBgV.isHidden = true
            
            
            if self.AllRecipeSelItem.recipes?.breakfast?.count ?? 0 == 0{
                self.BreakFastCollVBgV.isHidden = true
                self.BreakFastBtnBgV.isHidden = true
            }else{
                self.BreakFastCollVBgV.isHidden = false
                self.BreakFastBtnBgV.isHidden = false
            }
        }else{
            self.BreakFastCollVBgV.isHidden = true
            self.BreakFastDishCollVBgV.isHidden = false
            self.BreakFastBtnBgV.isHidden = false
        }
        
        if self.AllDataList.lunch?.count ?? 0 == 0{
            // self.LunchCollVBgV.isHidden = false
            self.LunchDishCollVBgV.isHidden = true
            
            if self.AllRecipeSelItem.recipes?.lunch?.count ?? 0 == 0{
                self.LunchCollVBgV.isHidden = true
                self.LunchBtnBgV.isHidden = true
            }else{
                self.LunchCollVBgV.isHidden = false
                self.LunchBtnBgV.isHidden = false
            }
        }else{
            self.LunchCollVBgV.isHidden = true
            self.LunchDishCollVBgV.isHidden = false
            self.LunchBtnBgV.isHidden = false
        }
        
        
        if self.AllDataList.dinner?.count ?? 0 == 0{
            //  self.DinnerCollVBgV.isHidden = false
            self.DinnerDishCollVBgV.isHidden = true
            
            if self.AllRecipeSelItem.recipes?.dinner?.count ?? 0 == 0{
                self.DinnerCollVBgV.isHidden = true
                self.DinnerBtnBgV.isHidden = true
            }else{
                self.DinnerCollVBgV.isHidden = false
                self.DinnerBtnBgV.isHidden = false
            }
        }else{
            self.DinnerCollVBgV.isHidden = true
            self.DinnerDishCollVBgV.isHidden = false
            self.DinnerBtnBgV.isHidden = false
        }
        
        if self.AllDataList.snacks?.count ?? 0 == 0{
            //  self.SnacksCollVBgV.isHidden = false
            self.SnacksDishCollVBgV.isHidden = true
            
            if self.AllRecipeSelItem.recipes?.Snack?.count ?? 0 == 0{
                self.SnacksCollVBgV.isHidden = true
                self.SnacksBtnBgV.isHidden = true
            }else{
                self.SnacksCollVBgV.isHidden = false
                self.SnacksBtnBgV.isHidden = false
            }
        }else{
            self.SnacksCollVBgV.isHidden = true
            self.SnacksDishCollVBgV.isHidden = false
            self.SnacksBtnBgV.isHidden = false
        }
        
        if self.AllDataList.teatime?.count ?? 0 == 0{
            // self.TeaTimeCollVBgV.isHidden = false
            self.TeaTimeDishCollVBgV.isHidden = true
            
            if self.AllRecipeSelItem.recipes?.Teatime?.count ?? 0 == 0{
                self.TeaTimeCollVBgV.isHidden = true
                self.TeaTimeBtnBgV.isHidden = true
            }else{
                self.TeaTimeCollVBgV.isHidden = false
                self.TeaTimeBtnBgV.isHidden = false
            }
        }else{
            self.TeaTimeCollVBgV.isHidden = true
            self.TeaTimeDishCollVBgV.isHidden = false
            self.TeaTimeBtnBgV.isHidden = false
        }
        
        if self.AllDataList.breakfast?.count ?? 0 != 0 || self.AllDataList.lunch?.count ?? 0 != 0 || self.AllDataList.dinner?.count ?? 0 != 0 || self.AllDataList.snacks?.count ?? 0 != 0 || self.AllDataList.teatime?.count ?? 0 != 0{
            //            self.AddtoBasketBtnO.isUserInteractionEnabled = true
            //            self.AddtoBasketBtnO.backgroundColor = #colorLiteral(red: 0.02352941176, green: 0.7568627451, blue: 0.4117647059, alpha: 1)
        }else{
            self.AddtoBasketBtnO.isUserInteractionEnabled = false
            self.AddtoBasketBtnO.backgroundColor = UIColor.lightGray
        }
        
        self.BreakFastDishCollV.reloadData()
        self.LunchDishCollV.reloadData()
        self.DinnerDishCollV.reloadData()
        self.SnacksDishCollV.reloadData()
        self.TeaTimeDishCollV.reloadData()
    }
}

     
