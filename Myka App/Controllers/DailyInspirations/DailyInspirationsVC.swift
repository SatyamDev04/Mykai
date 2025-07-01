//
//  DailyInspirationsVC.swift
//  Myka App
//
//  Created by Sumit on 15/12/24.
//

import UIKit
import ScrollingPageControl
import Alamofire
import SDWebImage

class DailyInspirationsVC: UIViewController, UIGestureRecognizerDelegate {
    
    
    @IBOutlet weak var RecipeNameLbl: UILabel!
    @IBOutlet weak var TotalTimeLbl: UILabel!
    @IBOutlet weak var RatingCountLbl: UILabel!
    @IBOutlet weak var PriceLbl: UILabel!
    
    @IBOutlet var BreakfastBgV: UIView!
    @IBOutlet weak var BreakfastLbl: UILabel!
    @IBOutlet weak var BreakFastLine: UILabel!
    
    @IBOutlet var LunchBgV: UIView!
    @IBOutlet weak var LunchLbl: UILabel!
    @IBOutlet weak var LunchLine: UILabel!
    
    @IBOutlet var DinnerBgV: UIView!
    @IBOutlet weak var DinnerLbl: UILabel!
    @IBOutlet weak var DinnerLine: UILabel!
    
    @IBOutlet var SnackBgV: UIView!
    @IBOutlet weak var SnackLbl: UILabel!
    @IBOutlet weak var SnackLine: UILabel!
    
    @IBOutlet var TeatimeBgV: UIView!
    @IBOutlet weak var TeatimeLbl: UILabel!
    @IBOutlet weak var TeatimeLine: UILabel!
    
    @IBOutlet var pageControl: ScrollingPageControl!
    @IBOutlet weak var CollV: UICollectionView!
    
    // for Choosedays popup
    @IBOutlet var ChoosedaysPopupV: UIView!
    @IBOutlet weak var ChoosedaysTblV: UITableView!
    @IBOutlet weak var ChooseDayWeekLabel: UILabel!
    //
    
    // for ChooseMeal popup
    @IBOutlet var ChooseMealTypePopupV: UIView!
    @IBOutlet weak var ChooseMealTypePopupBgV: UIView!
    @IBOutlet weak var ChooseMealTypeTblV: UITableView!
    //
    
    var currentWeekDates: [Date] = []
    var calendar = Calendar.current
    
    var selectedIndex: IndexPath?
    
    var seldate = Date()
    
    var ChooseDayData = [BodyGoalsModel(Name: "Monday", isSelected: false), BodyGoalsModel(Name: "Tuesday", isSelected: false), BodyGoalsModel(Name: "Wednesday", isSelected: false), BodyGoalsModel(Name: "Thursday", isSelected: false), BodyGoalsModel(Name: "Friday", isSelected: false), BodyGoalsModel(Name: "Saturday", isSelected: false), BodyGoalsModel(Name: "Sunday", isSelected: false)]
    
    var ChooseMealTypeyData = [BodyGoalsModel(Name: "Breakfast", isSelected: false), BodyGoalsModel(Name: "Lunch", isSelected: false), BodyGoalsModel(Name: "Dinner", isSelected: false), BodyGoalsModel(Name: "Snacks", isSelected: false), BodyGoalsModel(Name: "Brunch", isSelected: false)]
    
    var mealType = ""
    //
    
    
    var AllRecipeSelItem = PlanDataClass()
    
    var tag = 0
    var SelUri = ""
    // for swipe to dismiss
    let edgeThreshold: CGFloat = 30
    //

    override func viewDidLoad() {
        super.viewDidLoad()
        self.ChoosedaysPopupV.frame = self.view.bounds
        self.view.addSubview(self.ChoosedaysPopupV)
        self.ChoosedaysPopupV.isHidden = true
        
        self.ChooseMealTypePopupV.frame = self.view.bounds
        self.view.addSubview(self.ChooseMealTypePopupV)
        self.ChooseMealTypePopupV.isHidden = true
        
        
        self.CollV.register(UINib(nibName: "PopUpCollVCell", bundle: nil), forCellWithReuseIdentifier: "PopUpCollVCell")
        self.CollV.delegate = self
        self.CollV.dataSource = self
        
       // pageControl.pages = 5
        pageControl.selectedPage = 0
        pageControl.dotSize = 10
        pageControl.centerDots = 3
        pageControl.selectedColor = #colorLiteral(red: 0.9960784314, green: 0.6235294118, blue: 0.2705882353, alpha: 1)
        
        self.tag = 0
        
        calendar.firstWeekday = 2 // Start the week on Monday
        setupInitialWeek()
        setupTableView()
        
        self.mealType = "Breakfast"
        
    //    setupSwipeGestures()
        
        Api_To_GetAllRecipe()
        
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        ChooseMealTypePopupBgV.addGestureRecognizer(tapGesture2)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        print("View1 was tapped!")
        self.willMove(toParent: nil)
        self.view.removeFromSuperview()
        self.removeFromParent()
    }
     
    
//    private func setupSwipeGestures() {
//         // Swipe right to dismiss
//         let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
//         swipeRight.direction = .right
//         swipeRight.delegate = self
//         view.addGestureRecognizer(swipeRight)
//         
//         // Swipe left to dismiss
//         let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
//         swipeLeft.direction = .left
//         swipeLeft.delegate = self
//         view.addGestureRecognizer(swipeLeft)
//     }
//     
//     @objc private func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
//         if gesture.direction == .right || gesture.direction == .left {
//             self.willMove(toParent: nil)
//             self.view.removeFromSuperview()
//             self.removeFromParent()
//         }
//     }
//    
//    // Gesture recognizer delegate method
//        func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
//            let touchLocation = touch.location(in: view)
//            
//            // Check if the touch location is within the edge threshold of the left or right side of the screen
//            if touchLocation.x < edgeThreshold || touchLocation.x > (view.bounds.width - edgeThreshold) {
//                return true // Allow swipe gesture if it starts from the left or right edge
//            }
//            
//            return false // Don't recognize swipe gesture if it's not near the edge
//        }
    
