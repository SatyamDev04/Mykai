//
//  RecipeDetailNewVC.swift
//  My Kai
//
//  Created by YATIN  KALRA on 23/09/25.
//

import UIKit
import Cosmos
import SDWebImage
import SkeletonView

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
    
    // for ChooseMealType popup
    
    @IBOutlet var ChooseMealTypePopupV: UIView!
    @IBOutlet weak var ChooseMealTypeTblV: UITableView!
    @IBOutlet weak var ChooseMealTypeTblVH: NSLayoutConstraint!
    @IBOutlet weak var ChooseMealTypeBgV: UIView!
    @IBOutlet weak var ScrollV: UIScrollView!
   
    var ServCount = 1
    var ChooseDayData = [BodyGoalsModel(Name: "Monday", isSelected: false), BodyGoalsModel(Name: "Tuesday", isSelected: false), BodyGoalsModel(Name: "Wednesday", isSelected: false), BodyGoalsModel(Name: "Thursday", isSelected: false), BodyGoalsModel(Name: "Friday", isSelected: false), BodyGoalsModel(Name: "Saturday", isSelected: false), BodyGoalsModel(Name: "Sunday", isSelected: false)]
    
    var ChooseMealTypeyData = [BodyGoalsModel(Name: "Breakfast", isSelected: false),BodyGoalsModel(Name: "Brunch", isSelected: false), BodyGoalsModel(Name: "Lunch", isSelected: false), BodyGoalsModel(Name: "Dinner", isSelected: false), BodyGoalsModel(Name: "Snacks", isSelected: false), BodyGoalsModel(Name: "Dessert", isSelected: false)]
    
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
    var inerServing = 1
    private var baseIngredientData: [RecipeDataModel] = []
    private var isLoadingRecipeDetails = false
    private let loadingIngredientRowCount = 5
    private let loadingCookwareRowCount = 3
    private let loadingDirectionRowCount = 4

    private var recipeDetailSkeletonViews: [UIView] {
        [
            ImgV,
            RatingLbl,
            recipeNameLbl,
            recipeDesLbl,
            Calorieslbl,
            FatLbl,
            CarbsLbl,
            ProtienLbl,
            TotalTimeLbl,
            PrepTimeLbl,
            ServCountLbl,
            notesTxtV
        ]
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.ServCountLbl.text = "\(ServCount * inerServing) servings"
     
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
        
        configureSkeletonAppearance()
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

    private func configureSkeletonAppearance() {
        ImgV.isSkeletonable = true
        RatingLbl.isSkeletonable = true
        recipeNameLbl.isSkeletonable = true
        recipeNameLbl.linesCornerRadius = 6
        recipeNameLbl.skeletonTextNumberOfLines = 2
        recipeDesLbl.isSkeletonable = true
        recipeDesLbl.linesCornerRadius = 4
        //Calorieslbl.isSkeletonable = true
        FatLbl.isSkeletonable = true
        CarbsLbl.isSkeletonable = true
      //  ProtienLbl.isSkeletonable = true
        TotalTimeLbl.isSkeletonable = true
        PrepTimeLbl.isSkeletonable = true
        ServCountLbl.isSkeletonable = true
        notesTxtV.isSkeletonable = true
        notesTxtV.layer.cornerRadius = 12
        notesTxtV.clipsToBounds = true
    }

    private func setRecipeDetailSkeletonVisible(_ visible: Bool) {
        view.layoutIfNeeded()
        ImgV.layoutIfNeeded()

        if visible {
            ImgV.image = nil
            RatingLbl.text = " "
            recipeNameLbl.text = " "
            recipeDesLbl.text = " "
            Calorieslbl.text = " "
            FatLbl.text = " "
            CarbsLbl.text = " "
            ProtienLbl.text = " "
            TotalTimeLbl.text = " "
            PrepTimeLbl.text = " "
            ServCountLbl.text = " "
            notesTxtV.text = " "
            recipeDetailSkeletonViews.forEach { $0.showAnimatedGradientSkeleton() }
        } else {
            recipeDetailSkeletonViews.forEach {
                $0.stopSkeletonAnimation()
                $0.hideSkeleton(reloadDataAfter: false)
            }
        }
    }

    private func beginRecipeDetailLoading() {
        isLoadingRecipeDetails = true
        TblV.reloadData()
        CookwareTblV.reloadData()
        recipeTblV.reloadData()
        setRecipeDetailSkeletonVisible(true)
    }

    private func endRecipeDetailLoading() {
        isLoadingRecipeDetails = false
        setRecipeDetailSkeletonVisible(false)
        TblV.reloadData()
        CookwareTblV.reloadData()
        recipeTblV.reloadData()
    }

    private func populateRecipeSummaryFields(from recipe: RecipeDetail?, detail: RecipeDetailModel?) {
        recipeFrom = recipe?.createdType ?? ""
        sourceUrl = recipe?.source_url ?? ""
        ServCount = Int(detail?.servings?.stringValue() ?? "1") ?? 1

        let innerServing = Int(recipe?.servings?.stringValue() ?? "1") ?? 1
        inerServing = innerServing
        let outerServing = Int(detail?.servings?.stringValue() ?? "1") ?? 1

        ServCountLbl.text = "\(innerServing * outerServing) servings"
        recipeNameLbl.text = recipe?.label ?? ""
        recipeDesLbl.text = recipe?.source ?? ""

        let review = detail?.review ?? 0
        let reviewNum = detail?.review_number ?? 0
        RatingLbl.text = "\(review)(\(reviewNum))"

        let img = recipe?.images?.small?.url
        let imgUrl = URL(string: img ?? "")
        ImgV.setRemoteImage(imgUrl, placeholder: UIImage(named: "No_Image"))

        let carbs = recipe?.totalNutrients?.first(where: { $0.key == "CHOCDF" })
        CarbsLbl.text = "\(Int(carbs?.value.quantity ?? 0))g"

        let fat = recipe?.totalNutrients?.first(where: { $0.key == "FAT" })
        FatLbl.text = "\(Int(fat?.value.quantity ?? 0))g"

        let protein = recipe?.totalNutrients?.first(where: { $0.key == "PROCNT" })
        ProtienLbl.text = "\(Int(protein?.value.quantity ?? 0))g"

        let calories = recipe?.calories ?? 0
        Calorieslbl.text = "\(Int(calories))"

        TotalTimeLbl.text = "\(recipe?.totalTime ?? 0) min"
        PrepTimeLbl.text = "\(recipe?.prep_time ?? 0) min"
        notesTxtV.text = recipe?.description
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
        if recipeFrom.lowercased() == "import"{
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
        self.ServCountLbl.text = "\(ServCount * inerServing) servings"
        updateQuantitiesForServing()
    }
    
    @IBAction func ServCountPlusBtn(_ sender: UIButton) {
        self.ServCount += 1
        
        self.ServCountLbl.text = "\(ServCount * inerServing) servings"
        updateQuantitiesForServing()
    }
    
    @IBAction func AddToPlanBtn(_ sender: UIButton) {
        self.ChoosedaysPopupV.isHidden = false
    }
    
    @IBAction func AddToBasketBtn(_ sender: UIButton) {

        let selectedIngredients = tblVIngredientData
            .flatMap { $0.ingredients ?? [] }
            .filter { $0.isSelected ?? false }

        guard !selectedIngredients.isEmpty else {
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
        if tableView == ChoosedaysTblV {
            return 1
        }else if tableView == ChooseMealTypeTblV{
            return 1
        }else if isLoadingRecipeDetails {
            return 1
        }else if tableView == self.TblV {
            return tblVIngredientData.count
        } else if tableView == self.CookwareTblV {
            return cookwareArr.count
        } else {
            return recipeArr.count
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == ChoosedaysTblV {
            return ChooseDayData.count
        }else if tableView == ChooseMealTypeTblV{
            return ChooseMealTypeyData.count
        }else if isLoadingRecipeDetails {
            if tableView == TblV {
                return loadingIngredientRowCount
            } else if tableView == CookwareTblV {
                return loadingCookwareRowCount
            } else if tableView == recipeTblV {
                return loadingDirectionRowCount
            }
            return 0
        }else if tableView == self.TblV {
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
        }else if tableView == self.TblV {
            let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientsTblVCell", for: indexPath) as! IngredientsTblVCell
            if isLoadingRecipeDetails {
                cell.type = .normal
                cell.checkBoxView.isHidden = false
                cell.setLoading(true)
                cell.selectionStyle = .none
                return cell
            }
            cell.setLoading(false)
            
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
                cell.img.setRemoteImage(URL(string: ingredient.img ?? ""), placeholder: UIImage(named: "NewRec"))
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
            if isLoadingRecipeDetails {
                cell.type = .normal
                cell.checkBoxView.isHidden = true
                cell.setLoading(true)
                cell.selectionStyle = .none
                return cell
            }
            cell.setLoading(false)
            cell.type = .normal
            cell.checkBoxView.isHidden = true
            let section = indexPath.section
            let row = indexPath.row
            if section < cookwareArr.count,
               let ingredients = cookwareArr[section].cookware,
               row < ingredients.count {
                let ingredient = ingredients[row]
                cell.ingredientlbl?.text = ingredient.name
                cell.img.setRemoteImage(URL(string: ingredient.img ?? ""), placeholder: UIImage(named: "addCook"))
            } else {
                cell.ingredientlbl?.text = ""
                cell.img.image = UIImage(named: "addCook")
            }
            cell.selectionStyle = .none
            return cell
        }else{
            let cell = recipeTblV.dequeueReusableCell(withIdentifier: "RecipeTblVCell", for: indexPath) as! RecipeTblVCell
            if isLoadingRecipeDetails {
                cell.type = .normal
                cell.setLoading(true)
                cell.selectionStyle = .none
                return cell
            }
            cell.setLoading(false)
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
        guard !isLoadingRecipeDetails else { return }
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
        return 75
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard !isLoadingRecipeDetails else { return nil }
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
        guard !isLoadingRecipeDetails else { return 0 }
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

        self.beginRecipeDetailLoading()
        
        let loginURL = baseURL.baseURL + appEndPoints.get_recipe
        print(params,"Params")
        print(loginURL,"loginURL")
        
        WebService.shared.postServiceURLEncoding(loginURL, VC: self, andParameter: params, withCompletion: { (json, statusCode) in
            let data = try! json.rawData()
            
            do{
                let d = try JSONDecoder().decode(RecipeDetailModelClass.self, from: data)
                if d.success == true {
                    if let list = d.data, list.first?.recipe != nil {
                        DispatchQueue.main.async {
                            self.tblVIngredientData.removeAll()
                            self.baseIngredientData.removeAll()
                            self.cookwareArr.removeAll()
                            self.recipeArr.removeAll()
                            self.RecipeDetailsData = d.data ?? []
                            
                            let val = self.RecipeDetailsData.first?.recipe
                            
                            if let ingredients = val?.ingredients {
                                for ingredient in ingredients {
                                    var header = ingredient.header
                                    if header == "Recipe" {
                                        header = ""
                                    }

                                    let imageValue = (ingredient.imageURL ?? "").isEmpty
                                        ? ingredient.image
                                        : ingredient.imageURL

                                    var ingredientModel = IngredientDataModel(
                                        name: ingredient.name,
                                        quantity: ingredient.quantity?.stringValue(),
                                        unit: ingredient.measure,
                                        img: imageValue,
                                        isSelected: true
                                    )

                                    ingredientModel.food = ingredient.food
                                    ingredientModel.foodCategory = ingredient.category
                                    ingredientModel.id = ingredient.id
                                    ingredientModel.ingredient_cost = ingredient.ingredientCost
                                    ingredientModel.measure = ingredient.measure

                                    self.addIngredient(Header: header, data: ingredientModel)
                                }
                            }

                            self.baseIngredientData = self.tblVIngredientData

                            if let cookwares = val?.cookware {
                                for cookware in cookwares {
                                    self.addCookware(data: CookwareDataModel(name: cookware.name, img: cookware.imageURL))
                                }
                            }
                            
                            if let instructions = val?.instructions {
                                for instruction in instructions {
                                    var header = instruction.stepsHeaders
                                    if header == "Recipe" {
                                        header = ""
                                    }
                                    self.addRecipe(Header: header, data: StepsDataModel(instruction: instruction.text))
                                }
                            }

                            self.SelectAllBtnO.isSelected = true
                            self.endRecipeDetailLoading()
                            self.populateRecipeSummaryFields(from: val, detail: self.RecipeDetailsData.first)
                        }
                    }
                }else{
                    DispatchQueue.main.async {
                        self.endRecipeDetailLoading()
                        let msg = d.message ?? ""
                        self.showToast(msg)
                    }
                }
            }catch{
                DispatchQueue.main.async {
                    self.endRecipeDetailLoading()
                    print(error)
                }
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

        let selectedIngredients =
            tblVIngredientData
                .flatMap { $0.ingredients ?? [] }
                .filter { $0.isSelected ?? false }

        guard !selectedIngredients.isEmpty else {
            AlertControllerOnr(title: "", message: "Please select atleast one ingredients.")
            return
        }

        var jsonArray: [[String: Any]] = []

        for item in selectedIngredients {

            // ---- CLEAN IMAGE STRING ----
            var cleanImage = (item.image ?? item.img ?? "")
            cleanImage = cleanImage
                .replacingOccurrences(of: "%22", with: "")
                .replacingOccurrences(of: "\"", with: "")
                .trimmingCharacters(in: .whitespacesAndNewlines)

            // ---- CONVERT QUANTITY TO NUMBER ----
            let quantityValue = Double(item.quantity ?? "") ?? 0

            // ---- SKIP INVALID INGREDIENT ----
            let nameValue = (item.name ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
            if nameValue.isEmpty { continue }

            let dict: [String: Any] = [
                "name": nameValue,
                "image": cleanImage,
                "food": item.food ?? "",
                "quantity": quantityValue,
                "ingredient_cost": item.ingredient_cost ?? "",
                "foodCategory": item.foodCategory ?? "",
                "measure": item.measure ?? "",
                "food_id": item.id ?? "",
                "status": "0"
            ]

            jsonArray.append(dict)
        }

        guard !jsonArray.isEmpty else {
            AlertControllerOnr(title: "", message: "No valid ingredients to add.")
            return
        }

        let paramsDict: [String: Any] = [
            "ingredients": jsonArray,     // flat array (NOT nested)
            "serving": self.ServCount,
            "uri": self.uri,
            "type": self.MealType
        ]

        // ---- VALIDATE JSON BEFORE SENDING ----
        guard JSONSerialization.isValidJSONObject(paramsDict) else {
            print("❌ Invalid JSON payload")
            return
        }

        // ---- DEBUG PRINT (VERY IMPORTANT) ----
        if let debugData = try? JSONSerialization.data(withJSONObject: paramsDict, options: .prettyPrinted),
           let debugString = String(data: debugData, encoding: .utf8) {
            print("\n✅ FINAL ADD TO BASKET JSON:\n", debugString)
        }

        showIndicator(withTitle: "", and: "")

        let loginURL = baseURL.baseURL + appEndPoints.ingredient_basket

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
        } else {
            print("Failed to encode JSON.")
            self.hideIndicator()
            self.showToast("An error occurred while preparing the request.")
        }
    }
}

extension RecipeDetailNewVC{
    func addIngredient(Header: String?, data: IngredientDataModel) {
        
        let ingredientName = data.name?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let headerText = Header?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let imgStr = data.img?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard let baseQty = Double(data.quantity ?? "") else { return }
        
        // base unit clean
        var unitText = data.unit?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        if unitText.lowercased() == "each" {
            unitText = ""
        }
        
        // ---------- BASE INGREDIENT (original quantity) ----------
        var baseIngredient = IngredientDataModel(
            name: ingredientName,
            quantity: formatQuantity(baseQty),   // original
            unit: unitText,
            img: imgStr,
            isSelected: true
        )
        // ---- COPY FULL META ----
        baseIngredient.food = data.food
        baseIngredient.foodCategory = data.foodCategory
        baseIngredient.id = data.id
        baseIngredient.ingredient_cost = data.ingredient_cost
        baseIngredient.measure = data.measure
        
        // ---------- DISPLAY INGREDIENT (serving applied) ----------
        let finalQty = baseQty * Double(ServCount)
        
        var displayIngredient = IngredientDataModel(
            name: ingredientName,
            quantity: formatQuantity(finalQty),
            unit: unitText,
            img: imgStr,
            isSelected: true
        )
        // ---- COPY FULL META ----
        displayIngredient.food = data.food
        displayIngredient.foodCategory = data.foodCategory
        displayIngredient.id = data.id
        displayIngredient.ingredient_cost = data.ingredient_cost
        displayIngredient.measure = data.measure
        
        DispatchQueue.main.async {
            
            // ---------- STORE IN BASE ----------
            self.appendIngredient(baseIngredient, header: headerText, to: &self.baseIngredientData)
            
            // ---------- STORE IN DISPLAY ----------
            self.appendIngredient(displayIngredient, header: headerText, to: &self.tblVIngredientData)
            
            self.TblV.reloadData()
        }
    }
    
    private func appendIngredient(
        _ ingredient: IngredientDataModel,
        header: String,
        to array: inout [RecipeDataModel]
    ) {
        
        if header.isEmpty {
            array.append(RecipeDataModel(hearder: "", ingredients: [ingredient]))
            return
        }
        
        if let index = array.firstIndex(where: {
            ($0.hearder ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
                .caseInsensitiveCompare(header) == .orderedSame
        }) {
            array[index].ingredients?.append(ingredient)
        } else {
            array.append(RecipeDataModel(hearder: header, ingredients: [ingredient]))
        }
    }
    func updateQuantitiesForServing() {
        
        tblVIngredientData.removeAll()
        
        for section in baseIngredientData {
            
            var updatedIngredients: [IngredientDataModel] = []
            
            for ingredient in section.ingredients ?? [] {
                
                guard let baseQty = Double(ingredient.quantity ?? "") else {
                    updatedIngredients.append(ingredient)
                    continue
                }
                
                let newQty = baseQty * Double(ServCount)
                
                var updatedIngredient = ingredient
                updatedIngredient.quantity = formatQuantity(newQty)
                
                // remove each
                if updatedIngredient.unit?.lowercased() == "each" {
                    updatedIngredient.unit = ""
                }
                
                updatedIngredients.append(updatedIngredient)
            }
            
            let updatedSection = RecipeDataModel(
                hearder: section.hearder,
                ingredients: updatedIngredients
            )
            
            tblVIngredientData.append(updatedSection)
        }
        
        TblV.reloadData()
    }
    private func formatQuantity(_ value: Double) -> String {
        if value.truncatingRemainder(dividingBy: 1) == 0 {
            return String(Int(value))   // 2.0 → 2
        } else {
            return String(format: "%.2f", value)  // 2.5 → 2.50
                .replacingOccurrences(of: #"0+$"#, with: "", options: .regularExpression)
                .replacingOccurrences(of: #"\.$"#, with: "", options: .regularExpression)
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
