//
//  RecipeDetailsVC.swift
//  Myka App
//
//  Created by Sumit on 10/12/24.
//

import UIKit
import SDWebImage
import Alamofire

struct RecipeDetailsIngredientModel{
    var name: String = ""
    var image : String = ""
    var Quantity: String = ""
    var food: String = ""
    var foodCategory: String = ""
    var measure: String = ""
    var foodID: String = ""
}

class RecipeDetailsVC: UIViewController {
    
    @IBOutlet weak var ImgbottomBorder: UIView!
    @IBOutlet weak var ImgV: UIImageView!
    
    @IBOutlet weak var RatingLbl: UILabel!
    
    @IBOutlet weak var ImgDesc: UILabel!
   
    
    @IBOutlet weak var Calorieslbl: UILabel!
    @IBOutlet weak var FatLbl: UILabel!
    @IBOutlet weak var CarbsLbl: UILabel!
    @IBOutlet weak var ProtienLbl: UILabel!
    @IBOutlet weak var TotalTimeLbl: UILabel!
    @IBOutlet weak var PrepTimeLbl: UILabel!
    
    @IBOutlet weak var IngredientLbl: UILabel!
    @IBOutlet weak var CookwareLbl: UILabel!
    @IBOutlet weak var DirectionsLbl: UILabel!
    
    @IBOutlet weak var IngredientasBtnO: UIButton!
    @IBOutlet weak var CookwareBtnO: UIButton!
    @IBOutlet weak var recipeBtnO: UIButton!
    
    @IBOutlet weak var SelectAllBtnO: UIButton!
    @IBOutlet weak var ServCountLbl: UILabel!
    @IBOutlet weak var TblV: UITableView!
    @IBOutlet weak var TblVH: NSLayoutConstraint!
    @IBOutlet weak var IngredientBgV: UIView!
    @IBOutlet weak var IngredientBtnsBgV: UIView!
    
    @IBOutlet weak var CookTblV: UITableView!
    @IBOutlet weak var CookTblVH: NSLayoutConstraint!
    @IBOutlet weak var CookTblVBgV: UIView!
    
    @IBOutlet weak var DirectionsTblV: UITableView!
    @IBOutlet weak var DirectionsTblVH: NSLayoutConstraint!
    @IBOutlet weak var DirectionsTblVBgV: UIView!
    @IBOutlet weak var DirectionsBtnsBgV: UIView!
    
    // for Choosedays popup
    @IBOutlet var ChoosedaysPopupV: UIView!
    @IBOutlet weak var ChoosedaysTblV: UITableView!
    @IBOutlet weak var ChooseDayWeekLabel: UILabel!
    @IBOutlet weak var ChoosedaysBgV: UIView!
    //
    
    // for ChooseMealType popup
    @IBOutlet var ChooseMealTypePopupV: UIView!
    @IBOutlet weak var ChooseMealTypeTblV: UITableView!
    @IBOutlet weak var ChooseMealTypeTblVH: NSLayoutConstraint!
    @IBOutlet weak var ChooseMealTypeBgV: UIView!
    
    @IBOutlet weak var ScrollV: UIScrollView!
    //
    
    var ServCount = 1
    
    var ChooseDayData = [BodyGoalsModel(Name: "Monday", isSelected: false), BodyGoalsModel(Name: "Tuesday", isSelected: false), BodyGoalsModel(Name: "Wednesday", isSelected: false), BodyGoalsModel(Name: "Thursday", isSelected: false), BodyGoalsModel(Name: "Friday", isSelected: false), BodyGoalsModel(Name: "Saturday", isSelected: false), BodyGoalsModel(Name: "Sunday", isSelected: false)]
    
    var ChooseMealTypeyData = [BodyGoalsModel(Name: "Breakfast", isSelected: false), BodyGoalsModel(Name: "Lunch", isSelected: false), BodyGoalsModel(Name: "Dinner", isSelected: false), BodyGoalsModel(Name: "Snacks", isSelected: false), BodyGoalsModel(Name: "Brunch", isSelected: false)]
    
    var recipesArray: [RecipeDetailsIngredientModel] = []
    
    var CookWareArray: [IngredientModel] = [
        IngredientModel(name: "Cooker", image: UIImage(named: "1")!, Quantity: ""), IngredientModel(name: "Cutting borad", image: UIImage(named: "2")!, Quantity: ""), IngredientModel(name: "Grater", image: UIImage(named: "3.0")!, Quantity: ""), IngredientModel(name: "Peeler", image: UIImage(named: "3")!, Quantity: ""), IngredientModel(name: "Mixing bowl", image: UIImage(named: "4")!, Quantity: "")]
    
