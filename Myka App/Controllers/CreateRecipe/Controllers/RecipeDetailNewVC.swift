//
//  RecipeDetailNewVC.swift
//  My Kai
//
//  Created by YATIN  KALRA on 23/09/25.
//

import UIKit
import Cosmos
import SDWebImage

class RecipeDetailNewVC: UIViewController {

    @IBOutlet weak var ImgV: UIImageView!
    
    @IBOutlet weak var RatingLbl: UILabel!
    @IBOutlet weak var recipeNameLbl: UILabel!
    @IBOutlet weak var recipeDesLbl: UILabel!
    
    
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
    
    @IBOutlet weak var CookwareTblV: UITableView!
    @IBOutlet weak var CookwareTblVH: NSLayoutConstraint!
    @IBOutlet weak var CookwareTblVBgV: UIView!
    
    @IBOutlet weak var recipeTblV: UITableView!
    @IBOutlet weak var recipeTblVH: NSLayoutConstraint!
    @IBOutlet weak var recipeTblVBgV: UIView!
    @IBOutlet weak var recipeBtnsBgV: UIView!
    @IBOutlet weak var authorNoteBgV: UIView!
    @IBOutlet weak var notesTxtV: UITextView!
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
    var CookWareArray = [Cookware]()
    var RecipeInstArr = [String]()
    var selectedIndex = [Int]()
    var currentWeekDates: [Date] = []
    var calendar = Calendar.current
    var uri = ""
    var Id = ""
    var type = ""
    var RecipeDetailsData = [RecipeDetailModel]()
    var MealType = ""
    var backAction:()->() = {}
    var tblVIngredientData : [RecipeDataModel] = []
    var cookwareArr = [RecipeDataModel]()
    var recipeArr = [RecipeDataModel]()
    var recipeFrom = ""
    var sourceUrl = ""
    var conevertType = "O"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.ServCountLbl.text = "\(ServCount) servings"
     
        self.ChoosedaysPopupV.frame = self.view.bounds
        self.view.addSubview(self.ChoosedaysPopupV)
        self.ChoosedaysPopupV.isHidden = true
        
        self.ChooseMealTypePopupV.frame = self.view.bounds
        self.view.addSubview(self.ChooseMealTypePopupV)
        self.ChooseMealTypePopupV.isHidden = true
     
        self.IngredientLbl.backgroundColor = UIColor.init(red: 254/255, green: 159/255, blue: 69/255, alpha: 1)
        self.CookwareLbl.backgroundColor = UIColor.init(red: 255/255, green: 247/255, blue: 240/255, alpha: 1)
        self.DirectionsLbl.backgroundColor = UIColor.init(red: 255/255, green: 247/255, blue: 240/255, alpha: 1)
        
        self.IngredientLbl.textColor = UIColor.white
        self.CookwareLbl.textColor = UIColor.init(red: 60/255, green: 69/255, blue: 65/255, alpha: 1)
        self.DirectionsLbl.textColor = UIColor.init(red: 60/255, green: 69/255, blue: 65/255, alpha: 1)
        
        self.notesTxtV.isUserInteractionEnabled = false
        self.IngredientBgV.isHidden = false
        self.IngredientBtnsBgV.isHidden = false
        
        self.CookwareTblVBgV.isHidden = true
        
        self.recipeTblVBgV.isHidden = true
        self.recipeBtnsBgV.isHidden = true
        
        self.TblV.register(UINib(nibName: "IngredientsTblVCell", bundle: nil), forCellReuseIdentifier: "IngredientsTblVCell")
        self.TblV.delegate = self
        self.TblV.dataSource = self
        
        self.CookwareTblV.register(UINib(nibName: "IngredientsTblVCell", bundle: nil), forCellReuseIdentifier: "IngredientsTblVCell")
        self.CookwareTblV.delegate = self
        self.CookwareTblV.dataSource = self
        
        self.recipeTblV.register(UINib(nibName: "RecipeTblVCell", bundle: nil), forCellReuseIdentifier: "RecipeTblVCell")
        self.recipeTblV.delegate = self
        self.recipeTblV.dataSource = self
        
        calendar.firstWeekday = 2
        setupInitialWeek()
        
        setupTableView()
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        ChoosedaysBgV.addGestureRecognizer(tapGesture)
        
