//
//  StatesForWeekOrYearVC.swift
//  Myka App
//
//  Created by Sumit on 12/12/24.
//

import UIKit
import Alamofire
import SDWebImage

class StatesForWeekOrYearVC: UIViewController, UIPopoverPresentationControllerDelegate {

    @IBOutlet weak var FromDateToLbl: UILabel!
    @IBOutlet weak var CalanderCollV: UICollectionView!
    @IBOutlet weak var weekLabel: UILabel!
    @IBOutlet weak var BreakFastCollV: UICollectionView!
    @IBOutlet weak var LunchCollV: UICollectionView!
    @IBOutlet weak var DinnerCollV: UICollectionView!
    @IBOutlet weak var SnacksCollV: UICollectionView!
    @IBOutlet weak var TeatimeCollV: UICollectionView!
    @IBOutlet weak var MarketTblV: UITableView!
    @IBOutlet weak var MarketTblVH: NSLayoutConstraint!
    
    @IBOutlet weak var BreakFastBgV: UIView!
    @IBOutlet weak var LunchBgV: UIView!
    @IBOutlet weak var DinnerBgV: UIView!
    @IBOutlet weak var SnacksBgV: UIView!
    @IBOutlet weak var TeatimeBgV: UIView!
    
    
    // for the Amount Spent outlets.
    @IBOutlet weak var AmountSpentBreakFastLbl: UILabel!
    @IBOutlet weak var AmountSpentBreakFastThisWeekLbl: UILabel!
    @IBOutlet weak var SpentBreakFastThisWeekLbl: UILabel!
    
    @IBOutlet weak var AmountSpentLunchLbl: UILabel!
    @IBOutlet weak var AmountSpentLunchThisWeekLbl: UILabel!
    @IBOutlet weak var SpentLunchThisWeekLbl: UILabel!
    
    @IBOutlet weak var AmountSpentDinnerLbl: UILabel!
    @IBOutlet weak var AmountSpentDinnerThisWeekLbl: UILabel!
    @IBOutlet weak var SpentDinnerThisWeekLbl: UILabel!
    
    @IBOutlet weak var AmountSpentSnacksLbl: UILabel!
    @IBOutlet weak var AmountSpentSnacksThisWeekLbl: UILabel!
    @IBOutlet weak var SpentSnacksThisWeekLbl: UILabel!
    
    @IBOutlet weak var AmountSpentTeatimeLbl: UILabel!
    @IBOutlet weak var AmountSpentTeatimeThisWeekLbl: UILabel!
    @IBOutlet weak var SpentTeatimeThisWeekLbl: UILabel!
    
    //
    @IBOutlet weak var NoOrderLbl: UILabel!
    
    // for Choosedays popup
    @IBOutlet var ChoosedaysPopupV: UIView!
    @IBOutlet weak var ChoosedaysTblV: UITableView!
    @IBOutlet weak var ChooseDayWeekLabel: UILabel!
    //
    
    // for Choosedays popup
    @IBOutlet var ChooseMealTypePopupV: UIView!
    @IBOutlet weak var ChooseMealTypeTblV: UITableView!
    //
     
  
    var currentWeekDates: [Date] = []
    var calendar = Calendar.current
    
    var selectedIndex: IndexPath?
    
    var seldate = Date()
    
    var longPressedEnabled = false
    
    
    
    var BreakfastData = ["Pasta", "BBQ", "stawberry"]
    var LunchData = ["Pasta", "Bar-B-Q", "Pizza"]
    var DinnerData = ["Lasagne", "stawberry", "Pizza"]
    
    
    // for popUps
    
    var ChooseDayData = [BodyGoalsModel(Name: "Monday", isSelected: false), BodyGoalsModel(Name: "Tuesday", isSelected: false), BodyGoalsModel(Name: "Wednesday", isSelected: false), BodyGoalsModel(Name: "Thursday", isSelected: false), BodyGoalsModel(Name: "Friday", isSelected: false), BodyGoalsModel(Name: "Saturday", isSelected: false), BodyGoalsModel(Name: "Sunday", isSelected: false)]
    
    var ChooseMealTypeyData = [BodyGoalsModel(Name: "Breakfast", isSelected: false), BodyGoalsModel(Name: "Lunch", isSelected: false), BodyGoalsModel(Name: "Dinner", isSelected: false), BodyGoalsModel(Name: "Snacks", isSelected: false), BodyGoalsModel(Name: "Brunch", isSelected: false)]
        //
    
    var StatesDataList = StatesForWeekModelData()
    
    var StartDate = ""
    var EndDate = ""
     
    
    // for api use only.
    var uri = ""
    var mealType = ""
    