    var RecipeInstArr = [String]()
    
    var selectedIndex = [Int]()
    
    var currentWeekDates: [Date] = []
    var calendar = Calendar.current
    
    var uri = ""
    
    var MealId = ""
    
    var RecipeDetailsData = [RecipeDetailModel]()
    
    var MealType = ""
    
    var backAction:()->() = {}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ServCountLbl.text = "\(ServCount)"
      //  ImgbottomBorder.roundCorners([.bottomLeft, .bottomRight], radius: 22.0)
        self.ChoosedaysPopupV.frame = self.view.bounds
        self.view.addSubview(self.ChoosedaysPopupV)
        self.ChoosedaysPopupV.isHidden = true
        
        self.ChooseMealTypePopupV.frame = self.view.bounds
        self.view.addSubview(self.ChooseMealTypePopupV)
        self.ChooseMealTypePopupV.isHidden = true

        // Do any additional setup after loading the view.
        
        self.IngredientLbl.backgroundColor = UIColor.init(red: 254/255, green: 159/255, blue: 69/255, alpha: 1)
        self.CookwareLbl.backgroundColor = UIColor.init(red: 255/255, green: 247/255, blue: 240/255, alpha: 1)
        self.DirectionsLbl.backgroundColor = UIColor.init(red: 255/255, green: 247/255, blue: 240/255, alpha: 1)
        
        self.IngredientLbl.textColor = UIColor.white
        self.CookwareLbl.textColor = UIColor.init(red: 60/255, green: 69/255, blue: 65/255, alpha: 1)
        self.DirectionsLbl.textColor = UIColor.init(red: 60/255, green: 69/255, blue: 65/255, alpha: 1)
         
      
        self.IngredientBgV.isHidden = false
        self.IngredientBtnsBgV.isHidden = false
        
        self.CookTblVBgV.isHidden = true
        
        self.DirectionsTblVBgV.isHidden = true
        self.DirectionsBtnsBgV.isHidden = true
        
        self.TblV.register(UINib(nibName: "MissingIngredientsTblVCell", bundle: nil), forCellReuseIdentifier: "MissingIngredientsTblVCell")
        self.TblV.delegate = self
        self.TblV.dataSource = self
        
        self.CookTblV.register(UINib(nibName: "CookwareTblVCell", bundle: nil), forCellReuseIdentifier: "CookwareTblVCell")
        self.CookTblV.delegate = self
        self.CookTblV.dataSource = self
        
        self.DirectionsTblV.register(UINib(nibName: "DirectionsTblVCell", bundle: nil), forCellReuseIdentifier: "DirectionsTblVCell")
        self.DirectionsTblV.delegate = self
        self.DirectionsTblV.dataSource = self
        
        calendar.firstWeekday = 2 // Start the week on Monday
        setupInitialWeek()
     
        setupTableView()
       
         
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        ChoosedaysBgV.addGestureRecognizer(tapGesture)
        
