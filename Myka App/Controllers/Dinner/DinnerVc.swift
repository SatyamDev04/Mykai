//
//  DinnerVc.swift
//  Myka App
//
//  Created by Sumit on 12/12/24.
//

import UIKit
import Alamofire
import SDWebImage

class DinnerVc: UIViewController {

    @IBOutlet weak var TitleLbl: UILabel!
    @IBOutlet weak var CollV: UICollectionView!
    
    
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
    
    var titleTxt = ""
    
    var SelectedIngNames = ""
    
    // for popUps
    
    var ChooseDayData = [BodyGoalsModel(Name: "Monday", isSelected: false), BodyGoalsModel(Name: "Tuesday", isSelected: false), BodyGoalsModel(Name: "Wednesday", isSelected: false), BodyGoalsModel(Name: "Thursday", isSelected: false), BodyGoalsModel(Name: "Friday", isSelected: false), BodyGoalsModel(Name: "Saturday", isSelected: false), BodyGoalsModel(Name: "Sunday", isSelected: false)]
    
    var ChooseMealTypeyData = [BodyGoalsModel(Name: "Breakfast", isSelected: false), BodyGoalsModel(Name: "Lunch", isSelected: false), BodyGoalsModel(Name: "Dinner", isSelected: false), BodyGoalsModel(Name: "Snacks", isSelected: false), BodyGoalsModel(Name: "Brunch", isSelected: false)]
    
    var currentWeekDates: [Date] = []
    var calendar = Calendar.current
    
    var selectedIndex: IndexPath?
    
    var seldate = Date()
    
    var SelUri = ""
    //
    
    var AllRecipeSelItem = PlanDataClass()
    
    var SearchAllRecipeArr = [RecipeElement]() // Main arr APi
    
    var comesfrom = ""
    
    // getting value from filter screen.
    var MealArray = [FilterModuel]()
    var DietArray = [FilterModuel]()
    var CookTimeArray = [FilterModuel]()
    var CuisinesArray = [FilterModuel]()
    var NutritionArray = [FilterModuel]()
    //
 
    var hasReachedEnd = false
    var lastContentOffset: CGFloat = 0
  
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ChoosedaysPopupV.frame = self.view.bounds
        self.view.addSubview(self.ChoosedaysPopupV)
        self.ChoosedaysPopupV.isHidden = true
        
        self.ChooseMealTypePopupV.frame = self.view.bounds
        self.view.addSubview(self.ChooseMealTypePopupV)
        self.ChooseMealTypePopupV.isHidden = true
        
           self.TitleLbl.text = self.titleTxt
        
        
        CollV.delegate = self
        CollV.dataSource = self
        CollV.register(UINib(nibName: "DinnerCollVCell", bundle: nil), forCellWithReuseIdentifier: "DinnerCollVCell")
        
        calendar.firstWeekday = 2 // Start the week on Monday
        setupInitialWeek()
        setupTableView()
        
      //  self.Api_To_GetAllRecipe()
        if comesfrom != "All_IngredientsVC"{
            self.Api_To_GetAllMealsRecipe(Serach: self.titleTxt)
        }else{
            self.Api_To_GetAllMealsRecipe(Serach: self.SelectedIngNames)   
        }
       
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        ChoosedaysBgV.addGestureRecognizer(tapGesture)
        
        let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(handleTap1(_:)))
        ChooseMealTypeBgV.addGestureRecognizer(tapGesture1)
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
           
           self.ChoosedaysTblV.reloadData()
           self.ChooseMealTypeTblV.reloadData()
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
        
        self.ChoosedaysTblV.reloadData()
        self.ChooseMealTypeTblV.reloadData()
    }
    
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

    
    @IBAction func BackBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
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
    
    // for popUps btns
    // for popups
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
         
        self.Api_For_AddToPlan(uri: self.SelUri, type: self.titleTxt)
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
    
    //
}

