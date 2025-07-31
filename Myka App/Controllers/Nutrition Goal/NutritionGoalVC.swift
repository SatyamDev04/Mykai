//
//  NutritionGoalVC.swift
//  Myka App
//  Created by Sumit on 18/12/24.
//

import UIKit
import DropDown
import Alamofire

// MARK: - Data Models
struct MacroTypeModelData {
    var name: String = ""
    var desc: String = ""
}

// MARK: - Main View Controller
class NutritionGoalVC: UIViewController {
    
    // MARK: - IBOutlets
    // Sliders
    @IBOutlet weak var CaloriesSlider: UISlider!
    @IBOutlet weak var FatSlider: UISlider!
    @IBOutlet weak var CarbsSlider: UISlider!
    @IBOutlet weak var ProteinSlider: UISlider!
    
    // Labels
    @IBOutlet weak var CaloriesSliderLbl: UILabel!
    @IBOutlet weak var FatSliderLbl: UILabel!
    @IBOutlet weak var CarbsSliderLbl: UILabel!
    @IBOutlet weak var ProteinSliderLbl: UILabel!
    @IBOutlet weak var fatPercentageLbl: UILabel!
    @IBOutlet weak var carbsPercentageLbl: UILabel!
    @IBOutlet weak var protienPercentageLbl: UILabel!
    @IBOutlet weak var UserNutritionGoalLbl: UILabel!
    @IBOutlet weak var infoLbl: UILabel!
    @IBOutlet weak var TotalPercentLbl: UILabel!
    
    // Text Fields
    @IBOutlet weak var DropDownTxtF: UITextField!
    
    // Buttons
    @IBOutlet weak var updateBtnO: UIButton!
    @IBOutlet weak var resetCaloriesBtn: UIButton!
    @IBOutlet weak var resetProteinBtn: UIButton!
    @IBOutlet weak var resetFatBtn: UIButton!
    @IBOutlet weak var resetCarbsBtn: UIButton!
    
    // Views
    @IBOutlet var headsupPopupView: UIView!
    @IBOutlet var CustomCaloriesPopupView: UIView!
    
    // MARK: - Properties
    var SuggestedData = HealthSuggestedData()
    var uNchangedSuggestedData = HealthSuggestedData()
    var heighProtine: String = ""
    var name = ""
    
    var currentSlider = ""
    var infoLableTxt = ""
    var originalMacroName: String = ""
    let dropDown = DropDown()
    
    var macroTypeDataArr = [
        MacroTypeModelData(name: "Balanced", desc: "Supports overall health"),
        MacroTypeModelData(name: "Low Carb", desc: "Helps with weight management"),
        MacroTypeModelData(name: "High Protein", desc: "Supports muscle strength"),
        MacroTypeModelData(name: "Keto", desc: "Promotes the use of fat for energy"),
        MacroTypeModelData(name: "Low Fat", desc: "Good for heart health"),
        MacroTypeModelData(name: "Custom", desc: "Create your own customization")
    ]
    
