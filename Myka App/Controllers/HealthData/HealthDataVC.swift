//
//  HealthDataVC.swift
//  Myka App
//
//  Created by YES IT Labs on 17/12/24.
//

import UIKit
import DropDown
import Alamofire
import RangeSeekSlider

class HealthDataVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var MaleImg: UIImageView!
    @IBOutlet weak var MaleBtnO: UIButton!
    
    @IBOutlet weak var FeMaleImg: UIImageView!
    @IBOutlet weak var FeMaleBtnO: UIButton!
    
    @IBOutlet weak var DOBTxtF: UITextField!
    
    @IBOutlet weak var HeightTxtF: UITextField!
  
    
    @IBOutlet weak var WeightTxtF: UITextField!
    
    @IBOutlet weak var targetWeightTxtF: UITextField!
    @IBOutlet weak var targetWeightBtnO: UIButton!
    
    @IBOutlet weak var targetDateDropdownLbl: UITextField!
    @IBOutlet weak var targetDateDropdownBtnO: UIButton!
    
     
    @IBOutlet weak var LevelTxtF: UITextField!
    
    @IBOutlet weak var NutritionGoalBgV: UIView!

    @IBOutlet weak var targetWeightMsgLbl: UILabel!
    
    
    @IBOutlet weak var targetDateInfoLbl: UILabel!
    
    @IBOutlet weak var EditNutriitionBtnO: UIButton!
    
    @IBOutlet weak var DoneBtnO: UIButton!
    @IBOutlet weak var calculateGoalsBtnO: UIButton!
    @IBOutlet weak var CalTxtF: UITextField!
    @IBOutlet weak var FatTxtF: UITextField!
    @IBOutlet weak var CarbsTxtF: UITextField!
    @IBOutlet weak var ProtienTxtF: UITextField!
    
    @IBOutlet var disclaimerPopupView: UIView!
    @IBOutlet weak var continueBtnO: UIButton!
    @IBOutlet weak var checkboxBtnO: UIButton!
    
    
    
    var datePicker = UIDatePicker()
    let dateFormatter = DateFormatter()
    var toolBar = UIToolbar()
    let screenWidth = UIScreen.main.bounds.width

    
    let dropDown = DropDown()
    
    let LevelDropDown = DropDown()
    
    private var HeighProtine = ""
    private var Name = ""
    private var Bio = ""
    private var macros = "Balanced"
    var comesFrom = ""
    
    var isComesFromPlanTab = false
    
    var levelDescArray = ["Little to no exercise (desk job, minimal walking).", "Light exercise or sports 1–3 days/week (casual walks, yoga).", "Moderate exercise 3–5 days/week (gym workouts, cycling).", "Hard exercise 6–7 days/week or a physically demanding job."]
    
    var SuggestedData = HealthSuggestedData()
    
    var targetDateArray = [DataPerWeek]()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.disclaimerPopupView.frame = self.view.bounds
        self.view.addSubview(self.disclaimerPopupView)
        self.disclaimerPopupView.isHidden = true
        
        continueBtnO.setBackgroundImage(UIImage(named: "ButtonGray"), for: .normal)
        continueBtnO.isUserInteractionEnabled = false
        
        self.HeightTxtF.isUserInteractionEnabled = false
        
        self.NutritionGoalBgV.isHidden = true
        self.calculateGoalsBtnO.isHidden = false
        self.EditNutriitionBtnO.isHidden = true
        self.DoneBtnO.isHidden = true
        self.calculateGoalsBtnO.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        self.calculateGoalsBtnO.isUserInteractionEnabled = false
        
        
        self.CalTxtF.isUserInteractionEnabled = false
        self.FatTxtF.isUserInteractionEnabled = false
        self.CarbsTxtF.isUserInteractionEnabled = false
        self.ProtienTxtF.isUserInteractionEnabled = false
        
        HeightTxtF.delegate = self
        WeightTxtF.delegate = self
        
        toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 44.0))
        
        toolBar.sizeToFit()
       
        toolBar.tintColor = .systemBlue
        toolBar.isUserInteractionEnabled = true
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneButtonTapped))
        doneButton.tintColor = .black
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([flexibleSpace, doneButton], animated: false)
        toolBar.backgroundColor = .white
      
        DOBTxtF.inputView = datePicker
        DOBTxtF.inputAccessoryView = toolBar
        DOBTxtF.delegate = self
        datePicker.minimumDate = .none
         
        var date = Date()
        let calendar = Calendar.current
        
        if let date13YearsAgo = calendar.date(byAdding: .year, value: -13, to: date) {
            print("Date 13 years ago: \(date13YearsAgo)")
            date = date13YearsAgo
        } else {
            print("Failed to calculate the date 13 years ago.")
        }
        
        datePicker.maximumDate = date
        
        
        datePicker.preferredDatePickerStyle = .wheels
      
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            self?.datePicker.backgroundColor = .white
            self?.datePicker.subviews[0].subviews[1].backgroundColor = #colorLiteral(red: 0, green: 0.7843137255, blue: 0.4862745098, alpha: 0.09602649007)
            self?.datePicker.subviews[0].subviews[2].backgroundColor = #colorLiteral(red: 0, green: 0.7843137255, blue: 0.4862745098, alpha: 0.09602649007)
        }
        self.Api_To_Get_HealthData()
    }
  
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
               if textField == DOBTxtF {
                   datePicker.datePickerMode = .date
               }
           }
        
           @objc func doneButtonTapped() {
               if DOBTxtF.isFirstResponder {
                   dateFormatter.dateStyle = .medium
                   dateFormatter.timeStyle = .none
                   dateFormatter.dateFormat = "dd/MM/yyyy"
                   DOBTxtF.text = dateFormatter.string(from: datePicker.date)
                   
                   view.endEditing(true)
                   
                   if self.DOBTxtF.text != "" && self.HeightTxtF.text! != "" && self.WeightTxtF.text! != "" && self.targetWeightTxtF.text! != "" && self.LevelTxtF.text! != ""{
                       self.calculateGoalsBtnO.isUserInteractionEnabled = true
                       self.calculateGoalsBtnO.backgroundColor = #colorLiteral(red: 0, green: 0.786260426, blue: 0.4870494008, alpha: 1)
                       self.Api_To_Get_NutritionGoalSuggestionData()
                   }
                   
               }
               self.view.endEditing(true)
           }

    
    
    @IBAction func BackBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func MaleBtn(_ sender: UIButton) {
        self.MaleImg.image = UIImage(named: "Group 1171276687")
        self.MaleBtnO.isSelected = true
        self.FeMaleImg.image = UIImage(named: "Ellipse 96")
        self.FeMaleBtnO.isSelected = false
        Api_To_Get_NutritionGoalSuggestionData()
        view.endEditing(true)
    }
    
    @IBAction func FemaleBtn(_ sender: UIButton) {
        
        self.FeMaleImg.image = UIImage(named: "Group 1171276687")
        self.FeMaleBtnO.isSelected = true
        self.MaleImg.image = UIImage(named: "Ellipse 96")
        self.MaleBtnO.isSelected = false
        Api_To_Get_NutritionGoalSuggestionData()
        view.endEditing(true)
    }
    
    
    @IBAction func heightBtn(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "HeightPickerVC") as! HeightPickerVC
        
        vc.selectedHeight = simplifyHeight(self.HeightTxtF.text ?? "")
        
        if self.HeightTxtF.text!.contains(s: "cm"){
            vc.isFeetSelected = false
        }else{
            vc.isFeetSelected = true
        }
        
        vc.backAction = { str in
            print(str, "<< Str")
            if !str.contains(s: "cm"){
                self.HeightTxtF.text = self.formatHeight(heightString: str)
            }else{
                self.HeightTxtF.text = str
            }
            if self.DOBTxtF.text != "" && self.HeightTxtF.text! != "" && self.WeightTxtF.text! != "" && self.targetWeightTxtF.text! != "" && self.LevelTxtF.text! != ""{
                self.calculateGoalsBtnO.isUserInteractionEnabled = true
                self.calculateGoalsBtnO.backgroundColor = #colorLiteral(red: 0, green: 0.786260426, blue: 0.4870494008, alpha: 1)
                
                self.Api_To_Get_NutritionGoalSuggestionData()
            }
        }
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func weightBtn(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "WeightPickerVC") as! WeightPickerVC
        vc.Weight = self.WeightTxtF.text ?? ""
        vc.comesfromWeight = true
       print(self.WeightTxtF.text?.lowercased() ?? "")
        if (self.WeightTxtF.text?.lowercased() ?? "").contains(s: "kg"){
            vc.isPoundsSelected = false
        }else{
            vc.isPoundsSelected = true
        }
        
        vc.backAction = { str in
            self.WeightTxtF.text = str
            self.SuggestedData.weight = str
            if self.DOBTxtF.text != "" && self.HeightTxtF.text! != "" && self.WeightTxtF.text! != "" && self.targetWeightTxtF.text! != "" && self.LevelTxtF.text! != ""{
                self.calculateGoalsBtnO.isUserInteractionEnabled = true
                self.calculateGoalsBtnO.backgroundColor = #colorLiteral(red: 0, green: 0.786260426, blue: 0.4870494008, alpha: 1)
                self.targetWeightTxtF.text = ""
              //  self.Api_To_Get_NutritionGoalSuggestionData()
                
            }
        }
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func targetWeightBtn(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "WeightPickerVC") as! WeightPickerVC
        vc.comesfromWeight = false
        vc.Weight = self.WeightTxtF.text!
        vc.targetWeight = self.targetWeightTxtF.text ?? ""
        
        if (self.WeightTxtF.text?.lowercased() ?? "").contains(s: "kg"){
            vc.isPoundsSelected = false
        }else{
            vc.isPoundsSelected = true
        }
        
        print(self.WeightTxtF.text?.lowercased() ?? "")
        vc.backAction = { str in
            self.targetWeightTxtF.text = str
            self.SuggestedData.targetWeight = str
            if self.DOBTxtF.text != "" && self.HeightTxtF.text! != "" && self.WeightTxtF.text! != "" && self.targetWeightTxtF.text! != "" && self.LevelTxtF.text! != ""{
                self.calculateGoalsBtnO.isUserInteractionEnabled = true
                self.calculateGoalsBtnO.backgroundColor = #colorLiteral(red: 0, green: 0.786260426, blue: 0.4870494008, alpha: 1)
                self.Api_To_Get_NutritionGoalSuggestionData()
            }
        }
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func LevelDropDownBtn(_ sender: UIButton) {
        view.endEditing(true)
         
        LevelDropDown.dataSource = ["Sedentary","Lightly active","Moderately active", "Very active"]
  
        LevelDropDown.anchorView = sender
          
          let trailingSpace: CGFloat = 5
        LevelDropDown.bottomOffset = CGPoint(x: -trailingSpace, y: sender.bounds.height)
        LevelDropDown.topOffset = CGPoint(x: -trailingSpace, y: -(LevelDropDown.anchorView?.plainView.bounds.height ?? 0))
        LevelDropDown.width = sender.frame.width + 10
        LevelDropDown.setupCornerRadius(10)
          
  
        LevelDropDown.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        LevelDropDown.layer.shadowOpacity = 0
        LevelDropDown.layer.shadowRadius = 4
        LevelDropDown.layer.shadowOffset = CGSize(width: 0, height: 0)
        LevelDropDown.backgroundColor = .white
        LevelDropDown.cellHeight = 70
        LevelDropDown.textFont = UIFont.systemFont(ofSize: 16)
        
       
        LevelDropDown.cellNib = UINib(nibName: "levelDropDownTblVCell", bundle: nil)
        LevelDropDown.customCellConfiguration = { [weak self] (index: Index, item: String, cell: DropDownCell) in
            guard let cell = cell as? levelDropDownTblVCell else { return }
            guard let self = self else { return }
            let desc = levelDescArray[index]
            cell.descLbl.text = desc
        }
        
        
        LevelDropDown.selectionAction = { [weak self] (index: Int, item: String) in
          guard let self = self else { return }
          print(index)
            self.LevelTxtF.text = item
             
            if self.DOBTxtF.text != "" && self.HeightTxtF.text! != "" && self.WeightTxtF.text! != "" && self.targetWeightTxtF.text! != "" && self.LevelTxtF.text! != ""{
                self.calculateGoalsBtnO.isUserInteractionEnabled = true
                self.calculateGoalsBtnO.backgroundColor = #colorLiteral(red: 0, green: 0.786260426, blue: 0.4870494008, alpha: 1)
                self.Api_To_Get_NutritionGoalSuggestionData()
            }
              
      }
        LevelDropDown.show()
    }
    
 
    @IBAction func targetDateDropDownBtn(_ sender: UIButton) {
        view.endEditing(true)
        
        dropDown.dataSource = self.targetDateArray.map { String($0.name ?? "") }
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
        dropDown.cellHeight = 65
        dropDown.selectionBackgroundColor = .clear
        dropDown.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    
        dropDown.cellNib = UINib(nibName: "targetDateDropDownTblVCell", bundle: nil)
        dropDown.customCellConfiguration = { [weak self] (index: Index, item: String, cell: DropDownCell) in
            guard let cell = cell as? targetDateDropDownTblVCell else { return }
            guard let self = self else { return }
            _ = self.targetDateArray[index].days ?? 0
            let newEstimatedDays = self.SuggestedData.dataPerWeek?[index].days ?? 0.0
            let estimatedDays = convertDaysToMonthsAndDays(totalDays: Int(newEstimatedDays))
            
//            let estimatedDays = self.SuggestedData.time ?? 0
//            let months = estimatedDays/30
//            let days = estimatedDays % 30
//            
//            var estimatedText = "Estimated time: "
//            
//            if months > 0 {
//                estimatedText += "\(months) \(months == 1 ? "month" : "months")"
//            }
//            
//            if days > 0 {
//                if months > 0 { estimatedText += " and " }
//                estimatedText += "\(days) \(days == 1 ? "day" : "days")"
//            }
//            cell.EstimateLbl.text = estimatedText
            
            if estimatedDays.months == 0 && estimatedDays.days == 0 {
                cell.EstimateLbl.isHidden = false
                cell.EstimateLbl.text = "Estimated time : " // or something like "No estimated time"
                } else {
                    let monthText = estimatedDays.months > 0 ? "\(estimatedDays.months) \(estimatedDays.months == 1 ? "month" : "months")" : ""
                    let dayText = estimatedDays.days > 0 ? "\(estimatedDays.days) \(estimatedDays.days == 1 ? "day" : "days")" : ""

                    var estimatedText = "Estimated time : "
                    if !monthText.isEmpty {
                        estimatedText += monthText
                    }
                    if !monthText.isEmpty && !dayText.isEmpty {
                        estimatedText += " and "
                    }
                    if !dayText.isEmpty {
                        estimatedText += dayText
                    }

                    cell.EstimateLbl.isHidden = false
                    cell.EstimateLbl.text = estimatedText
                }
            
            let lbPerWeek = self.targetDateArray[index].value ?? 0.5
            let output = lbPerWeek.truncatingRemainder(dividingBy: 1) == 0 ? "\(Int(lbPerWeek))" : "\(lbPerWeek)"
            
//            var weightUnit = ""
            
//            if let text = self.WeightTxtF.text?.lowercased(), text.contains("kg") {
//                weightUnit = "kg"
//            } else {
//                weightUnit = "lb"
//            }
//            if self.SuggestedData.dataPerWeek?[index].tar == "Lose"{
//                cell.lbPerWeekLbl.text = "You'll lose \(output) \(weightUnit)/week"
//            }else{
//                cell.lbPerWeekLbl.text = "You'll gain \(output) \(weightUnit)/week"
//            }
            cell.lbPerWeekLbl.text = "You'll lose \(output) lb/week"
            
            if self.targetDateArray[index].isSelected == 1{
                cell.BgV.backgroundColor = #colorLiteral(red: 0.9058823529, green: 1, blue: 0.9568627451, alpha: 1)
            }else{
                cell.BgV.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
            }
        }
        
        dropDown.selectionAction = { [weak self] (index: Int, item: String) in
            guard let self = self else { return }
            print(index)
            self.targetDateDropdownLbl.text = item
            self.targetDateInfoLbl.text = self.targetDateArray[index].description ?? ""
            self.targetDateInfoLbl.textColor = #colorLiteral(red: 0, green: 0.786260426, blue: 0.4870494008, alpha: 1)
            
            if self.DOBTxtF.text != "" && self.HeightTxtF.text! != "" && self.WeightTxtF.text! != "" && self.targetWeightTxtF.text! != "" && self.LevelTxtF.text! != ""{
                self.calculateGoalsBtnO.isUserInteractionEnabled = true
                self.calculateGoalsBtnO.backgroundColor = #colorLiteral(red: 0, green: 0.786260426, blue: 0.4870494008, alpha: 1)
                self.Api_To_Get_NutritionGoalSuggestionData()
            }
        }
        dropDown.show()
    }
    
    @IBAction func CalculateGoalBtn(_ sender: UIButton) {
        view.endEditing(true)
        self.disclaimerPopupView.isHidden = false
        self.checkboxBtnO.isSelected = false
        self.continueBtnO.setBackgroundImage(UIImage(named: "ButtonGray"), for: .normal)
        self.continueBtnO.isUserInteractionEnabled = false
    }
    
    @IBAction func EditNutriitionBtn(_ sender: UIButton) {
        view.endEditing(true)
        self.disclaimerPopupView.isHidden = false
        self.checkboxBtnO.isSelected = false
        self.continueBtnO.setBackgroundImage(UIImage(named: "ButtonGray"), for: .normal)
        self.continueBtnO.isUserInteractionEnabled = false
    }
    
    @IBAction func DoneBtn(_ sender: UIButton) {
        view.endEditing(true)
        self.CalTxtF.isUserInteractionEnabled = false
        self.FatTxtF.isUserInteractionEnabled = false
        self.CarbsTxtF.isUserInteractionEnabled = false
        self.ProtienTxtF.isUserInteractionEnabled = false
       
        self.Api_To_Upload_HealthData()
    }
    
    
    @IBAction func checkboxBtn(_ sender: UIButton) {
        if self.checkboxBtnO.isSelected == true{
            self.checkboxBtnO.isSelected = false
            self.continueBtnO.setBackgroundImage(UIImage(named: "ButtonGray"), for: .normal)
            self.continueBtnO.isUserInteractionEnabled = false
        }else{
            self.checkboxBtnO.isSelected = true
            self.continueBtnO.setBackgroundImage(UIImage(named: "Button"), for: .normal)
            self.continueBtnO.isUserInteractionEnabled = true
        }
    }
    
    @IBAction func cancelBtn(_ sender: UIButton) {
        self.disclaimerPopupView.isHidden = true
        self.checkboxBtnO.isSelected = false
        self.continueBtnO.setBackgroundImage(UIImage(named: "ButtonGray"), for: .normal)
        self.continueBtnO.isUserInteractionEnabled = false
    }
    @IBAction func tapToRestoreButtonBtn(_ sender: UIButton) {
        Api_To_Get_NutritionGoalSuggestionData(old: true)
    }
    
    @IBAction func continueBtn(_ sender: UIButton) {
        self.disclaimerPopupView.isHidden = true
        self.checkboxBtnO.isSelected = false
        self.continueBtnO.setBackgroundImage(UIImage(named: "ButtonGray"), for: .normal)
        self.continueBtnO.isUserInteractionEnabled = false
        
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "NutritionGoalVC") as! NutritionGoalVC
        vc.SuggestedData = self.SuggestedData
        vc.heighProtine = self.HeighProtine
        vc.uNchangedSuggestedData = self.SuggestedData
        vc.name = self.Name
        
        vc.backAction = { heighProt, calories, fat, carbs, protien, data, isCaloriesSliderMoves in
            self.SuggestedData = data
           
            if heighProt != "" || calories != 0 || fat != 0 || carbs != 0 || protien != 0 {
                self.NutritionGoalBgV.isHidden = false
                self.calculateGoalsBtnO.isHidden = true
                self.EditNutriitionBtnO.isHidden = false
                self.DoneBtnO.isHidden = false
            }
            self.HeighProtine = heighProt
            
            if isCaloriesSliderMoves {
                self.targetWeightMsgLbl.text = "You have set your own calories so your target weight cannot be calculated."
                
                self.view.viewWithTag(101)?.isHidden = true
                self.view.viewWithTag(102)?.isHidden = false
                if let label = self.view.viewWithTag(103) as? UILabel{
                    label.text = self.SuggestedData.target
                }
                self.targetDateInfoLbl.text = ""
                self.targetDateInfoLbl.isHidden = true
                self.SuggestedData.typeStatus = "1"
                self.targetDateInfoLbl.textColor = .red
                self.targetWeightTxtF.text = ""
                self.targetDateDropdownLbl.text = ""
                self.targetDateDropdownLbl.placeholder = "Target Date"
                self.targetWeightBtnO.isUserInteractionEnabled = false
                self.targetDateDropdownBtnO.isUserInteractionEnabled = false
                self.SuggestedData.old_macro = self.SuggestedData.macros
            }else{
                self.SuggestedData.typeStatus = "0"
                let targetWeight = self.SuggestedData.targetWeight ?? ""
                let targetWeight_type = self.SuggestedData.targetWeightType ?? ""
                
                if targetWeight_type == "Kilograms"{
                    if targetWeight != "" && targetWeight != "0"{
                        self.targetWeightTxtF.text = "\(targetWeight) kg"
                    }else{
                        self.targetWeightTxtF.text = ""
                    }
                }else{
                    if targetWeight != "" && targetWeight != "0"{
                        self.targetWeightTxtF.text = "\(targetWeight) lb"
                    }else{
                        self.targetWeightTxtF.text = ""
                    }
                }
               
                if let indx = self.targetDateArray.firstIndex(where: {$0.isSelected == 1}){
                    let target = self.targetDateArray[indx].name ?? ""
                    self.targetDateDropdownLbl.text = target.capitalizedFirst
                    
                    self.targetDateInfoLbl.text = self.targetDateArray[indx].description
                    self.targetDateInfoLbl.textColor = #colorLiteral(red: 0, green: 0.786260426, blue: 0.4870494008, alpha: 1)
                    
                    self.targetWeightMsgLbl.text = ""
                }
                
                self.targetWeightBtnO.isUserInteractionEnabled = true
                self.targetDateDropdownBtnO.isUserInteractionEnabled = true
            }
             
            //let calories = self.SuggestedData.calories ?? 0
            self.CalTxtF.text = "\(calories)"
            
            self.SuggestedData.calories = calories
            let fatVal = self.calculateGram(calorieTarget: calories, percentage: fat, divide: 9)
                self.FatTxtF.text = "\(fatVal)"
           
              
            let carbsVal = self.calculateGram(calorieTarget: calories, percentage: carbs, divide: 4)
                self.CarbsTxtF.text = "\(carbsVal)"
            
              
            let proteinVal = self.calculateGram(calorieTarget: calories, percentage: protien, divide: 4)
                self.ProtienTxtF.text = "\(proteinVal)"
        }
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func validateInputs(includeActivityLevel: Bool) -> Bool {
        if self.DOBTxtF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            AlertControllerOnr(title: "", message: "Please Select DOB")
            return false
        } else if self.HeightTxtF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            AlertControllerOnr(title: "", message: "Please Select Height")
            return false
        } else if self.WeightTxtF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            AlertControllerOnr(title: "", message: "Please Select Weight.")
            return false
        } else if self.targetWeightTxtF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            AlertControllerOnr(title: "", message: "Please Select Target Weight.")
            return false
        } else if includeActivityLevel && self.LevelTxtF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            AlertControllerOnr(title: "", message: "Select Your Activity Level.")
            return false
        }
        return true
    }
    
    func formatHeight(heightString: String) -> String {
        // Check if inches (") are already included
        if heightString.contains("\"") {
            return heightString.trimmingCharacters(in: .whitespaces)
        } else {
            return heightString.trimmingCharacters(in: .whitespaces) + " 0\""
        }
    }
    
    func convertDaysToMonthsAndDays(totalDays: Int) -> (months: Int, days: Int) {
        let daysInMonth = 30  // Approximate month length
        let months = totalDays / daysInMonth
        let days = totalDays % daysInMonth
        return (months, days)
    }
    
    func simplifyHeight(_ heightString: String) -> String {
        let trimmed = heightString.trimmingCharacters(in: .whitespaces)
        
        // Match pattern: e.g. "4' 11\""
        let pattern = #"(\d+)' ?(\d+)""#
        let regex = try? NSRegularExpression(pattern: pattern)
        
        if let match = regex?.firstMatch(in: trimmed, range: NSRange(trimmed.startIndex..., in: trimmed)),
           let feetRange = Range(match.range(at: 1), in: trimmed),
           let inchRange = Range(match.range(at: 2), in: trimmed) {
            
            let feet = trimmed[feetRange]
            let inches = trimmed[inchRange]
            
            if inches == "0" {
                return "\(feet)'"  // Simplify to feet only
            } else {
                return "\(feet)' \(inches)\""
            }
        }
        
        return trimmed // Return as-is if not matching expected format
    }
    
}
 