extension DinnerVc: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return self.SearchAllRecipeArr.count
       }
       
       func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
               let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DinnerCollVCell", for: indexPath) as! DinnerCollVCell
           cell.NameLbl.text = self.SearchAllRecipeArr[indexPath.item].recipe?.label ?? ""
           
           cell.RatingLbl.text = "\(self.SearchAllRecipeArr[indexPath.item].review ?? 0)(\(self.SearchAllRecipeArr[indexPath.item].review_number ?? 0))"
            
          // cell.PriceLbl.text = ""
                
           cell.TimeLbl.text = "\(self.SearchAllRecipeArr[indexPath.item].recipe?.totalTime ?? 0) min"
           
           let ImgUrl = self.SearchAllRecipeArr[indexPath.item].recipe?.images?.small?.url ?? ""
           
           cell.ImgV.sd_imageIndicator = SDWebImageActivityIndicator.medium
           cell.ImgV.sd_setImage(with: URL(string: ImgUrl), placeholderImage: UIImage(named: "No_Image"))
           
           let islike = self.SearchAllRecipeArr[indexPath.item].isLike ?? 0
           if islike == 1{
               cell.FavBtn.setImage(UIImage(named: "Fav"), for: .normal)
           }else{
               cell.FavBtn.setImage(UIImage(named: "UnFav"), for: .normal)
           }
       
           cell.FavBtn.tag = indexPath.item
           cell.FavBtn.addTarget(self, action: #selector(FavBtnClick(_:)), for: .touchUpInside)
           
           cell.CartBtn.tag = indexPath.item
           cell.CartBtn.addTarget(self, action: #selector(BaskBtnClick(_:)), for: .touchUpInside)
           
           cell.AddToPlanBtn.tag = indexPath.item
           cell.AddToPlanBtn.addTarget(self, action: #selector(Add_to_PlanBtnClick(_:)), for: .touchUpInside)
               
               return cell
           
       }
    
    
    //favBtn
    @objc func FavBtnClick(_ sender: UIButton)   {
        let uri = self.SearchAllRecipeArr[sender.tag].recipe?.uri ?? ""
        
        if self.SearchAllRecipeArr[sender.tag].isLike == 1{
            self.SearchAllRecipeArr[sender.tag].isLike = 0
            self.Api_To_Like_UnlikeRecipe(uri: uri, type: self.titleTxt)
        }else{
            self.FavBtnClickNav(TypeClicked: self.titleTxt, Uri: uri, SelID: "")
        }
         
        self.CollV.reloadData()
    }
    
    func FavBtnClickNav(TypeClicked: String, Uri: String, SelID: String)   {
        let storyboard = UIStoryboard(name: "Tabbar", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "FavrouitPopupVC") as! FavrouitPopupVC
        vc.comesFrom = "SearchTab"
        vc.uri = Uri
        vc.selID = SelID
        vc.typeclicked = TypeClicked
        vc.backAction = {
            self.Api_To_GetAllMealsRecipe(Serach: self.TitleLbl.text!)
        }
        self.addChild(vc)
        vc.view.frame = self.view.frame
        self.view.addSubview(vc.view)
        self.view.bringSubviewToFront(vc.view)
        vc.didMove(toParent: self)
    }
    
    @objc func Add_to_PlanBtnClick(_ sender: UIButton)   {
        let uri = self.SearchAllRecipeArr[sender.tag].recipe?.uri ?? ""
        self.ChoosedaysPopupV.isHidden = false
        self.SelUri = uri
        }
    
    @objc func BaskBtnClick(_ sender: UIButton)   {
        
        let uri = self.SearchAllRecipeArr[sender.tag].recipe?.uri ?? ""
       
        if self.TitleLbl.text! != ""{
            self.Api_To_AddToBasket_Recipe(uri: uri, type: titleTxt)
        }else{
            if self.MealArray.count == 1{
                let mealType = self.MealArray[0].name
                self.Api_To_AddToBasket_Recipe(uri: uri, type: mealType)
            }else{
                let mealType = self.SearchAllRecipeArr[sender.tag].recipe?.mealType?.first ?? ""
                
                let Type = mealType.components(separatedBy: "/").first
                
                self.Api_To_AddToBasket_Recipe(uri: uri, type: Type ?? "")
            }
        }
        }
    
    
        
       
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }
 
       func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//               return CGSize(width: collectionView.frame.width/2 - 5, height: collectionView.frame.height)
           
//           let padding: CGFloat = 10
//           let itemsPerRow: CGFloat = 2
//           let totalPadding = padding * (itemsPerRow + 1)
//           let availableWidth = collectionView.frame.size.width - totalPadding
//           let itemWidth = availableWidth / itemsPerRow
           
           return CGSize(width: 190, height: 275)
       }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return 0
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
                self.Api_To_GetAllMealsRecipe(Serach: self.titleTxt)
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
     

