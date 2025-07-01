//
//  YourCoockedMealVC.swift
//  Myka App
//
//  Created by Sumit on 11/12/24.
//

import UIKit
import Alamofire
import SDWebImage

class YourCoockedMealVC: UIViewController {

    @IBOutlet weak var FromDateToLbl: UILabel!
    @IBOutlet weak var CalanderCollV: UICollectionView!
    @IBOutlet weak var weekLabel: UILabel!
    @IBOutlet weak var BreakFastCollV: UICollectionView!
    @IBOutlet weak var LunchCollV: UICollectionView!
    @IBOutlet weak var DinnerCollV: UICollectionView!
    @IBOutlet weak var SnackCollV: UICollectionView!
    @IBOutlet weak var TeatimeCollV: UICollectionView!
    

    @IBOutlet weak var FridgeLbl: UILabel!
    @IBOutlet weak var FreezerLbl: UILabel!
    
    @IBOutlet weak var FridgeBtnO: UIButton!
    @IBOutlet weak var FreezerBtnO: UIButton!
    
    @IBOutlet weak var CalanderBgV: UIView!
    @IBOutlet weak var EmptyMealBgV: UIView!
    @IBOutlet weak var EmptyMealLbl: UILabel!
    
    @IBOutlet weak var BreakFastBgV: UIView!
    @IBOutlet weak var LunchBgV: UIView!
    @IBOutlet weak var DinnerBgV: UIView!
    @IBOutlet weak var SnackBgV: UIView!
    @IBOutlet weak var TeatimeBgV: UIView!
    
    @IBOutlet weak var CalanderDropBtnO: UIButton!
    @IBOutlet weak var DropIcon: UIImageView!
    
    
    //RemovePopUpV
    @IBOutlet var RemovePopupV: UIView!
    //
   
    
    var currentWeekDates: [Date] = []
    var calendar = Calendar.current
    
    var selectedIndex: IndexPath?
    
    var seldate = Date()
   
    var selCollv = 0
    var selID = Int()
    
    var tag = 0
    var typeClicked = ""
    var SelRemoveIndx = 0
    
    
    var AllDataList = YourCookedMealModelNew()
        
  
    override func viewDidLoad() {
            super.viewDidLoad()
        self.RemovePopupV.frame = self.view.bounds
        self.view.addSubview(self.RemovePopupV)
        self.RemovePopupV.isHidden = true
        
        self.EmptyMealBgV.isHidden = false
        self.CalanderBgV.isHidden = false
        self.BreakFastBgV.isHidden = true
        self.LunchBgV.isHidden = true
        self.DinnerBgV.isHidden = true
        self.SnackBgV.isHidden = true
        self.TeatimeBgV.isHidden = true
        
        CalanderDropBtnO.isSelected = true
        self.CalanderBgV.isHidden = false
        self.DropIcon.image = UIImage(named: "DropUpDark")
        
            calendar.firstWeekday = 2 // Start the week on Monday
            setupInitialWeek()
            setupCollectionView()
         
        let firstText = "Uh oh,"
        let firstAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.init(name: "Poppins SemiBold", size: 15) ?? UIFont.systemFont(ofSize: 15),
            .foregroundColor: UIColor.black
        ]