        let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(handleTap1(_:)))
        ChooseMealTypeBgV.addGestureRecognizer(tapGesture1)
        
        NotificationCenter.default.addObserver(self, selector: #selector(listnerFunctionReloadDetails(_:)), name: NSNotification.Name(rawValue: "notificationNameReloadDetails"), object: nil)
        
        self.Api_To_Recipe_Details(uri: uri)
       }
  //
     
     @objc func listnerFunctionReloadDetails(_ notification: NSNotification) {
         if let data = notification.userInfo?["data"] as? String {
             self.Api_To_Recipe_Details(uri: uri)
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
    }
    
    private func setupTableView() {
        self.ChoosedaysTblV.register(UINib(nibName: "ChooseDaysTblVCell", bundle: nil), forCellReuseIdentifier: "ChooseDaysTblVCell")
        self.ChoosedaysTblV.delegate = self
        self.ChoosedaysTblV.dataSource = self
        self.ChoosedaysTblV.separatorStyle = .none
        
        self.ChooseMealTypeTblV.register(UINib(nibName: "ChooseDaysTblVCell", bundle: nil), forCellReuseIdentifier: "ChooseDaysTblVCell")
        self.ChooseMealTypeTblV.delegate = self
        self.ChooseMealTypeTblV.dataSource = self
        self.ChooseMealTypeTblV.separatorStyle = .none
        
        // Add observers for table views
               TblV.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
               CookTblV.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
               DirectionsTblV.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        ChooseMealTypeTblV.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        
    }
    
    // KVO observation
        override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
            if keyPath == "contentSize" {
                if let tableView = object as? UITableView {
                    if tableView == TblV {
                        TblVH.constant = tableView.contentSize.height
                    } else if tableView == CookTblV {
                        CookTblVH.constant = tableView.contentSize.height
                    } else if tableView == DirectionsTblV {
                        DirectionsTblVH.constant = tableView.contentSize.height
                    } else if tableView == ChooseMealTypeTblV {
                        ChooseMealTypeTblVH.constant = tableView.contentSize.height
                    }
                }
            }
        }
        
        deinit {
            // Remove observers
            TblV.removeObserver(self, forKeyPath: "contentSize")
            CookTblV.removeObserver(self, forKeyPath: "contentSize")
            DirectionsTblV.removeObserver(self, forKeyPath: "contentSize")
        }
    
  
    
    private func setupInitialWeek() {
            let today = Date()
            currentWeekDates = calculateWeekDates(for: today)
            updateWeekLabel()
        }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ScrollV.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    @IBAction func BackBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
     
    
    @IBAction func IngredientBtn(_ sender: UIButton) {
        self.IngredientLbl.backgroundColor = UIColor.init(red: 254/255, green: 159/255, blue: 69/255, alpha: 1)
        self.CookwareLbl.backgroundColor = UIColor.init(red: 255/255, green: 247/255, blue: 240/255, alpha: 1)
        self.DirectionsLbl.backgroundColor = UIColor.init(red: 255/255, green: 247/255, blue: 240/255, alpha: 1)
        
        self.IngredientLbl.textColor = UIColor.white
        self.CookwareLbl.textColor = UIColor.init(red: 60/255, green: 69/255, blue: 65/255, alpha: 1)
        self.DirectionsLbl.textColor = UIColor.init(red: 60/255, green: 69/255, blue: 65/255, alpha: 1)
        
        self.IngredientBgV.isHidden = false
        self.IngredientBtnsBgV.isHidden = false
        
        self.CookTblVBgV.isHidden = true
        
        self.DirectionsTblVBgV.isHidden = true
        self.DirectionsBtnsBgV.isHidden = true
    }
    
    
    
    @IBAction func CookBtn(_ sender: UIButton) {
        self.IngredientLbl.backgroundColor = UIColor.init(red: 255/255, green: 247/255, blue: 240/255, alpha: 1)
        self.CookwareLbl.backgroundColor = UIColor.init(red: 254/255, green: 159/255, blue: 69/255, alpha: 1)
        self.DirectionsLbl.backgroundColor = UIColor.init(red: 255/255, green: 247/255, blue: 240/255, alpha: 1)
        
        self.IngredientLbl.textColor = UIColor.init(red: 60/255, green: 69/255, blue: 65/255, alpha: 1)
        self.CookwareLbl.textColor = UIColor.white
        self.DirectionsLbl.textColor = UIColor.init(red: 60/255, green: 69/255, blue: 65/255, alpha: 1)
        
        self.IngredientBgV.isHidden = true
        self.IngredientBtnsBgV.isHidden = true
        
        self.CookTblVBgV.isHidden = false
        
        self.DirectionsTblVBgV.isHidden = true
        self.DirectionsBtnsBgV.isHidden = true
    }
    
    @IBAction func DirectionsBtn(_ sender: UIButton) {
        self.IngredientLbl.backgroundColor = UIColor.init(red: 255/255, green: 247/255, blue: 240/255, alpha: 1)
        self.CookwareLbl.backgroundColor = UIColor.init(red: 255/255, green: 247/255, blue: 240/255, alpha: 1)
        self.DirectionsLbl.backgroundColor = UIColor.init(red: 254/255, green: 159/255, blue: 69/255, alpha: 1)
        
        self.IngredientLbl.textColor = UIColor.init(red: 60/255, green: 69/255, blue: 65/255, alpha: 1)
        self.CookwareLbl.textColor = UIColor.init(red: 60/255, green: 69/255, blue: 65/255, alpha: 1)
        self.DirectionsLbl.textColor = UIColor.white
        
        self.IngredientBgV.isHidden = true
        self.IngredientBtnsBgV.isHidden = true
        
        self.CookTblVBgV.isHidden = true
        
        self.DirectionsTblVBgV.isHidden = false
        self.DirectionsBtnsBgV.isHidden = false
    }
    
    @IBAction func SelectAllBtn(_ sender: UIButton) {
        if self.SelectAllBtnO.isSelected {
            self.SelectAllBtnO.isSelected = false
            selectedIndex.removeAll()
        }else{
            self.SelectAllBtnO.isSelected = true
            for i in 0..<recipesArray.count {
                selectedIndex.append(i)
            }
        }
        self.TblV.reloadData()
     }
    
    
    @IBAction func ServCountMinusBtn(_ sender: UIButton) {
        guard ServCount != 1 else{
            return
        }
        
        self.ServCount -= 1
        
        self.ServCountLbl.text = "\(ServCount)"
    }
    
    @IBAction func ServCountPlusBtn(_ sender: UIButton) {
        self.ServCount += 1
        
        self.ServCountLbl.text = "\(ServCount)"
    }
    
    @IBAction func AddToPlanBtn(_ sender: UIButton) {
        self.ChoosedaysPopupV.isHidden = false
    }
    
    @IBAction func AddToBasketBtn(_ sender: UIButton) {
       guard selectedIndex.count > 0 else{
        AlertControllerOnr(title: "", message: "Please select atleast one ingredients.")
          return
        }
     
        self.Api_To_AddToBasket_Recipe()
    }
    
    @IBAction func ViewStepbyStepBtn(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Tabbar", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "RecipeDetail1VC") as! RecipeDetail1VC
        //let vc = storyboard.instantiateViewController(withIdentifier: "RecipeDetail2VC") as! RecipeDetail2VC
        vc.recipesArray = self.recipesArray
        vc.MealType = self.MealType
        vc.RecipeDetailsData = self.RecipeDetailsData
        vc.RecipeListArr = self.RecipeInstArr
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    // for popups
    @IBAction func ChoosedaysDoneBtn(_ sender: UIButton) {
        guard ChooseDayData.contains(where: { $0.isSelected }) else {
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
        
        let SubscriptionStatus = Int(UserDetail.shared.getSubscriptionStatus())
        if SubscriptionStatus == 1{
            let addtoplanStatus = Int(UserDetail.shared.getaddmeal()) ?? 0
            guard addtoplanStatus == 0 else {
                SubscriptionPopUp ()
                return
            }
        }
        self.Api_For_AddToPlan()
        
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
    
    @IBAction func previousWeekTapped(_ sender: UIButton) {
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

       @IBAction func nextWeekTapped(_ sender: UIButton) {
           if let lastDate = currentWeekDates.last {
                 currentWeekDates = calculateWeekDates(for: calendar.date(byAdding: .day, value: 7, to: lastDate)!)
                 updateWeekLabel()
             }
       }
}


extension RecipeDetailsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == ChoosedaysTblV {
            return ChooseDayData.count
        }else if tableView == ChooseMealTypeTblV{
            return ChooseMealTypeyData.count
        }else
        if tableView == self.TblV {
            return recipesArray.count
        }else if tableView == self.CookTblV {
            return CookWareArray.count
        }else{
            return self.RecipeInstArr.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == ChoosedaysTblV {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChooseDaysTblVCell", for: indexPath) as! ChooseDaysTblVCell
            cell.NameLbl.text = ChooseDayData[indexPath.row].Name
            cell.TickImg.image = ChooseDayData[indexPath.row].isSelected ? UIImage(named: "chck") : UIImage(named: "Unchck")
            cell.selectedBgImg.image = ChooseDayData[indexPath.row].isSelected ? UIImage(named: "Yelloborder") : UIImage(named: "Group 1171276489")
            cell.selectionStyle = .none
            return cell
        }else if tableView == ChooseMealTypeTblV{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChooseDaysTblVCell", for: indexPath) as! ChooseDaysTblVCell
            cell.NameLbl.text = ChooseMealTypeyData[indexPath.row].Name
            cell.TickImg.image = ChooseMealTypeyData[indexPath.row].isSelected ? UIImage(named: "RadioOn") : UIImage(named: "RadioOff")
            cell.selectionStyle = .none
            return cell
        }else
        if tableView == self.TblV {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MissingIngredientsTblVCell", for: indexPath) as! MissingIngredientsTblVCell
            cell.NameLbl.text = recipesArray[indexPath.row].name
            let img = recipesArray[indexPath.row].image
            
            cell.Img.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
            cell.Img.sd_setImage(with: URL(string: img), placeholderImage: UIImage(named: "No_Image"))
             
            let quantityString = recipesArray[indexPath.row].Quantity

              let quantity = Double(quantityString) ?? 0
               let formatter = NumberFormatter()
               formatter.minimumFractionDigits = 0  // Show no fractional digits if not needed
               formatter.maximumFractionDigits = 2  // Limit to 2 fractional digits
               formatter.numberStyle = .decimal

               if let formattedQuantity = formatter.string(from: NSNumber(value: quantity)) {
                   print(formattedQuantity) // This will give "2" for 2.00 and "2.05" for 2.05
                   cell.QuentityLbl.text = "\(formattedQuantity) \(recipesArray[indexPath.row].measure)"
               }else{
                   cell.QuentityLbl.text = "\(quantityString) \(recipesArray[indexPath.row].measure)"
               }
            
            
            if selectedIndex.contains(indexPath.row){
                cell.CheckBtn.setImage(UIImage(named: "YellowCheck"), for: .normal)
            }else{
                cell.CheckBtn.setImage(UIImage(named: "YelloUncheck"), for: .normal)
            }
            
            cell.CheckBtn.tag = indexPath.item
            cell.CheckBtn.addTarget(self, action: #selector(AddIngredientBtnTapped(sender: )), for: .touchUpInside)
            return cell
        }else if tableView == self.CookTblV {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CookwareTblVCell", for: indexPath) as! CookwareTblVCell
            cell.NameLbl.text = CookWareArray[indexPath.row].name
            cell.Img.image = CookWareArray[indexPath.row].image
            return cell
            
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "DirectionsTblVCell", for: indexPath) as! DirectionsTblVCell
            cell.StepLbl.text = "Step \(indexPath.row + 1):"
            cell.DescLbl.text = self.RecipeInstArr[indexPath.row]
            return cell
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
              ChooseMealTypeTblV.reloadData()
          }
      }
    
    
    @objc func AddIngredientBtnTapped(sender: UIButton){
        let index = sender.tag
        if selectedIndex.contains(index){
            selectedIndex.remove(at: selectedIndex.firstIndex(of: index)!)
        }else{
            selectedIndex.append(index)
        }
        
        if selectedIndex.count == recipesArray.count{
            self.SelectAllBtnO.isSelected = true
        }else {
            self.SelectAllBtnO.isSelected = false
        }
        
        self.TblV.reloadData()
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == ChoosedaysTblV {
            return 50
        }else if tableView == ChooseMealTypeTblV{
            return 50
        }else{
            return UITableView.automaticDimension
        }
    }
}
  
extension RecipeDetailsVC {
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
            
            let formatter1 = DateFormatter()
            formatter1.dateFormat = "d" // For the day number
            let startDay = formatter1.string(from: start)
            let endDay = formatter1.string(from: end)

            formatter1.dateFormat = "MMM" // For the month abbreviation (e.g., Dec)
            let month = formatter1.string(from: start)

//            FromDateToLbl.text = "\(startDay) - \(endDay) \(month)"
            for j in 0..<ChooseDayData.count {
                ChooseDayData[j].isSelected = false
            }
            
            ChoosedaysTblV.reloadData()
        }
    }
}