    //
    private func setupInitialWeek() {
            let today = Date()
            currentWeekDates = calculateWeekDates(for: today)
            updateWeekLabel()
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
        
    }
    //
    
        func setupCurrentWeek() {
            let today = Date()
            currentWeekDates = calculateWeekDates(for: today)
            updateWeekLabel()
        }
    
    
    @IBAction func BreakFastBtn(_ sender: UIButton) {
        self.BreakfastLbl.textColor = #colorLiteral(red: 0.9960784314, green: 0.6235294118, blue: 0.2705882353, alpha: 1)
        self.BreakFastLine.backgroundColor = #colorLiteral(red: 0.9960784314, green: 0.6235294118, blue: 0.2705882353, alpha: 1)
        self.LunchLbl.textColor = #colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
        self.LunchLine.backgroundColor = .clear
        self.DinnerLbl.textColor = #colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
        self.DinnerLine.backgroundColor = .clear
        self.SnackLbl.textColor = #colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
        self.SnackLine.backgroundColor = .clear
        self.TeatimeLbl.textColor = #colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
        self.TeatimeLine.backgroundColor = .clear
        
        self.tag = 0
        self.mealType = "Breakfast"
        if self.AllRecipeSelItem.recipes?.breakfast?.count != 0 {
            let uri = self.AllRecipeSelItem.recipes?.breakfast?[0].recipe?.uri ?? ""
            self.SelUri = uri
            
            self.RecipeNameLbl.text = self.AllRecipeSelItem.recipes?.breakfast?[0].recipe?.label ?? ""
            self.TotalTimeLbl.text = "\(self.AllRecipeSelItem.recipes?.breakfast?[0].recipe?.totalTime ?? 0) min"
            
            self.RatingCountLbl.text = "\(self.AllRecipeSelItem.recipes?.breakfast?[0].review ?? 0.0) (\(self.AllRecipeSelItem.recipes?.breakfast?[0].review_number ?? 0))"
        }
        
        self.CollV.reloadData()
    }
    
 
    @IBAction func LunchBtn(_ sender: UIButton) {
        self.BreakfastLbl.textColor = #colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
        self.BreakFastLine.backgroundColor = .clear
        self.LunchLbl.textColor = #colorLiteral(red: 0.9960784314, green: 0.6235294118, blue: 0.2705882353, alpha: 1)
        self.LunchLine.backgroundColor = #colorLiteral(red: 0.9960784314, green: 0.6235294118, blue: 0.2705882353, alpha: 1)
        self.DinnerLbl.textColor = #colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
        self.DinnerLine.backgroundColor = .clear
        self.SnackLbl.textColor = #colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
        self.SnackLine.backgroundColor = .clear
        self.TeatimeLbl.textColor = #colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
        self.TeatimeLine.backgroundColor = .clear
        
        self.tag = 1
        self.mealType = "Luanch"
        if self.AllRecipeSelItem.recipes?.lunch?.count != 0 {
            let uri = self.AllRecipeSelItem.recipes?.lunch?[0].recipe?.uri ?? ""
            self.SelUri = uri
            
            self.RecipeNameLbl.text = self.AllRecipeSelItem.recipes?.lunch?[0].recipe?.label ?? ""
            self.TotalTimeLbl.text = "\(self.AllRecipeSelItem.recipes?.lunch?[0].recipe?.totalTime ?? 0) min"
            self.RatingCountLbl.text = "\(self.AllRecipeSelItem.recipes?.lunch?[0].review ?? 0.0) (\(self.AllRecipeSelItem.recipes?.lunch?[0].review_number ?? 0))"
        }
        
        self.CollV.reloadData()
    }
    