        let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(handleTap1(_:)))
        ChooseMealTypeBgV.addGestureRecognizer(tapGesture1)
        
        NotificationCenter.default.addObserver(self, selector: #selector(listnerFunctionReloadDetails(_:)), name: NSNotification.Name(rawValue: "notificationNameReloadDetails"), object: nil)
        
        self.Api_To_Recipe_Details(uri: uri)
    }
    

    @objc func listnerFunctionReloadDetails(_ notification: NSNotification) {
        if let data = notification.userInfo?["data"] as? String {
            self.Api_To_Recipe_Details(uri: uri)
        }
    }
    
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
        
       
        TblV.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        CookwareTblV.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        recipeTblV.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        ChooseMealTypeTblV.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        
    }
    
  
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize" {
            if let tableView = object as? UITableView {
                if tableView == TblV {
                    TblVH.constant = tableView.contentSize.height
                } else if tableView == CookwareTblV {
                    CookwareTblVH.constant = tableView.contentSize.height
                } else if tableView == recipeTblV {
                    recipeTblVH.constant = tableView.contentSize.height
                } else if tableView == ChooseMealTypeTblV {
                    ChooseMealTypeTblVH.constant = tableView.contentSize.height
                }
            }
        }
    }
    
    deinit {
      
        TblV.removeObserver(self, forKeyPath: "contentSize")
        CookwareTblV.removeObserver(self, forKeyPath: "contentSize")
        recipeTblV.removeObserver(self, forKeyPath: "contentSize")
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
        
        self.CookwareTblVBgV.isHidden = true
        
        self.recipeTblVBgV.isHidden = true
        self.recipeBtnsBgV.isHidden = true
        self.authorNoteBgV.isHidden = false
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
        
        self.CookwareTblVBgV.isHidden = false
        
        self.recipeTblVBgV.isHidden = true
        self.recipeBtnsBgV.isHidden = true
        
        self.authorNoteBgV.isHidden = false
    }
    
    @IBAction func DirectionsBtn(_ sender: UIButton) {
        if recipeFrom == "Import"{
            let storyboard = UIStoryboard(name: "CreateRecipeSB", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "ImportedRecipeWebViewVC") as! ImportedRecipeWebViewVC
            vc.WebUrl = sourceUrl
            vc.backAction = { tabTapped in
                if tabTapped == "Ing"{
                    self.IngredientBtn(UIButton())
                }else{
                    self.CookBtn(UIButton())
                }
            }
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
            
        }else{
            self.IngredientLbl.backgroundColor = UIColor.init(red: 255/255, green: 247/255, blue: 240/255, alpha: 1)
            self.CookwareLbl.backgroundColor = UIColor.init(red: 255/255, green: 247/255, blue: 240/255, alpha: 1)
            self.DirectionsLbl.backgroundColor = UIColor.init(red: 254/255, green: 159/255, blue: 69/255, alpha: 1)
            
            self.IngredientLbl.textColor = UIColor.init(red: 60/255, green: 69/255, blue: 65/255, alpha: 1)
            self.CookwareLbl.textColor = UIColor.init(red: 60/255, green: 69/255, blue: 65/255, alpha: 1)
            self.DirectionsLbl.textColor = UIColor.white
            
            self.IngredientBgV.isHidden = true
            self.IngredientBtnsBgV.isHidden = true
            
            self.CookwareTblVBgV.isHidden = true
            
            self.recipeTblVBgV.isHidden = false
            self.recipeBtnsBgV.isHidden = false
            self.authorNoteBgV.isHidden = true
        }
    }
    
    @IBAction func convertUntiBtn(_ sender: UIButton){
        let sb = UIStoryboard(name: "CreateRecipeSB", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "ConvertUnitPopVC") as! ConvertUnitPopVC
        vc.ingredientData = self.tblVIngredientData
        vc.type = self.conevertType
        vc.backAction = { type, convertedData in
            self.conevertType = type
            let data = convertedData
            var index = 0

            for recipeIndex in self.tblVIngredientData.indices {
                if var ingredients = self.tblVIngredientData[recipeIndex].ingredients {
                    for i in ingredients.indices {
                        if index < data.count {
                            ingredients[i].quantity = data[index].converted
                            ingredients[i].unit = data[index].targetUnit
                            index += 1
                        }
                    }
                    self.tblVIngredientData[recipeIndex].ingredients = ingredients
                    self.TblV.reloadData()
                }
            }
            
        }
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true, completion: nil)
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
        self.ServCountLbl.text = "\(ServCount) servings"
    }
    
    @IBAction func ServCountPlusBtn(_ sender: UIButton) {
        self.ServCount += 1
        
        self.ServCountLbl.text = "\(ServCount) servings"
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
     
        vc.MealType = self.MealType
        vc.RecipeDetailsData = self.RecipeDetailsData 
        vc.RecipeListArr = self.recipeArr
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
        //                currentWeekDates = calculateWeekDates(for:  calendar.date(byAdding: .day, value: -7, to: firstDate)!)
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
// MARK: - UITableViewDelegate & DataSource

extension RecipeDetailNewVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == self.TblV {
            return tblVIngredientData.count
        } else if tableView == self.CookwareTblV {
            return cookwareArr.count
        } else {
            return recipeArr.count
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.TblV {
            guard section < tblVIngredientData.count else { return 0 }
            return tblVIngredientData[section].ingredients?.count ?? 0
        } else if tableView == self.CookwareTblV {
            guard section < cookwareArr.count else { return 0 }
            return cookwareArr[section].cookware?.count ?? 0
        } else {
            guard section < recipeArr.count else { return 0 }
            return recipeArr[section].recipe?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.TblV {
            let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientsTblVCell", for: indexPath) as! IngredientsTblVCell
            
            let section = indexPath.section
            let row = indexPath.row
            
            cell.checkBoxView.isHidden = false
        
            let header = tblVIngredientData[section].hearder ?? ""
            if header.isEmpty{
                cell.type = .normal
            }else{
                cell.type = .withHeader
            }
            if section < tblVIngredientData.count,
               let ingredients = tblVIngredientData[section].ingredients,
               row < ingredients.count {
                let ingredient = ingredients[row]
                cell.ingredientlbl?.text = ingredient.name
                cell.amout_MeasurmentLbl?.text = "\(ingredient.quantity ?? "") \(ingredient.unit ?? "")"
                cell.img.sd_setImage(with: URL(string: ingredient.img ?? ""), placeholderImage: UIImage(named: "NewRec"))
            } else {
                cell.ingredientlbl?.text = ""
                cell.amout_MeasurmentLbl?.text = ""
                cell.img.image = UIImage(named: "NewRec")
            }
            
            cell.checkBoxBtn.tag = row
            cell.checkBoxBtn.addTarget(self, action: #selector(checkIngredientBtn(_:)), for: .touchUpInside)
            if tblVIngredientData[section].ingredients?[row].isSelected == true{
                cell.checkBoxBtn.setImage(UIImage(named: "YellowCheck"), for: .normal)
            }else{
                cell.checkBoxBtn.setImage(UIImage(named: "YelloUncheck"), for: .normal)
            }
            cell.selectionStyle = .none
            return cell
        }else if tableView == CookwareTblV{
            let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientsTblVCell", for: indexPath) as! IngredientsTblVCell
            cell.type = .normal
            cell.checkBoxView.isHidden = true
            let section = indexPath.section
            let row = indexPath.row
            if section < cookwareArr.count,
               let ingredients = cookwareArr[section].cookware,
               row < ingredients.count {
                let ingredient = ingredients[row]
                cell.ingredientlbl?.text = ingredient.name
                cell.img.sd_setImage(with: URL(string: ingredient.img ?? ""), placeholderImage: UIImage(named: "addCook"))
            } else {
                cell.ingredientlbl?.text = ""
                cell.img.image = UIImage(named: "addCook")
            }
            cell.selectionStyle = .none
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeTblVCell", for: indexPath) as! RecipeTblVCell
            let section = indexPath.section
            let row = indexPath.row
            let header = recipeArr[section].hearder ?? ""
            if header.isEmpty{
                cell.type = .normal
                cell.stepLbl.text = "Step - \(section+1)"
            }else{
                cell.type = .withHeader
                cell.stepLbl.text = "Step - \(row+1)"
            }
            
            if section < recipeArr.count,
               let recipes = recipeArr[section].recipe,
               row < recipes.count {
                let recipe = recipes[row]
                cell.recipeLbl?.text = recipe.instruction
               
            } else {
                cell.recipeLbl?.text = ""
                
            }
            cell.selectionStyle = .none

            return cell
        }
//        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView == self.TblV {
            guard section < tblVIngredientData.count else { return nil }
            let title = tblVIngredientData[section].hearder?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            guard !title.isEmpty else { return nil }
            
            let label = UILabel()
            label.text = "   \(title)"
            label.font = UIFont(name: "Poppins-SemiBold", size: 16)
            label.textColor = #colorLiteral(red: 0.2352941176, green: 0.2705882353, blue: 0.2549019608, alpha: 1)
          
            return label
        }else if tableView == recipeTblV{
            guard section < recipeArr.count else { return nil }
            let title = recipeArr[section].hearder?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            guard !title.isEmpty else { return nil }
            
            let label = UILabel()
            label.text = "   \(title)"
            label.font = UIFont.boldSystemFont(ofSize: 18)
            label.textColor = #colorLiteral(red: 0.2352941176, green: 0.2705882353, blue: 0.2549019608, alpha: 1)
          
            return label
        }else{
            guard section < cookwareArr.count else { return nil }
            let title = cookwareArr[section].hearder?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            guard !title.isEmpty else { return nil }
            
            let label = UILabel()
            label.text = "   \(title)"
            label.font = UIFont.boldSystemFont(ofSize: 18)
            label.textColor = #colorLiteral(red: 0.2352941176, green: 0.2705882353, blue: 0.2549019608, alpha: 1)
          
            return label
        }
//        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == self.TblV {
            guard section < tblVIngredientData.count else { return 0 }
            let title = tblVIngredientData[section].hearder?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            return title.isEmpty ? 0 : 40
        }else if tableView == self.recipeTblV{
            guard section < recipeArr.count else { return 0 }
            let title = recipeArr[section].hearder?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            return title.isEmpty ? 0 : 40
        }
        return 0
    }
    
    // After user taps a row's checkbox
    @objc func checkIngredientBtn(_ sender: UIButton) {
        let point = sender.convert(CGPoint.zero, to: TblV)
        
        if let indexPath = TblV.indexPathForRow(at: point) {
            // Toggle selection
            if let isSelected = tblVIngredientData[indexPath.section].ingredients?[indexPath.row].isSelected {
                tblVIngredientData[indexPath.section].ingredients?[indexPath.row].isSelected = !isSelected
            }
            
            // Reload only that row (not the whole table)
            TblV.reloadRows(at: [indexPath], with: .none)
            
            // Now check if all rows in this section are selected
            let allSelected = tblVIngredientData[indexPath.section].ingredients?.allSatisfy { $0.isSelected ?? false } ?? false
            
            // Update your "Select All" button state
            SelectAllBtnO.isSelected = allSelected
        }
    }
    
}
extension RecipeDetailNewVC {
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


extension RecipeDetailNewVC{
    func Api_To_Recipe_Details(uri: String){
        var params = [String: Any]()
        
        params["uri"] = uri
        params["id"] = Id
        params["type"] = type
        params["servings"] = "\(ServCount)"
        
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
                        
                        self.recipeFrom = val?.createdType ?? ""
                        self.sourceUrl = val?.source_url ?? ""
                        
                        self.recipeNameLbl.text = val?.label ?? ""
                        self.recipeDesLbl.text = val?.source ?? ""
                        let review = self.RecipeDetailsData.first?.review ?? 0
                        let reviewNum = self.RecipeDetailsData.first?.review_number ?? 0
                        self.RatingLbl.text = "\(review)(\(reviewNum))"
                        let roundedReview = Double(round(10 * review) / 10.0)
//                        self.RatingView.rating = roundedReview
                        
                        let img  = val?.images?.large?.url
                        let imgUrl = URL(string: img ?? "")
                        self.ImgV.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
                        self.ImgV.sd_setImage(with: imgUrl, placeholderImage: UIImage(named: "No_Image"))
                        
//                        self.ImgDesc.text = val?.label ?? ""
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
                        self.PrepTimeLbl.text = "\(val?.prep_time ?? 0) min"
                        let ingredients = val?.ingredients
                        
                        if let ingredients = val?.ingredients {
                            for ingredient in ingredients {
                                var header = ingredient.header
                                if header == "Recipe"{
                                    header = ""
                                }
                                self.addIngredient(Header: header, data: IngredientDataModel(name: ingredient.name, quantity: ingredient.quantity, unit: ingredient.measure, img: ingredient.image,isSelected: true))
                            }
                        }
                        
                        if let cookwares = val?.cookware {
                            for cookware in cookwares {
                                self.addCookware(data: CookwareDataModel(name: cookware.name,img: cookware.imageURL))
                            }
                        }
                        
                        if let instructions = val?.instructions {
                            for instruction in instructions {
                                var header = instruction.stepsHeaders
                                if header == "Recipe"{
                                    header = ""
                                }
                                self.addRecipe(Header: header, data: StepsDataModel(instruction: instruction.text))
                            }
                        }
                        self.SelectAllBtnO.isSelected = true
                        
                        self.notesTxtV.text = val?.description
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
                let dictionary1: [String: String] = ["name": recipesArray[i].name, "image": recipesArray[i].image, "food": recipesArray[i].food, "quantity": recipesArray[i].Quantity,"ingredient_cost": recipesArray[i].ingredient_cost, "foodCategory": recipesArray[i].foodCategory, "measure": recipesArray[i].measure, "food_id": recipesArray[i].foodID, "status": "0"]
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
extension RecipeDetailNewVC{
    func addIngredient(Header:String?,data:IngredientDataModel) {
       
        let ingredientName = data.name?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        var amountText = ""
        if let amountValue = Double(data.quantity ?? "") {
            let truncated = floor(amountValue * 10) / 10
            let formattedAmount = String(format: "%.1f", truncated)
            amountText = formattedAmount.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        let unitText = data.unit?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let imgStr = data.img?.trimmingCharacters(in: .whitespacesAndNewlines)
        let headerText = Header?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
     

        if  ingredientName.isEmpty || amountText.isEmpty || unitText.isEmpty {
            return
        }
        
        let ingredient = IngredientDataModel(
            name: ingredientName,
            quantity: amountText,
            unit: unitText,
            img: imgStr,
            isSelected: true
        )

        DispatchQueue.main.async {
            if headerText.isEmpty {
                let data = RecipeDataModel(hearder: "", ingredients: [ingredient])
                self.tblVIngredientData.append(data)
            } else {
                if let existingIndex = self.tblVIngredientData.firstIndex(where: {
                    ($0.hearder ?? "").trimmingCharacters(in: .whitespacesAndNewlines).caseInsensitiveCompare(headerText) == .orderedSame
                }) {
                    if self.tblVIngredientData[existingIndex].ingredients == nil {
                        self.tblVIngredientData[existingIndex].ingredients = [ingredient]
                    } else {
                        self.tblVIngredientData[existingIndex].ingredients?.append(ingredient)
                    }
                } else {
                    let data = RecipeDataModel(hearder: headerText, ingredients: [ingredient])
                    self.tblVIngredientData.append(data)
                }
            }
          
            self.TblV.reloadData()
        }
    }
    
    func addCookware(data:CookwareDataModel) {
       
        let cookwareName =  data.name?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
//        let amountText = addIngredientAmoutTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
//        let unitText = addIngredientMesurementTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let imgStr = data.img?.trimmingCharacters(in: .whitespacesAndNewlines)
        let headerText = ""
     
        if  cookwareName.isEmpty {
            return
        }
        
        let ingredient = IngredientDataModel(
            name: cookwareName,
            unit: "",
            img: imgStr
        )

        DispatchQueue.main.async {
            if headerText.isEmpty {
                let data = RecipeDataModel(hearder: "", cookware: [ingredient])
                self.cookwareArr.append(data)
            } else {
                if let existingIndex = self.cookwareArr.firstIndex(where: {
                    ($0.hearder ?? "").trimmingCharacters(in: .whitespacesAndNewlines).caseInsensitiveCompare(headerText) == .orderedSame
                }) {
                    if self.cookwareArr[existingIndex].cookware == nil {
                        self.cookwareArr[existingIndex].cookware = [ingredient]
                    } else {
                        self.cookwareArr[existingIndex].cookware?.append(ingredient)
                    }
                } else {
                    let data = RecipeDataModel(hearder: headerText, cookware: [ingredient])
                    self.cookwareArr.append(data)
                }
            }
            print("cookwareArr count: \(self.cookwareArr.count)")
           
            self.CookwareTblV.reloadData()
        }
    }
    
    func addRecipe(Header: String?,data:StepsDataModel) {
        
        let recipeName = data.instruction?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
     
        let headerText = Header?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
     
        if  recipeName.isEmpty  {
            return
        }
        
        let recipe = StepsDataModel(instruction: recipeName)

        DispatchQueue.main.async {
            if headerText.isEmpty {
                let data = RecipeDataModel(hearder: "", recipe: [recipe])
                self.recipeArr.append(data)
            } else {
                if let existingIndex = self.recipeArr.firstIndex(where: {
                    ($0.hearder ?? "").trimmingCharacters(in: .whitespacesAndNewlines).caseInsensitiveCompare(headerText) == .orderedSame
                }) {
                    if self.recipeArr[existingIndex].recipe == nil {
                        self.recipeArr[existingIndex].recipe = [recipe]
                    } else {
                        self.recipeArr[existingIndex].recipe?.append(recipe)
                    }
                } else {
                    let data = RecipeDataModel(hearder: headerText, recipe: [recipe])
                    self.recipeArr.append(data)
                }
            }
//            print("recipeArr count: \(self.recipeArr)")
          

           
            self.recipeTblV.reloadData()
        }
    }
}