extension RecipeDetailsVC{
    func Api_To_Recipe_Details(uri: String){
        var params = [String: Any]()
        
            params["uri"] = uri
           
      
        
        showIndicator(withTitle: "", and: "")
        
        let loginURL = baseURL.baseURL + appEndPoints.get_recipe
        print(params,"Params")
        print(loginURL,"loginURL")
        
        WebService.shared.postServiceURLEncoding(loginURL, VC: self, andParameter: params, withCompletion: { (json, statusCode) in
            
            self.hideIndicator()
            let data = try! json.rawData()
            
            do{
                let d = try JSONDecoder().decode(RecipeDetailModelClass.self, from: data)
                if d.success == true {
                    if let list = d.data, list.first?.recipe != nil {
                        self.RecipeDetailsData = d.data ?? []
                        
                        let val = self.RecipeDetailsData.first?.recipe
                        
                        let review = self.RecipeDetailsData.first?.review ?? 0
                        let reviewNum = self.RecipeDetailsData.first?.review_number ?? 0
                        
                        self.RatingLbl.text = "\(review)(\(reviewNum))"
                        
                        let img  = val?.images?.large?.url
                        let imgUrl = URL(string: img ?? "")
                        self.ImgV.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
                        self.ImgV.sd_setImage(with: imgUrl, placeholderImage: UIImage(named: "No_Image"))
                        
                        self.ImgDesc.text = val?.label ?? ""
                       // self.ImgDesc1Lbl.text = "By \(val?.source ?? "")"
                        
                        let carbs = val?.totalNutrients?.first(where: {$0.key == "CHOCDF"})
                        self.CarbsLbl.text = "\(Int(carbs?.value.quantity ?? 0))"
                        
                        let Fat = val?.totalNutrients?.first(where: {$0.key == "FAT"})
                        self.FatLbl.text = "\(Int(Fat?.value.quantity ?? 0))"
                        
                        let Protine = val?.totalNutrients?.first(where: {$0.key == "PROCNT"})
                        self.ProtienLbl.text = "\(Int(Protine?.value.quantity ?? 0))"
                         
                        let calories = val?.calories ?? 0
                        self.Calorieslbl.text = "\(Int(calories))"
                        
                        self.TotalTimeLbl.text = "\(val?.totalTime ?? 0) min"
                        
                        let ingredients = val?.ingredients
                        
                        for item in ingredients ?? [] {
                            let name = item.food ?? ""
                            let quantity = item.quantity ?? 0
                            let measure = item.measure ?? ""
                            let img = item.image ?? ""
                            let food = item.food ?? ""
                            let foodCat = item.foodCategory ?? ""
                            let FoodId = item.foodID ?? ""
                            print("name: \(name)")
                            print("quantity: \(quantity)")
                            print("measure: \(measure)")
                            
                            self.recipesArray.append(contentsOf: [RecipeDetailsIngredientModel(name: name, image: img, Quantity: "\(quantity)", food: food, foodCategory: foodCat, measure: "\(measure)", foodID: FoodId)])
                        }
                        
                        let ingredientList = val?.instructionLines
                        self.RecipeInstArr.removeAll()
                        
                        for item in ingredientList ?? [] {
                            print("item: \(item)")
                            self.RecipeInstArr.append(item)
                        }
                        
                        for i in 0..<self.recipesArray.count{
                            self.selectedIndex.append(i)
                        }
                        
                        self.SelectAllBtnO.isSelected = true
                         
                         
                        self.TblV.reloadData()
                        self.CookTblV.reloadData()
                        self.DirectionsTblV.reloadData()
  
                    }
                }else{
                    let msg = d.message ?? ""
                    self.showToast(msg)
                }
            }catch{
                print(error)
            }
        })
    }
    