extension DinnerVc: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == ChoosedaysTblV {
            return ChooseDayData.count
        }else{
            return ChooseMealTypeyData.count
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
        }else{
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
        }else{
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
   

extension DinnerVc {
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

          //  FromDateToLbl.text = "\(startDay) - \(endDay) \(month)"
           // ChooseDayWeekLabel.text = "\(startDay) - \(endDay) \(month)"
            
            for j in 0..<ChooseDayData.count {
                ChooseDayData[j].isSelected = false
            }
            
            ChoosedaysTblV.reloadData()
            
        }
    }
}



extension DinnerVc {
//    func Api_To_GetAllRecipe(){
//        var params = [String: Any]()
//        
//        params["q"] = self.titleTxt
//        
//        
//        let token  = UserDetail.shared.getTokenWith()
//        
//        let headers: HTTPHeaders = [
//            "Authorization": "Bearer \(token)"
//        ]
//        
//        showIndicator(withTitle: "", and: "")
//        
//        let loginURL = baseURL.baseURL + appEndPoints.all_recipe
//        print(params,"Params")
//        print(loginURL,"loginURL")
//        
//        WebService.shared.postServiceURLEncoding(loginURL, VC: self, andParameter: params, headers: headers, withCompletion: { (json, statusCode) in
//            
//            self.hideIndicator()
//            
//            let data = try! json.rawData()
//            
//            do{
//                let d = try JSONDecoder().decode(PlanModelClass.self, from: data)
//                if d.success == true {
//                    if let list = d.data, list.recipes != nil {
//                        self.AllRecipeSelItem = list
//                    }
//                }else{
//                 
//                    let msg = d.message ?? ""
//                    self.showToast(msg)
//                }
//            }catch{
//                print(error)
//            }
//        })
//    }
}

extension DinnerVc {
    func Api_To_GetAllMealsRecipe(Serach: String){
        var params = [String: Any]()
        
        var mealTypeArray: [String] = []
        var healthArray: [String] = []
        var timeArray: [String] = []
        var cuisinesArrList: [String] = []
        var NuritionArr: [String] = []
        
        mealTypeArray = MealArray.filter { $0.Selcolor }.map { $0.name }
        healthArray = DietArray.filter { $0.Selcolor }.map { $0.value }
        timeArray = CookTimeArray.filter { $0.Selcolor }.map { $0.value }
        cuisinesArrList = CuisinesArray.filter { $0.Selcolor }.map { $0.value }
        NuritionArr = NutritionArray.filter { $0.Selcolor }.map { $0.value }
        
        if comesfrom == "Filter"{
            params["mealType"] = mealTypeArray
            params["health"] = healthArray
            params["time"] = timeArray
            params["cuisineType"] = cuisinesArrList
            params["calories"] = NuritionArr
        }else if comesfrom == "Mealtype"{
            params["mealType"] = Serach
        }else if comesfrom == "PopularCat"{
            params["dishType"] = Serach
        }else{
            params["q"] = Serach
        }
      
        
        showIndicator(withTitle: "", and: "")
        
        let loginURL = baseURL.baseURL + appEndPoints.recipe
        print(params,"Params")
        print(loginURL,"loginURL")
        
        WebService.shared.postServiceMultipart(loginURL, VC: self, andParameter: params, withCompletion: { (json, statusCode) in
            
            self.hideIndicator()
            
            let data = try! json.rawData()
            
            do{
                let d = try JSONDecoder().decode(SearchModelClass.self, from: data)
                if d.success == true {
                    if let list = d.data, list.recipes != nil {
 
                        let allData = list.recipes ?? []
     
                        let uniqueRecipes = Array(
                            Dictionary(grouping: allData) { $0.recipe?.label ?? "" }
                                .values
                                .compactMap { $0.first }
                        )

                        // Assign back to your array if needed
                        self.SearchAllRecipeArr.append(contentsOf: uniqueRecipes)
                        
                        self.hasReachedEnd = false
                        
                        if self.SearchAllRecipeArr.count == 0{
                            self.CollV.setEmptyMessage("No recipe yet.", UIImage())
                        }else{
                            self.CollV.setEmptyMessage("", UIImage())
                        }
                    }
                    
                    self.CollV.reloadData()
                }else{
                    self.SearchAllRecipeArr.removeAll()
                    let msg = d.message ?? ""
                    self.showToast(msg)
                }
            }catch{
                print(error)
            }
        })
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
                self.Api_To_GetAllMealsRecipe(Serach: self.titleTxt)
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
//                    
                    
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

 