    var backAction: (_ HighProtine: String, _ Calories: Int, _ Fat: Int, _ Carbs: Int, _ Protine: Int, _ data: HealthSuggestedData, _ isCaloriesSliderMoves: Bool) -> () = {_,_,_,_,_,_,_ in}
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupSliders()
        setupInitialData()
        setupDropdown()
    }
    
    // MARK: - Setup Methods
    private func setupUI() {
        
        self.headsupPopupView.frame = self.view.bounds
        self.view.addSubview(self.headsupPopupView)
        self.headsupPopupView.isHidden = true
        
        self.CustomCaloriesPopupView.frame = self.view.bounds
        self.view.addSubview(self.CustomCaloriesPopupView)
        self.CustomCaloriesPopupView.isHidden = true
        
        self.UserNutritionGoalLbl.text = "\(self.name)'s Nutrition Goals"
    }
    
    private func setupSliders() {
        
        // Calory Slider
        configureSlider(CaloriesSlider)
        CaloriesSlider.addTarget(self, action: #selector(CaloriessliderValueChanged), for: .valueChanged)
        CaloriesSlider.addTarget(self, action: #selector(CaloriessliderDidEndSliding), for: [.touchUpInside, .touchUpOutside, .touchCancel])
        resetCaloriesBtn.addTarget(self, action: #selector(resetCalTap), for: [.touchUpInside, .touchUpOutside, .touchCancel])
        
        // Fat Slider
        configureSlider(FatSlider)
        FatSlider.addTarget(self, action: #selector(FatsliderValueChanged), for: .valueChanged)
        FatSlider.addTarget(self, action: #selector(FatsliderDidEnd), for: [.touchUpInside, .touchUpOutside, .touchCancel])
        resetFatBtn.addTarget(self, action: #selector(resetFatTap), for: [.touchUpInside, .touchUpOutside, .touchCancel])
        
        // Carbs Slider
        configureSlider(CarbsSlider)
        CarbsSlider.addTarget(self, action: #selector(CarbssliderValueChanged), for: .valueChanged)
        CarbsSlider.addTarget(self, action: #selector(carbsliderDidEnd), for: [.touchUpInside, .touchUpOutside, .touchCancel])
        resetCarbsBtn.addTarget(self, action: #selector(resetCarbTap), for: [.touchUpInside, .touchUpOutside, .touchCancel])
        
        // Protein Slider
        configureSlider(ProteinSlider)
        ProteinSlider.addTarget(self, action: #selector(ProteinsliderValueChanged), for: .valueChanged)
        ProteinSlider.addTarget(self, action: #selector(protiensliderDidEnd), for: [.touchUpInside, .touchUpOutside, .touchCancel])
        resetProteinBtn.addTarget(self, action: #selector(resetProtienTap), for: [.touchUpInside, .touchUpOutside, .touchCancel])
    }
    
    private func configureSlider(_ slider: UISlider) {
        slider.transform = CGAffineTransform(scaleX: 1.0, y: 2.0)
        if let thumbImage = UIImage(named: "Rectangle 4725")?
            .resized(to: CGSize(width: 6, height: 12))?
            .withTintColor(#colorLiteral(red: 0.02352941176, green: 0.7568627451, blue: 0.4117647059, alpha: 1), renderingMode: .alwaysOriginal) {
            slider.setThumbImage(thumbImage, for: .normal)
        }
    }
    
    private func setupInitialData() {
        
        self.uNchangedSuggestedData = self.SuggestedData
        
        self.CaloriesSlider.value = Float(self.SuggestedData.calories ?? 0)
        self.CaloriesSliderLbl.text = "\(Int(self.SuggestedData.calories ?? 0))"
        
        self.FatSlider.value = Float(self.SuggestedData.macroPer?.fat ?? 0)
        self.fatPercentageLbl.text = "\(self.SuggestedData.macroPer?.fat ?? 0)%"
        self.FatSliderLbl.text = "(\(calculateGram(calorieTarget: self.SuggestedData.calories ?? 0, percentage: self.SuggestedData.macroPer?.fat ?? 0, divide: 9))g)"
        
        self.CarbsSlider.value = Float(self.SuggestedData.macroPer?.carbs ?? 0)
        self.carbsPercentageLbl.text = "\(self.SuggestedData.macroPer?.carbs ?? 0)%"
        self.CarbsSliderLbl.text = "(\(calculateGram(calorieTarget: self.SuggestedData.calories ?? 0, percentage: self.SuggestedData.macroPer?.carbs ?? 0, divide: 4))g)"
        
        self.ProteinSlider.value = Float(self.SuggestedData.macroPer?.protein ?? 0)
        self.protienPercentageLbl.text = "\(self.SuggestedData.macroPer?.protein ?? 0)%"
        self.ProteinSliderLbl.text = "(\(calculateGram(calorieTarget: self.SuggestedData.calories ?? 0, percentage: self.SuggestedData.macroPer?.protein ?? 0, divide: 4))g)"
        
        setupMacroType()
        
        // Update reset buttons after initial setup
        updateIndividualResetButtons()
    }
    
    private func setupMacroType() {
        if self.heighProtine.isEmpty {
            self.DropDownTxtF.text = "Balanced"
            self.originalMacroName = "Balanced"
            self.infoLbl.text = "Supports overall health"
            self.infoLableTxt = "Supports overall health"
        } else {
            self.DropDownTxtF.text = self.heighProtine
            self.originalMacroName = self.heighProtine
            if let index = macroTypeDataArr.firstIndex(where: { $0.name == self.heighProtine }) {
                self.infoLbl.text = macroTypeDataArr[index].desc
                self.infoLableTxt = macroTypeDataArr[index].desc
                view.viewWithTag(110)?.isHidden = (self.DropDownTxtF.text ?? "" != "Custom")
            }
        }
    }
    
    private func setupDropdown() {
        dropDown.dataSource = self.macroTypeDataArr.map { $0.name }
        dropDown.cellNib = UINib(nibName: "levelDropDownTblVCell", bundle: nil)
        
        dropDown.customCellConfiguration = { [weak self] (index: Index, item: String, cell: DropDownCell) in
            guard let self = self, let customCell = cell as? levelDropDownTblVCell else { return }
            
            let desc = self.macroTypeDataArr[index].desc
            customCell.descLbl.text = desc
            
            if let selectedText = self.DropDownTxtF.text, selectedText == item {
                customCell.BGV.backgroundColor = #colorLiteral(red: 0.9058823529, green: 1, blue: 0.9568627451, alpha: 1)
            } else {
                customCell.BGV.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
            }
        }
        
        dropDown.selectionAction = { [weak self] (index: Int, item: String) in
            guard let self = self else { return }
            
            self.DropDownTxtF.text = item
            self.originalMacroName = item
            self.infoLbl.text = macroTypeDataArr[index].desc
            self.infoLableTxt = macroTypeDataArr[index].desc
            view.viewWithTag(110)?.isHidden = false
            
            if item != "Custom" {
                self.SuggestedData.isCaloriesSliderMoves = false
                self.Api_To_Get_NutritionGoalSuggestionData()
            } else {
                view.viewWithTag(110)?.isHidden = true
            }
        }
    }
    
    // MARK: - Slider Value Change Handlers
    
    @objc func CaloriessliderValueChanged(_ sender: UISlider) {
        let currentValue = sender.value
        self.CaloriesSliderLbl.text = "\(Int(currentValue))"
        self.UpdateallSliderData(calories: Int(currentValue))
        self.currentSlider = "calorie"
    }
    
    @objc func CaloriessliderDidEndSliding(_ sender: UISlider) {
        let originalCalories = Float(self.uNchangedSuggestedData.calories ?? 0)
        let currentValue = sender.value
        self.SuggestedData.calories = Int(currentValue)
        let lowerThreshold = originalCalories * 0.75
        let upperThreshold = originalCalories * 1.15
        let isSliderMoved = !(self.SuggestedData.isCaloriesSliderMoves ?? false)
        
        if (currentValue < lowerThreshold || currentValue > upperThreshold) && isSliderMoved {
            self.headsupPopupView.isHidden = false
            self.CustomCaloriesPopupView.isHidden = true
        } else if isSliderMoved {
            self.headsupPopupView.isHidden = true
            self.CustomCaloriesPopupView.isHidden = false
        } else {
            self.headsupPopupView.isHidden = true
            self.CustomCaloriesPopupView.isHidden = true
        }
        
        updateIndividualResetButtons()
        evaluateMacroChange()
    }
    
    @objc func FatsliderValueChanged(_ sender: UISlider) {
        let currentValue = sender.value
        let percentage = Int((Double(currentValue) / 100.0) * 100)
        
        self.SuggestedData.macroPer?.fat = percentage
        self.fatPercentageLbl.text = "\(percentage)%"
        view.viewWithTag(110)?.isHidden = true
        
        let fatVal = calculateGram(calorieTarget: self.SuggestedData.calories ?? 0, percentage: percentage, divide: 9)
        self.FatSliderLbl.text = "(\(fatVal)g)"
        
        updateTotalPercentage()
    }
    
    @objc func FatsliderDidEnd(_ sender: UISlider) {
        evaluateHeadsUpConditions(currentSilder: "fat")
        updateIndividualResetButtons()
        evaluateMacroChange()
    }
    
    @objc func CarbssliderValueChanged(_ sender: UISlider) {
        let currentValue = sender.value
        let percentage = Int((Double(currentValue) / 100.0) * 100)
        
        self.SuggestedData.macroPer?.carbs = percentage
        self.carbsPercentageLbl.text = "\(percentage)%"
        view.viewWithTag(110)?.isHidden = true
        
        let carbsVal = calculateGram(calorieTarget: self.SuggestedData.calories ?? 0, percentage: percentage, divide: 4)
        self.CarbsSliderLbl.text = "(\(carbsVal)g)"
        
        updateTotalPercentage()
    }
    
    @objc func carbsliderDidEnd(_ sender: UISlider) {
        evaluateHeadsUpConditions(currentSilder: "carb")
        updateIndividualResetButtons()
        evaluateMacroChange()
    }
    
    @objc func ProteinsliderValueChanged(_ sender: UISlider) {
        let currentValue = sender.value
        let percentage = Int((Double(currentValue) / 100.0) * 100)
        
        self.SuggestedData.macroPer?.protein = percentage
        self.protienPercentageLbl.text = "\(percentage)%"
        view.viewWithTag(110)?.isHidden = true
        
        let proteinVal = calculateGram(calorieTarget: self.SuggestedData.calories ?? 0, percentage: percentage, divide: 4)
        self.ProteinSliderLbl.text = "(\(proteinVal)g)"
        
        updateTotalPercentage()
    }
    
    @objc func protiensliderDidEnd(_ sender: UISlider) {
        evaluateHeadsUpConditions(currentSilder: "protien")
        updateIndividualResetButtons()
        evaluateMacroChange()
    }
    
    // MARK: - Helper Methods
    func calculateGram(calorieTarget: Int, percentage: Int, divide: Int) -> Int {
        let totalGram = (Double(calorieTarget) * Double(percentage) / 100.0) / Double(divide)
        return Int(round(totalGram))
    }
    
    func UpdateallSliderData(calories: Int) {
        let fatVal = calculateGram(calorieTarget: calories, percentage: self.SuggestedData.macroPer?.fat ?? 0, divide: 9)
        self.FatSliderLbl.text = "(\(fatVal)g)"
        
        let carbsVal = calculateGram(calorieTarget: calories, percentage: self.SuggestedData.macroPer?.carbs ?? 0, divide: 4)
        self.CarbsSliderLbl.text = "(\(carbsVal)g)"
        
        let protienVal = calculateGram(calorieTarget: calories, percentage: self.SuggestedData.macroPer?.protein ?? 0, divide: 4)
        self.ProteinSliderLbl.text = "(\(protienVal)g)"
    }
    
    private func updateTotalPercentage() {
        let totalPerc = (self.SuggestedData.macroPer?.fat ?? 0) +
        (self.SuggestedData.macroPer?.carbs ?? 0) +
        (self.SuggestedData.macroPer?.protein ?? 0)
        
        self.TotalPercentLbl.text = "\(Int(totalPerc))%"
        
        if Int(totalPerc) == 100 {
            self.TotalPercentLbl.textColor = UIColor.black
            self.updateBtnO.backgroundColor = #colorLiteral(red: 0, green: 0.786260426, blue: 0.4870494008, alpha: 1)
            self.updateBtnO.isUserInteractionEnabled = true
        } else {
            self.TotalPercentLbl.textColor = UIColor.red
            self.updateBtnO.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
            self.updateBtnO.isUserInteractionEnabled = false
        }
    }
    
    private func evaluateHeadsUpConditions(currentSilder: String) {
        let carbs = Int(CarbsSlider.value)
        let fat = Int(FatSlider.value)
        let protein = Int(ProteinSlider.value)
        currentSlider = currentSilder
        
        let isFatMoved = !(SuggestedData.isfatSliderMoves ?? false)
        let isCarbMoved = !(SuggestedData.isCarbSliderMoves ?? false)
        let isProteinMoved = !(SuggestedData.isProtienliderMoves ?? false)
       
        
        if (carbs == 0 && protein < 10){
            if isCarbMoved || isProteinMoved {
                headsupPopupView.isHidden = false
                CustomCaloriesPopupView.isHidden = true
            }
           
            
        }else if (fat == 0 && protein < 10) {
            if isFatMoved || isProteinMoved {
                headsupPopupView.isHidden = false
                CustomCaloriesPopupView.isHidden = true
            }
         
           
        } else if (carbs == 0 && isCarbMoved) ||
                    (fat == 0 && isFatMoved) ||
                    (protein == 0 && isProteinMoved) {
            headsupPopupView.isHidden = false
            CustomCaloriesPopupView.isHidden = true
        } else {
            headsupPopupView.isHidden = true
        }
    }
    
    private func updateIndividualResetButtons() {
        print("Current calories: \(SuggestedData.calories ?? 0), Original: \(uNchangedSuggestedData.calories ?? 0)")
        print("Current protein: \(SuggestedData.macroPer?.protein ?? 0), Original: \(uNchangedSuggestedData.macroPer?.protein ?? 0)")
        print("Current fat: \(SuggestedData.macroPer?.fat ?? 0), Original: \(uNchangedSuggestedData.macroPer?.fat ?? 0)")
        print("Current carbs: \(SuggestedData.macroPer?.carbs ?? 0), Original: \(uNchangedSuggestedData.macroPer?.carbs ?? 0)")
        
        resetCaloriesBtn.isHidden = SuggestedData.calories == uNchangedSuggestedData.calories
        resetProteinBtn.isHidden = SuggestedData.macroPer?.protein == uNchangedSuggestedData.macroPer?.protein
        resetFatBtn.isHidden = SuggestedData.macroPer?.fat == uNchangedSuggestedData.macroPer?.fat
        resetCarbsBtn.isHidden = SuggestedData.macroPer?.carbs == uNchangedSuggestedData.macroPer?.carbs
        evaluateMacroChange()
    }
    
    private func evaluateMacroChange() {
        let calChanged = SuggestedData.calories != uNchangedSuggestedData.calories
        print(calChanged,"calChanged")
        let proChanged = SuggestedData.macroPer?.protein != uNchangedSuggestedData.macroPer?.protein
        print(proChanged,"proChanged")
        let fatChanged = SuggestedData.macroPer?.fat != uNchangedSuggestedData.macroPer?.fat
        print(fatChanged,"fatChanged")
        let carbChanged = SuggestedData.macroPer?.carbs != uNchangedSuggestedData.macroPer?.carbs
        print(carbChanged,"carbChanged")
        
        if calChanged || proChanged || fatChanged || carbChanged {
            DropDownTxtF.text = "Custom"
            infoLbl.text = "Create your own customization"
        } else {
            SuggestedData.isCaloriesSliderMoves = false
            SuggestedData.isfatSliderMoves = false
            SuggestedData.iscarbProtienMoves = false
            SuggestedData.isFatProtienMoves = false
            SuggestedData.isCarbSliderMoves = false
            SuggestedData.isProtienliderMoves = false
            DropDownTxtF.text = originalMacroName
            view.viewWithTag(110)?.isHidden = false
            if let selected = macroTypeDataArr.first(where: { $0.name == originalMacroName }) {
                infoLbl.text = selected.desc
            }
        }
    }
    
    // MARK: - Reset Methods
    
    @objc func resetCalTap() {
        resetCalorie(list: uNchangedSuggestedData)
        updateIndividualResetButtons()
        evaluateMacroChange()
    }
    
    @objc func resetFatTap() {
        resetFat(list: uNchangedSuggestedData)
        updateIndividualResetButtons()
        evaluateMacroChange()
        
    }
    
    @objc func resetCarbTap() {
        resetCarb(list: uNchangedSuggestedData)
        updateIndividualResetButtons()
        evaluateMacroChange()
    }
    
    @objc func resetProtienTap() {
        resetProtien(list: uNchangedSuggestedData)
        updateIndividualResetButtons()
        evaluateMacroChange()
    }
    
    
    func resetFat(list: HealthSuggestedData) {
        self.FatSlider.value = Float(list.macroPer?.fat ?? 0)
        self.fatPercentageLbl.text = "\(list.macroPer?.fat ?? 0)%"
        self.SuggestedData.macroPer?.fat = list.macroPer?.fat
        self.FatSliderLbl.text = "(\(calculateGram(calorieTarget: list.calories ?? 0, percentage: list.macroPer?.fat ?? 0, divide: 9))g)"
        updateTotalPercentage()
    }
    
    func resetCalorie(list: HealthSuggestedData) {
        self.CaloriesSlider.value = Float(list.calories ?? 0)
        self.CaloriesSliderLbl.text = "\(Int(list.calories ?? 0))"
        self.SuggestedData.calories = list.calories
//        self.resetProtien(list: list)
//        self.resetCarb(list: list)
//        self.resetFat(list: list)
    }
    
    func resetCarb(list: HealthSuggestedData) {
        self.CarbsSlider.value = Float(list.macroPer?.carbs ?? 0)
        self.carbsPercentageLbl.text = "\(list.macroPer?.carbs ?? 0)%"
        self.SuggestedData.macroPer?.carbs = list.macroPer?.carbs
        self.CarbsSliderLbl.text = "(\(calculateGram(calorieTarget: list.calories ?? 0, percentage: list.macroPer?.carbs ?? 0, divide: 4))g)"
        updateTotalPercentage()
    }
    
    func resetProtien(list: HealthSuggestedData) {
        self.ProteinSlider.value = Float(list.macroPer?.protein ?? 0)
        self.protienPercentageLbl.text = "\(list.macroPer?.protein ?? 0)%"
        self.SuggestedData.macroPer?.protein = list.macroPer?.protein
        self.ProteinSliderLbl.text = "(\(calculateGram(calorieTarget: list.calories ?? 0, percentage: list.macroPer?.protein ?? 0, divide: 4))g)"
        updateTotalPercentage()
    }
    
    func setData(list: HealthSuggestedData) {
        self.SuggestedData = list
        self.uNchangedSuggestedData = list
        
        self.CaloriesSlider.value = Float(self.SuggestedData.calories ?? 0)
        self.CaloriesSliderLbl.text = "\(Int(self.SuggestedData.calories ?? 0))"
        
        self.FatSlider.value = Float(self.SuggestedData.macroPer?.fat ?? 0)
        self.fatPercentageLbl.text = "\(self.SuggestedData.macroPer?.fat ?? 0)%"
        self.FatSliderLbl.text = "(\(calculateGram(calorieTarget: self.SuggestedData.calories ?? 0, percentage: self.SuggestedData.macroPer?.fat ?? 0, divide: 9))g"
        
        self.CarbsSlider.value = Float(self.SuggestedData.macroPer?.carbs ?? 0)
        self.carbsPercentageLbl.text = "\(self.SuggestedData.macroPer?.carbs ?? 0)%"
        self.CarbsSliderLbl.text = "(\(calculateGram(calorieTarget: self.SuggestedData.calories ?? 0, percentage: self.SuggestedData.macroPer?.carbs ?? 0, divide: 4))g"
        
        self.ProteinSlider.value = Float(self.SuggestedData.macroPer?.protein ?? 0)
        self.protienPercentageLbl.text = "\(self.SuggestedData.macroPer?.protein ?? 0)%"
        self.ProteinSliderLbl.text = "(\(calculateGram(calorieTarget: self.SuggestedData.calories ?? 0, percentage: self.SuggestedData.macroPer?.protein ?? 0, divide: 4))g"
        
        updateTotalPercentage()
    }
    
    // MARK: - IBActions
    @IBAction func Backbtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func HighProteinDropDownBtn(_ sender: UIButton) {
        dropDown.anchorView = sender
        let trailingSpace: CGFloat = 6
        dropDown.bottomOffset = CGPoint(x: -trailingSpace, y: sender.bounds.height + 2)
        dropDown.topOffset = CGPoint(x: -trailingSpace, y: -(dropDown.anchorView?.plainView.bounds.height ?? 0))
        dropDown.width = (dropDown.anchorView?.plainView.bounds.width ?? 0) + 15
        dropDown.setupCornerRadius(10)
        
        dropDown.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        dropDown.layer.shadowOpacity = 0
        dropDown.layer.shadowRadius = 4
        dropDown.layer.shadowOffset = CGSize(width: 0, height: 0)
        dropDown.backgroundColor = .white
        dropDown.cellHeight = 60
        dropDown.textFont = UIFont(name: "Poppins-Medium", size: 16)!
        dropDown.textColor = #colorLiteral(red: 0.02352941176, green: 0.7568627451, blue: 0.4117647059, alpha: 1)
        
        dropDown.show()
    }
    
    @IBAction func infoBtn(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "NutritionGoal_InfoVC") as? NutritionGoal_InfoVC else { return }
        
        vc.macroOptions = self.SuggestedData.macro_options ?? ""
        vc.disclaimer = self.SuggestedData.disclaimer ?? ""
        vc.SelectedMacroType = self.DropDownTxtF.text ?? ""
        
        vc.modalPresentationStyle = .pageSheet
        if let sheet = vc.sheetPresentationController {
            sheet.detents = [.large()]
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 20
        }
        vc.isModalInPresentation = false
        
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func UpdateBtn(_ sender: UIButton) {
        guard CaloriesSlider.value >= 1200 else {
            showToast("Alert: Minimum 1200 calories required.")
            return
        }
        
        self.backAction(
            self.DropDownTxtF.text!,
            Int(CaloriesSlider.value),
            Int(FatSlider.value),
            Int(CarbsSlider.value),
            Int(ProteinSlider.value),
            self.SuggestedData,
            self.SuggestedData.isCaloriesSliderMoves ?? false
        )
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func calcelBtn(_ sender: UIButton) {
        self.headsupPopupView.isHidden = true
        
        switch self.currentSlider {
        case "fat":
            SuggestedData.isfatSliderMoves = false
            self.resetFat(list: uNchangedSuggestedData)
        case "carb":
            SuggestedData.isCarbSliderMoves = false
            self.resetCarb(list: uNchangedSuggestedData)
        case "protien":
            SuggestedData.isProtienliderMoves = false
            self.resetProtien(list: uNchangedSuggestedData)
        case "carbpro":
            SuggestedData.iscarbProtienMoves = false
            self.resetProtien(list: uNchangedSuggestedData)
        case "fatpro":
            SuggestedData.iscarbProtienMoves = false
            self.resetProtien(list: uNchangedSuggestedData)
        case "calorie":
            self.SuggestedData.isCaloriesSliderMoves = false
            self.resetCalorie(list: uNchangedSuggestedData)
        default:
            self.SuggestedData.isCaloriesSliderMoves = false
            self.setData(list: uNchangedSuggestedData)
        }
        updateIndividualResetButtons()
        self.infoLbl.text = self.infoLableTxt
        self.DropDownTxtF.text = self.originalMacroName
        view.viewWithTag(110)?.isHidden = false
    }
    
    @IBAction func RestorePlanBtn(_ sender: UIButton) {
        self.SuggestedData.isCaloriesSliderMoves = false
        self.resetCalorie(list: uNchangedSuggestedData)
        self.CustomCaloriesPopupView.isHidden = true
        self.infoLbl.text = self.infoLableTxt
        self.DropDownTxtF.text = self.originalMacroName
        view.viewWithTag(110)?.isHidden = false
        updateIndividualResetButtons()
    }
    
    @IBAction func ProceedAnywayBtn(_ sender: UIButton) {
        self.SuggestedData.isCaloriesSliderMoves = true
        self.DropDownTxtF.text = "Custom"
        view.viewWithTag(110)?.isHidden = true
        self.infoLbl.text = "Create your own customization"
        self.CustomCaloriesPopupView.isHidden = true
    }
    
    @IBAction func `continue`(_ sender: UIButton) {
        switch self.currentSlider {
        case "fat":
            SuggestedData.isfatSliderMoves = true
        case "carb":
            SuggestedData.isCarbSliderMoves = true
        case "protien":
            SuggestedData.isProtienliderMoves = true
        case "carbpro":
            SuggestedData.iscarbProtienMoves = true
        case "fatpro":
            SuggestedData.isFatProtienMoves = true
        case "calorie":
            self.SuggestedData.isCaloriesSliderMoves = true
        default:
            self.SuggestedData.isCaloriesSliderMoves = true
        }
        
        self.headsupPopupView.isHidden = true
        self.DropDownTxtF.text = "Custom"
        self.infoLbl.text = "Create your own customization"
        view.viewWithTag(110)?.isHidden = true
    }
    
    @IBAction func caloryReload(_ sender: UIButton) {
        SuggestedData.calories = uNchangedSuggestedData.calories
        CaloriesSlider.value = Float(SuggestedData.calories ?? 0)
        CaloriesSliderLbl.text = "\(SuggestedData.calories ?? 0)"
        updateIndividualResetButtons()
    }
    
    @IBAction func fatReload(_ sender: UIButton) {
        SuggestedData.fat = uNchangedSuggestedData.fat
        FatSlider.value = Float(SuggestedData.fat ?? 0)
        FatSliderLbl.text = "\(SuggestedData.fat ?? 0)"
        updateIndividualResetButtons()
    }
    
    @IBAction func carbsReload(_ sender: UIButton) {
        SuggestedData.carbs = uNchangedSuggestedData.carbs
        CarbsSlider.value = Float(SuggestedData.carbs ?? 0)
        CarbsSliderLbl.text = "\(SuggestedData.carbs ?? 0)"
        updateIndividualResetButtons()
    }
    
    @IBAction func protienReload(_ sender: UIButton) {
        SuggestedData.protein = uNchangedSuggestedData.protein
        ProteinSlider.value = Float(SuggestedData.protein ?? 0)
        ProteinSliderLbl.text = "\(SuggestedData.protein ?? 0)"
        updateIndividualResetButtons()
    }
    
    // MARK: - API Methods
    func Api_To_Get_NutritionGoalSuggestionData() {
        var params = [String: Any]()
        
        params["height"] = self.SuggestedData.height ?? ""
        params["height_type"] = self.SuggestedData.heightType ?? ""
        params["weight"] = self.SuggestedData.weight ?? ""
        params["weight_type"] = self.SuggestedData.weightType ?? ""
        params["target_weight"] = self.SuggestedData.targetWeight ?? ""
        params["target_weight_type"] = self.SuggestedData.targetWeightType ?? ""
        params["activityLevel"] = self.SuggestedData.activityLevel ?? ""
        params["dob"] = self.SuggestedData.dob ?? ""
        params["type"] = self.SuggestedData.target ?? ""
        params["macros"] = self.DropDownTxtF.text
        params["calories"] = "\(self.SuggestedData.calories ?? 0)"
        params["fat_per"] = "\(self.SuggestedData.macroPer?.fat ?? 0)"
        params["protein_per"] = "\(self.SuggestedData.macroPer?.protein ?? 0)"
        params["carbs_per"] = "\(self.SuggestedData.macroPer?.carbs ?? 0)"
        params["gender"] = self.SuggestedData.gender ?? "Male"
        
        showIndicator(withTitle: "", and: "")
        
        let loginURL = baseURL.baseURL + appEndPoints.user_diet_suggetion
        print(params, "Params")
        print(loginURL, "loginURL")
        
        WebService.shared.postServiceURLEncoding(loginURL, VC: self, andParameter: params, withCompletion: { (json, statusCode) in
            self.hideIndicator()
            
            let data = try! json.rawData()
            
            do {
                let d = try JSONDecoder().decode(HealthSuggestedModelClass.self, from: data)
                if d.success == true {
                    if let list = d.data {
                        self.SuggestedData = list
                        self.setData(list: list)
                    }
                } else {
                    let msg = d.message ?? ""
                    self.showToast(msg)
                }
            } catch {
                print(error)
            }
        })
    }
}