    func Api_For_AddToPlan() {
       
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
        
        let uri = self.uri
        
        let MealType = ChooseMealTypeyData.first(where: {$0.isSelected == true})?.Name ?? ""
        
            let paramsDict: [String: Any] = [
                "type": MealType,
                "uri": uri,
                "slot": SerArray,
                "serving": self.ServCount
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
                    self.ChooseMealTypePopupV.isHidden = true
                    
                    for i in 0..<self.ChooseDayData.count {
                        self.ChooseDayData[i].isSelected = false
                    }
                    
                    for i in 0..<self.ChooseMealTypeyData.count {
                        self.ChooseMealTypeyData[i].isSelected = false
                    }
                    
                    self.ChoosedaysTblV.reloadData()
                    self.ChooseMealTypeTblV.reloadData()
                     
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
    
    
    func Api_To_AddToBasket_Recipe() {
        
        var jsonArray: [[String: Any]] = []
        for i in 0..<recipesArray.count{
            if selectedIndex.contains(i){
                let dictionary1: [String: String] = ["name": recipesArray[i].name, "image": recipesArray[i].image, "food": recipesArray[i].food, "quantity": recipesArray[i].Quantity, "foodCategory": recipesArray[i].foodCategory, "measure": recipesArray[i].measure, "food_id": recipesArray[i].foodID, "status": "0"]
                jsonArray.append(dictionary1)
            }
        }
        print(jsonArray)
        
            let paramsDict: [String: Any] = [
                "ingredients": jsonArray,
                "serving": self.ServCount,
                "uri": self.uri,
                "type": self.MealType
            ]
      
        
        showIndicator(withTitle: "", and: "")
        
        let loginURL = baseURL.baseURL + appEndPoints.ingredient_basket
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
                    self.backAction()
                    self.navigationController?.popViewController(animated: true)
                    self.navigationController?.showToast("Added to basket.")
    
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