    @IBAction func DinnerBtn(_ sender: UIButton) {
        self.BreakfastLbl.textColor = #colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
        self.BreakFastLine.backgroundColor = .clear
        self.LunchLbl.textColor = #colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
        self.LunchLine.backgroundColor = .clear
        self.DinnerLbl.textColor = #colorLiteral(red: 0.9960784314, green: 0.6235294118, blue: 0.2705882353, alpha: 1)
        self.DinnerLine.backgroundColor = #colorLiteral(red: 0.9960784314, green: 0.6235294118, blue: 0.2705882353, alpha: 1)
        self.SnackLbl.textColor = #colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
        self.SnackLine.backgroundColor = .clear
        self.TeatimeLbl.textColor = #colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
        self.TeatimeLine.backgroundColor = .clear
        
        self.tag = 2
        self.mealType = "Dinner"
        if self.AllRecipeSelItem.recipes?.dinner?.count != 0 {
            let uri = self.AllRecipeSelItem.recipes?.dinner?[0].recipe?.uri ?? ""
            self.SelUri = uri
            
            self.RecipeNameLbl.text = self.AllRecipeSelItem.recipes?.dinner?[0].recipe?.label ?? ""
            self.TotalTimeLbl.text = "\(self.AllRecipeSelItem.recipes?.dinner?[0].recipe?.totalTime ?? 0) min"
            self.RatingCountLbl.text = "\(self.AllRecipeSelItem.recipes?.dinner?[0].review ?? 0.0) (\(self.AllRecipeSelItem.recipes?.dinner?[0].review_number ?? 0))"
        }
        
        self.CollV.reloadData()
    }
    
    @IBAction func SnacksBtn(_ sender: UIButton) {
        self.BreakfastLbl.textColor = #colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
        self.BreakFastLine.backgroundColor = .clear
        self.LunchLbl.textColor = #colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
        self.LunchLine.backgroundColor = .clear
        self.DinnerLbl.textColor = #colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
        self.DinnerLine.backgroundColor = .clear
        self.SnackLbl.textColor = #colorLiteral(red: 0.9960784314, green: 0.6235294118, blue: 0.2705882353, alpha: 1)
        self.SnackLine.backgroundColor = #colorLiteral(red: 0.9960784314, green: 0.6235294118, blue: 0.2705882353, alpha: 1)
        self.TeatimeLbl.textColor = #colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
        self.TeatimeLine.backgroundColor = .clear
        
        self.tag = 3
        self.mealType = "Snacks"
        if self.AllRecipeSelItem.recipes?.Snack?.count != 0 {
            let uri = self.AllRecipeSelItem.recipes?.Snack?[0].recipe?.uri ?? ""
            self.SelUri = uri
            
            self.RecipeNameLbl.text = self.AllRecipeSelItem.recipes?.Snack?[0].recipe?.label ?? ""
            self.TotalTimeLbl.text = "\(self.AllRecipeSelItem.recipes?.Snack?[0].recipe?.totalTime ?? 0) min"
            self.RatingCountLbl.text = "\(self.AllRecipeSelItem.recipes?.Snack?[0].review ?? 0.0) (\(self.AllRecipeSelItem.recipes?.Snack?[0].review_number ?? 0))"
        }
        
        self.CollV.reloadData()
    }
    
    @IBAction func TeatimeBtn(_ sender: UIButton) {
        self.BreakfastLbl.textColor = #colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
        self.BreakFastLine.backgroundColor = .clear
        self.LunchLbl.textColor = #colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
        self.LunchLine.backgroundColor = .clear
        self.DinnerLbl.textColor = #colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
        self.DinnerLine.backgroundColor = .clear
        self.SnackLbl.textColor = #colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
        self.SnackLine.backgroundColor = .clear
        self.TeatimeLbl.textColor = #colorLiteral(red: 0.9960784314, green: 0.6235294118, blue: 0.2705882353, alpha: 1)
        self.TeatimeLine.backgroundColor = #colorLiteral(red: 0.9960784314, green: 0.6235294118, blue: 0.2705882353, alpha: 1)
        
        self.tag = 4
        self.mealType = "Brunch"
        if self.AllRecipeSelItem.recipes?.Teatime?.count != 0 {
            let uri = self.AllRecipeSelItem.recipes?.Teatime?[0].recipe?.uri ?? ""
            self.SelUri = uri
            
            self.RecipeNameLbl.text = self.AllRecipeSelItem.recipes?.Teatime?[0].recipe?.label ?? ""
            self.TotalTimeLbl.text = "\(self.AllRecipeSelItem.recipes?.Teatime?[0].recipe?.totalTime ?? 0) min"
            self.RatingCountLbl.text = "\(self.AllRecipeSelItem.recipes?.Teatime?[0].review ?? 0.0) (\(self.AllRecipeSelItem.recipes?.Teatime?[0].review_number ?? 0))"
        }
        
        self.CollV.reloadData()
    }
    
    @IBAction func ChoosedaysDoneBtn(_ sender: UIButton) {
        guard ChooseDayData.contains(where: {$0.isSelected == true}) else{
            AlertControllerOnr(title: "", message: "Please select at least one day.")
            return
        }
        self.ChoosedaysPopupV.isHidden = true
        self.ChooseMealTypePopupV.isHidden = false
   
    }
    
