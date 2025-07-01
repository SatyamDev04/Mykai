//
//  FullCookingScheduleVC.swift
//  Myka App
//
//  Created by YES IT Labs on 04/12/24.
//

import UIKit
import Alamofire
import SDWebImage

class FullCookingScheduleVC: UIViewController {
    
    @IBOutlet weak var NameLbl: UILabel!
    @IBOutlet weak var FromDateToLbl: UILabel!
    @IBOutlet weak var CalanderCollV: UICollectionView!
    @IBOutlet weak var weekLabel: UILabel!
    @IBOutlet weak var BreakFastCollV: UICollectionView!
    @IBOutlet weak var LunchCollV: UICollectionView!
    @IBOutlet weak var DinnerCollV: UICollectionView!
    @IBOutlet weak var SnacksCollV: UICollectionView!
    @IBOutlet weak var TeatimeCollV: UICollectionView!
    @IBOutlet weak var BgV: UIView!
    @IBOutlet var RemovePopupV: UIView!
    @IBOutlet weak var ScrollV: UIScrollView!
    
    @IBOutlet weak var BreakFastBgV: UIView!
    @IBOutlet weak var LunchBgV: UIView!
    @IBOutlet weak var DinnerBgV: UIView!
    @IBOutlet weak var SnacksBgV: UIView!
    @IBOutlet weak var TeatimeBgV: UIView!
    
    @IBOutlet weak var Change_cooking_ScheduleBtnO: UIButton!
    
    @IBOutlet weak var NoOrderLbl: UILabel!
    
    @IBOutlet var DragDropRemoveDayPopUpV: UIView!
    
    
    var Mealtypeclicked: String = ""
    var MealtypeSelectedIndex = 0
    //
    
    var currentWeekDates: [Date] = []
    var calendar = Calendar.current
    
    var selectedIndex: IndexPath? // for calander
    
    var seldate = Date()
    var Prevseldate = Date()
    
    var longPressedEnabled = false
    
    
    var AllDataList = YourCookedMealModel() // for by date Api data
    
    var selID = ""
    var selItem = ""
    var CollVType: String = ""
    
    var veryFirstLoading = 0
    
    var DragItemDate: String = ""
    
    var tag = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.RemovePopupV.frame = self.view.bounds
        self.view.addSubview(self.RemovePopupV)
        self.RemovePopupV.isHidden = true
        
        self.DragDropRemoveDayPopUpV.frame = self.view.bounds
        self.view.addSubview(self.DragDropRemoveDayPopUpV)
        self.DragDropRemoveDayPopUpV.isHidden = true
        
        self.NoOrderLbl.isHidden = true
        
        ScrollV.delegate = self
        
        self.Change_cooking_ScheduleBtnO .isUserInteractionEnabled = false
        self.Change_cooking_ScheduleBtnO.backgroundColor = UIColor.lightGray
        
        StateMangerModelClass.shared.tg = "1"
        
        calendar.firstWeekday = 2 // Start the week on Monday
        setupInitialWeek()
        setupCollectionView()
        
        
        addLongPressGestureToView()
        