extension HealthDataVC {
    func Api_To_Get_HealthData(){
        let params = [String: Any]()
        
        showIndicator(withTitle: "", and: "")
        
        let loginURL = baseURL.baseURL + appEndPoints.getUserProfile
        print(params,"Params")
        print(loginURL,"loginURL")
        
        WebService.shared.postServiceURLEncoding(loginURL, VC: self, andParameter: params, withCompletion: { (json, statusCode) in
            
            self.hideIndicator()
            
            let data = try! json.rawData()
            
            do{
                let d = try JSONDecoder().decode(HealthSuggestedModelClass.self, from: data)
                if d.success == true {
                    let list = d.data
                    
                    self.SuggestedData = list ?? HealthSuggestedData()
                    self.targetDateArray = self.SuggestedData.dataPerWeek ?? []
                    
                    if let indx = self.targetDateArray.firstIndex(where: {$0.isSelected == 1}){
                        let target = self.targetDateArray[indx].name ?? ""
                        self.targetDateDropdownLbl.text = target.capitalizedFirst
                        
                        self.targetDateInfoLbl.text = self.targetDateArray[indx].description
                        self.targetDateInfoLbl.textColor = #colorLiteral(red: 0, green: 0.786260426, blue: 0.4870494008, alpha: 1)
                    }

                    
                    
                    let name = self.SuggestedData.name ?? ""
                    self.Name = name.capitalizedFirst
                    
                    let bio = self.SuggestedData.bio ?? ""
                    self.Bio = bio
                    let dob = self.SuggestedData.dob ?? ""
                    if !dob.isEmpty {
                        let inputFormatter = DateFormatter()
                        inputFormatter.dateFormat = "MM/dd/yyyy"

                        let outputFormatter = DateFormatter()
                        outputFormatter.dateFormat = "dd/MM/yyyy"

                        if let date = inputFormatter.date(from: dob) {
                            self.DOBTxtF.text = outputFormatter.string(from: date)
                        } else {
                            self.DOBTxtF.text = ""
                        }
                    } else {
                        self.DOBTxtF.text = ""
                    }
                    let calories = self.SuggestedData.calories ?? 0
                    self.CalTxtF.text = "\(calories)"
                    
                    
                    let fatVal = self.calculateGram(calorieTarget: self.SuggestedData.calories ?? 0, percentage: self.SuggestedData.macroPer?.fat ?? 0, divide: 9)
                        self.FatTxtF.text = "\(fatVal)"
                   
                      
                    let carbsVal = self.calculateGram(calorieTarget: self.SuggestedData.calories ?? 0, percentage: self.SuggestedData.macroPer?.carbs ?? 0, divide: 4)
                        self.CarbsTxtF.text = "\(carbsVal)"
                    
                      
                    let proteinVal = self.calculateGram(calorieTarget: self.SuggestedData.calories ?? 0, percentage: self.SuggestedData.macroPer?.protein ?? 0, divide: 4)
                        self.ProtienTxtF.text = "\(proteinVal)"
                    
                    let fat = self.SuggestedData.fat ?? 0
                    let carbs = self.SuggestedData.carbs ?? 0
                    let protien = self.SuggestedData.protein ?? 0
                    let gender = self.SuggestedData.gender ?? ""
                    let SelGender = gender.uppercased()
                    
//                    if gender != ""{
//                        self.MaleBtnO.isUserInteractionEnabled = false
//                        self.FeMaleBtnO.isUserInteractionEnabled = false
//                    }else{
//                        self.MaleBtnO.isUserInteractionEnabled = true
//                        self.FeMaleBtnO.isUserInteractionEnabled = true
//                    }
                    
                    if SelGender == "MALE"{
                        self.MaleImg.image = UIImage(named: "Group 1171276687")
                        self.MaleBtnO.isSelected = true
                        self.FeMaleImg.image = UIImage(named: "Ellipse 96")
                        self.FeMaleBtnO.isSelected = false
                    }else{
                        self.FeMaleImg.image = UIImage(named: "Group 1171276687")
                        self.FeMaleBtnO.isSelected = true
                        self.MaleImg.image = UIImage(named: "Ellipse 96")
                        self.MaleBtnO.isSelected = false
                    }
                    
                    
                    let height = self.SuggestedData.height ?? ""
                    let heightType = self.SuggestedData.heightType ?? ""
                    
                    if heightType == "feet"{
                        if let heightInFeet = Double(height) {
                            let feet = Int(heightInFeet)
                            let inchesDecimal = (heightInFeet - Double(feet)) * 12
                            let inches = Int(round(inchesDecimal))

                            let formattedHeight = "\(feet)' \(inches)\""
                            print(formattedHeight)
                            self.HeightTxtF.text = formattedHeight
                        }
                    }else{
                        if height != ""{
                            self.HeightTxtF.text = "\(height) cm"
                        }else{
                            self.HeightTxtF.text = ""
                        }
                    }
                    
                    
                    let Weight = self.SuggestedData.weight ?? ""
                    let Weight_type = self.SuggestedData.weightType ?? ""
                    
                    if Weight_type == "Kilograms"{
                        if Weight != ""{
                            self.WeightTxtF.text = "\(Weight) kg"
                        }else{
                            self.WeightTxtF.text = ""
                        }
                    }else{
                        if Weight != ""{
                            self.WeightTxtF.text = "\(Weight) lb"
                        }else{
                            self.WeightTxtF.text = ""
                        }
                    }
                    
                    
                    let targetWeight = self.SuggestedData.targetWeight ?? ""
                    let targetWeight_type = self.SuggestedData.targetWeightType ?? ""
                    
                    if targetWeight_type == "Kilograms"{
                        if targetWeight != "" && targetWeight != "0"{
                            self.targetWeightTxtF.text = "\(targetWeight) kg"
                        }else{
                            self.targetWeightTxtF.text = ""
                        }
                    }else{
                        if targetWeight != "" && targetWeight != "0"{
                            self.targetWeightTxtF.text = "\(targetWeight) lb"
                        }else{
                            self.targetWeightTxtF.text = ""
                        }
                    }
                    let target = self.SuggestedData.target ?? ""
                    self.targetDateDropdownLbl.text = target.capitalizedFirst
                    
                    let activity_level = self.SuggestedData.activityLevel ?? ""
                    self.LevelTxtF.text = activity_level
                    let height_protein = self.SuggestedData.heightProtein ?? ""
                    self.HeighProtine = height_protein
                    
        
                    
                    if calories != 0 || fat != 0 || carbs != 0 || protien != 0{
                        self.NutritionGoalBgV.isHidden = false
                        self.calculateGoalsBtnO.isHidden = true
                        self.EditNutriitionBtnO.isHidden = false
                        self.DoneBtnO.isHidden = false
                    }
                    
                    if self.SuggestedData.typeStatus == "1"{
                        self.targetWeightMsgLbl.text = "You have set your own calories so your target weight cannot be calculated."
                        
                        self.view.viewWithTag(101)?.isHidden = true
                        if let label = self.view.viewWithTag(103) as? UILabel{
                            label.text = self.SuggestedData.macros
                        }
                        self.targetDateInfoLbl.text = ""
                        self.targetDateInfoLbl.isHidden = true
                        
                        self.targetDateInfoLbl.textColor = .red
                        self.targetWeightTxtF.text = ""
                        self.targetDateDropdownLbl.text = ""
                        self.targetDateDropdownLbl.placeholder = "Target Date"
                        self.targetWeightBtnO.isUserInteractionEnabled = false
                        self.targetDateDropdownBtnO.isUserInteractionEnabled = false
                    }else{
                        self.view.viewWithTag(101)?.isHidden = false
                        self.view.viewWithTag(102)?.isHidden = true
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
    
    
    func calculateGram(calorieTarget: Int, percentage: Int, divide: Int) -> Int {
        let totalGram = (Double(calorieTarget) * Double(percentage) / 100.0) / Double(divide)
        return Int(round(totalGram))
    }
    
    func Api_To_Upload_HealthData(){
        var params = [String: Any]()
         
        
        params["activity_level"] = self.LevelTxtF.text!
        params["calories"] = Int(self.CalTxtF.text!) ?? 0
        params["fat"] = Int(self.FatTxtF.text!) ?? 0
        params["carbs"] = Int(self.CarbsTxtF.text!) ?? 0
        params["protein"] = Int(self.ProtienTxtF.text!) ?? 0
        params["height_protein"] = self.HeighProtine
        params["name"] = self.Name
        params["bio"] = self.Bio
        params["type"] = self.targetDateDropdownLbl.text!
        params["macros"] = self.macros
        params["macro_carbs"] = "\(self.SuggestedData.macroPer?.carbs ?? 0)"
        params["macro_protein"] = "\(self.SuggestedData.macroPer?.protein ?? 0)"
        params["macro_fat"] = "\(self.SuggestedData.macroPer?.fat ?? 0)"
         params["value_per_week"] = "\(self.SuggestedData.valuePerWeek ?? 0)"
        params["time"] = "\(self.SuggestedData.time ?? 0)"
        params["typeStatus"] = self.SuggestedData.typeStatus ?? "0"
        let val = self.HeightTxtF.text!.removeSpaces
        
        let components = val.split { $0 == "'" || $0 == "\"" }
        if components.count == 2,
           let feet = Float(components[0]),
           let inches = Float(components[1]) {
            let totalHeightAsDecimal = feet + (inches / 10)
            print("Height in float: \(totalHeightAsDecimal)")
            params["height"] = totalHeightAsDecimal
            params["height_type"] = "feet"
        } else {
           
            let heightStr = val.replace(string: "cm", withString: "")
            let HighgtAsInt = Int(heightStr) ?? 0
            print("Height in float: \(HighgtAsInt)")
            params["height"] = HighgtAsInt
            params["height_type"] = "cm"
        }
        
        if self.MaleBtnO.isSelected == true{
            params["gender"] = "male"
        }else{
            params["gender"] = "female"
        }
        if let text = self.DOBTxtF.text, !text.isEmpty {
            let displayFormatter = DateFormatter()
            displayFormatter.dateFormat = "dd/MM/yyyy"
            
            let sendFormatter = DateFormatter()
            sendFormatter.dateFormat = "MM/dd/yyyy"
            
            if let date = displayFormatter.date(from: text) {
                params["dob"] = sendFormatter.string(from: date)
            } else {
                params["dob"] = text
            }
        } else {
            params["dob"] = ""
        }
        
        
        let weigthStr = self.WeightTxtF.text!.removeSpaces
        if weigthStr.contains(s: "lb"){
            let fWeight = weigthStr.replace(string: "lb", withString: "")
            params["weight"] = fWeight
            params["weight_type"] = "lb"
        }else{
            let fWeight = weigthStr.replace(string: "kg", withString: "")
            params["weight"] = fWeight
            params["weight_type"] = "Kilograms"
        }
        var targetWeigthStr = ""
        if SuggestedData.typeStatus == "1"{
            targetWeigthStr = self.SuggestedData.targetWeight ?? ""
            params["old_macro"] = "\(self.SuggestedData.macros ?? "")"
            params["target"] = "\(self.SuggestedData.target ?? "")"
        }else{
            targetWeigthStr = self.targetWeightTxtF.text!.removeSpaces
            params["old_macro"] = "\(self.SuggestedData.old_macro ?? "")"
            params["target"] = self.targetDateDropdownLbl.text!
        }
           
            if targetWeigthStr.contains(s: "lb"){
                let tWeight = targetWeigthStr.replace(string: "lb", withString: "")
                
                params["target_weight"] = tWeight
                params["target_weight_type"] = "lb"
            }else{
                let tWeight = targetWeigthStr.replace(string: "kg", withString: "")
                
                params["target_weight"] = tWeight
                params["target_weight_type"] = "Kilograms"
                
            }
     
          
        showIndicator(withTitle: "", and: "")
        
        let loginURL = baseURL.baseURL + appEndPoints.UpdateProfile
        print(params,"Params")
        print(loginURL,"loginURL")
        
        WebService.shared.postServiceURLEncoding(loginURL, VC: self, andParameter: params, withCompletion: { (json, statusCode) in
            
            self.hideIndicator()
            
            guard let dictData = json.dictionaryObject else{
                return
            }
            
            if dictData["success"] as? Bool == true{
               
                let responseMessage = dictData["message"] as? String ?? ""
                
                let data:[String: String] = ["data": ""]
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "notificationNameReloadData"), object: nil, userInfo: data)
               
                
                self.disclaimerPopupView.isHidden = true
                self.checkboxBtnO.isSelected = false
                self.continueBtnO.setBackgroundImage(UIImage(named: "ButtonGray"), for: .normal)
                self.continueBtnO.isUserInteractionEnabled = false
                
                
                if self.isComesFromPlanTab == true{
                //    self.navigationController?.showToast(responseMessage)
                    self.navigationController?.popViewController(animated: true)
                }else{
                    if self.comesFrom == "Profile"{
                        //self.navigationController?.showToast(responseMessage)
                        self.navigationController?.popViewController(animated: true)
                    }else{
                        self.navigationController?.popViewController(animated: true)
                       // self.navigationController?.showToast(responseMessage)
                    }
                }
                
            }else{
                let responseMessage = dictData["message"] as? String ?? ""
                self.showToast(responseMessage)
            }
        })
    }
    
    
    func Api_To_Get_NutritionGoalSuggestionData(old:Bool? = false){
            var params = [String: Any]()
             
            let val = self.HeightTxtF.text!.removeSpaces
            let components = val.split { $0 == "'" || $0 == "\"" }
            if components.count == 2,
               let feet = Float(components[0]),
               let inches = Float(components[1]) {
                let totalHeightAsDecimal = feet + (inches / 10)
                print("Height in float: \(totalHeightAsDecimal)")
                params["height"] = totalHeightAsDecimal
                params["height_type"] = "feet"
            } else {
                let heightStr = val.replace(string: "cm", withString: "")
                let HighgtAsInt = Int(heightStr) ?? 0
                print("Height in float: \(HighgtAsInt)")
                params["height"] = HighgtAsInt
                params["height_type"] = "cm"
            }
            
        let weigthStr = self.SuggestedData.weight?.removeSpaces ?? ""
            if weigthStr.contains(s: "lb"){
                let fWeight = weigthStr.replace(string: "lb", withString: "")
                params["weight"] = fWeight
                params["weight_type"] = "lb"
            }else{
                let fWeight = weigthStr.replace(string: "kg", withString: "")
                params["weight"] = fWeight
                params["weight_type"] = "Kilograms"
            }
            
            
        let targetWeigthStr = self.SuggestedData.targetWeight?.removeSpaces ?? ""
            if targetWeigthStr.contains(s: "lb"){
                let tWeight = targetWeigthStr.replace(string: "lb", withString: "")
                params["target_weight"] = tWeight
                params["target_weight_type"] = "lb"
            }else{
                let tWeight = targetWeigthStr.replace(string: "kg", withString: "")
                params["target_weight"] = tWeight
                params["target_weight_type"] = "Kilograms"//, lb
            }
             params["activityLevel"] = self.LevelTxtF.text ?? ""
        
     //   MARK: - Deepak ask to send in mm/dd/yyyy but show on tf dd/mm/yyyy
        
            if let text = self.DOBTxtF.text, !text.isEmpty {
                let displayFormatter = DateFormatter()
                displayFormatter.dateFormat = "dd/MM/yyyy"
                
                let sendFormatter = DateFormatter()
                sendFormatter.dateFormat = "MM/dd/yyyy"
                
                if let date = displayFormatter.date(from: text) {
                    params["dob"] = sendFormatter.string(from: date)
                } else {
                    params["dob"] = text
                }
            } else {
                params["dob"] = ""
            }
        if self.SuggestedData.typeStatus == "1"{
            params["type"] = "\(self.SuggestedData.target ?? "Gentle")"
            params["macros"] =  "Custom"
        }else{
            params["type"] =  self.targetDateDropdownLbl.text ?? "Gentle"
            params["macros"] = self.macros
        }
           if let old = old,old == true{
               params["macros"] = "\(self.SuggestedData.old_macro ?? "")"
               self.HeighProtine = "\(self.SuggestedData.old_macro ?? "")"
           }
            params["calories"] = "\(self.SuggestedData.calories ?? 0)"
            params["fat_per"] = "\(self.SuggestedData.macroPer?.fat ?? 0)"
            params["protein_per"] = "\(self.SuggestedData.macroPer?.protein ?? 0)"
            params["carbs_per"] = "\(self.SuggestedData.macroPer?.carbs ?? 0)"
           
            
            if self.MaleBtnO.isSelected{
                params["gender"] = "Male"
            }else{
                params["gender"] = "Female"
            }
          
  
            showIndicator(withTitle: "", and: "")
    
            let loginURL = baseURL.baseURL + appEndPoints.user_diet_suggetion
            print(params,"Params")
            print(loginURL,"loginURL")
    
            WebService.shared.postServiceURLEncoding(loginURL, VC: self, andParameter: params, withCompletion: { (json, statusCode) in
    
                self.hideIndicator()
    
                guard let dictData = json.dictionaryObject else{
                    return
                }
                
                let data = try! json.rawData()
                
                do{
                    let d = try JSONDecoder().decode(HealthSuggestedModelClass.self, from: data)
                    if d.success == true {
                    let list = d.data
                      
                        self.SuggestedData = list ?? HealthSuggestedData()
                        
                        if self.SuggestedData.typeStatus == "1"{
                            self.targetWeightMsgLbl.text = "You have set your own calories so your target weight cannot be calculated."
                            
                            self.view.viewWithTag(101)?.isHidden = true
                            if let label = self.view.viewWithTag(103) as? UILabel{
                                label.text = self.SuggestedData.macros
                            }
                            self.targetDateInfoLbl.text = ""
                            self.targetDateInfoLbl.isHidden = true
                            
                            self.targetDateInfoLbl.textColor = .red
                            self.targetWeightTxtF.text = ""
                            self.targetDateDropdownLbl.text = ""
                            self.targetDateDropdownLbl.placeholder = "Target Date"
                            self.targetWeightBtnO.isUserInteractionEnabled = false
                            self.targetDateDropdownBtnO.isUserInteractionEnabled = false
                        }else{
                            self.view.viewWithTag(101)?.isHidden = false
                            self.view.viewWithTag(102)?.isHidden = true
                           
                            let targetWeight = self.SuggestedData.targetWeight ?? ""
                            let targetWeight_type = self.SuggestedData.targetWeightType ?? ""
                          
                            if targetWeight_type == "Kilograms"{
                                if targetWeight != ""{
                                    self.targetWeightTxtF.text = "\(targetWeight) kg"
                                }else{
                                    self.targetWeightTxtF.text = ""
                                }
                            }else{
                                if targetWeight != "" && targetWeight != "0"{
                                    self.targetWeightTxtF.text = "\(targetWeight) lb"
                                }else{
                                    self.targetWeightTxtF.text = ""
                                }
                            }
                            self.targetDateArray = self.SuggestedData.dataPerWeek ?? []
                            let target = self.SuggestedData.target ?? ""
                            self.targetWeightMsgLbl.text = ""
                            self.targetDateInfoLbl.text = ""
                            self.targetDateInfoLbl.isHidden = false
                            self.targetDateDropdownLbl.text = target.capitalizedFirst
                            self.targetWeightBtnO.isUserInteractionEnabled = true
                            self.targetDateDropdownBtnO.isUserInteractionEnabled = true
                            if let index = self.targetDateArray.firstIndex(where: {$0.name == target}){
                                self.targetDateInfoLbl.text = self.targetDateArray[index].description ?? ""
                                self.targetDateInfoLbl.textColor = #colorLiteral(red: 0, green: 0.786260426, blue: 0.4870494008, alpha: 1)
                            }
                           
                            
                        }
                            
                    if self.calculateGoalsBtnO.isHidden == true {
                        self.CalTxtF.text = "\(self.SuggestedData.calories ?? 0)"
                        self.FatTxtF.text = "\(self.SuggestedData.fat ?? 0)"
                        self.CarbsTxtF.text = "\(self.SuggestedData.carbs ?? 0)"
                        self.ProtienTxtF.text = "\(self.SuggestedData.protein ?? 0)"
                    }else{
                        
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
}