        let secondText = " the fridge is empty! Let’s fill it up with some delicious dishes!"
        let secondAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.init(name: "Poppins Regular", size: 15) ?? UIFont.systemFont(ofSize: 15),
            .foregroundColor: UIColor.black
        ]

        let firstAttributedString = NSAttributedString(string: firstText, attributes: firstAttributes)
        let secondAttributedString = NSAttributedString(string: secondText, attributes: secondAttributes)

        let combinedAttributedString = NSMutableAttributedString()
        combinedAttributedString.append(firstAttributedString)
        combinedAttributedString.append(secondAttributedString)
        
        EmptyMealLbl.attributedText = combinedAttributedString
        
        self.FridgeLbl.backgroundColor = UIColor.init(red: 254/255, green: 159/255, blue: 69/255, alpha: 1)
        self.FreezerLbl.backgroundColor = UIColor.init(red: 255/255, green: 247/255, blue: 240/255, alpha: 1)
        
        self.FridgeLbl.textColor = UIColor.white
        self.FreezerLbl.textColor = UIColor.init(red: 60/255, green: 69/255, blue: 65/255, alpha: 1)
       
        self.FridgeLbl.font = UIFont.init(name: "Poppins Medium", size: 16) ?? UIFont.systemFont(ofSize: 16)
        self.FreezerLbl.font = UIFont.init(name: "Poppins Regular", size: 16) ?? UIFont.systemFont(ofSize: 16)
        
        self.FridgeBtnO.isSelected = true
        self.FreezerBtnO.isSelected = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(listnerFunctionAddRecipe(_:)), name: NSNotification.Name(rawValue: "notificationNameAddRecipeY"), object: nil)
        }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.Api_To_GetAllMealsList()
        
        if  StateMangerModelClass.shared.subs == "1"{
            
        }
    }
    
    
        
    private func setupInitialWeek() {
            let today = Date()
            currentWeekDates = calculateWeekDates(for: today)
            updateWeekLabel()
        }
        
        private func setupCollectionView() {
            CalanderCollV.delegate = self
            CalanderCollV.dataSource = self
            CalanderCollV.register(UINib(nibName: "YrCockedMCalCollVCell", bundle: nil), forCellWithReuseIdentifier: "YrCockedMCalCollVCell")
            
            BreakFastCollV.delegate = self
            BreakFastCollV.dataSource = self
            BreakFastCollV.register(UINib(nibName: "YourCoockedMealCollVCell", bundle: nil), forCellWithReuseIdentifier: "YourCoockedMealCollVCell")
            
            LunchCollV.delegate = self
            LunchCollV.dataSource = self
            LunchCollV.register(UINib(nibName: "YourCoockedMealCollVCell", bundle: nil), forCellWithReuseIdentifier: "YourCoockedMealCollVCell")
            
            DinnerCollV.delegate = self
            DinnerCollV.dataSource = self
            DinnerCollV.register(UINib(nibName: "YourCoockedMealCollVCell", bundle: nil), forCellWithReuseIdentifier: "YourCoockedMealCollVCell")
            
            SnackCollV.delegate = self
            SnackCollV.dataSource = self
            SnackCollV.register(UINib(nibName: "YourCoockedMealCollVCell", bundle: nil), forCellWithReuseIdentifier: "YourCoockedMealCollVCell")
            
            TeatimeCollV.delegate = self
            TeatimeCollV.dataSource = self
            TeatimeCollV.register(UINib(nibName: "YourCoockedMealCollVCell", bundle: nil), forCellWithReuseIdentifier: "YourCoockedMealCollVCell")
        }
     
        func setupCurrentWeek() {
            let today = Date()
            currentWeekDates = calculateWeekDates(for: today)
            updateWeekLabel()
            CalanderCollV.reloadData()
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
    

    
    @IBAction func BackBtn(_ sender: UIButton) {
        StateMangerModelClass.shared.SearchClickFromPopup = true
        if let tabBar = tabBarController?.tabBar,
           let items = tabBar.items,
           items.count > 4 {
            let item = items[0] // Get the UITabBarItem at index 4
            tabBarController?.tabBar(tabBar, didSelect: item)
            tabBarController?.selectedIndex = 0
        }
      //  self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func AddMealBtn(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "RestScreens", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AddMealVC") as! AddMealVC
        vc.hidesBottomBarWhenPushed = true
        vc.backAction = {
            self.EmptyMealBgV.isHidden = true
            self.CalanderBgV.isHidden = false
            self.BreakFastBgV.isHidden = false
            self.LunchBgV.isHidden = false
            self.DinnerBgV.isHidden = false
        }
        
        vc.backActionn = { tag in
            self.tag = tag
        }
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func CalanderDropBtn(_ sender: UIButton) {
        if CalanderDropBtnO.isSelected == false{
            CalanderDropBtnO.isSelected = true
            self.CalanderBgV.isHidden = false
            self.DropIcon.image = UIImage(named: "DropUpDark")
        }else{
            CalanderDropBtnO.isSelected = false
            self.CalanderBgV.isHidden = true
            self.DropIcon.image = UIImage(named: "DropDownDark")
        }
    }
    
    // for custome calander.
    @IBAction func previousWeekTapped(_ sender: UIButton) {
        if let firstDate = currentWeekDates.first {
                currentWeekDates = calculateWeekDates(for: calendar.date(byAdding: .day, value: -7, to: firstDate)!)
                updateWeekLabel()
            
            for i in 0..<currentWeekDates.count {
                let previousIndex = IndexPath(item: i, section: 0)
                let previousCell = CalanderCollV.cellForItem(at: previousIndex) as? YrCockedMCalCollVCell
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
                   let previousCell = CalanderCollV.cellForItem(at: previousIndex) as? YrCockedMCalCollVCell
                   previousCell?.updateSelection(isSelected: false)
               }
               CalanderCollV.reloadData()
             }
       }
    
    
    //RemovePopUpView Btn
    @IBAction func RemovePopUpNoBtn(_ sender: UIButton) {
        self.RemovePopupV.isHidden = true
    }
    
    @IBAction func RemovePopUpYesBtn(_ sender: UIButton) {
        self.RemovePopupV.isHidden = true

        self.Api_To_RemoveMeal()
        }
    //
    
   
    @IBAction func FridgeBtn(_ sender: UIButton) {
        self.FridgeLbl.backgroundColor = UIColor.init(red: 254/255, green: 159/255, blue: 69/255, alpha: 1)
        self.FreezerLbl.backgroundColor = UIColor.init(red: 255/255, green: 247/255, blue: 240/255, alpha: 1)
        
        self.FridgeLbl.textColor = UIColor.white
        self.FreezerLbl.textColor = UIColor.init(red: 60/255, green: 69/255, blue: 65/255, alpha: 1)
        
        self.FridgeLbl.font = UIFont.init(name: "Poppins Medium", size: 16) ?? UIFont.systemFont(ofSize: 16)
        self.FreezerLbl.font = UIFont.init(name: "Poppins Regular", size: 16) ?? UIFont.systemFont(ofSize: 16)
         
        self.FridgeBtnO.isSelected = true
        self.FreezerBtnO.isSelected = false
        
//        self.Api_To_GetAllMealsList()
        self.ShowNoDataFoundonCollV()
    }
    
    
    
    @IBAction func FreezerBtn(_ sender: UIButton) {
        self.FridgeLbl.backgroundColor = UIColor.init(red: 255/255, green: 247/255, blue: 240/255, alpha: 1)
        self.FreezerLbl.backgroundColor = UIColor.init(red: 254/255, green: 159/255, blue: 69/255, alpha: 1)
        
        self.FridgeLbl.textColor = UIColor.init(red: 60/255, green: 69/255, blue: 65/255, alpha: 1)
        self.FreezerLbl.textColor = UIColor.white
        
        self.FreezerLbl.font = UIFont.init(name: "Poppins Medium", size: 16)
        self.FridgeLbl.font = UIFont.init(name: "Poppins Regular", size: 16)
         
        self.FridgeBtnO.isSelected = false
        self.FreezerBtnO.isSelected = true
        
        //self.Api_To_GetAllMealsList()
        self.ShowNoDataFoundonCollV()
    }
    
    
    @IBAction func AddbreakFastBtn(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "RestScreens", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AddMealVC") as! AddMealVC
        vc.hidesBottomBarWhenPushed = true
        vc.backActionn = { tag in
            self.tag = tag
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func AddLunchBtn(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "RestScreens", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AddMealVC") as! AddMealVC
        vc.hidesBottomBarWhenPushed = true
        vc.backActionn = { tag in
            self.tag = tag
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func DinnerBtn(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "RestScreens", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AddMealVC") as! AddMealVC
        vc.hidesBottomBarWhenPushed = true
        vc.backActionn = { tag in
            self.tag = tag
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func SnackBtn(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "RestScreens", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AddMealVC") as! AddMealVC
        vc.hidesBottomBarWhenPushed = true
        vc.backActionn = { tag in
            self.tag = tag
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func TeatimeBtn(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "RestScreens", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AddMealVC") as! AddMealVC
        vc.hidesBottomBarWhenPushed = true
        vc.backActionn = { tag in
            self.tag = tag
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension YourCoockedMealVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == CalanderCollV{
            return currentWeekDates.count
        }else if collectionView == BreakFastCollV{
            if self.FridgeBtnO.isSelected == true{
                return self.AllDataList.fridgeData?.breakfast?.count ?? 0
            }else{
                return self.AllDataList.freezerData?.breakfast?.count ?? 0
            }
        }else if collectionView == LunchCollV{
            if self.FridgeBtnO.isSelected == true{
                return self.AllDataList.fridgeData?.lunch?.count ?? 0
            }else{
                return self.AllDataList.freezerData?.lunch?.count ?? 0
            }
        }else if collectionView == DinnerCollV{
            if self.FridgeBtnO.isSelected == true{
                return self.AllDataList.fridgeData?.dinner?.count ?? 0
            }else{
                return self.AllDataList.freezerData?.dinner?.count ?? 0
            }
        }else if collectionView == SnackCollV{
            if self.FridgeBtnO.isSelected == true{
                return self.AllDataList.fridgeData?.snacks?.count ?? 0
            }else{
                return self.AllDataList.freezerData?.snacks?.count ?? 0
            }
        }else{
            if self.FridgeBtnO.isSelected == true{
                return self.AllDataList.fridgeData?.teatime?.count ?? 0
            }else{
                return self.AllDataList.freezerData?.teatime?.count ?? 0
            }
        }
       }
       
       func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            
           if collectionView == CalanderCollV{
               let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "YrCockedMCalCollVCell", for: indexPath) as! YrCockedMCalCollVCell
               let date = currentWeekDates[indexPath.item]
                 
               cell.configure(with: date)
               
               return cell
           }else if collectionView == BreakFastCollV{
               let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "YourCoockedMealCollVCell", for: indexPath) as! YourCoockedMealCollVCell
               
               var nme = ""
               var img = ""
               var serv = ""
               var createdDate = ""
               var isLike = 0
               
               if self.FridgeBtnO.isSelected == true{
                   nme = self.AllDataList.fridgeData?.breakfast?[indexPath.item].recipe?.label ?? ""
                   serv = "\(self.AllDataList.fridgeData?.breakfast?[indexPath.item].servings ?? 0)"
                   createdDate = self.AllDataList.fridgeData?.breakfast?[indexPath.item].createdDate ?? "0 days ago"
                   img = self.AllDataList.fridgeData?.breakfast?[indexPath.item].recipe?.images?.small?.url ?? ""
                   isLike = self.AllDataList.fridgeData?.breakfast?[indexPath.item].isLike ?? 0
               }else{
                   nme = self.AllDataList.freezerData?.breakfast?[indexPath.item].recipe?.label ?? ""
                   serv = "\(self.AllDataList.freezerData?.breakfast?[indexPath.item].servings ?? 0)"
                   createdDate = self.AllDataList.freezerData?.breakfast?[indexPath.item].createdDate ?? "0 days ago"
                   img = self.AllDataList.freezerData?.breakfast?[indexPath.item].recipe?.images?.small?.url ?? ""
                   isLike = self.AllDataList.freezerData?.breakfast?[indexPath.item].isLike ?? 0
               }
               
               
               cell.NameLbl.text = nme
               
               cell.ServeCountLbl.text = "Serves \(serv)"
               
               cell.DayLbl.text = createdDate
               
               let imgUrl = img
               
               cell.IMg.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
               cell.IMg.sd_setImage(with: URL(string: imgUrl), placeholderImage: UIImage(named: "No_Image"))
               
               let islike = isLike
               
               if islike == 1{
                   cell.FavBtn.setImage(UIImage(named: "Fav"), for: .normal)
               }else{
                   cell.FavBtn.setImage(UIImage(named: "UnFav"), for: .normal)
               }
          
               cell.MinusBtn.tag = indexPath.item
               cell.MinusBtn.addTarget(self, action: #selector(BreakServecountMinusBtnClick(_:)), for: .touchUpInside)
               
               cell.PlusBtn.tag = indexPath.item
               cell.PlusBtn.addTarget(self, action: #selector(BreakServecountPlusBtnClick(_:)), for: .touchUpInside)
               
               cell.EatBtn.tag = indexPath.item
               cell.EatBtn.addTarget(self, action: #selector(BreakfastremoveBtnClick(_:)), for: .touchUpInside)
                
                      
               cell.FavBtn.tag = indexPath.item
               cell.FavBtn.addTarget(self, action: #selector(BreakFastFavBtnClick(_:)), for: .touchUpInside)
               
               return cell
           }else if collectionView == LunchCollV{
               let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "YourCoockedMealCollVCell", for: indexPath) as! YourCoockedMealCollVCell
               var nme = ""
               var img = ""
               var serv = ""
               var createdDate = ""
               var isLike = 0
               
               if self.FridgeBtnO.isSelected == true{
                   nme = self.AllDataList.fridgeData?.lunch?[indexPath.item].recipe?.label ?? ""
                   serv = "\(self.AllDataList.fridgeData?.lunch?[indexPath.item].servings ?? 0)"
                   createdDate = self.AllDataList.fridgeData?.lunch?[indexPath.item].createdDate ?? "0 days ago"
                   img = self.AllDataList.fridgeData?.lunch?[indexPath.item].recipe?.images?.small?.url ?? ""
                   isLike = self.AllDataList.fridgeData?.lunch?[indexPath.item].isLike ?? 0
               }else{
                   nme = self.AllDataList.freezerData?.lunch?[indexPath.item].recipe?.label ?? ""
                   serv = "\(self.AllDataList.freezerData?.lunch?[indexPath.item].servings ?? 0)"
                   createdDate = self.AllDataList.freezerData?.lunch?[indexPath.item].createdDate ?? "0 days ago"
                   img = self.AllDataList.freezerData?.lunch?[indexPath.item].recipe?.images?.small?.url ?? ""
                   isLike = self.AllDataList.freezerData?.lunch?[indexPath.item].isLike ?? 0
               }
               
               cell.NameLbl.text = nme
               cell.EatBtn.tag = indexPath.item
               cell.EatBtn.addTarget(self, action: #selector(LunchremoveBtnClick(_:)), for: .touchUpInside)
               
               let imgUrl =  img
               
               cell.IMg.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
               cell.IMg.sd_setImage(with: URL(string: imgUrl), placeholderImage: UIImage(named: "No_Image"))
                
               cell.ServeCountLbl.text = "Serves \(serv)"
               
               cell.DayLbl.text = createdDate
               
               let islike = isLike
               
               if islike == 1{
                   cell.FavBtn.setImage(UIImage(named: "Fav"), for: .normal)
               }else{
                   cell.FavBtn.setImage(UIImage(named: "UnFav"), for: .normal)
               }
               
               cell.FavBtn.tag = indexPath.item
               cell.FavBtn.addTarget(self, action: #selector(LunchFavBtnClick(_:)), for: .touchUpInside)
               
               cell.MinusBtn.tag = indexPath.item
               cell.MinusBtn.addTarget(self, action: #selector(LunchServecountMinusBtnClick(_:)), for: .touchUpInside)
               
               cell.PlusBtn.tag = indexPath.item
               cell.PlusBtn.addTarget(self, action: #selector(LunchServecountPlusBtnClick(_:)), for: .touchUpInside)
               
               return cell
               
           }else if collectionView == DinnerCollV{
               let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "YourCoockedMealCollVCell", for: indexPath) as! YourCoockedMealCollVCell
               
               var nme = ""
               var img = ""
               var serv = ""
               var createdDate = ""
               var isLike = 0
               
               if self.FridgeBtnO.isSelected == true{
                   nme = self.AllDataList.fridgeData?.dinner?[indexPath.item].recipe?.label ?? ""
                   serv = "\(self.AllDataList.fridgeData?.dinner?[indexPath.item].servings ?? 0)"
                   createdDate = self.AllDataList.fridgeData?.dinner?[indexPath.item].createdDate ?? "0 days ago"
                   img = self.AllDataList.fridgeData?.dinner?[indexPath.item].recipe?.images?.small?.url ?? ""
                   isLike = self.AllDataList.fridgeData?.dinner?[indexPath.item].isLike ?? 0
               }else{
                   nme = self.AllDataList.freezerData?.dinner?[indexPath.item].recipe?.label ?? ""
                   serv = "\(self.AllDataList.freezerData?.dinner?[indexPath.item].servings ?? 0)"
                   createdDate = self.AllDataList.freezerData?.dinner?[indexPath.item].createdDate ?? "0 days ago"
                   img = self.AllDataList.freezerData?.dinner?[indexPath.item].recipe?.images?.small?.url ?? ""
                   isLike = self.AllDataList.freezerData?.dinner?[indexPath.item].isLike ?? 0
               }
               
               
               cell.NameLbl.text = nme
               cell.EatBtn.tag = indexPath.item
               cell.EatBtn.addTarget(self, action: #selector(DinnerremoveBtnClick(_:)), for: .touchUpInside)
               
               let imgUrl =  img
               
               cell.IMg.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
               cell.IMg.sd_setImage(with: URL(string: imgUrl), placeholderImage: UIImage(named: "No_Image"))
            
               cell.ServeCountLbl.text = "Serves \(serv)"
               
               cell.DayLbl.text = createdDate
               
               let islike = isLike
               
               if islike == 1{
                   cell.FavBtn.setImage(UIImage(named: "Fav"), for: .normal)
               }else{
                   cell.FavBtn.setImage(UIImage(named: "UnFav"), for: .normal)
               }
               
               cell.FavBtn.tag = indexPath.item
               cell.FavBtn.addTarget(self, action: #selector(DinnerFavBtnClick(_:)), for: .touchUpInside)
               
               cell.MinusBtn.tag = indexPath.item
               cell.MinusBtn.addTarget(self, action: #selector(DinnerServecountMinusBtnClick(_:)), for: .touchUpInside)
               
               cell.PlusBtn.tag = indexPath.item
               cell.PlusBtn.addTarget(self, action: #selector(DinnerServecountPlusBtnClick(_:)), for: .touchUpInside)
               
               return cell
           }else if collectionView == SnackCollV{
               let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "YourCoockedMealCollVCell", for: indexPath) as! YourCoockedMealCollVCell
               
               var nme = ""
               var img = ""
               var serv = ""
               var createdDate = ""
               var isLike = 0
               
               if self.FridgeBtnO.isSelected == true{
                   nme = self.AllDataList.fridgeData?.snacks?[indexPath.item].recipe?.label ?? ""
                   serv = "\(self.AllDataList.fridgeData?.snacks?[indexPath.item].servings ?? 0)"
                   createdDate = self.AllDataList.fridgeData?.snacks?[indexPath.item].createdDate ?? "0 days ago"
                   img = self.AllDataList.fridgeData?.snacks?[indexPath.item].recipe?.images?.small?.url ?? ""
                   isLike = self.AllDataList.fridgeData?.snacks?[indexPath.item].isLike ?? 0
               }else{
                   nme = self.AllDataList.freezerData?.snacks?[indexPath.item].recipe?.label ?? ""
                   serv = "\(self.AllDataList.freezerData?.snacks?[indexPath.item].servings ?? 0)"
                   createdDate = self.AllDataList.freezerData?.snacks?[indexPath.item].createdDate ?? "0 days ago"
                   img = self.AllDataList.freezerData?.snacks?[indexPath.item].recipe?.images?.small?.url ?? ""
                   isLike = self.AllDataList.freezerData?.snacks?[indexPath.item].isLike ?? 0
               }
               
               cell.NameLbl.text = nme
               cell.EatBtn.tag = indexPath.item
               cell.EatBtn.addTarget(self, action: #selector(SnacksremoveBtnClick(_:)), for: .touchUpInside)
               
               let imgUrl =  img
               
               cell.IMg.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
               cell.IMg.sd_setImage(with: URL(string: imgUrl), placeholderImage: UIImage(named: "No_Image"))
            
               cell.ServeCountLbl.text = "Serves \(serv)"
               
               cell.DayLbl.text = createdDate
               
               let islike = isLike
               
               if islike == 1{
                   cell.FavBtn.setImage(UIImage(named: "Fav"), for: .normal)
               }else{
                   cell.FavBtn.setImage(UIImage(named: "UnFav"), for: .normal)
               }
               
               cell.FavBtn.tag = indexPath.item
               cell.FavBtn.addTarget(self, action: #selector(SnacksFavBtnClick(_:)), for: .touchUpInside)
               
               cell.MinusBtn.tag = indexPath.item
               cell.MinusBtn.addTarget(self, action: #selector(SnacksServecountMinusBtnClick(_:)), for: .touchUpInside)
               
               cell.PlusBtn.tag = indexPath.item
               cell.PlusBtn.addTarget(self, action: #selector(SnacksServecountPlusBtnClick(_:)), for: .touchUpInside)
               
               return cell
           }else{
               let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "YourCoockedMealCollVCell", for: indexPath) as! YourCoockedMealCollVCell
               
               var nme = ""
               var img = ""
               var serv = ""
               var createdDate = ""
               var isLike = 0
               
               if self.FridgeBtnO.isSelected == true{
                   nme = self.AllDataList.fridgeData?.teatime?[indexPath.item].recipe?.label ?? ""
                   serv = "\(self.AllDataList.fridgeData?.teatime?[indexPath.item].servings ?? 0)"
                   createdDate = self.AllDataList.fridgeData?.teatime?[indexPath.item].createdDate ?? "0 days ago"
                   img = self.AllDataList.fridgeData?.teatime?[indexPath.item].recipe?.images?.small?.url ?? ""
                   isLike = self.AllDataList.fridgeData?.teatime?[indexPath.item].isLike ?? 0
               }else{
                   nme = self.AllDataList.freezerData?.teatime?[indexPath.item].recipe?.label ?? ""
                   serv = "\(self.AllDataList.freezerData?.teatime?[indexPath.item].servings ?? 0)"
                   createdDate = self.AllDataList.freezerData?.teatime?[indexPath.item].createdDate ?? "0 days ago"
                   img = self.AllDataList.freezerData?.teatime?[indexPath.item].recipe?.images?.small?.url ?? ""
                   isLike = self.AllDataList.freezerData?.teatime?[indexPath.item].isLike ?? 0
               }
               
               cell.NameLbl.text = nme
               cell.EatBtn.tag = indexPath.item
               cell.EatBtn.addTarget(self, action: #selector(teatimeremoveBtnClick(_:)), for: .touchUpInside)
            
               let imgUrl =  img
               
               cell.IMg.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
               cell.IMg.sd_setImage(with: URL(string: imgUrl), placeholderImage: UIImage(named: "No_Image"))
               
               cell.ServeCountLbl.text = "Serves \(serv)"
               
               cell.DayLbl.text = createdDate
               
               let islike = isLike
               
               if islike == 1{
                   cell.FavBtn.setImage(UIImage(named: "Fav"), for: .normal)
               }else{
                   cell.FavBtn.setImage(UIImage(named: "UnFav"), for: .normal)
               }
               
               cell.FavBtn.tag = indexPath.item
               cell.FavBtn.addTarget(self, action: #selector(TeatimeFavBtnClick(_:)), for: .touchUpInside)
               
               cell.MinusBtn.tag = indexPath.item
               cell.MinusBtn.addTarget(self, action: #selector(TeaTimeServecountMinusBtnClick(_:)), for: .touchUpInside)
               
               cell.PlusBtn.tag = indexPath.item
               cell.PlusBtn.addTarget(self, action: #selector(TeaTimeServecountPlusBtnClick(_:)), for: .touchUpInside)
               
               return cell
           }
       }
    
    @objc func BreakfastremoveBtnClick(_ sender: UIButton)   {
        self.RemovePopupV.isHidden = false
        if self.FridgeBtnO.isSelected == true{
            selID = self.AllDataList.fridgeData?.breakfast?[sender.tag].id ?? 0
        }else{
            selID = self.AllDataList.freezerData?.breakfast?[sender.tag].id ?? 0
        }
        
        selCollv = 0
        self.SelRemoveIndx = sender.tag
        typeClicked = "Breakfast"
        
        }
    
    @objc func LunchremoveBtnClick(_ sender: UIButton)   {
        self.RemovePopupV.isHidden = false
        if self.FridgeBtnO.isSelected == true{
            selID = self.AllDataList.fridgeData?.lunch?[sender.tag].id ?? 0
        }else{
            selID = self.AllDataList.freezerData?.lunch?[sender.tag].id ?? 0
        }
        selCollv = 1
        self.SelRemoveIndx = sender.tag
        typeClicked = "Lunch"
        }
    
    @objc func DinnerremoveBtnClick(_ sender: UIButton)   {
        self.RemovePopupV.isHidden = false
        if self.FridgeBtnO.isSelected == true{
            selID = self.AllDataList.fridgeData?.dinner?[sender.tag].id ?? 0
        }else{
            selID = self.AllDataList.freezerData?.dinner?[sender.tag].id ?? 0
        }
        selCollv = 2
        self.SelRemoveIndx = sender.tag
        typeClicked = "Dinner"
        }
    
    @objc func SnacksremoveBtnClick(_ sender: UIButton)   {
        self.RemovePopupV.isHidden = false
        if self.FridgeBtnO.isSelected == true{
            selID = self.AllDataList.fridgeData?.snacks?[sender.tag].id ?? 0
        }else{
            selID = self.AllDataList.freezerData?.snacks?[sender.tag].id ?? 0
        }
        selCollv = 3
        self.SelRemoveIndx = sender.tag
        typeClicked = "Snacks"
        }
    
    @objc func teatimeremoveBtnClick(_ sender: UIButton)   {
        self.RemovePopupV.isHidden = false
        if self.FridgeBtnO.isSelected == true{
            selID = self.AllDataList.fridgeData?.teatime?[sender.tag].id ?? 0
        }else{
            selID = self.AllDataList.freezerData?.teatime?[sender.tag].id ?? 0
        }
        selCollv = 4
        self.SelRemoveIndx = sender.tag
        typeClicked = "Teatime"
        }

    
    //favBtn
    @objc func BreakFastFavBtnClick(_ sender: UIButton)   {
        let index  = sender.tag
        
        var uri = ""
        var selID = ""
        var islike = 0
        
        if self.FridgeBtnO.isSelected == true{
            uri = self.AllDataList.fridgeData?.breakfast?[index].recipe?.uri ?? ""
            selID = "\(self.AllDataList.fridgeData?.breakfast?[index].id ?? 0)"
            islike = self.AllDataList.fridgeData?.breakfast?[index].isLike ?? 0
        }else{
            uri = self.AllDataList.freezerData?.breakfast?[index].recipe?.uri ?? ""
            selID = "\(self.AllDataList.freezerData?.breakfast?[index].id ?? 0)"
            islike = self.AllDataList.freezerData?.breakfast?[index].isLike ?? 0
        }
        
        if islike == 1{
            self.Api_To_UnFAv(uri: uri)
        }else{
            self.FavBtnClickNav(TypeClicked: "Breakfast", Uri: uri, SelID: selID)
        }
      }
    
    @objc func LunchFavBtnClick(_ sender: UIButton)   {
        let index  = sender.tag
        var uri = ""
        var selID = ""
        var islike = 0
        
        if self.FridgeBtnO.isSelected == true{
            uri = self.AllDataList.fridgeData?.lunch?[index].recipe?.uri ?? ""
            selID = "\(self.AllDataList.fridgeData?.lunch?[index].id ?? 0)"
            islike = self.AllDataList.fridgeData?.lunch?[index].isLike ?? 0
        }else{
            uri = self.AllDataList.freezerData?.lunch?[index].recipe?.uri ?? ""
            selID = "\(self.AllDataList.freezerData?.lunch?[index].id ?? 0)"
            islike = self.AllDataList.freezerData?.lunch?[index].isLike ?? 0
        }
        
        if islike == 1{
            self.Api_To_UnFAv(uri: uri)
        }else{
            self.FavBtnClickNav(TypeClicked: "Lunch", Uri: uri, SelID: selID)
        }
    }
    
    @objc func DinnerFavBtnClick(_ sender: UIButton)   {
        let index  = sender.tag
        var uri = ""
        var selID = ""
        var islike = 0
        
        if self.FridgeBtnO.isSelected == true{
            uri = self.AllDataList.fridgeData?.dinner?[index].recipe?.uri ?? ""
            selID = "\(self.AllDataList.fridgeData?.dinner?[index].id ?? 0)"
            islike = self.AllDataList.fridgeData?.dinner?[index].isLike ?? 0
        }else{
            uri = self.AllDataList.freezerData?.dinner?[index].recipe?.uri ?? ""
            selID = "\(self.AllDataList.freezerData?.dinner?[index].id ?? 0)"
            islike = self.AllDataList.freezerData?.dinner?[index].isLike ?? 0
        }
        
        if islike == 1{
            self.Api_To_UnFAv(uri: uri)
        }else{
            self.FavBtnClickNav(TypeClicked: "Dinner", Uri: uri, SelID: selID)
        }
     }
    
    @objc func SnacksFavBtnClick(_ sender: UIButton)   {
        let index  = sender.tag
        var uri = ""
        var selID = ""
        var islike = 0
        
        if self.FridgeBtnO.isSelected == true{
            uri = self.AllDataList.fridgeData?.snacks?[index].recipe?.uri ?? ""
            selID = "\(self.AllDataList.fridgeData?.snacks?[index].id ?? 0)"
            islike = self.AllDataList.fridgeData?.snacks?[index].isLike ?? 0
        }else{
            uri = self.AllDataList.freezerData?.snacks?[index].recipe?.uri ?? ""
            selID = "\(self.AllDataList.freezerData?.snacks?[index].id ?? 0)"
            islike = self.AllDataList.freezerData?.snacks?[index].isLike ?? 0
        }
        
        if islike == 1{
            self.Api_To_UnFAv(uri: uri)
        }else{
            self.FavBtnClickNav(TypeClicked: "Snacks", Uri: uri, SelID: selID)
        }
       
        }
    
    @objc func TeatimeFavBtnClick(_ sender: UIButton)   {
        let index  = sender.tag
        var uri = ""
        var selID = ""
        var islike = 0
        
        if self.FridgeBtnO.isSelected == true{
            uri = self.AllDataList.fridgeData?.teatime?[index].recipe?.uri ?? ""
            selID = "\(self.AllDataList.fridgeData?.teatime?[index].id ?? 0)"
            islike = self.AllDataList.fridgeData?.teatime?[index].isLike ?? 0
        }else{
            uri = self.AllDataList.freezerData?.teatime?[index].recipe?.uri ?? ""
            selID = "\(self.AllDataList.freezerData?.teatime?[index].id ?? 0)"
            islike = self.AllDataList.freezerData?.teatime?[index].isLike ?? 0
        }
        
        if islike == 1{
            self.Api_To_UnFAv(uri: uri)
        }else{
            self.FavBtnClickNav(TypeClicked: "Brunch", Uri: uri, SelID: selID)
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
            self.Api_To_GetAllMealsList()
        }
        self.addChild(vc)
        vc.view.frame = self.view.frame
        self.view.addSubview(vc.view)
        self.view.bringSubviewToFront(vc.view)
        vc.didMove(toParent: self)
    }
    
    
    // for colllView for Plus btns..
    @objc func BreakServecountPlusBtnClick(_ sender: UIButton)   {
        let index = sender.tag
        
        var uri = ""
        var count = 0
         
        if self.FridgeBtnO.isSelected == true{
            uri = self.AllDataList.fridgeData?.breakfast?[index].recipe?.uri ?? ""
            self.AllDataList.fridgeData?.breakfast?[index].servings! += 1
            count = self.AllDataList.fridgeData?.breakfast?[index].servings ?? 0
        }else{
            uri = self.AllDataList.freezerData?.breakfast?[index].recipe?.uri ?? ""
            self.AllDataList.freezerData?.breakfast?[index].servings! += 1
            count = self.AllDataList.freezerData?.breakfast?[index].servings ?? 0
        }
         
        self.BreakFastCollV.reloadData()
          
        self.Api_For_AddServingcount(uri: uri, type: "Breakfast", servingCount: count)
        }
    
    @objc func LunchServecountPlusBtnClick(_ sender: UIButton)   {
        let index = sender.tag
        var uri = ""
        var count = 0
         
        if self.FridgeBtnO.isSelected == true{
            uri = self.AllDataList.fridgeData?.lunch?[index].recipe?.uri ?? ""
            self.AllDataList.fridgeData?.lunch?[index].servings! += 1
            count = self.AllDataList.fridgeData?.lunch?[index].servings ?? 0
        }else{
            uri = self.AllDataList.freezerData?.lunch?[index].recipe?.uri ?? ""
            self.AllDataList.freezerData?.lunch?[index].servings! += 1
            count = self.AllDataList.freezerData?.lunch?[index].servings ?? 0
        }
       
        self.LunchCollV.reloadData()
         
        self.Api_For_AddServingcount(uri: uri, type: "Lunch", servingCount: count)
        }
    
    @objc func DinnerServecountPlusBtnClick(_ sender: UIButton)   {
        let index = sender.tag
        var uri = ""
        var count = 0
         
        if self.FridgeBtnO.isSelected == true{
            uri = self.AllDataList.fridgeData?.dinner?[index].recipe?.uri ?? ""
            self.AllDataList.fridgeData?.dinner?[index].servings! += 1
            count = self.AllDataList.fridgeData?.dinner?[index].servings ?? 0
        }else{
            uri = self.AllDataList.freezerData?.dinner?[index].recipe?.uri ?? ""
            self.AllDataList.freezerData?.dinner?[index].servings! += 1
            count = self.AllDataList.freezerData?.dinner?[index].servings ?? 0
        }
        
        self.DinnerCollV.reloadData()
        
        self.Api_For_AddServingcount(uri: uri, type: "Dinner", servingCount: count)
        }
    
    @objc func SnacksServecountPlusBtnClick(_ sender: UIButton)   {
        let index = sender.tag
        var uri = ""
        var count = 0
         
        if self.FridgeBtnO.isSelected == true{
            uri = self.AllDataList.fridgeData?.snacks?[index].recipe?.uri ?? ""
            self.AllDataList.fridgeData?.snacks?[index].servings! += 1
            count = self.AllDataList.fridgeData?.snacks?[index].servings ?? 0
        }else{
            uri = self.AllDataList.freezerData?.snacks?[index].recipe?.uri ?? ""
            self.AllDataList.freezerData?.snacks?[index].servings! += 1
            count = self.AllDataList.freezerData?.snacks?[index].servings ?? 0
        }
        self.SnackCollV.reloadData()
         
        self.Api_For_AddServingcount(uri: uri, type: "Snacks", servingCount: count)
        }
    
    @objc func TeaTimeServecountPlusBtnClick(_ sender: UIButton)   {
        let index = sender.tag
        var uri = ""
        var count = 0
         
        if self.FridgeBtnO.isSelected == true{
            uri = self.AllDataList.fridgeData?.teatime?[index].recipe?.uri ?? ""
            self.AllDataList.fridgeData?.teatime?[index].servings! += 1
            count = self.AllDataList.fridgeData?.teatime?[index].servings ?? 0
        }else{
            uri = self.AllDataList.freezerData?.teatime?[index].recipe?.uri ?? ""
            self.AllDataList.freezerData?.teatime?[index].servings! += 1
            count = self.AllDataList.freezerData?.teatime?[index].servings ?? 0
        }
        self.TeatimeCollV.reloadData()
         
        self.Api_For_AddServingcount(uri: uri, type: "Brunch", servingCount: count)
        }
    
    // for colllView for minus btns.
    @objc func BreakServecountMinusBtnClick(_ sender: UIButton)   {
        let index = sender.tag
        var uri = ""
        var count = 0
         
        if self.FridgeBtnO.isSelected == true{
            guard self.AllDataList.fridgeData?.breakfast?[index].servings ?? 0 > 1 else{
                return
            }
            
            uri = self.AllDataList.fridgeData?.breakfast?[index].recipe?.uri ?? ""
            self.AllDataList.fridgeData?.breakfast?[index].servings! -= 1
            count = self.AllDataList.fridgeData?.breakfast?[index].servings ?? 0
        }else{
            guard self.AllDataList.freezerData?.breakfast?[index].servings ?? 0 > 1 else{
                return
            }
            
            uri = self.AllDataList.freezerData?.breakfast?[index].recipe?.uri ?? ""
            self.AllDataList.freezerData?.breakfast?[index].servings! -= 1
            count = self.AllDataList.freezerData?.breakfast?[index].servings ?? 0
        }
        
       
         
        self.BreakFastCollV.reloadData()
              
        self.Api_For_AddServingcount(uri: uri, type: "Breakfast", servingCount: count)
        }
    
    @objc func LunchServecountMinusBtnClick(_ sender: UIButton)   {
        let index = sender.tag
        
        var uri = ""
        var count = 0
         
        if self.FridgeBtnO.isSelected == true{
            guard self.AllDataList.fridgeData?.lunch?[index].servings ?? 0 > 1 else{
                return
            }
            
            uri = self.AllDataList.fridgeData?.lunch?[index].recipe?.uri ?? ""
            self.AllDataList.fridgeData?.lunch?[index].servings! -= 1
            count = self.AllDataList.fridgeData?.lunch?[index].servings ?? 0
        }else{
            guard self.AllDataList.freezerData?.lunch?[index].servings ?? 0 > 1 else{
                return
            }
            
            uri = self.AllDataList.freezerData?.lunch?[index].recipe?.uri ?? ""
            self.AllDataList.freezerData?.lunch?[index].servings! -= 1
            count = self.AllDataList.freezerData?.lunch?[index].servings ?? 0
        }
        
        self.LunchCollV.reloadData()
          
        self.Api_For_AddServingcount(uri: uri, type: "Lunch", servingCount: count)
        }
    
    @objc func DinnerServecountMinusBtnClick(_ sender: UIButton)   {
        let index = sender.tag
        var uri = ""
        var count = 0
         
        if self.FridgeBtnO.isSelected == true{
            guard self.AllDataList.fridgeData?.dinner?[index].servings ?? 0 > 1 else{
                return
            }
            
            uri = self.AllDataList.fridgeData?.dinner?[index].recipe?.uri ?? ""
            self.AllDataList.fridgeData?.dinner?[index].servings! -= 1
            count = self.AllDataList.fridgeData?.dinner?[index].servings ?? 0
        }else{
            guard self.AllDataList.freezerData?.dinner?[index].servings ?? 0 > 1 else{
                return
            }
            
            uri = self.AllDataList.freezerData?.dinner?[index].recipe?.uri ?? ""
            self.AllDataList.freezerData?.dinner?[index].servings! -= 1
            count = self.AllDataList.freezerData?.dinner?[index].servings ?? 0
        }
        self.DinnerCollV.reloadData()
        
        self.Api_For_AddServingcount(uri: uri, type: "Dinner", servingCount: count)
        }
    
    @objc func SnacksServecountMinusBtnClick(_ sender: UIButton)   {
        let index = sender.tag
         
        var uri = ""
        var count = 0
         
        if self.FridgeBtnO.isSelected == true{
            guard self.AllDataList.fridgeData?.snacks?[index].servings ?? 0 > 1 else{
                return
            }
            
            uri = self.AllDataList.fridgeData?.snacks?[index].recipe?.uri ?? ""
            self.AllDataList.fridgeData?.snacks?[index].servings! -= 1
            count = self.AllDataList.fridgeData?.snacks?[index].servings ?? 0
        }else{
            guard self.AllDataList.freezerData?.snacks?[index].servings ?? 0 > 1 else{
                return
            }
            
            uri = self.AllDataList.freezerData?.snacks?[index].recipe?.uri ?? ""
            self.AllDataList.freezerData?.snacks?[index].servings! -= 1
            count = self.AllDataList.freezerData?.snacks?[index].servings ?? 0
        }
        
        self.SnackCollV.reloadData()
         
        self.Api_For_AddServingcount(uri: uri, type: "Snacks", servingCount: count)
        }
    
    @objc func TeaTimeServecountMinusBtnClick(_ sender: UIButton)   {
        let index = sender.tag
        var uri = ""
        var count = 0
         
        if self.FridgeBtnO.isSelected == true{
            guard self.AllDataList.fridgeData?.teatime?[index].servings ?? 0 > 1 else{
                return
            }
            
            uri = self.AllDataList.fridgeData?.teatime?[index].recipe?.uri ?? ""
            self.AllDataList.fridgeData?.teatime?[index].servings! -= 1
            count = self.AllDataList.fridgeData?.teatime?[index].servings ?? 0
        }else{
            guard self.AllDataList.freezerData?.teatime?[index].servings ?? 0 > 1 else{
                return
            }
            
            uri = self.AllDataList.freezerData?.teatime?[index].recipe?.uri ?? ""
            self.AllDataList.freezerData?.teatime?[index].servings! -= 1
            count = self.AllDataList.freezerData?.teatime?[index].servings ?? 0
        }
        
        self.TeatimeCollV.reloadData()
         
        self.Api_For_AddServingcount(uri: uri, type: "Brunch", servingCount: count)
        }
        
       
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == CalanderCollV{
            // Deselect the previously selected item, if any
            if let previousIndex = selectedIndex {
                let previousCell = collectionView.cellForItem(at: previousIndex) as? YrCockedMCalCollVCell
                previousCell?.updateSelection(isSelected: false)
            }
            
            // Select the current item
            let currentCell = collectionView.cellForItem(at: indexPath) as? YrCockedMCalCollVCell
            currentCell?.updateSelection(isSelected: true)
            
            // Update the selected index
            selectedIndex = indexPath
            
            seldate = currentWeekDates[indexPath.item]
            
            self.tag = 1
            
            self.Api_To_GetAllMealsList()
           //   CalanderCollV.reloadData()
        } else if collectionView == BreakFastCollV{
            var uri = ""
           
            if self.FridgeBtnO.isSelected == true{
                uri = self.AllDataList.fridgeData?.breakfast?[indexPath.item].recipe?.uri ?? ""
            }else{
                uri = self.AllDataList.freezerData?.breakfast?[indexPath.item].recipe?.uri ?? ""
            }
            
            let storyboard = UIStoryboard(name: "Tabbar", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "RecipeDetailsVC") as! RecipeDetailsVC
            vc.uri = uri
            vc.MealType = "Breakfast"
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }else if collectionView == LunchCollV{
            var uri = ""
           
            if self.FridgeBtnO.isSelected == true{
                uri = self.AllDataList.fridgeData?.lunch?[indexPath.item].recipe?.uri ?? ""
            }else{
                uri = self.AllDataList.freezerData?.lunch?[indexPath.item].recipe?.uri ?? ""
            }
            
            let storyboard = UIStoryboard(name: "Tabbar", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "RecipeDetailsVC") as! RecipeDetailsVC
            vc.uri = uri
            vc.MealType = "Lunch"
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }else if collectionView == DinnerCollV{
            var uri = ""
           
            if self.FridgeBtnO.isSelected == true{
                uri = self.AllDataList.fridgeData?.dinner?[indexPath.item].recipe?.uri ?? ""
            }else{
                uri = self.AllDataList.freezerData?.dinner?[indexPath.item].recipe?.uri ?? ""
            }
            
            let storyboard = UIStoryboard(name: "Tabbar", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "RecipeDetailsVC") as! RecipeDetailsVC
            vc.uri = uri
            vc.MealType = "Dinner"
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }else if collectionView == SnackCollV{
            var uri = ""
           
            if self.FridgeBtnO.isSelected == true{
                uri = self.AllDataList.fridgeData?.snacks?[indexPath.item].recipe?.uri ?? ""
            }else{
                uri = self.AllDataList.freezerData?.snacks?[indexPath.item].recipe?.uri ?? ""
            }
            
            let storyboard = UIStoryboard(name: "Tabbar", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "RecipeDetailsVC") as! RecipeDetailsVC
            vc.uri = uri
            vc.MealType = "Snacks"
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            var uri = ""
           
            if self.FridgeBtnO.isSelected == true{
                uri = self.AllDataList.fridgeData?.teatime?[indexPath.item].recipe?.uri ?? ""
            }else{
                uri = self.AllDataList.freezerData?.teatime?[indexPath.item].recipe?.uri ?? ""
            }
            
            let storyboard = UIStoryboard(name: "Tabbar", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "RecipeDetailsVC") as! RecipeDetailsVC
            vc.uri = uri
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
               return CGSize(width: 197, height: collectionView.bounds.height)
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
   
extension YourCoockedMealVC {
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
            
           // ChooseDayWeekLabel.text = "\(formatter.string(from: start)) - \(formatter.string(from: end))"
            
            let formatter1 = DateFormatter()
            formatter1.dateFormat = "d" // For the day number
//            let startDay = formatter1.string(from: start)
//            let endDay = formatter1.string(from: end)

            formatter1.dateFormat = "MMM, yyy" // For the month abbreviation (e.g., Dec)
            let month = formatter1.string(from: start)

            FromDateToLbl.text = "\(month)" // \(startDay) - \(endDay)
            
        }
    }
}

//YourCookedMealModelClass
extension YourCoockedMealVC {
  
    func Api_To_GetAllMealsList(){
        var params = [String: Any]()
        
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy-MM-dd"
        
        if tag == 0{
            params["date"] = ""
        }else{
            let Sdate = dateformatter.string(from: seldate)
            params["date"] = Sdate
        }
     
        
        
//        if FridgeBtnO.isSelected{
//            params["plan_type"] = "1"
//        }else{
//            params["plan_type"] = "2"
//        }
        
        
        showIndicator(withTitle: "", and: "")
        
        let loginURL = baseURL.baseURL + appEndPoints.get_meals_by_random_date//get_meals
        print(params,"Params")
        print(loginURL,"loginURL")
        
        WebService.shared.postServiceURLEncoding(loginURL, VC: self, andParameter: params, withCompletion: { (json, statusCode) in
            
            self.hideIndicator()
            
            let data = try! json.rawData()
            
            do{
                let d = try JSONDecoder().decode(YourCookedMealModelClassNew.self, from: data)
                if d.success == true {
                     let list = d.data
                    self.AllDataList  = list ?? YourCookedMealModelNew()
                    
                    self.FridgeLbl.text = "Fridge (\(self.AllDataList.fridge ?? 0))"
                    
                    self.FreezerLbl.text = "Freezer (\(self.AllDataList.freezer ?? 0))"
                             
                    
                    if self.FridgeBtnO.isSelected == true{
                        if self.AllDataList.fridgeData?.breakfast?.count ?? 0 == 0 && self.AllDataList.fridgeData?.lunch?.count ?? 0 == 0 && self.AllDataList.fridgeData?.dinner?.count ?? 0 == 0 && self.AllDataList.fridgeData?.snacks?.count ?? 0 == 0 && self.AllDataList.fridgeData?.teatime?.count ?? 0 == 0{
                            self.EmptyMealBgV.isHidden = false
                            self.BreakFastBgV.isHidden = true
                            self.LunchBgV.isHidden = true
                            self.DinnerBgV.isHidden = true
                            self.SnackBgV.isHidden = true
                            self.TeatimeBgV.isHidden = true
                        }else{
                            self.EmptyMealBgV.isHidden = true
                            self.BreakFastBgV.isHidden = false
                            self.LunchBgV.isHidden = false
                            self.DinnerBgV.isHidden = false
                            self.SnackBgV.isHidden = false
                            self.TeatimeBgV.isHidden = false
                        }
                    }else{
                        if self.AllDataList.freezerData?.breakfast?.count ?? 0 == 0 && self.AllDataList.freezerData?.lunch?.count ?? 0 == 0 && self.AllDataList.freezerData?.dinner?.count ?? 0 == 0 && self.AllDataList.freezerData?.snacks?.count ?? 0 == 0 && self.AllDataList.freezerData?.teatime?.count ?? 0 == 0{
                            self.EmptyMealBgV.isHidden = false
                            self.BreakFastBgV.isHidden = true
                            self.LunchBgV.isHidden = true
                            self.DinnerBgV.isHidden = true
                            self.SnackBgV.isHidden = true
                            self.TeatimeBgV.isHidden = true
                        }else{
                            self.EmptyMealBgV.isHidden = true
                            self.BreakFastBgV.isHidden = false
                            self.LunchBgV.isHidden = false
                            self.DinnerBgV.isHidden = false
                            self.SnackBgV.isHidden = false
                            self.TeatimeBgV.isHidden = false
                        }
                    }
                    
                    if self.tag == 0{
                        let date = self.AllDataList.date ?? ""
                        
                        let df = DateFormatter()
                        df.dateFormat = "yyyy-MM-dd"
                        df.locale = Locale(identifier: "en_US_POSIX")
                        let Ndate = df.date(from: date)
                        
                        self.seldate = Ndate ?? Date()
                        
                        let today = Ndate ?? Date()
                        self.currentWeekDates = self.calculateWeekDates(for: today)
                        self.updateWeekLabel()
                        
                        self.updateSelection(at: today)
                       
                        }
                     
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
    
    
    func updateSelection(at date: Date) {
        guard let matchingIndex = self.currentWeekDates.firstIndex(where: {
            Calendar.current.isDate($0, inSameDayAs: date)
        }) else {
            print("date is not part of currentWeekDates.")
            return
        }
        
        let indexPath = IndexPath(item: matchingIndex, section: 0)
 
        // Perform the actions that should occur on selection
        self.collectionView(self.CalanderCollV, didSelectItemAt: indexPath)
    }

    
    
    func ShowNoDataFoundonCollV(){
        if self.FridgeBtnO.isSelected == true{
            if self.AllDataList.fridgeData?.breakfast?.count ?? 0 == 0{
                self.BreakFastBgV.isHidden = true
            }else{
                self.BreakFastBgV.isHidden = false
            }
            
            if self.AllDataList.fridgeData?.lunch?.count ?? 0 == 0{
                self.LunchBgV.isHidden = true
            }else{
                self.LunchBgV.isHidden = false
            }
            
            
            if self.AllDataList.fridgeData?.dinner?.count ?? 0 == 0{
                self.DinnerBgV.isHidden = true
            }else{
                self.DinnerBgV.isHidden = false
            }
            
            if self.AllDataList.fridgeData?.snacks?.count ?? 0 == 0{
                self.SnackBgV.isHidden = true
            }else{
                self.SnackBgV.isHidden = false
            }
            
            if self.AllDataList.fridgeData?.teatime?.count ?? 0 == 0{
                self.TeatimeBgV.isHidden = true
            }else{
                self.TeatimeBgV.isHidden = false
            }
        }else{
            if self.AllDataList.freezerData?.breakfast?.count ?? 0 == 0{
                self.BreakFastBgV.isHidden = true
            }else{
                self.BreakFastBgV.isHidden = false
            }
            
            if self.AllDataList.freezerData?.lunch?.count ?? 0 == 0{
                self.LunchBgV.isHidden = true
            }else{
                self.LunchBgV.isHidden = false
            }
            
            
            if self.AllDataList.freezerData?.dinner?.count ?? 0 == 0{
                self.DinnerBgV.isHidden = true
            }else{
                self.DinnerBgV.isHidden = false
            }
            
            if self.AllDataList.freezerData?.snacks?.count ?? 0 == 0{
                self.SnackBgV.isHidden = true
            }else{
                self.SnackBgV.isHidden = false
            }
            
            if self.AllDataList.freezerData?.teatime?.count ?? 0 == 0{
                self.TeatimeBgV.isHidden = true
            }else{
                self.TeatimeBgV.isHidden = false
            }
        }
        
        self.BreakFastCollV.reloadData()
        self.LunchCollV.reloadData()
        self.DinnerCollV.reloadData()
        self.SnackCollV.reloadData()
        self.TeatimeCollV.reloadData()
    }
    
    func Api_To_RemoveMeal(){
        var params = [String: Any]()
        
       
        params["id"] = selID
       
        showIndicator(withTitle: "", and: "")
        
        let loginURL = baseURL.baseURL + appEndPoints.remove_meal_cooked
        print(params,"Params")
        print(loginURL,"loginURL")
        
        WebService.shared.postServiceURLEncoding(loginURL, VC: self, andParameter: params, withCompletion: { (json, statusCode) in
            
            self.hideIndicator()
            
            guard let dictData = json.dictionaryObject else{
                return
            }
            
            if dictData["success"] as? Bool == true{
                let result = dictData["data"] as? NSDictionary ?? NSDictionary()
                
                let date = result["date"] as? String ?? ""
               
                if self.typeClicked == "Breakfast"{
                    if self.FridgeBtnO.isSelected == true{
                        self.AllDataList.fridgeData?.breakfast?.remove(at: self.SelRemoveIndx)
                    }else{
                        self.AllDataList.freezerData?.breakfast?.remove(at: self.SelRemoveIndx)
                    }
                }else if self.typeClicked == "Lunch"{
                    if self.FridgeBtnO.isSelected == true{
                        self.AllDataList.fridgeData?.lunch?.remove(at: self.SelRemoveIndx)
                    }else{
                        self.AllDataList.freezerData?.lunch?.remove(at: self.SelRemoveIndx)
                    }
                }else if self.typeClicked == "Dinner" {
                    if self.FridgeBtnO.isSelected == true{
                        self.AllDataList.fridgeData?.dinner?.remove(at: self.SelRemoveIndx)
                    }else{
                        self.AllDataList.freezerData?.dinner?.remove(at: self.SelRemoveIndx)
                    }
                }else if self.typeClicked == "Snacks" {
                    if self.FridgeBtnO.isSelected == true{
                        self.AllDataList.fridgeData?.snacks?.remove(at: self.SelRemoveIndx)
                    }else{
                        self.AllDataList.freezerData?.snacks?.remove(at: self.SelRemoveIndx)
                    }
                }else{
                    if self.FridgeBtnO.isSelected == true{
                        self.AllDataList.fridgeData?.teatime?.remove(at: self.SelRemoveIndx)
                    }else{
                        self.AllDataList.freezerData?.teatime?.remove(at: self.SelRemoveIndx)
                    }
                }
                
                if self.FridgeBtnO.isSelected == true{
                    self.AllDataList.fridge? -= 1
                    self.FridgeLbl.text = "Fridge (\(self.AllDataList.fridge ?? 0))"
                }else{
                    self.AllDataList.freezer? -= 1
                    self.FreezerLbl.text = "Freezer (\(self.AllDataList.freezer ?? 0))"
                }
                
                self.ShowNoDataFoundonCollV()
                
                  if self.AllDataList.fridge == 0 && self.AllDataList.freezer == 0{
                     self.tag = 0
                      let df = DateFormatter()
                      df.dateFormat = "yyyy-MM-dd"
                      df.locale = Locale(identifier: "en_US_POSIX")
                      let Ndate = df.date(from: date)
                      
                      self.seldate = Ndate ?? Date()
                      
                      let today = Ndate ?? Date()
                      self.currentWeekDates = self.calculateWeekDates(for: today)
                      self.updateWeekLabel()
                      
                      self.updateSelection(at: today)
                  }else{
                      self.Api_To_GetAllMealsList()
                  }
                 
            }else{
                let responseMessage = dictData["message"] as! String
                self.showToast(responseMessage)
            }
        })
    }
    
    func Api_To_UnFAv(uri: String){
        var params = [String: Any]()
        
        params["uri"] = uri
        params["type"] = 0
//        params["cook_book"] = self.selID
 
        
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
                self.showToast("Removed from favourites successfully!")
                self.Api_To_GetAllMealsList()
               }else{
                   let responseMessage = dictData["message"] as? String ?? ""
                   self.showToast(responseMessage)
               }
          })
         }
    
    func Api_For_AddServingcount(uri: String, type: String, servingCount: Int) {
       
        let dateformatter = DateFormatter()
        
        var SerArray = [[String: String]]()
        
            let date = self.seldate
            dateformatter.dateFormat = "yyyy-MM-dd"
        let Sdate = dateformatter.string(from: date)
            
            dateformatter.dateFormat = "EEEE" // Full day name, e.g., "Monday"
            let dayOfWeek = dateformatter.string(from: date)
         
                print("\(dayOfWeek), \(Sdate) is selected!")
                
            let dictionary1: [String: String] = ["date": Sdate, "day": dayOfWeek]
                SerArray.append(dictionary1)
        
        
        print(SerArray)
        
        
            let paramsDict: [String: Any] = [
                "type": type,
                "uri": uri,
                "slot": SerArray,
                "servings": servingCount
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