    @IBAction func ChooseMealDoneBtn(_ sender: UIButton) {
        guard ChooseMealTypeyData.contains(where: { $0.isSelected }) else {
            AlertControllerOnr(title: "", message: "Please select meal type.")
            return
        }
        self.ChooseMealTypePopupV.isHidden = true
        
        let SubscriptionStatus = Int(UserDetail.shared.getSubscriptionStatus())
        
        if SubscriptionStatus == 1{
            let addtoplanStatus = Int(UserDetail.shared.getaddmeal()) ?? 0
            guard addtoplanStatus == 0 else {
                SubscriptionPopUp ()
                return
            }
        }
        
        self.Api_For_AddToPlan(uri: self.SelUri, type: self.mealType)
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
    
    @IBAction func PoppUpreviousWeekTapped(_ sender: UIButton) {
//        if let firstDate = currentWeekDates.first {
//                currentWeekDates = calculateWeekDates(for: calendar.date(byAdding: .day, value: -7, to: firstDate)!)
//                updateWeekLabel()
//            }
        let today = Date()
        let VfirstDate = currentWeekDates.first ?? Date()
        guard VfirstDate >= today else{
                 return // Exit if the previous week's start date is earlier than today
             }
        
        if let firstDate = currentWeekDates.first {
                currentWeekDates = calculateWeekDates(for: calendar.date(byAdding: .day, value: -7, to: firstDate)!)
                updateWeekLabel()
            }
       }

       @IBAction func PopUpnextWeekTapped(_ sender: UIButton) {
           if let lastDate = currentWeekDates.last {
                 currentWeekDates = calculateWeekDates(for: calendar.date(byAdding: .day, value: 7, to: lastDate)!)
                 updateWeekLabel()
             }
       }
    
    
    
    @IBAction func AddToPlan(_ sender: UIButton) {
        self.ChoosedaysPopupV.isHidden = false
    }
    
    @IBAction func AddToCart(_ sender: UIButton) {
        self.Api_To_AddToBasket_Recipe(uri: self.SelUri, type: self.mealType)
    }
}


extension DailyInspirationsVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if tag == 0{
            self.pageControl.pages = self.AllRecipeSelItem.recipes?.breakfast?.count ?? 0
            return self.AllRecipeSelItem.recipes?.breakfast?.count ?? 0//BreakfastData.count
        }else if tag == 1{
            self.pageControl.pages = self.AllRecipeSelItem.recipes?.lunch?.count ?? 0
            return self.AllRecipeSelItem.recipes?.lunch?.count ?? 0//LunchData.count
        }else if tag == 2{
            self.pageControl.pages = self.AllRecipeSelItem.recipes?.dinner?.count ?? 0
            return self.AllRecipeSelItem.recipes?.dinner?.count ?? 0//DinnerData.count
        }else if tag == 3{
            self.pageControl.pages = self.AllRecipeSelItem.recipes?.Snack?.count ?? 0
            return self.AllRecipeSelItem.recipes?.Snack?.count ?? 0
        }else{
            self.pageControl.pages = self.AllRecipeSelItem.recipes?.Teatime?.count ?? 0
            return self.AllRecipeSelItem.recipes?.Teatime?.count ?? 0
        }
     }
        
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         if tag == 0{
             let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PopUpCollVCell", for: indexPath) as! PopUpCollVCell

            let img = self.AllRecipeSelItem.recipes?.breakfast?[indexPath.item].recipe?.images?.small?.url ?? ""
            let ImgUrl = URL(string: img)
             cell.Img.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
            cell.Img.sd_setImage(with: ImgUrl, placeholderImage: UIImage(named: "No_Image"))
            
            let islike = self.AllRecipeSelItem.recipes?.breakfast?[indexPath.item].isLike
            
            if islike == 1{
                cell.FavBtn.setImage(UIImage(named: "Fav"), for: .normal)
            }else{
                cell.FavBtn.setImage(UIImage(named: "UnFav"), for: .normal)
            }

             
            cell.FavBtn.tag = indexPath.item
            cell.FavBtn.addTarget(self, action: #selector(FavBreakfastBtnClick(_:)), for: .touchUpInside)
            
             
            return cell
         }else if tag == 1{
             let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PopUpCollVCell", for: indexPath) as! PopUpCollVCell
 
             let img = self.AllRecipeSelItem.recipes?.lunch?[indexPath.item].recipe?.images?.small?.url ?? ""
            let ImgUrl = URL(string: img)
             cell.Img.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
            cell.Img.sd_setImage(with: ImgUrl, placeholderImage: UIImage(named: "No_Image"))
             
            let islike = self.AllRecipeSelItem.recipes?.lunch?[indexPath.item].isLike
            
            if islike == 1{
                cell.FavBtn.setImage(UIImage(named: "Fav"), for: .normal)
            }else{
                cell.FavBtn.setImage(UIImage(named: "UnFav"), for: .normal)
            }
            
           
            cell.FavBtn.tag = indexPath.item
            cell.FavBtn.addTarget(self, action: #selector(FavLunchBtnClick(_:)), for: .touchUpInside)
         
            return cell
         }else if tag == 2{
             let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PopUpCollVCell", for: indexPath) as! PopUpCollVCell
 
            let img = self.AllRecipeSelItem.recipes?.dinner?[indexPath.item].recipe?.images?.small?.url ?? ""
            let ImgUrl = URL(string: img)
            cell.Img.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
            cell.Img.sd_setImage(with: ImgUrl, placeholderImage: UIImage(named: "No_Image"))
            
            let islike = self.AllRecipeSelItem.recipes?.dinner?[indexPath.item].isLike
            
            if islike == 1{
                cell.FavBtn.setImage(UIImage(named: "Fav"), for: .normal)
            }else{
                cell.FavBtn.setImage(UIImage(named: "UnFav"), for: .normal)
            }
             
            cell.FavBtn.tag = indexPath.item
            cell.FavBtn.addTarget(self, action: #selector(FavDinnerBtnClick(_:)), for: .touchUpInside)
        
            return cell
         }else if tag == 3{
             let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PopUpCollVCell", for: indexPath) as! PopUpCollVCell

            let img = self.AllRecipeSelItem.recipes?.Snack?[indexPath.item].recipe?.images?.small?.url ?? ""
            let ImgUrl = URL(string: img)
            cell.Img.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
            cell.Img.sd_setImage(with: ImgUrl, placeholderImage: UIImage(named: "No_Image"))
            
            let islike = self.AllRecipeSelItem.recipes?.Snack?[indexPath.item].isLike
            
            if islike == 1{
                cell.FavBtn.setImage(UIImage(named: "Fav"), for: .normal)
            }else{
                cell.FavBtn.setImage(UIImage(named: "UnFav"), for: .normal)
            }
           
            cell.FavBtn.tag = indexPath.item
            cell.FavBtn.addTarget(self, action: #selector(FavSnacksBtnClick(_:)), for: .touchUpInside)
            
            return cell
         }else if tag == 4{
             let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PopUpCollVCell", for: indexPath) as! PopUpCollVCell

            let img = self.AllRecipeSelItem.recipes?.Teatime?[indexPath.item].recipe?.images?.small?.url ?? ""
            let ImgUrl = URL(string: img)
            cell.Img.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
            cell.Img.sd_setImage(with: ImgUrl, placeholderImage: UIImage(named: "No_Image"))
            
            let islike = self.AllRecipeSelItem.recipes?.Teatime?[indexPath.item].isLike
            
            if islike == 1{
                cell.FavBtn.setImage(UIImage(named: "Fav"), for: .normal)
            }else{
                cell.FavBtn.setImage(UIImage(named: "UnFav"), for: .normal)
            }
           
            cell.FavBtn.tag = indexPath.item
            cell.FavBtn.addTarget(self, action: #selector(FavTeaTimeBtnClick(_:)), for: .touchUpInside)
          
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    //favBtn
    @objc func FavBreakfastBtnClick(_ sender: UIButton)   {
        let index = sender.tag
        
        let SubscriptionStatus = Int(UserDetail.shared.getSubscriptionStatus())
        
        if SubscriptionStatus == 1{
            let addtoplanStatus = Int(UserDetail.shared.getfavorite()) ?? 0
            guard addtoplanStatus <= 2 else {
                SubscriptionPopUp ()
                return
            }
        }
        
        let uri = self.AllRecipeSelItem.recipes?.breakfast?[index].recipe?.uri ?? ""
        let islike = self.AllRecipeSelItem.recipes?.breakfast?[index].isLike
         
        if islike == 1{
            self.AllRecipeSelItem.recipes?.breakfast?[index].isLike = 0
            self.Api_To_Like_UnlikeRecipe(uri: uri, type: "0")
        }else{
             
            self.FavBtnClickNav(TypeClicked: "Breakfast", Uri: uri, SelID: "")
        }
        self.CollV.reloadData()
    }
    
    @objc func FavLunchBtnClick(_ sender: UIButton)   {
        let index = sender.tag
        
        let SubscriptionStatus = Int(UserDetail.shared.getSubscriptionStatus())
        
        if SubscriptionStatus == 1{
            let addtoplanStatus = Int(UserDetail.shared.getfavorite()) ?? 0
            guard addtoplanStatus <= 2 else {
                SubscriptionPopUp ()
                return
            }
        }
        
        let uri = self.AllRecipeSelItem.recipes?.lunch?[index].recipe?.uri ?? ""
        let islike = self.AllRecipeSelItem.recipes?.lunch?[index].isLike
        if islike == 1{
            self.AllRecipeSelItem.recipes?.lunch?[index].isLike = 0
            self.Api_To_Like_UnlikeRecipe(uri: uri, type: "0")
        }else{
//            self.AllRecipeSelItem.recipes?.lunch?[index].isLike = 1
//            self.Api_To_Like_UnlikeRecipe(uri: uri, type: "1")
            self.FavBtnClickNav(TypeClicked: "Lunch", Uri: uri, SelID: "")
        }
        
        self.CollV.reloadData()
    }
    
    @objc func FavDinnerBtnClick(_ sender: UIButton)   {
        let index = sender.tag
        
        let SubscriptionStatus = Int(UserDetail.shared.getSubscriptionStatus())
        
        if SubscriptionStatus == 1{
            let addtoplanStatus = Int(UserDetail.shared.getfavorite()) ?? 0
            guard addtoplanStatus <= 2 else {
                SubscriptionPopUp ()
                return
            }
        }
        
        let uri = self.AllRecipeSelItem.recipes?.dinner?[index].recipe?.uri ?? ""
        let islike = self.AllRecipeSelItem.recipes?.dinner?[index].isLike
        if islike == 1{
            self.AllRecipeSelItem.recipes?.dinner?[index].isLike = 0
            self.Api_To_Like_UnlikeRecipe(uri: uri, type: "0")
        }else{
//            self.AllRecipeSelItem.recipes?.dinner?[index].isLike = 1
//            self.Api_To_Like_UnlikeRecipe(uri: uri, type: "1")
            self.FavBtnClickNav(TypeClicked: "Dinner", Uri: uri, SelID: "")
        }
        self.CollV.reloadData()
    }
    
    @objc func FavSnacksBtnClick(_ sender: UIButton)   {
        let index = sender.tag
        
        let SubscriptionStatus = Int(UserDetail.shared.getSubscriptionStatus())
        
        if SubscriptionStatus == 1{
            let addtoplanStatus = Int(UserDetail.shared.getfavorite()) ?? 0
            guard addtoplanStatus <= 2 else {
                SubscriptionPopUp ()
                return
            }
        }
        
        let uri = self.AllRecipeSelItem.recipes?.Snack?[index].recipe?.uri ?? ""
        let islike = self.AllRecipeSelItem.recipes?.Snack?[index].isLike
        if islike == 1{
            self.AllRecipeSelItem.recipes?.Snack?[index].isLike = 0
            self.Api_To_Like_UnlikeRecipe(uri: uri, type: "0")
        }else{
           // self.AllRecipeSelItem.recipes?.Snack?[index].isLike = 1
          //  self.Api_To_Like_UnlikeRecipe(uri: uri, type: "1")
            self.FavBtnClickNav(TypeClicked: "Snacks", Uri: uri, SelID: "")
        }
        self.CollV.reloadData()
    }
    
    @objc func FavTeaTimeBtnClick(_ sender: UIButton)   {
        let index = sender.tag
        
        let SubscriptionStatus = Int(UserDetail.shared.getSubscriptionStatus())
        
        if SubscriptionStatus == 1{
            let addtoplanStatus = Int(UserDetail.shared.getfavorite()) ?? 0
            guard addtoplanStatus <= 2 else {
                SubscriptionPopUp ()
                return
            }
        }
        
        let uri = self.AllRecipeSelItem.recipes?.Teatime?[index].recipe?.uri ?? ""
     
        
        let islike = self.AllRecipeSelItem.recipes?.Teatime?[index].isLike
        if islike == 1{
            self.AllRecipeSelItem.recipes?.Teatime?[index].isLike = 0
            self.Api_To_Like_UnlikeRecipe(uri: uri, type: "0")
        }else{
          //  self.AllRecipeSelItem.recipes?.Teatime?[index].isLike = 1
            self.FavBtnClickNav(TypeClicked: "Teatime", Uri: uri, SelID: "")
        }
        self.CollV.reloadData()
    }
  
  
    
    func FavBtnClickNav(TypeClicked: String, Uri: String, SelID: String)   {
        let storyboard = UIStoryboard(name: "Tabbar", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "FavrouitPopupVC") as! FavrouitPopupVC
        vc.comesFrom = "FullCookingScheduleVC"
        vc.uri = Uri
        vc.selID = SelID
        vc.typeclicked = TypeClicked
        vc.backAction = {
            self.Api_To_GetAllRecipe()
        }
        self.addChild(vc)
        vc.view.frame = self.view.frame
        self.view.addSubview(vc.view)
        self.view.bringSubviewToFront(vc.view)
        vc.didMove(toParent: self)
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        targetContentOffset.pointee = scrollView.contentOffset
        var indexes = self.CollV.indexPathsForVisibleItems
        indexes.sort()
        var index = indexes.first!
        let cell = self.CollV.cellForItem(at: index)!
        let position = self.CollV.contentOffset.x - cell.frame.origin.x
        if position > cell.frame.size.width/2{
            index.row = index.row+1
        }
        
        if tag == 0{
            if self.AllRecipeSelItem.recipes?.breakfast?.count != 0 {
                let uri = self.AllRecipeSelItem.recipes?.breakfast?[index.row].recipe?.uri ?? ""
                self.SelUri = uri
                
                self.RecipeNameLbl.text = self.AllRecipeSelItem.recipes?.breakfast?[index.row].recipe?.label ?? ""
                self.TotalTimeLbl.text = "\(self.AllRecipeSelItem.recipes?.breakfast?[index.row].recipe?.totalTime ?? 0) min"
                self.RatingCountLbl.text = "\(self.AllRecipeSelItem.recipes?.breakfast?[index.row].review ?? 0.0) (\(self.AllRecipeSelItem.recipes?.breakfast?[index.row].review_number ?? 0))"
            }
        }else if tag == 1{
            if self.AllRecipeSelItem.recipes?.lunch?.count != 0 {
                let uri = self.AllRecipeSelItem.recipes?.lunch?[index.row].recipe?.uri ?? ""
                self.SelUri = uri
                
                self.RecipeNameLbl.text = self.AllRecipeSelItem.recipes?.lunch?[index.row].recipe?.label ?? ""
                self.TotalTimeLbl.text = "\(self.AllRecipeSelItem.recipes?.lunch?[index.row].recipe?.totalTime ?? 0) min"
                self.RatingCountLbl.text = "\(self.AllRecipeSelItem.recipes?.lunch?[index.row].review ?? 0.0) (\(self.AllRecipeSelItem.recipes?.lunch?[index.row].review_number ?? 0))"
            }
        }else if tag == 2{
            if self.AllRecipeSelItem.recipes?.dinner?.count != 0 {
                let uri = self.AllRecipeSelItem.recipes?.dinner?[index.row].recipe?.uri ?? ""
                self.SelUri = uri
                
                self.RecipeNameLbl.text = self.AllRecipeSelItem.recipes?.dinner?[index.row].recipe?.label ?? ""
                self.TotalTimeLbl.text = "\(self.AllRecipeSelItem.recipes?.dinner?[index.row].recipe?.totalTime ?? 0) min"
                self.RatingCountLbl.text = "\(self.AllRecipeSelItem.recipes?.dinner?[index.row].review ?? 0.0) (\(self.AllRecipeSelItem.recipes?.dinner?[index.row].review_number ?? 0))"
            }
        }else if tag == 3{
            if self.AllRecipeSelItem.recipes?.Snack?.count != 0 {
                let uri = self.AllRecipeSelItem.recipes?.Snack?[index.row].recipe?.uri ?? ""
                self.SelUri = uri
                
                self.RecipeNameLbl.text = self.AllRecipeSelItem.recipes?.Snack?[index.row].recipe?.label ?? ""
                self.TotalTimeLbl.text = "\(self.AllRecipeSelItem.recipes?.Snack?[index.row].recipe?.totalTime ?? 0) min"
                self.RatingCountLbl.text = "\(self.AllRecipeSelItem.recipes?.Snack?[index.row].review ?? 0.0) (\(self.AllRecipeSelItem.recipes?.Snack?[index.row].review_number ?? 0))"
            }
        }else{
            if self.AllRecipeSelItem.recipes?.Teatime?.count != 0 {
                let uri = self.AllRecipeSelItem.recipes?.Teatime?[index.row].recipe?.uri ?? ""
                self.SelUri = uri
                
                self.RecipeNameLbl.text = self.AllRecipeSelItem.recipes?.Teatime?[index.row].recipe?.label ?? ""
                self.TotalTimeLbl.text = "\(self.AllRecipeSelItem.recipes?.Teatime?[index.row].recipe?.totalTime ?? 0) min"
                self.RatingCountLbl.text = "\(self.AllRecipeSelItem.recipes?.Teatime?[index.row].review ?? 0.0) (\(self.AllRecipeSelItem.recipes?.Teatime?[index.row].review_number ?? 0))"
            }
        }
        
        self.CollV.scrollToItem(at: index, at: .left, animated: true )
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let visibleRect = CGRect(origin: self.CollV.contentOffset, size: self.CollV.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        if let visibleIndexPath = self.CollV.indexPathForItem(at: visiblePoint) {
            self.pageControl.selectedPage = visibleIndexPath.row
            
        }
    }
  }

extension DailyInspirationsVC : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewHeight = collectionView.frame.height
        print(collectionViewHeight, "collectionViewHeight")
     return CGSize(width: collectionView.frame.width, height: collectionViewHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        CollV.collectionViewLayout.invalidateLayout() // Ensures layout is recalculated
        CollV.reloadData()
    }
}


extension DailyInspirationsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == ChoosedaysTblV {
            return ChooseDayData.count
        }else if tableView == ChooseMealTypeTblV{
            return ChooseMealTypeyData.count
        }else{
            return 0
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
        }
        return UITableViewCell()
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
            ChooseMealTypeTblV.reloadData()
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 50
        }
    }

   

extension DailyInspirationsVC {
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
            
            ChooseDayWeekLabel.text = "\(formatter.string(from: start)) - \(formatter.string(from: end))"
  
        }
    }
}


extension DailyInspirationsVC {
    func Api_To_GetAllRecipe(){
        var params = [String: Any]()
        
        params["q"] = "q"
        
    
        showIndicator(withTitle: "", and: "")
        
        let loginURL = baseURL.baseURL + appEndPoints.all_recipe
        print(params,"Params")
        print(loginURL,"loginURL")
        
        WebService.shared.postServiceURLEncoding(loginURL, VC: self, andParameter: params, withCompletion: { (json, statusCode) in
            
            self.hideIndicator()
            
            let data = try! json.rawData()
            
            do{
                let d = try JSONDecoder().decode(PlanModelClass.self, from: data)
                if d.success == true {
                    if let list = d.data, list.recipes != nil {
                        self.AllRecipeSelItem = list
                    }
                    
                    self.Show_Hide_Meal_Plan_View()
                    
                    if self.tag == 0{
                        if self.AllRecipeSelItem.recipes?.breakfast?.count != 0 {
                            let uri = self.AllRecipeSelItem.recipes?.breakfast?[0].recipe?.uri ?? ""
                            self.SelUri = uri
                            self.RecipeNameLbl.text = self.AllRecipeSelItem.recipes?.breakfast?[0].recipe?.label ?? ""
                            self.TotalTimeLbl.text = "\(self.AllRecipeSelItem.recipes?.breakfast?[0].recipe?.totalTime ?? 0) min"
                            self.RatingCountLbl.text = "\(self.AllRecipeSelItem.recipes?.breakfast?[0].review ?? 0.0) (\(self.AllRecipeSelItem.recipes?.breakfast?[0].review_number ?? 0))"
                            
                        }
                    }else if self.tag == 1{
                        if self.AllRecipeSelItem.recipes?.lunch?.count != 0 {
                            let uri = self.AllRecipeSelItem.recipes?.lunch?[0].recipe?.uri ?? ""
                            self.SelUri = uri
                            
                            self.RecipeNameLbl.text = self.AllRecipeSelItem.recipes?.lunch?[0].recipe?.label ?? ""
                            self.TotalTimeLbl.text = "\(self.AllRecipeSelItem.recipes?.lunch?[0].recipe?.totalTime ?? 0) min"
                            self.RatingCountLbl.text = "\(self.AllRecipeSelItem.recipes?.lunch?[0].review ?? 0.0) (\(self.AllRecipeSelItem.recipes?.lunch?[0].review_number ?? 0))"
                        }
                    }else if self.tag == 2{
                        if self.AllRecipeSelItem.recipes?.dinner?.count != 0 {
                            let uri = self.AllRecipeSelItem.recipes?.dinner?[0].recipe?.uri ?? ""
                            self.SelUri = uri
                            
                            self.RecipeNameLbl.text = self.AllRecipeSelItem.recipes?.dinner?[0].recipe?.label ?? ""
                            self.TotalTimeLbl.text = "\(self.AllRecipeSelItem.recipes?.dinner?[0].recipe?.totalTime ?? 0) min"
                            self.RatingCountLbl.text = "\(self.AllRecipeSelItem.recipes?.dinner?[0].review ?? 0.0) (\(self.AllRecipeSelItem.recipes?.dinner?[0].review_number ?? 0))"
                        }
                    }else if self.tag == 3{
                        if self.AllRecipeSelItem.recipes?.Snack?.count != 0 {
                            let uri = self.AllRecipeSelItem.recipes?.Snack?[0].recipe?.uri ?? ""
                            self.SelUri = uri
                            
                            self.RecipeNameLbl.text = self.AllRecipeSelItem.recipes?.Snack?[0].recipe?.label ?? ""
                            self.TotalTimeLbl.text = "\(self.AllRecipeSelItem.recipes?.Snack?[0].recipe?.totalTime ?? 0) min"
                            self.RatingCountLbl.text = "\(self.AllRecipeSelItem.recipes?.Snack?[0].review ?? 0.0) (\(self.AllRecipeSelItem.recipes?.Snack?[0].review_number ?? 0))"
                        }
                    }else{
                        if self.AllRecipeSelItem.recipes?.Teatime?.count != 0 {
                            let uri = self.AllRecipeSelItem.recipes?.Teatime?[0].recipe?.uri ?? ""
                            self.SelUri = uri
                            
                            self.RecipeNameLbl.text = self.AllRecipeSelItem.recipes?.Teatime?[0].recipe?.label ?? ""
                            self.TotalTimeLbl.text = "\(self.AllRecipeSelItem.recipes?.Teatime?[0].recipe?.totalTime ?? 0) min"
                            self.RatingCountLbl.text = "\(self.AllRecipeSelItem.recipes?.Teatime?[0].review ?? 0.0) (\(self.AllRecipeSelItem.recipes?.Teatime?[0].review_number ?? 0))"
                        }
                    }
                    
                    self.CollV.reloadData()
                }else{
                    
                    let msg = d.message ?? ""
                    self.showToast(msg)
                }
            }catch{
                print(error)
            }
        })
    }
    
    func Show_Hide_Meal_Plan_View(){
        
        if self.AllRecipeSelItem.recipes?.breakfast?.count != nil {
            self.BreakfastBgV.isHidden = false
        }else{
            self.BreakfastBgV.isHidden = true
        }
        
        if self.AllRecipeSelItem.recipes?.lunch?.count != nil {
            self.LunchBgV.isHidden = false
        }else{
            self.LunchBgV.isHidden = true
        }
        
        if self.AllRecipeSelItem.recipes?.dinner?.count != nil {
            self.DinnerBgV.isHidden = false
        }else{
            self.DinnerBgV.isHidden = true
        }
        
        if self.AllRecipeSelItem.recipes?.Snack?.count != nil {
            self.SnackBgV.isHidden = false
        }else{
            self.SnackBgV.isHidden = true
        }
        
        if self.AllRecipeSelItem.recipes?.Teatime?.count != nil {
            self.TeatimeBgV.isHidden = false
        }else{
            self.TeatimeBgV.isHidden = true
        }
    }
    
    
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
                self.Api_To_GetAllRecipe()
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
    }

extension DailyInspirationsVC {
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
                    self.SelUri = ""
                    
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