        //            // Add a tap gesture recognizer to dismiss long press mode
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapAnywhere(_:)))
        tapGesture.cancelsTouchesInView = false // Allows other views to receive touch events
        self.view.addGestureRecognizer(tapGesture)
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        planService.shared.Api_To_Get_ProfileData(vc: self) { result in
            
            switch result {
            case .success(let allData):
                let response = allData
                
                let Name = response?["name"] as? String ?? String()
                
                if Name != ""{
                    self.NameLbl.text = "\(Name.capitalizedFirst)'s week"
                }
            case .failure(let error):
                // Handle error
                print("Error retrieving data: \(error.localizedDescription)")
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1){
            self.Api_To_GetAllRecipeByDate()
        }
        if  StateMangerModelClass.shared.subs == "1"{
            
        }
    }
    
    func addLongPressGestureToView() {
        // Add a tap gesture recognizer to dismiss long press mode
        let tapGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.longTap(_:)))
        tapGesture.cancelsTouchesInView = false // Allows other views to receive touch events
        self.view.addGestureRecognizer(tapGesture)
        
    }
    
    private func setupInitialWeek() {
        let today = Date()
        currentWeekDates = calculateWeekDates(for: today)
        updateWeekLabel()
        //
       // selectCurrentDate()
        //
    }
    
    private func setupCollectionView() {
        CalanderCollV.delegate = self
        CalanderCollV.dataSource = self
        CalanderCollV.register(UINib(nibName: "CalendarCell", bundle: nil), forCellWithReuseIdentifier: "CalendarCell")
        CalanderCollV.dropDelegate = self
        
        BreakFastCollV.register(UINib(nibName: "BrealFLunchDinnerCollV", bundle: nil), forCellWithReuseIdentifier: "BrealFLunchDinnerCollV")
        
        LunchCollV.register(UINib(nibName: "BrealFLunchDinnerCollV", bundle: nil), forCellWithReuseIdentifier: "BrealFLunchDinnerCollV")
        
        DinnerCollV.register(UINib(nibName: "BrealFLunchDinnerCollV", bundle: nil), forCellWithReuseIdentifier: "BrealFLunchDinnerCollV")
        
        SnacksCollV.register(UINib(nibName: "BrealFLunchDinnerCollV", bundle: nil), forCellWithReuseIdentifier: "BrealFLunchDinnerCollV")
        
        TeatimeCollV.register(UINib(nibName: "BrealFLunchDinnerCollV", bundle: nil), forCellWithReuseIdentifier: "BrealFLunchDinnerCollV")
        
        setupCollectionView(collectionView: BreakFastCollV)
        setupCollectionView(collectionView: LunchCollV)
        setupCollectionView(collectionView: DinnerCollV)
        setupCollectionView(collectionView: SnacksCollV)
        setupCollectionView(collectionView: TeatimeCollV)
    }
    
    func setupCollectionView(collectionView: UICollectionView) {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.dragDelegate = self
        collectionView.dropDelegate = self
        collectionView.dragInteractionEnabled = false
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
    
    func setupCurrentWeek() {
        let today = Date()
        currentWeekDates = calculateWeekDates(for: today)
        updateWeekLabel()
        CalanderCollV.reloadData()
    }
    
    
    @objc func longTap(_ gesture: UIGestureRecognizer) {
        let collectionViews: [UICollectionView] = [BreakFastCollV, LunchCollV, DinnerCollV, SnacksCollV, TeatimeCollV]
        
        // Handle different states of the gesture
        switch gesture.state {
        case .began:
            // Loop through all collection views
            for collectionView in collectionViews {
                let touchLocation = gesture.location(in: collectionView)
                
                // Check if the touch is inside a collection view item
                if let selectedIndexPath = collectionView.indexPathForItem(at: touchLocation) {
                    collectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
                    longPressedEnabled = true
                    startJiggleAnimationForAllCollectionViews() // Trigger jiggle animation on all collection views
                    return // Exit once we start interactive movement
                }
            }
            
            // If touch is not on a collection view item, check if it's on the view
            if !collectionViews.contains(where: { $0.bounds.contains(gesture.location(in: $0)) }) {
                // Gesture recognized outside of collection views (on self.view or other UI elements)
                // You can trigger actions here, such as stopping animations or other UI changes
                print("Long tap outside of collection views.")
                longPressedEnabled = true
                startJiggleAnimationForAllCollectionViews() // Trigger jiggle animation on all collection views
            }
        case .changed:
            // Update the interactive movement position for all collection views
            for collectionView in collectionViews {
                let touchLocation = gesture.location(in: collectionView)
                collectionView.updateInteractiveMovementTargetPosition(touchLocation)
            }
            
        case .ended:
            // End interactive movement for all collection views
            for collectionView in collectionViews {
                collectionView.endInteractiveMovement()
            }
            
        default:
            // Cancel interactive movement if gesture state is not recognized
            for collectionView in collectionViews {
                collectionView.cancelInteractiveMovement()
            }
        }
    }
    
    
    func startJiggleAnimationForAllCollectionViews() {
        let collectionViews = [BreakFastCollV, LunchCollV, DinnerCollV, SnacksCollV, TeatimeCollV]
        
        for collectionView in collectionViews {
            collectionView?.dragInteractionEnabled = true
            collectionView?.reloadData()
        }
    }
    
    
    // to stop jiggle
    @objc func tapAnywhere(_ gesture: UITapGestureRecognizer) {
        if longPressedEnabled {
            let collectionViews = [BreakFastCollV, LunchCollV, DinnerCollV, SnacksCollV, TeatimeCollV]
            var touchedInsideRemoveButton = false
            
            for collectionView in collectionViews {
                let touchLocation = gesture.location(in: collectionView)
                if let indexPath = collectionView?.indexPathForItem(at: touchLocation),
                   let cell = collectionView?.cellForItem(at: indexPath) as? BrealFLunchDinnerCollV {
                    if cell.removeBtn.frame.contains(touchLocation) {
                        touchedInsideRemoveButton = true
                        break
                    }
                }
            }
            
            if !touchedInsideRemoveButton {
                longPressedEnabled = false
                stopJiggleAnimationForAllCollectionViews()
            }
        }
    }
    
    func stopJiggleAnimationForAllCollectionViews() {
        let collectionViews = [BreakFastCollV, LunchCollV, DinnerCollV, SnacksCollV, TeatimeCollV]
        for collectionView in collectionViews {
            collectionView?.dragInteractionEnabled = false
            collectionView?.reloadData()
        }
    }
    
    @IBAction func BackBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
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
    
    
    //RemovePopUpView Btn
    @IBAction func RemovePopUpNoBtn(_ sender: UIButton) {
        self.RemovePopupV.isHidden = true
    }
    
    @IBAction func RemovePopUpYesBtn(_ sender: UIButton) {
        self.Api_To_RemoveMeal()
    }
    
    
    @IBAction func Change_Cooking_ScheduleBtn(_ sender: UIButton) {
        self.DragDropRemoveDayPopUpV.isHidden = false
        //        if selItem.contains(s: "http"){
        //            self.Api_For_AddToPlan()
        //        }else{
        //            self.Api_For_update_meal(id: selItem, date: seldate)
        //        }
    }
    
    // For darg drop popup Btns.
    @IBAction func darg_drop_popupNoBtn(_ sender: UIButton) {
        self.DragDropRemoveDayPopUpV.isHidden = true
        self.Change_cooking_ScheduleBtnO .isUserInteractionEnabled = false
        self.Change_cooking_ScheduleBtnO.backgroundColor = UIColor.lightGray
        
        seldate = Prevseldate
        
        // to unSelect All Cell Index.
        for i in 0..<self.currentWeekDates.count{
            let currentCell = self.CalanderCollV.cellForItem(at: IndexPath(item: i, section: 0)) as? CalendarCell
            currentCell?.updateSelection(isSelected: false)
        }
        //
        
        self.selectPrevSelectedDate()
    }
    
    private func selectPrevSelectedDate() {
        let today = self.Prevseldate
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
    
    
    @IBAction func darg_drop_popupYesBtn(_ sender: UIButton) {
        self.DragDropRemoveDayPopUpV.isHidden = true
        if selItem.contains(s: "http"){
            self.Api_For_AddToPlan()
        }else{
            self.Api_For_update_meal(id: selItem, date: seldate)
        }
    }
    //
}

extension FullCookingScheduleVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDragDelegate, UICollectionViewDropDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == CalanderCollV{
            return currentWeekDates.count
        }else if collectionView == BreakFastCollV{
            return self.AllDataList.breakfast?.count ?? 0
        }else if collectionView == LunchCollV{
            return self.AllDataList.lunch?.count ?? 0
        }else if collectionView == DinnerCollV{
            return self.AllDataList.dinner?.count ?? 0
        }else if collectionView == SnacksCollV{
            return self.AllDataList.snacks?.count ?? 0
        }else{
            return self.AllDataList.teatime?.count ?? 0        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == CalanderCollV{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CalendarCell", for: indexPath) as! CalendarCell
            let date = currentWeekDates[indexPath.item]
            cell.configure(with: date)
            return cell
        }else if collectionView == BreakFastCollV{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BrealFLunchDinnerCollV", for: indexPath) as! BrealFLunchDinnerCollV
            cell.NameLbl.text = self.AllDataList.breakfast?[indexPath.item].recipe?.label ?? ""
            
            cell.MinLbl.text =  "\(self.AllDataList.breakfast?[indexPath.item].recipe?.totalTime ?? 0) min"
            
            let img = self.AllDataList.breakfast?[indexPath.item].recipe?.images?.small?.url ?? ""
            cell.IMg.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
            cell.IMg.sd_setImage(with: URL(string: img), placeholderImage: UIImage(named:"No_Image"))
            
            let islike = self.AllDataList.breakfast?[indexPath.item].isLike
            
            if islike == 1{
                cell.FavBtn.setImage(UIImage(named: "Fav"), for: .normal)
            }else{
                cell.FavBtn.setImage(UIImage(named: "UnFav"), for: .normal)
            }
            
            let isMissing = self.AllDataList.breakfast?[indexPath.item].is_missing ?? 0
            
            if isMissing == 0{
                cell.CheckImg.image = UIImage(named: "Missing")
                cell.CheckBtn.tag = indexPath.row
                cell.CheckBtn.addTarget(self, action: #selector(BreakFastMissingIngrenients(_:)), for: .touchUpInside)
            }else{
                cell.CheckImg.image = UIImage(named: "CheckFill")
            }
            
            cell.removeBtn.tag = indexPath.item
            cell.removeBtn.addTarget(self, action: #selector(removeBtnClick(_:)), for: .touchUpInside)
            
            if longPressedEnabled   {
                cell.startAnimate()
            }else{
                cell.stopAnimate()
            }
            
            cell.FavBtn.tag = indexPath.item
            cell.FavBtn.addTarget(self, action: #selector(BreakFastFavBtnClick(_:)), for: .touchUpInside)
            
            return cell
        }else if collectionView == LunchCollV{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BrealFLunchDinnerCollV", for: indexPath) as! BrealFLunchDinnerCollV
            cell.NameLbl.text = self.AllDataList.lunch?[indexPath.item].recipe?.label ?? ""
            
            cell.MinLbl.text =  "\(self.AllDataList.lunch?[indexPath.item].recipe?.totalTime ?? 0) min"
            
            let img = self.AllDataList.lunch?[indexPath.item].recipe?.images?.small?.url ?? ""
            cell.IMg.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
            cell.IMg.sd_setImage(with: URL(string: img), placeholderImage: UIImage(named:"No_Image"))
            
            let islike = self.AllDataList.lunch?[indexPath.item].isLike
            
            if islike == 1{
                cell.FavBtn.setImage(UIImage(named: "Fav"), for: .normal)
            }else{
                cell.FavBtn.setImage(UIImage(named: "UnFav"), for: .normal)
            }
            
            let isMissing = self.AllDataList.lunch?[indexPath.item].is_missing ?? 0
            
            if isMissing == 0{
                cell.CheckImg.image = UIImage(named: "Missing")
                cell.CheckBtn.tag = indexPath.row
                cell.CheckBtn.addTarget(self, action: #selector(LunchMissingIngrenients(_:)), for: .touchUpInside)
            }else{
                cell.CheckImg.image = UIImage(named: "CheckFill")
            }
            
            cell.removeBtn.tag = indexPath.item
            cell.removeBtn.addTarget(self, action: #selector(LunchremoveBtnClick(_:)), for: .touchUpInside)
            
            if longPressedEnabled   {
                cell.startAnimate()
            }else{
                cell.stopAnimate()
            }
            
            cell.FavBtn.tag = indexPath.item
            cell.FavBtn.addTarget(self, action: #selector(LunchFavBtnClick(_:)), for: .touchUpInside)
            
            return cell
        }else if collectionView == DinnerCollV{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BrealFLunchDinnerCollV", for: indexPath) as! BrealFLunchDinnerCollV
            cell.NameLbl.text = self.AllDataList.dinner?[indexPath.item].recipe?.label ?? ""
            
            cell.MinLbl.text =  "\(self.AllDataList.dinner?[indexPath.item].recipe?.totalTime ?? 0) min"
            
            let img = self.AllDataList.dinner?[indexPath.item].recipe?.images?.small?.url ?? ""
            cell.IMg.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
            cell.IMg.sd_setImage(with: URL(string: img), placeholderImage: UIImage(named:"No_Image"))
            
            let islike = self.AllDataList.dinner?[indexPath.item].isLike
            
            if islike == 1{
                cell.FavBtn.setImage(UIImage(named: "Fav"), for: .normal)
            }else{
                cell.FavBtn.setImage(UIImage(named: "UnFav"), for: .normal)
            }
            
            let isMissing = self.AllDataList.dinner?[indexPath.item].is_missing ?? 0
            
            if isMissing == 0{
                cell.CheckImg.image = UIImage(named: "Missing")
                cell.CheckBtn.tag = indexPath.row
                cell.CheckBtn.addTarget(self, action: #selector(DinnerMissingIngrenients(_:)), for: .touchUpInside)
            }else{
                cell.CheckImg.image = UIImage(named: "CheckFill")
            }
            
            cell.removeBtn.tag = indexPath.item
            cell.removeBtn.addTarget(self, action: #selector(DinnerremoveBtnClick(_:)), for: .touchUpInside)
            
            
            if longPressedEnabled   {
                cell.startAnimate()
            }else{
                cell.stopAnimate()
            }
            
            cell.FavBtn.tag = indexPath.item
            cell.FavBtn.addTarget(self, action: #selector(DinnerFavBtnClick(_:)), for: .touchUpInside)
            
            return cell
        }else if collectionView == SnacksCollV{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BrealFLunchDinnerCollV", for: indexPath) as! BrealFLunchDinnerCollV
            cell.NameLbl.text = self.AllDataList.snacks?[indexPath.item].recipe?.label ?? ""
            
            cell.MinLbl.text =  "\(self.AllDataList.snacks?[indexPath.item].recipe?.totalTime ?? 0) min"
            
            let img = self.AllDataList.snacks?[indexPath.item].recipe?.images?.small?.url ?? ""
            cell.IMg.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
            cell.IMg.sd_setImage(with: URL(string: img), placeholderImage: UIImage(named:"No_Image"))
            
            let islike = self.AllDataList.snacks?[indexPath.item].isLike
            
            if islike == 1{
                cell.FavBtn.setImage(UIImage(named: "Fav"), for: .normal)
            }else{
                cell.FavBtn.setImage(UIImage(named: "UnFav"), for: .normal)
            }
            
            let isMissing = self.AllDataList.snacks?[indexPath.item].is_missing ?? 0
            
            if isMissing == 0{
                cell.CheckImg.image = UIImage(named: "Missing")
                cell.CheckBtn.tag = indexPath.row
                cell.CheckBtn.addTarget(self, action: #selector(SnacksMissingIngrenients(_:)), for: .touchUpInside)
            }else{
                cell.CheckImg.image = UIImage(named: "CheckFill")
            }
            
            cell.removeBtn.tag = indexPath.item
            cell.removeBtn.addTarget(self, action: #selector(SnacksremoveBtnClick(_:)), for: .touchUpInside)
            
            
            if longPressedEnabled   {
                cell.startAnimate()
            }else{
                cell.stopAnimate()
            }
            
            cell.FavBtn.tag = indexPath.item
            cell.FavBtn.addTarget(self, action: #selector(SnacksFavBtnClick(_:)), for: .touchUpInside)
            
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BrealFLunchDinnerCollV", for: indexPath) as! BrealFLunchDinnerCollV
            cell.NameLbl.text = self.AllDataList.teatime?[indexPath.item].recipe?.label ?? ""
            
            cell.MinLbl.text =  "\(self.AllDataList.teatime?[indexPath.item].recipe?.totalTime ?? 0) min"
            
            let img = self.AllDataList.teatime?[indexPath.item].recipe?.images?.small?.url ?? ""
            cell.IMg.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
            cell.IMg.sd_setImage(with: URL(string: img), placeholderImage: UIImage(named:"No_Image"))
            
            let islike = self.AllDataList.teatime?[indexPath.item].isLike
            
            if islike == 1{
                cell.FavBtn.setImage(UIImage(named: "Fav"), for: .normal)
            }else{
                cell.FavBtn.setImage(UIImage(named: "UnFav"), for: .normal)
            }
            
            let isMissing = self.AllDataList.teatime?[indexPath.item].is_missing ?? 0
            
            if isMissing == 0{
                cell.CheckImg.image = UIImage(named: "Missing")
                cell.CheckBtn.tag = indexPath.row
                cell.CheckBtn.addTarget(self, action: #selector(TeatimeMissingIngrenients(_:)), for: .touchUpInside)
            }else{
                cell.CheckImg.image = UIImage(named: "CheckFill")
            }
            
            cell.removeBtn.tag = indexPath.item
            cell.removeBtn.addTarget(self, action: #selector(TeatimeremoveBtnClick(_:)), for: .touchUpInside)
            
            if longPressedEnabled   {
                cell.startAnimate()
            }else{
                cell.stopAnimate()
            }
            
            cell.FavBtn.tag = indexPath.item
            cell.FavBtn.addTarget(self, action: #selector(TeatimeFavBtnClick(_:)), for: .touchUpInside)
            
            return cell
        }
    }
    
    @objc func removeBtnClick(_ sender: UIButton)   {
        let index = sender.tag
        self.MealtypeSelectedIndex = index
        self.RemovePopupV.isHidden = false
        self.Mealtypeclicked = "Breakfast"
        self.selID = "\(self.AllDataList.breakfast?[index].id ?? 0)"
    }
    
    @objc func LunchremoveBtnClick(_ sender: UIButton)   {
        let index = sender.tag
        self.MealtypeSelectedIndex = index
        self.RemovePopupV.isHidden = false
        self.Mealtypeclicked = "Lunch"
        self.selID = "\(self.AllDataList.lunch?[index].id ?? 0)"
    }
    
    @objc func DinnerremoveBtnClick(_ sender: UIButton)   {
        let index = sender.tag
        self.MealtypeSelectedIndex = index
        self.RemovePopupV.isHidden = false
        self.Mealtypeclicked = "Dinner"
        self.selID = "\(self.AllDataList.dinner?[index].id ?? 0)"
    }
    
    @objc func SnacksremoveBtnClick(_ sender: UIButton)   {
        let index = sender.tag
        self.MealtypeSelectedIndex = index
        self.RemovePopupV.isHidden = false
        self.Mealtypeclicked = "Snacks"
        self.selID = "\(self.AllDataList.snacks?[index].id ?? 0)"
    }
    
    @objc func TeatimeremoveBtnClick(_ sender: UIButton)   {
        let index = sender.tag
        self.MealtypeSelectedIndex = index
        self.RemovePopupV.isHidden = false
        self.Mealtypeclicked = "Brunch"
        self.selID = "\(self.AllDataList.teatime?[index].id ?? 0)"
    }
    
    
    //missing ingredients.
    @objc func BreakFastMissingIngrenients(_ sender: UIButton)   {
        let index  = sender.tag
        let uri = self.AllDataList.breakfast?[index].recipe?.uri ?? ""
        let selID = "\(self.AllDataList.breakfast?[index].id ?? 0)"
        
        self.MissingBtnClickNav(TypeClicked: "Breakfast", Uri: uri, SelID: selID)
    }
    
    @objc func LunchMissingIngrenients(_ sender: UIButton)   {
        let index  = sender.tag
        let uri = self.AllDataList.lunch?[index].recipe?.uri ?? ""
        let selID = "\(self.AllDataList.lunch?[index].id ?? 0)"
        
        self.MissingBtnClickNav(TypeClicked: "Lunch", Uri: uri, SelID: selID)
    }
    
    @objc func DinnerMissingIngrenients(_ sender: UIButton)   {
        let index  = sender.tag
        let uri = self.AllDataList.dinner?[index].recipe?.uri ?? ""
        let selID = "\(self.AllDataList.dinner?[index].id ?? 0)"
        
        self.MissingBtnClickNav(TypeClicked: "Dinner", Uri: uri, SelID: selID)
    }
    
    
    @objc func SnacksMissingIngrenients(_ sender: UIButton)   {
        let index  = sender.tag
        let uri = self.AllDataList.snacks?[index].recipe?.uri ?? ""
        let selID = "\(self.AllDataList.snacks?[index].id ?? 0)"
        
        self.MissingBtnClickNav(TypeClicked: "Snacks", Uri: uri, SelID: selID)
    }
    
    @objc func TeatimeMissingIngrenients(_ sender: UIButton)   {
        let index  = sender.tag
        let uri = self.AllDataList.teatime?[index].recipe?.uri ?? ""
        let selID = "\(self.AllDataList.teatime?[index].id ?? 0)"
        
        self.MissingBtnClickNav(TypeClicked: "Brunch", Uri: uri, SelID: selID)
    }
    
    func MissingBtnClickNav(TypeClicked: String, Uri: String, SelID: String)   {
        let storyboard = UIStoryboard(name: "Tabbar", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MissingIngredientsVC") as! MissingIngredientsVC
        vc.uri = Uri
        vc.sch_id = SelID
        vc.mealtype = TypeClicked
        vc.backAction = {
            self.Api_To_GetAllRecipeByDate()
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    //
    
    //favBtn
    @objc func BreakFastFavBtnClick(_ sender: UIButton)   {
        let index  = sender.tag
        
        let SubscriptionStatus = Int(UserDetail.shared.getSubscriptionStatus())
        
        if SubscriptionStatus == 1{
            let addtoplanStatus = Int(UserDetail.shared.getfavorite()) ?? 0
            guard addtoplanStatus <= 2 else {
                SubscriptionPopUp ()
                return
            }
        }
        
        let uri = self.AllDataList.breakfast?[index].recipe?.uri ?? ""
        let selID = "\(self.AllDataList.breakfast?[index].id ?? 0)"
        
        let islike = self.AllDataList.breakfast?[index].isLike ?? 0
        
        if islike == 1{
            self.Api_To_UnFAv(uri: uri)
        }else{
            self.FavBtnClickNav(TypeClicked: "Breakfast", Uri: uri, SelID: selID)
        }
    }
    
    @objc func LunchFavBtnClick(_ sender: UIButton)   {
        let index  = sender.tag
        
        let SubscriptionStatus = Int(UserDetail.shared.getSubscriptionStatus())
        
        if SubscriptionStatus == 1{
            let addtoplanStatus = Int(UserDetail.shared.getfavorite()) ?? 0
            guard addtoplanStatus <= 2 else {
                SubscriptionPopUp ()
                return
            }
        }
        
        let uri = self.AllDataList.lunch?[index].recipe?.uri ?? ""
        let selID = "\(self.AllDataList.lunch?[index].id ?? 0)"
        
        let islike = self.AllDataList.lunch?[index].isLike ?? 0
        
        if islike == 1{
            self.Api_To_UnFAv(uri: uri)
        }else{
            self.FavBtnClickNav(TypeClicked: "Lunch", Uri: uri, SelID: selID)
        }
    }
    
    @objc func DinnerFavBtnClick(_ sender: UIButton)   {
        let index  = sender.tag
        
        let SubscriptionStatus = Int(UserDetail.shared.getSubscriptionStatus())
        
        if SubscriptionStatus == 1{
            let addtoplanStatus = Int(UserDetail.shared.getfavorite()) ?? 0
            guard addtoplanStatus <= 2 else {
                SubscriptionPopUp ()
                return
            }
        }
        
        let uri = self.AllDataList.dinner?[index].recipe?.uri ?? ""
        let selID = "\(self.AllDataList.dinner?[index].id ?? 0)"
        
        let islike = self.AllDataList.dinner?[index].isLike ?? 0
        
        if islike == 1{
            self.Api_To_UnFAv(uri: uri)
        }else{
            self.FavBtnClickNav(TypeClicked: "Dinner", Uri: uri, SelID: selID)
        }
    }
    
    @objc func SnacksFavBtnClick(_ sender: UIButton)   {
        let index  = sender.tag
        
        let SubscriptionStatus = Int(UserDetail.shared.getSubscriptionStatus())
        
        if SubscriptionStatus == 1{
            let addtoplanStatus = Int(UserDetail.shared.getfavorite()) ?? 0
            guard addtoplanStatus <= 2 else {
                SubscriptionPopUp ()
                return
            }
        }
        
        let uri = self.AllDataList.snacks?[index].recipe?.uri ?? ""
        let selID = "\(self.AllDataList.snacks?[index].id ?? 0)"
        
        let islike = self.AllDataList.snacks?[index].isLike ?? 0
        
        if islike == 1{
            self.Api_To_UnFAv(uri: uri)
        }else{
            self.FavBtnClickNav(TypeClicked: "Snacks", Uri: uri, SelID: selID)
        }
        
    }
    
    @objc func TeatimeFavBtnClick(_ sender: UIButton)   {
        let index  = sender.tag
        
        let SubscriptionStatus = Int(UserDetail.shared.getSubscriptionStatus())
        
        if SubscriptionStatus == 1{
            let addtoplanStatus = Int(UserDetail.shared.getfavorite()) ?? 0
            guard addtoplanStatus <= 2 else {
                SubscriptionPopUp ()
                return
            }
        }
        
        let uri = self.AllDataList.teatime?[index].recipe?.uri ?? ""
        let selID = "\(self.AllDataList.teatime?[index].id ?? 0)"
        
        let islike = self.AllDataList.teatime?[index].isLike ?? 0
        
        if islike == 1{
            self.Api_To_UnFAv(uri: uri)
        }else{
            self.FavBtnClickNav(TypeClicked: "Brunch", Uri: uri, SelID: selID)
        }
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
    
    
    func FavBtnClickNav(TypeClicked: String, Uri: String, SelID: String)   {
        let storyboard = UIStoryboard(name: "Tabbar", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "FavrouitPopupVC") as! FavrouitPopupVC
        vc.comesFrom = "FullCookingScheduleVC"
        vc.uri = Uri
        vc.selID = SelID
        vc.typeclicked = TypeClicked
        vc.backAction = {
            self.Api_To_GetAllRecipeByDate()
        }
        self.addChild(vc)
        vc.view.frame = self.view.frame
        self.view.addSubview(vc.view)
        self.view.bringSubviewToFront(vc.view)
        vc.didMove(toParent: self)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == CalanderCollV{
            let today = Date()
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
            Prevseldate = currentWeekDates[indexPath.item]
            
            self.Change_cooking_ScheduleBtnO .isUserInteractionEnabled = false
            self.Change_cooking_ScheduleBtnO.backgroundColor = UIColor.lightGray
            
            if self.tag == 1{
                Api_To_GetAllRecipeByDate()
            }
            self.tag = 1
            //  collectionView.reloadData()
        }else if collectionView == BreakFastCollV{
            let storyboard = UIStoryboard(name: "Tabbar", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "RecipeDetailsVC") as! RecipeDetailsVC
            vc.MealType = "Breakfast"
            vc.uri = self.AllDataList.breakfast?[indexPath.item].recipe?.uri ?? ""
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }else if collectionView == LunchCollV{
            let storyboard = UIStoryboard(name: "Tabbar", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "RecipeDetailsVC") as! RecipeDetailsVC
            vc.MealType = "Lunch"
            vc.uri = self.AllDataList.lunch?[indexPath.item].recipe?.uri ?? ""
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }else if collectionView == DinnerCollV{
            let storyboard = UIStoryboard(name: "Tabbar", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "RecipeDetailsVC") as! RecipeDetailsVC
            vc.MealType = "Dinner"
            vc.uri = self.AllDataList.dinner?[indexPath.item].recipe?.uri ?? ""
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }else if collectionView == SnacksCollV{
            let storyboard = UIStoryboard(name: "Tabbar", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "RecipeDetailsVC") as! RecipeDetailsVC
            vc.MealType = "Snacks"
            vc.uri = self.AllDataList.snacks?[indexPath.item].recipe?.uri ?? ""
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }else if collectionView == TeatimeCollV{
            let storyboard = UIStoryboard(name: "Tabbar", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "RecipeDetailsVC") as! RecipeDetailsVC
            vc.MealType = "Brunch"
            vc.uri = self.AllDataList.teatime?[indexPath.item].recipe?.uri ?? ""
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == CalanderCollV{
            let width = collectionView.frame.width / 7
            return CGSize(width: width, height: collectionView.frame.height)
            //           }else if collectionView == DinnerCollV{
            //               return CGSize(width: collectionView.frame.width/2.3 - 5, height: collectionView.frame.height)
        }else{
            //               let itemCount: Int
            //                  switch collectionView {
            //                  case BreakFastCollV:
            //                      itemCount = self.AllDataList.breakfast?.count ?? 0
            //                      break;
            //                  case LunchCollV:
            //                      itemCount = self.AllDataList.lunch?.count ?? 0
            //                      break;
            //                  case DinnerCollV:
            //                      itemCount = self.AllDataList.dinner?.count ?? 0
            //                      break;
            //                  case SnacksCollV:
            //                      itemCount = self.AllDataList.snacks?.count ?? 0
            //                      break;
            //                  case TeatimeCollV:
            //                      itemCount = self.AllDataList.teatime?.count ?? 0
            //                      break;
            //                  default: // Teatime
            //                      itemCount = 0
            //                      break;
            //                  }
            
            // Calculate the cell size
            //                 let width: CGFloat = itemCount > 2 ? collectionView.frame.width / 2.3 - 5 : collectionView.frame.width / 2 - 15
            let height: CGFloat = collectionView.frame.height
            
            return CGSize(width: 185, height: height)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == CalanderCollV{
            return 0
        }else{
            return 3
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == CalanderCollV{
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }else{
            if section == 0 {
                return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 3)
            }else{
                return UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 3)
            }
        }
        //        }else{
        //            return UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        //        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == CalanderCollV{
            return 0
        }else{
            return 3
        }
    }
    
    // MARK: - UICollectionView Drag Delegate
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        // Only handle drag for the BreakFastCollV, LunchCollV, and DinnerCollV collections
        guard collectionView == BreakFastCollV || collectionView == LunchCollV || collectionView == DinnerCollV || collectionView == SnacksCollV || collectionView == TeatimeCollV else {
            return []
        }
        
        let item: String
        // Get the item to be dragged from the respective data source
        if collectionView == BreakFastCollV {
            CollVType = "Breakfast"
            
            if self.AllDataList.is_add ?? 0 == 0{
                item = self.AllDataList.breakfast?[indexPath.row].recipe?.uri ?? ""
            }else{
                item = "\(self.AllDataList.breakfast?[indexPath.row].id ?? 0)"
            }
            
            self.DragItemDate = self.AllDataList.breakfast?[indexPath.row].date ?? ""
            
        } else if collectionView == LunchCollV {
            CollVType = "Lunch"
            
            if self.AllDataList.is_add ?? 0 == 0{
                item = self.AllDataList.lunch?[indexPath.row].recipe?.uri ?? ""
            }else{
                item = "\(self.AllDataList.lunch?[indexPath.row].id ?? 0)"
            }
            
            self.DragItemDate = self.AllDataList.lunch?[indexPath.row].date ?? ""
        } else if collectionView == DinnerCollV {
            CollVType = "Dinner"
            
            if self.AllDataList.is_add ?? 0 == 0{
                item = self.AllDataList.dinner?[indexPath.row].recipe?.uri ?? ""
                
            }else{
                item = "\(self.AllDataList.dinner?[indexPath.row].id ?? 0)"
            }
            self.DragItemDate = self.AllDataList.dinner?[indexPath.row].date ?? ""
            
        } else if collectionView == SnacksCollV {
            CollVType = "Snacks"
            
            if self.AllDataList.is_add ?? 0 == 0{
                item = self.AllDataList.snacks?[indexPath.row].recipe?.uri ?? ""
                
            }else{
                item = "\(self.AllDataList.snacks?[indexPath.row].id ?? 0)"
            }
            
            self.DragItemDate = self.AllDataList.snacks?[indexPath.row].date ?? ""
            
        } else {
            CollVType = "Brunch"
            if self.AllDataList.is_add ?? 0 == 0{
                item = self.AllDataList.teatime?[indexPath.row].recipe?.uri ?? ""
                
            }else{
                item = "\(self.AllDataList.teatime?[indexPath.row].id ?? 0)"
            }
            self.DragItemDate = self.AllDataList.teatime?[indexPath.row].date ?? ""
        }
        print(item, "dragged item")
        
        
        
        // Create an item provider with the string object
        let itemProvider = NSItemProvider(object: item as NSString)
        
        // Return the UIDragItem which will be used during the drag session
        return [UIDragItem(itemProvider: itemProvider)]
    }
    
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        if let indexPath = destinationIndexPath {
            print("Currently dragging over calendar cell at index: \(indexPath.item)")
            
            if collectionView == CalanderCollV {
                print("Condition met, it's the calendar collection view")
                updateCalendarHoverState(at: indexPath)
                // Continue with the rest of the code
            } else {
                print("It's not the calendar collection view")
            }
            
            
        } else {
            print("Destination indexPath is nil")
        }
        
        return UICollectionViewDropProposal(operation: .move, intent: .insertIntoDestinationIndexPath)
    }
    
    
    
    // Update hover state
    func updateCalendarHoverState(at indexPath: IndexPath) {
        var selDateStr = ""
        let today = Date()
        let SelDate = currentWeekDates[indexPath.row]
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone.current // Use the local time zone
        // Convert to string
        let dateString = formatter.string(from: SelDate)
        selDateStr = dateString
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
        
        //        guard self.DragItemDate != selDateStr else{
        //            return
        //        }
        // Deselect previously selected cell (if any)
        if let previousIndex = selectedIndex {
            let previousCell = CalanderCollV.cellForItem(at: previousIndex) as? CalendarCell
            previousCell?.updateSelection(isSelected: false)
        }
        
        // Select the current cell being dragged over
        let currentCell = CalanderCollV.cellForItem(at: indexPath) as? CalendarCell
        currentCell?.updateSelection(isSelected: true)
        
        // Update the selected index
        selectedIndex = indexPath
        
        
        // Force the current cell to update its appearance
        currentCell?.setNeedsLayout()
        currentCell?.layoutIfNeeded()
    }
    
    // Handle drop
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        guard collectionView == CalanderCollV else { return }
        
        
        if let destinationIndexPath = coordinator.destinationIndexPath {
            let calendarDateIndex = destinationIndexPath.item
            print("Item dragged to calendar cell at index: \(calendarDateIndex)")
            seldate = currentWeekDates[calendarDateIndex]
            coordinator.items.forEach { item in
                item.dragItem.itemProvider.loadObject(ofClass: NSString.self) { (object, error) in
                    guard let draggedItem = object as? String else { return }
                    
                    DispatchQueue.main.async {
                        // Optionally, handle dropped data
                        self.handleDrop(forItem: draggedItem, at: calendarDateIndex)
                    }
                }
            }
        }
    }
    
    // Handle drop logic
    func handleDrop(forItem item: String, at dateIndex: Int) {
        var selDateStr = ""
        
        let today = Date()
        let SelDate = currentWeekDates[dateIndex]
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone.current // Use the local time zone
        // Convert to string
        let dateString = formatter.string(from: SelDate)
        selDateStr = dateString
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
        
        guard self.DragItemDate != selDateStr else{
            self.Change_cooking_ScheduleBtnO .isUserInteractionEnabled = false
            self.Change_cooking_ScheduleBtnO.backgroundColor = UIColor.lightGray
            return
        }
        
        guard dateIndex < currentWeekDates.count else { return }
        let selectedDate = currentWeekDates[dateIndex]
        print("Dropped item '\(item)' on calendar date \(selectedDate) at index \(dateIndex)")
        
        // Update the UI or data model
        currentWeekDates.enumerated().forEach { (i, date) in
            if let previousIndex = selectedIndex {
                let previousCell = CalanderCollV.cellForItem(at: previousIndex) as? CalendarCell
                previousCell?.updateSelection(isSelected: false)
            }
            
            // Select the current item
            let currentCell = CalanderCollV.cellForItem(at: IndexPath(item: dateIndex, section: 0)) as? CalendarCell
            currentCell?.updateSelection(isSelected: true)
            
            // Update the selected index
            selectedIndex = IndexPath(item: dateIndex, section: 0)
            seldate = currentWeekDates[dateIndex]
            
            // Reload the collection view to reflect changes (if necessary)
            //  CalanderCollV.reloadItems(at: [IndexPath(item: dateIndex, section: 0)])
        }
        
        if item != ""{
            self.Change_cooking_ScheduleBtnO.isUserInteractionEnabled = true
            self.Change_cooking_ScheduleBtnO.backgroundColor = #colorLiteral(red: 0.02352941176, green: 0.7568627451, blue: 0.4117647059, alpha: 1)
        }
        
        selItem = item
    }
    
    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: NSString.self)
    }
    
    func collectionView(_ collectionView: UICollectionView, dragPreviewForItemAt indexPath: IndexPath) -> UIDragPreview? {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return nil }
        
        let preview = UIDragPreview(view: cell)
        // You can modify the cell's alpha directly here
        preview.view.alpha = 0.5  // Set transparency (0.0 is fully transparent)
        return preview
    }
    
    // 2. When the drag session begins, reduce opacity of the dragged cell
    func collectionView(_ collectionView: UICollectionView, dragSessionWillBegin session: UIDragSession) {
        if let selectedIndexPath = collectionView.indexPathsForSelectedItems?.first {
            if let cell = collectionView.cellForItem(at: selectedIndexPath) {
                cell.alpha = 0.5  // Reduce opacity during drag
            }
        }
        
        // Scroll to the top when the drag session begins
        DispatchQueue.main.async {
            self.ScrollV.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        }
    }
    
    // 3. When the drag session ends, restore the opacity
    func collectionView(_ collectionView: UICollectionView, dragSessionDidEnd session: UIDragSession) {
        if let selectedIndexPath = collectionView.indexPathsForSelectedItems?.first {
            if let cell = collectionView.cellForItem(at: selectedIndexPath) {
                cell.alpha = 1.0  // Restore original opacity
            }
        }
    }
}


extension FullCookingScheduleVC {
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
            let startDay = formatter1.string(from: start)
            let endDay = formatter1.string(from: end)
            
            formatter1.dateFormat = "MMM" // For the month abbreviation (e.g., Dec)
            let month = formatter1.string(from: start)
            
            FromDateToLbl.text = "\(formatter.string(from: start)) - \(formatter.string(from: end))"//"\(startDay) - \(endDay) \(month)"
            
        }
    }
}

extension FullCookingScheduleVC {

    func Api_To_GetAllRecipeByDate(){
        var params = [String: Any]()
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy-MM-dd"
       
        
        if tag == 0{
            params["date"] = ""
        }else{
            let Sdate = dateformatter.string(from: seldate)
            params["date"] = Sdate
        }
       
        params["plan_type"] = "0"
        
        showIndicator(withTitle: "", and: "")
        let loginURL = baseURL.baseURL + appEndPoints.get_schedule_by_random_date//get_schedule
        
        WebService.shared.postServiceURLEncoding(loginURL, VC: self, andParameter: params, withCompletion: { (json, statusCode) in
            
            self.hideIndicator()
            
            let data = try! json.rawData()
            
            do{
                let d = try JSONDecoder().decode(YourCookedMealModelClass.self, from: data)
                if d.success == true {
                    let list = d.data
                    
                    self.AllDataList  = list ?? YourCookedMealModel()
                     
                    self.veryFirstLoading = 0
                     
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
                    
                    
                    self.ShowNoDataFoundonCollV1()
                    
                }else{
                    self.ShowNoDataFoundonCollV1()
                    
                    let msg = d.message ?? ""
                    self.showToast(msg)
                }
            }catch{
                self.ShowNoDataFoundonCollV1()
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
    
    func ShowNoDataFoundonCollV1(){
        if self.AllDataList.breakfast?.count ?? 0 == 0{
            self.BreakFastBgV.isHidden = true
        }else{
            self.BreakFastBgV.isHidden = false
        }
        
        if self.AllDataList.lunch?.count ?? 0 == 0{
            self.LunchBgV.isHidden = true
        }else{
            self.LunchBgV.isHidden = false
        }
        
        
        if self.AllDataList.dinner?.count ?? 0 == 0{
            self.DinnerBgV.isHidden = true
        }else{
            self.DinnerBgV.isHidden = false
        }
        
        if self.AllDataList.snacks?.count ?? 0 == 0{
            self.SnacksBgV.isHidden = true
        }else{
            self.SnacksBgV.isHidden = false
        }
        
        if self.AllDataList.teatime?.count ?? 0 == 0{
            self.TeatimeBgV.isHidden = true
        }else{
            self.TeatimeBgV.isHidden = false
        }
        
        if self.AllDataList.breakfast?.count ?? 0 == 0 && self.AllDataList.lunch?.count ?? 0 == 0 && self.AllDataList.dinner?.count ?? 0 == 0 && self.AllDataList.snacks?.count ?? 0 == 0 && self.AllDataList.teatime?.count ?? 0 == 0{
            self.NoOrderLbl.isHidden = false
        }else{
            self.NoOrderLbl.isHidden = true
        }
        
        DispatchQueue.main.async {
            self.BreakFastCollV.reloadData()
            self.LunchCollV.reloadData()
            self.DinnerCollV.reloadData()
            self.SnacksCollV.reloadData()
            self.TeatimeCollV.reloadData()
        }
    }
    
    func Api_To_RemoveMeal(){
        var params = [String: Any]()
         
        params["id"] = self.selID
        
        showIndicator(withTitle: "", and: "")
        
        let loginURL = baseURL.baseURL + appEndPoints.remove_meal
        print(params,"Params")
        print(loginURL,"loginURL")
        
        WebService.shared.postServiceURLEncoding(loginURL, VC: self, andParameter: params, withCompletion: { (json, statusCode) in
            
            self.hideIndicator()
            
            guard let dictData = json.dictionaryObject else{
                return
            }
            
            if dictData["success"] as? Bool == true{
                self.RemovePopupV.isHidden = true
                
                if self.Mealtypeclicked == "Breakfast"{
                    self.AllDataList.breakfast?.remove(at: self.MealtypeSelectedIndex)
                }else if self.Mealtypeclicked == "Lunch" {
                    self.AllDataList.lunch?.remove(at: self.MealtypeSelectedIndex)
                }else if self.Mealtypeclicked == "Dinner" {
                    self.AllDataList.dinner?.remove(at: self.MealtypeSelectedIndex)
                }else if self.Mealtypeclicked == "Snacks" {
                    self.AllDataList.snacks?.remove(at: self.MealtypeSelectedIndex)
                }else if self.Mealtypeclicked == "Brunch"{
                    self.AllDataList.teatime?.remove(at: self.MealtypeSelectedIndex)
                }
                
                self.ShowNoDataFoundonCollV1()
                
                if self.AllDataList.breakfast?.count ?? 0 == 0 && self.AllDataList.lunch?.count ?? 0 == 0 && self.AllDataList.dinner?.count ?? 0 == 0 && self.AllDataList.snacks?.count ?? 0 == 0 && self.AllDataList.teatime?.count ?? 0 == 0{
                    self.tag = 0
                    self.Api_To_GetAllRecipeByDate()
                }
                
                let collectionViews: [UICollectionView] = [self.BreakFastCollV, self.LunchCollV, self.DinnerCollV, self.SnacksCollV, self.TeatimeCollV]
                for collectionView in collectionViews {
                    print(collectionView)
                    self.longPressedEnabled = false
                    self.stopJiggleAnimationForAllCollectionViews()
                    return
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
            
            
            guard let dictData = json.dictionaryObject else{
                return
            }
            
            if dictData["success"] as? Bool == true{
                self.showToast("Removed from favourites successfully!")
                self.Api_To_GetAllRecipeByDate()
            }else{
                let responseMessage = dictData["message"] as? String ?? ""
                self.showToast(responseMessage)
            }
        })
    }
    
    func Api_For_update_meal(id: String, date: Date) {
        
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy-MM-dd"
        let date1 = dateformatter.string(from: date)
        
        dateformatter.dateFormat = "EEEE"
        let Day = dateformatter.string(from: date)
        //
        let paramsDict: [String: Any] = [
            "type": CollVType,
            "id": id,
            "date": date1,
            "day": Day
        ]
        
        
        showIndicator(withTitle: "", and: "")
        
        let loginURL = baseURL.baseURL + appEndPoints.update_meal
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
                    
                    self.Change_cooking_ScheduleBtnO .isUserInteractionEnabled = false
                    self.Change_cooking_ScheduleBtnO.backgroundColor = UIColor.lightGray
                }else{
                    print("Failed to encode JSON.")
                    self.hideIndicator()
                    self.showToast(Msg)
                }
            }
        }
    }
    
    func Api_For_AddToPlan() {
        
        let dateformatter = DateFormatter()
        
        var SerArray = [[String: String]]()
        
        let date = self.seldate
        dateformatter.dateFormat = "yyyy-MM-dd"
        let Sdate = dateformatter.string(from: date)
        
        dateformatter.dateFormat = "EEEE" // Full day name, e.g., "Monday"
        let dayOfWeek = dateformatter.string(from: date)
        
        let dictionary1: [String: String] = ["date": Sdate, "day": dayOfWeek]
        SerArray.append(dictionary1)
        
        
        print(SerArray)
        
        
        let paramsDict: [String: Any] = [
            "type": self.CollVType,
            "uri": self.selItem,
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
                    self.Change_cooking_ScheduleBtnO .isUserInteractionEnabled = false
                    self.Change_cooking_ScheduleBtnO.backgroundColor = UIColor.lightGray
                    self.Api_To_GetAllRecipeByDate()
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