    // for lazy loading
    var indx = Int()
    var Seltype = ""
    //
    
    override func viewDidLoad() {
            super.viewDidLoad()
        self.ChoosedaysPopupV.frame = self.view.bounds
        self.view.addSubview(self.ChoosedaysPopupV)
        self.ChoosedaysPopupV.isHidden = true
        
        self.ChooseMealTypePopupV.frame = self.view.bounds
        self.view.addSubview(self.ChooseMealTypePopupV)
        self.ChooseMealTypePopupV.isHidden = true
        
        self.NoOrderLbl.isHidden = true
       
            calendar.firstWeekday = 2 // Start the week on Monday
            setupInitialWeek()
            setupCollectionView()
            setupTableView()
        
    //    self.Api_To_get_StatesForWeekOrYear()
       
        self.MarketTblV.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize" {
            if let tableView = object as? UITableView {
                if tableView == MarketTblV {
                    MarketTblVH.constant = tableView.contentSize.height
                }
                view.layoutIfNeeded()
            }
        }
    }
    
    
    deinit {
        // Remove observers
        MarketTblV.removeObserver(self, forKeyPath: "contentSize")
    }
        
    private func setupInitialWeek() {
        let today = self.seldate
            currentWeekDates = calculateWeekDates(for: today)
            updateWeekLabel()
        }
        
        private func setupCollectionView() {
            CalanderCollV.delegate = self
            CalanderCollV.dataSource = self
            CalanderCollV.register(UINib(nibName: "CalendarCell", bundle: nil), forCellWithReuseIdentifier: "CalendarCell")
            
            BreakFastCollV.delegate = self
            BreakFastCollV.dataSource = self
            BreakFastCollV.register(UINib(nibName: "StatesForWeekOrYearCollVCell", bundle: nil), forCellWithReuseIdentifier: "StatesForWeekOrYearCollVCell")
            
            LunchCollV.delegate = self
            LunchCollV.dataSource = self
            LunchCollV.register(UINib(nibName: "StatesForWeekOrYearCollVCell", bundle: nil), forCellWithReuseIdentifier: "StatesForWeekOrYearCollVCell")
            
            DinnerCollV.delegate = self
            DinnerCollV.dataSource = self
            DinnerCollV.register(UINib(nibName: "StatesForWeekOrYearCollVCell", bundle: nil), forCellWithReuseIdentifier: "StatesForWeekOrYearCollVCell")
            
            SnacksCollV.delegate = self
            SnacksCollV.dataSource = self
            SnacksCollV.register(UINib(nibName: "StatesForWeekOrYearCollVCell", bundle: nil), forCellWithReuseIdentifier: "StatesForWeekOrYearCollVCell")
            
            TeatimeCollV.delegate = self
            TeatimeCollV.dataSource = self
            TeatimeCollV.register(UINib(nibName: "StatesForWeekOrYearCollVCell", bundle: nil), forCellWithReuseIdentifier: "StatesForWeekOrYearCollVCell")
        }
    
    // for popups and market.
    private func setupTableView() {
        self.MarketTblV.register(UINib(nibName: "MarketTblVCell", bundle: nil), forCellReuseIdentifier: "MarketTblVCell")
        self.MarketTblV.delegate = self
        self.MarketTblV.dataSource = self
        self.MarketTblV.separatorStyle = .none
        
         
        self.ChoosedaysTblV.register(UINib(nibName: "ChooseDaysTblVCell", bundle: nil), forCellReuseIdentifier: "ChooseDaysTblVCell")
        self.ChoosedaysTblV.delegate = self
        self.ChoosedaysTblV.dataSource = self
        self.ChoosedaysTblV.separatorStyle = .none
        
        self.ChooseMealTypeTblV.register(UINib(nibName: "ChooseDaysTblVCell", bundle: nil), forCellReuseIdentifier: "ChooseDaysTblVCell")
        self.ChooseMealTypeTblV.delegate = self
        self.ChooseMealTypeTblV.dataSource = self
        self.ChooseMealTypeTblV.separatorStyle = .none
    }
 
         
    @IBAction func BackBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    

    @IBAction func CalanderDropBtn(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "Tabbar", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "StatesCalendarVC") as! StatesCalendarVC
        vc.seldate = seldate
        vc.backAction = {date in
            self.seldate = date
            self.currentWeekDates = self.calculateWeekDates(for: date)
            self.updateWeekLabel()
 
        }
        self.addChild(vc)
        vc.view.frame = self.view.frame
        self.view.addSubview(vc.view)
        self.view.bringSubviewToFront(vc.view)
        vc.didMove(toParent: self)
    }
    
    // for custome calander.
    @IBAction func previousWeekTapped(_ sender: UIButton) {
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
       }
    
    @IBAction func ChoosedaysDoneBtn(_ sender: UIButton) {
        self.ChoosedaysPopupV.isHidden = true
        self.ChooseMealTypePopupV.isHidden = false
    }
    
    @IBAction func ChooseMealDoneBtn(_ sender: UIButton) {
      
        guard ChooseMealTypeyData.contains(where: { $0.isSelected }) else {
            AlertControllerOnr(title: "", message: "Please select meal type.")
            return
        }
        self.ChooseMealTypePopupV.isHidden = true
         
        self.Api_For_AddToPlan(uri: self.uri, type: self.mealType)
    }
}

extension StatesForWeekOrYearVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == CalanderCollV{
            return currentWeekDates.count
        }else if collectionView == BreakFastCollV{
            return self.StatesDataList.recipes?.breakfast?.count ?? 0
        }else if collectionView == LunchCollV{
            return self.StatesDataList.recipes?.lunch?.count ?? 0
        }else if collectionView == DinnerCollV{
            return self.StatesDataList.recipes?.dinner?.count ?? 0
        }else if collectionView == SnacksCollV{
            return self.StatesDataList.recipes?.Snack?.count ?? 0
        }else{
            return self.StatesDataList.recipes?.Teatime?.count ?? 0
        }
       }
       
       func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            
           if collectionView == CalanderCollV{
               let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CalendarCell", for: indexPath) as! CalendarCell
               let date = currentWeekDates[indexPath.item]
               cell.configure(with: date)
               cell.updateSelection(isSelected: true)
               return cell
           }else if collectionView == BreakFastCollV{
               let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StatesForWeekOrYearCollVCell", for: indexPath) as! StatesForWeekOrYearCollVCell
               cell.NameLbl.text = self.StatesDataList.recipes?.breakfast?[indexPath.item].recipe?.label ?? ""
               
               cell.PriceLbl.text = "$\(self.StatesDataList.recipes?.breakfast?[indexPath.item].price ?? 0)* per /s"
               
               cell.TimeLbl.text = "\(self.StatesDataList.recipes?.breakfast?[indexPath.item].recipe?.totalTime ?? 0 ) min"
 
               let img = self.StatesDataList.recipes?.breakfast?[indexPath.item].recipe?.images?.small?.url ?? ""
               let ImgUrl = URL(string: img) ?? nil
               cell.ImgV.sd_imageIndicator = SDWebImageActivityIndicator.medium
               cell.ImgV.sd_setImage(with: ImgUrl, placeholderImage: UIImage(named: "No_Image"))
                
               let islike = self.StatesDataList.recipes?.breakfast?[indexPath.item].isLike
               
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
               let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StatesForWeekOrYearCollVCell", for: indexPath) as! StatesForWeekOrYearCollVCell
               cell.NameLbl.text = self.StatesDataList.recipes?.lunch?[indexPath.item].recipe?.label ?? ""
               
               cell.PriceLbl.text = "$\(self.StatesDataList.recipes?.lunch?[indexPath.item].price ?? 0)* per /s"
               
               cell.TimeLbl.text = "\(self.StatesDataList.recipes?.lunch?[indexPath.item].recipe?.totalTime ?? 0 ) min"
               
               let img = self.StatesDataList.recipes?.lunch?[indexPath.item].recipe?.images?.small?.url ?? ""
               let ImgUrl = URL(string: img) ?? nil
               cell.ImgV.sd_imageIndicator = SDWebImageActivityIndicator.medium
               cell.ImgV.sd_setImage(with: ImgUrl, placeholderImage: UIImage(named: "No_Image"))
               
               let islike = self.StatesDataList.recipes?.lunch?[indexPath.item].isLike
               
               if islike == 1{
                   cell.FavBtn.setImage(UIImage(named: "Fav"), for: .normal)
               }else{
                   cell.FavBtn.setImage(UIImage(named: "UnFav"), for: .normal)
               }
        
               cell.AddToPlanBtn.tag = indexPath.item
               cell.AddToPlanBtn.addTarget(self, action: #selector(LunchAddtoPlanBtnClick(_:)), for: .touchUpInside)
               
               cell.FavBtn.tag = indexPath.item
               cell.FavBtn.addTarget(self, action: #selector(FavLunchBtnClick(_:)), for: .touchUpInside)
               
               cell.CartBtn.tag = indexPath.item
               cell.CartBtn.addTarget(self, action: #selector(LunchAddtoBasketBtnClick(_:)), for: .touchUpInside)
               
               return cell
           }else if collectionView == DinnerCollV{
               let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StatesForWeekOrYearCollVCell", for: indexPath) as! StatesForWeekOrYearCollVCell
               cell.NameLbl.text = self.StatesDataList.recipes?.dinner?[indexPath.item].recipe?.label ?? ""
               
               cell.PriceLbl.text = "$\(self.StatesDataList.recipes?.dinner?[indexPath.item].price ?? 0)* per /s"
               
               cell.TimeLbl.text = "\(self.StatesDataList.recipes?.dinner?[indexPath.item].recipe?.totalTime ?? 0 ) min"
               
               let img = self.StatesDataList.recipes?.dinner?[indexPath.item].recipe?.images?.small?.url ?? ""
               let ImgUrl = URL(string: img) ?? nil
               cell.ImgV.sd_imageIndicator = SDWebImageActivityIndicator.medium
               cell.ImgV.sd_setImage(with: ImgUrl, placeholderImage: UIImage(named: "No_Image"))
               
               let islike = self.StatesDataList.recipes?.dinner?[indexPath.item].isLike
               
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
               let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StatesForWeekOrYearCollVCell", for: indexPath) as! StatesForWeekOrYearCollVCell
               cell.NameLbl.text = self.StatesDataList.recipes?.Snack?[indexPath.item].recipe?.label ?? ""
               
               cell.PriceLbl.text = "$\(self.StatesDataList.recipes?.Snack?[indexPath.item].price ?? 0)* per /s"
               
               cell.TimeLbl.text = "\(self.StatesDataList.recipes?.Snack?[indexPath.item].recipe?.totalTime ?? 0 ) min"
               
               let img = self.StatesDataList.recipes?.Snack?[indexPath.item].recipe?.images?.small?.url ?? ""
               let ImgUrl = URL(string: img) ?? nil
               cell.ImgV.sd_imageIndicator = SDWebImageActivityIndicator.medium
               cell.ImgV.sd_setImage(with: ImgUrl, placeholderImage: UIImage(named: "No_Image"))
               
               let islike = self.StatesDataList.recipes?.Snack?[indexPath.item].isLike
               
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
           }else{
               let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StatesForWeekOrYearCollVCell", for: indexPath) as! StatesForWeekOrYearCollVCell
               cell.NameLbl.text = self.StatesDataList.recipes?.Teatime?[indexPath.item].recipe?.label ?? ""
               
               cell.PriceLbl.text = "$\(self.StatesDataList.recipes?.Teatime?[indexPath.item].price ?? 0)* per /s"
               
               cell.TimeLbl.text = "\(self.StatesDataList.recipes?.Teatime?[indexPath.item].recipe?.totalTime ?? 0 ) min"
               
               let img = self.StatesDataList.recipes?.Teatime?[indexPath.item].recipe?.images?.small?.url ?? ""
               let ImgUrl = URL(string: img) ?? nil
               cell.ImgV.sd_imageIndicator = SDWebImageActivityIndicator.medium
               cell.ImgV.sd_setImage(with: ImgUrl, placeholderImage: UIImage(named: "No_Image"))
               
               let islike = self.StatesDataList.recipes?.Teatime?[indexPath.item].isLike
               
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
           }
       }
    
    
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
        let uri = self.StatesDataList.recipes?.breakfast?[sender.tag].recipe?.uri ?? ""
            self.uri = uri
            self.ChoosedaysPopupV.isHidden = false
         
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
        let uri = self.StatesDataList.recipes?.lunch?[sender.tag].recipe?.uri ?? ""
        
            self.uri = uri
            self.ChoosedaysPopupV.isHidden = false
        
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
        let uri = self.StatesDataList.recipes?.dinner?[sender.tag].recipe?.uri ?? ""
        
            self.uri = uri
            self.ChoosedaysPopupV.isHidden = false
        
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
        let uri = self.StatesDataList.recipes?.Snack?[sender.tag].recipe?.uri ?? ""
         
            self.uri = uri
            self.ChoosedaysPopupV.isHidden = false
         
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
        
        let uri = self.StatesDataList.recipes?.Teatime?[sender.tag].recipe?.uri ?? ""
         
            self.uri = uri
            self.ChoosedaysPopupV.isHidden = false
         
    }
    
    
    //basketBtn
    @objc func BreakAddtoBasketBtnClick(_ sender: UIButton)   {
        let index = sender.tag
        let uri = self.StatesDataList.recipes?.breakfast?[sender.tag].recipe?.uri ?? ""
        
        self.Api_To_AddToBasket_Recipe(uri: uri, type: "Breakfast")
        }
    
    @objc func LunchAddtoBasketBtnClick(_ sender: UIButton)   {
        let index = sender.tag
        let uri = self.StatesDataList.recipes?.lunch?[sender.tag].recipe?.uri ?? ""
        self.Api_To_AddToBasket_Recipe(uri: uri, type: "Lunch")
        }
    
    @objc func DinnerAddtoBasketBtnClick(_ sender: UIButton)   {
        let index = sender.tag
        let uri = self.StatesDataList.recipes?.dinner?[sender.tag].recipe?.uri ?? ""
        self.Api_To_AddToBasket_Recipe(uri: uri, type: "Dinner")
        }
    
    @objc func SnacksAddtoBasketBtnClick(_ sender: UIButton)   {
        let index = sender.tag
        let uri = self.StatesDataList.recipes?.Snack?[sender.tag].recipe?.uri ?? ""
        self.Api_To_AddToBasket_Recipe(uri: uri, type: "Snacks")
        }
    
    @objc func TeaTimeAddtoBasketBtnClick(_ sender: UIButton)   {
        let index = sender.tag
        let uri = self.StatesDataList.recipes?.Teatime?[sender.tag].recipe?.uri ?? ""
        self.Api_To_AddToBasket_Recipe(uri: uri, type: "Brunch")
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
        let uri = self.StatesDataList.recipes?.breakfast?[index].recipe?.uri ?? ""
        let islike = self.StatesDataList.recipes?.breakfast?[sender.tag].isLike ?? 0
        if islike == 1{
            self.StatesDataList.recipes?.breakfast?[sender.tag].isLike = 0
            self.Api_To_Like_UnlikeRecipe(uri: uri, type: "0")
        }else{
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
        let uri = self.StatesDataList.recipes?.lunch?[index].recipe?.uri ?? ""
        let islike = self.StatesDataList.recipes?.lunch?[sender.tag].isLike ?? 0
        if islike == 1{
            self.StatesDataList.recipes?.lunch?[sender.tag].isLike = 0
            self.Api_To_Like_UnlikeRecipe(uri: uri, type: "0")
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
        let uri = self.StatesDataList.recipes?.dinner?[index].recipe?.uri ?? ""
        let islike = self.StatesDataList.recipes?.dinner?[sender.tag].isLike ?? 0
        if islike == 1{
            self.StatesDataList.recipes?.dinner?[sender.tag].isLike = 0
            self.Api_To_Like_UnlikeRecipe(uri: uri, type: "0")
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
        let uri = self.StatesDataList.recipes?.Snack?[index].recipe?.uri ?? ""
        let islike = self.StatesDataList.recipes?.Snack?[sender.tag].isLike ?? 0
        if islike == 1{
            self.StatesDataList.recipes?.Snack?[sender.tag].isLike = 0
            self.Api_To_Like_UnlikeRecipe(uri: uri, type: "0")
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
        let uri = self.StatesDataList.recipes?.Teatime?[index].recipe?.uri ?? ""
        let islike = self.StatesDataList.recipes?.Teatime?[sender.tag].isLike ?? 0
        if islike == 1{
            self.StatesDataList.recipes?.Teatime?[sender.tag].isLike = 0
            self.Api_To_Like_UnlikeRecipe(uri: uri, type: "0")
        }else{
          //  self.AllRecipeSelItem.recipes?.Teatime?[index].isLike = 1
            self.FavBtnClickNav(TypeClicked: "Brunch", Uri: uri, SelID: "", index: index)
        }
        self.TeatimeCollV.reloadData()
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
                self.StatesDataList.recipes?.breakfast?[self.indx].isLike = 1
                self.BreakFastCollV.reloadData()
            }else if self.Seltype == "Lunch"{
                self.StatesDataList.recipes?.lunch?[self.indx].isLike = 1
                self.LunchCollV.reloadData()
            }else if self.Seltype == "Dinner"{
                self.StatesDataList.recipes?.dinner?[self.indx].isLike = 1
                self.DinnerCollV.reloadData()
            }else if self.Seltype == "Snacks"{
                self.StatesDataList.recipes?.Snack?[self.indx].isLike = 1
                self.SnacksCollV.reloadData()
            }else if self.Seltype == "Brunch"{
                self.StatesDataList.recipes?.Teatime?[self.indx].isLike = 1
                self.TeatimeCollV.reloadData()
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
        
       
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == CalanderCollV{
//            // Deselect the previously selected item, if any
//            if let previousIndex = selectedIndex {
//                let previousCell = collectionView.cellForItem(at: previousIndex) as? CalendarCell
//                previousCell?.updateSelection(isSelected: false)
//            }
//            
//            // Select the current item
//            let currentCell = collectionView.cellForItem(at: indexPath) as? CalendarCell
//            currentCell?.updateSelection(isSelected: true)
//            
//            // Update the selected index
//            selectedIndex = indexPath
//            
//            seldate = currentWeekDates[indexPath.item]
//            

        }else if collectionView == BreakFastCollV{
            let storyboard = UIStoryboard(name: "Tabbar", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "RecipeDetailsVC") as! RecipeDetailsVC
            vc.MealType = "Breakfast"
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }else if collectionView == LunchCollV{
            let storyboard = UIStoryboard(name: "Tabbar", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "RecipeDetailsVC") as! RecipeDetailsVC
            vc.MealType = "Lunch"
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }else if collectionView == DinnerCollV{
            let storyboard = UIStoryboard(name: "Tabbar", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "RecipeDetailsVC") as! RecipeDetailsVC
            vc.MealType = "Dinner"
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }else if collectionView == SnacksCollV{
            let storyboard = UIStoryboard(name: "Tabbar", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "RecipeDetailsVC") as! RecipeDetailsVC
            vc.MealType = "Snacks"
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            let storyboard = UIStoryboard(name: "Tabbar", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "RecipeDetailsVC") as! RecipeDetailsVC
            vc.MealType = "Brunch"
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
 
       func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
           if collectionView == CalanderCollV{
               let width = collectionView.frame.width / 7
               return CGSize(width: width, height: collectionView.frame.height)
           }else{
               return CGSize(width: collectionView.frame.width/2.3 - 5, height: collectionView.frame.height)
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
        }else{
            if section == 0 {
                return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 5)
            }else{
                return UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == CalanderCollV{
            return 0
        }else{
            return 5
        }
     }
}

extension StatesForWeekOrYearVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == ChoosedaysTblV {
            return ChooseDayData.count
        }else if tableView == ChooseMealTypeTblV{
            return ChooseMealTypeyData.count
        }else{
            return self.StatesDataList.orders?.count ?? 0
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
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "MarketTblVCell", for: indexPath) as! MarketTblVCell
            let image = self.StatesDataList.orders?[indexPath.row].storeLogo ?? ""
            let ImgUrl = URL(string: image)
            cell.ImgV.sd_imageIndicator = SDWebImageActivityIndicator.medium
            cell.ImgV.sd_setImage(with: ImgUrl, placeholderImage: UIImage(named: "No_Image"))
            
            let TotalPrice = self.StatesDataList.orders?[indexPath.row].order?.finalQuote?.totalWithTip ?? 0
            let total = TotalPrice/100
            cell.TotalPriceLbl.text = "Total $\(total)"
            
            let itmsCount = self.StatesDataList.orders?[indexPath.row].order?.finalQuote?.items?.count ?? 0
            if itmsCount != 0{
                cell.TotalitmCountLbl.text = "View \(itmsCount) items"
            }else{
                cell.TotalitmCountLbl.text = ""
            }
            
            let orderID = self.StatesDataList.orders?[indexPath.row].order?.orderID ?? ""
            cell.OrderIDLbl.text = "Order #\(orderID)"
            
            cell.InfoBtn.tag = indexPath.row
            cell.InfoBtn.addTarget(self, action: #selector(InfoBtnClicked(sender:)), for: .touchUpInside)
            
            cell.ViewItemsBtn.tag = indexPath.row
            cell.ViewItemsBtn.addTarget(self, action: #selector(ViewItemsBtnClicked(sender:)), for: .touchUpInside)
            
            return cell
        }
    }
    
    @objc func ViewItemsBtnClicked(sender: UIButton){
  
        let SelData = self.StatesDataList.orders?[sender.tag]
     
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "OrderHistoryDetailVC") as! OrderHistoryDetailVC
        vc.comesfrom = "StatesForWeekOrYearVC"
        vc.StateOrderHistoryArrList = SelData ?? OrderElement()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func InfoBtnClicked(sender: UIButton){
        let storyboard = UIStoryboard(name: "Fav", bundle: nil)
            let popoverContent = storyboard.instantiateViewController(withIdentifier: "InfoVC") as! InfoVC
            popoverContent.MSg = "Total includes all fees"
            popoverContent.comesFrom = "StatesForWeekOrYearVC"
         
            popoverContent.modalPresentationStyle = .popover

            if let popover = popoverContent.popoverPresentationController {
                popover.sourceView = sender
                popover.sourceRect = sender.bounds // Attach to the button bounds
                popover.permittedArrowDirections = .up // Force the popover to show below the button
                popover.delegate = self
                popoverContent.preferredContentSize = CGSize(width: 150, height: 35)
            }

            self.present(popoverContent, animated: true, completion: nil)
    }
    
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none // Ensures the popover does not change to fullscreen on compact devices.
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == ChoosedaysTblV {
            if ChooseDayData[indexPath.row].isSelected {
                ChooseDayData[indexPath.row].isSelected = false
            }else{
                ChooseDayData[indexPath.row].isSelected = true
            }
            ChoosedaysTblV.reloadData()
        }else
            if tableView == ChooseMealTypeTblV{
            for i in 0..<ChooseMealTypeyData.count{
                ChooseMealTypeyData[i].isSelected = false
            }
            
            if ChooseMealTypeyData[indexPath.row].Name == "Snacks"{
                self.mealType = "Snacks"
            }else if ChooseMealTypeyData[indexPath.row].Name == "Brunch"{
                self.mealType = "Brunch"
            }else{
                self.mealType = ChooseMealTypeyData[indexPath.row].Name
            }
            
            ChooseMealTypeyData[indexPath.row].isSelected = true
            ChooseMealTypeTblV.reloadData()
        }else if tableView == MarketTblV{
           
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == ChoosedaysTblV {
            return 50
        }else if tableView == MarketTblV{
            return UITableView.automaticDimension
        }else{
            return 50
        }
    }
}

extension StatesForWeekOrYearVC {
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
            let startDay = formatter1.string(from: start)
            let endDay = formatter1.string(from: end)

            formatter1.dateFormat = "MMM" // For the month abbreviation (e.g., Dec)
            let month = formatter1.string(from: start)

            FromDateToLbl.text = "\(startDay) \(month) - \(endDay) \(month)"
            
            let dateFormatter1 = DateFormatter()
            dateFormatter1.dateStyle = .medium
            dateFormatter1.dateFormat = "yyyy-MM-dd"
            let startDate = dateFormatter1.string(from: self.currentWeekDates.first ?? Date())
            let endDate =  dateFormatter1.string(from: self.currentWeekDates.last ?? Date())
             
            self.StartDate = startDate
            self.EndDate = endDate
  
            self.Api_To_get_StatesForWeekOrYear()
        }
    }
}


extension StatesForWeekOrYearVC{
    func Api_To_get_StatesForWeekOrYear(){
        
        var params = [String: Any]()
         
        params["start_date"] = StartDate
        params["end_date"] = EndDate
//        params["week"] = "4" // self.SelWeek
//        params["month"] = "4" // self.SelMonth self.SelYear
     
        
          showIndicator(withTitle: "", and: "")
        
        let loginURL = baseURL.baseURL + appEndPoints.graph_week
        
        print(loginURL,"loginURL")
        
        WebService.shared.postServiceURLEncoding(loginURL, VC: self, andParameter: params, withCompletion: { (json, statusCode) in
            
              self.hideIndicator()
            
            let data = try! json.rawData()
            do{
                
                let d = try JSONDecoder().decode(StatesForWeekModelClass.self, from: data)
                if d.success == true {
                    
                    let allData = d.data
                    
                    
                    
                    self.StatesDataList = allData ?? StatesForWeekModelData()
                    
                    let totalPrice = self.StatesDataList.totalPrice ?? 0
                    let budgetPrice = self.StatesDataList.userBudget ?? 0
                    let savingsPrice = (budgetPrice - totalPrice)
  
                    // BreakFast
                    self.AmountSpentBreakFastLbl.text = "$\(self.StatesDataList.recipes?.dinnerPrice ?? 0)"
                    self.AmountSpentBreakFastThisWeekLbl.text = "$\(totalPrice)"
                    self.SpentBreakFastThisWeekLbl.text = "$\(savingsPrice)"
                    
                    //Lunch
                    self.AmountSpentLunchLbl.text = "$\(self.StatesDataList.recipes?.lunchPrice ?? 0)"
                    self.AmountSpentLunchThisWeekLbl.text = "$\(totalPrice)"
                    self.SpentLunchThisWeekLbl.text = "$\(savingsPrice)"
                    
                    //Dinner
                    self.AmountSpentDinnerLbl.text = "$\(self.StatesDataList.recipes?.dinnerPrice ?? 0)"
                    self.AmountSpentDinnerThisWeekLbl.text = "$\(totalPrice)"
                    self.SpentDinnerThisWeekLbl.text = "$\(savingsPrice)"
                    
                    //Snacks
                    self.AmountSpentSnacksLbl.text = "$\(self.StatesDataList.recipes?.SnacksPrice ?? 0)"
                    self.AmountSpentSnacksThisWeekLbl.text = "$\(totalPrice)"
                    self.SpentSnacksThisWeekLbl.text = "$\(savingsPrice)"
                    
                    //Brunch
                    self.AmountSpentTeatimeLbl.text = "$\(self.StatesDataList.recipes?.BrunchPrice ?? 0)"
                    self.AmountSpentTeatimeThisWeekLbl.text = "$\(totalPrice)"
                    self.SpentTeatimeThisWeekLbl.text = "$\(savingsPrice)"
                    
                    self.MarketTblV.reloadData()
                    
                    self.ShowNoDataFoundonCollV()
                      
                }else{
                    
                    let msg = d.message ?? ""
                    self.showToast(msg)
                }
            }catch{
                
                print(error)
            }
        })
    }
    
  
    func ShowNoDataFoundonCollV(){
        if self.StatesDataList.recipes?.breakfast?.count ?? 0 == 0{
            self.BreakFastBgV.isHidden = true
        }else{
            self.BreakFastBgV.isHidden = false
        }
        
        if self.StatesDataList.recipes?.lunch?.count ?? 0 == 0{
            self.LunchBgV.isHidden = true
        }else{
            self.LunchBgV.isHidden = false
        }
        
        
        if self.StatesDataList.recipes?.dinner?.count ?? 0 == 0{
            self.DinnerBgV.isHidden = true
        }else{
            self.DinnerBgV.isHidden = false
        }
        
        if self.StatesDataList.recipes?.Snack?.count ?? 0 == 0{
            self.SnacksBgV.isHidden = true
        }else{
            self.SnacksBgV.isHidden = false
        }
            
        if self.StatesDataList.recipes?.Teatime?.count ?? 0 == 0{
            self.TeatimeBgV.isHidden = true
        }else{
            self.TeatimeBgV.isHidden = false
        }
         
        if self.StatesDataList.recipes?.breakfast?.count ?? 0 == 0 && self.StatesDataList.recipes?.lunch?.count ?? 0 == 0 && self.StatesDataList.recipes?.dinner?.count ?? 0 == 0 && self.StatesDataList.recipes?.Snack?.count ?? 0 == 0 && self.StatesDataList.recipes?.Teatime?.count ?? 0 == 0{
            self.NoOrderLbl.isHidden = false
        }else{
            self.NoOrderLbl.isHidden = true
        }
        
        self.BreakFastCollV.reloadData()
        self.LunchCollV.reloadData()
        self.DinnerCollV.reloadData()
        self.SnacksCollV.reloadData()
        self.TeatimeCollV.reloadData()
    }
}

extension StatesForWeekOrYearVC{
    func Api_To_Like_UnlikeRecipe(uri: String, type: String){
        var params = [String: Any]()
            params["uri"] = uri
            params["type"] = type
     
        
        showIndicator(withTitle: "", and: "")
        
        let loginURL = baseURL.baseURL + appEndPoints.add_to_favorite
        print(params,"Params")
        print(loginURL,"loginURL")
        
        WebService.shared.postServiceURLEncoding(loginURL, VC: self, andParameter: params, withCompletion: { (json, statusCode) in
            
            self.hideIndicator()
            self.hideIndicator()
            
            guard let dictData = json.dictionaryObject else{
                return
            }
        
            if dictData["success"] as? Bool == true{
                    
               }else{
                   let responseMessage = dictData["message"] as? String ?? ""
                   self.showToast(responseMessage)
               }
          })
         }
    
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
    
    func Api_For_AddToPlan(uri: String, type: String) {
       
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
        
        
            let paramsDict: [String: Any] = [
                "type": type,
                "uri": uri,
                "slot": SerArray
            ]
        
        let token = UserDetail.shared.getTokenWith()
   
        
        showIndicator(withTitle: "", and: "")
        
        let loginURL = baseURL.baseURL + appEndPoints.AddMeal
        print(paramsDict, "Params")
        print(loginURL, "loginURL")
        
        if let jsonData = JSONStringEncoder().encode(paramsDict) {
            
            WebService.shared.postServiceRaw(loginURL, VC: self, jsonData: jsonData) { (json, statusCode) in
                self.hideIndicator()
                
                guard let dictData = json.dictionaryObject else {
                    return
                }
                
                let Msg = dictData["message"] as? String ?? ""
                
                if dictData["success"] as? Bool == true {
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
                   
                    
                    self.showToast(Msg)
                } else {
                    self.showToast(Msg)
                }
            }
        }else{
            print("Failed to encode JSON.")
            self.hideIndicator()
            self.showToast("An error occurred while preparing the request.")
        }
    }
} 
