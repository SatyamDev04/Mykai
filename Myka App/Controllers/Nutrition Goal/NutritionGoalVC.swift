//
//  NutritionGoalVC.swift
//  Myka App
//  Created by Sumit on 18/12/24.
//

import UIKit
import DropDown
import Alamofire

struct MacroTypeModelData{
    var name:String = ""
    var desc:String = ""
}


class NutritionGoalVC: UIViewController {
     
    @IBOutlet weak var CaloriesSlider: UISlider!
    @IBOutlet weak var FatSlider: UISlider!
    @IBOutlet weak var CarbsSlider: UISlider!
    @IBOutlet weak var ProteinSlider: UISlider!
    @IBOutlet weak var CaloriesSliderLbl: UILabel!
    @IBOutlet weak var FatSliderLbl: UILabel!
    @IBOutlet weak var CarbsSliderLbl: UILabel!
    @IBOutlet weak var ProteinSliderLbl: UILabel!
    @IBOutlet weak var fatPercentageLbl: UILabel!
    @IBOutlet weak var carbsPercentageLbl: UILabel!
    @IBOutlet weak var protienPercentageLbl: UILabel!
    @IBOutlet weak var UserNutritionGoalLbl: UILabel!
    @IBOutlet weak var DropDownTxtF: UITextField!
    @IBOutlet weak var infoLbl: UILabel!
    @IBOutlet weak var TotalPercentLbl: UILabel!
    @IBOutlet weak var updateBtnO: UIButton!
    @IBOutlet var headsupPopupView: UIView!
    @IBOutlet var CustomCaloriesPopupView: UIView!
    
    
    var SuggestedData = HealthSuggestedData()
    var uNchangedSuggestedData = HealthSuggestedData()
    var heighProtine: String = ""
    var name = ""
    
    private var isCaloriesSliderMoves: Bool = false
    var currentSlider = ""
    var infoLableTxt = ""
    var currentDropDownTxt = ""
    let dropDown = DropDown()
//    if self.DropDownTxtF.text ?? "" == "Custom" {
//        if view.viewWithTag(110)?.isHidden = true
//    }
    var macroTypeDataArr = [MacroTypeModelData(name: "Balanced", desc: "Supports overall health"), MacroTypeModelData(name: "Low Carb", desc: "Helps with weight management"), MacroTypeModelData(name: "High Protein", desc: "Supports muscle strength"), MacroTypeModelData(name: "Keto", desc: "Promotes the use of fat for energy"), MacroTypeModelData(name: "Low Fat", desc: "Good for heart health"), MacroTypeModelData(name: "Custom", desc: "Create your own customization")]
 
    var backAction:(_ HighProtine: String, _ Calories: Int, _ Fat: Int, _ Carbs: Int, _ Protine: Int,_ data: HealthSuggestedData,_ isCaloriesSliderMoves: Bool) -> () = {_,_,_,_,_,_,_   in}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.headsupPopupView.frame = self.view.bounds
        self.view.addSubview(self.headsupPopupView)
        self.headsupPopupView.isHidden = true
        
        self.CustomCaloriesPopupView.frame = self.view.bounds
        self.view.addSubview(self.CustomCaloriesPopupView)
        self.CustomCaloriesPopupView.isHidden = true
        
        
        CaloriesSlider.transform = CGAffineTransform(scaleX: 1.0, y: 2.0)
        if let thumbImage = UIImage(named: "Rectangle 4725")?
            .resized(to: CGSize(width: 6, height: 12))!
                    .withTintColor(#colorLiteral(red: 0.02352941176, green: 0.7568627451, blue: 0.4117647059, alpha: 1), renderingMode: .alwaysOriginal) {
            CaloriesSlider.setThumbImage(thumbImage, for: .normal)
                }
        
        FatSlider.transform = CGAffineTransform(scaleX: 1.0, y: 2.0)
        if let thumbImage = UIImage(named: "Rectangle 4725")?
            .resized(to: CGSize(width: 6, height: 12))!
                    .withTintColor(#colorLiteral(red: 0.02352941176, green: 0.7568627451, blue: 0.4117647059, alpha: 1), renderingMode: .alwaysOriginal) {
            FatSlider.setThumbImage(thumbImage, for: .normal)
                }
        
        CarbsSlider.transform = CGAffineTransform(scaleX: 1.0, y: 2.0)
        if let thumbImage = UIImage(named: "Rectangle 4725")?
            .resized(to: CGSize(width: 6, height: 12))!
                    .withTintColor(#colorLiteral(red: 0.02352941176, green: 0.7568627451, blue: 0.4117647059, alpha: 1), renderingMode: .alwaysOriginal) {
            CarbsSlider.setThumbImage(thumbImage, for: .normal)
                }
        
        ProteinSlider.transform = CGAffineTransform(scaleX: 1.0, y: 2.0)
        if let thumbImage = UIImage(named: "Rectangle 4725")?
            .resized(to: CGSize(width: 6, height: 12))!
                    .withTintColor(#colorLiteral(red: 0.02352941176, green: 0.7568627451, blue: 0.4117647059, alpha: 1) , renderingMode: .alwaysOriginal) {
            ProteinSlider.setThumbImage(thumbImage, for: .normal)
                }
        
        
        self.UserNutritionGoalLbl.text = "\(self.name)’s Nutrition Goals"
        
        
        self.CaloriesSlider.value = Float(self.SuggestedData.calories ?? 0)
        self.CaloriesSliderLbl.text = "\(Int(self.SuggestedData.calories ?? 0))"
        
        
        self.FatSlider.value = Float(self.SuggestedData.macroPer?.fat ?? 0)
        self.fatPercentageLbl.text = "\(self.SuggestedData.macroPer?.fat ?? 0)%"
        
        let fatVal = calculateGram(calorieTarget: self.SuggestedData.calories ?? 0, percentage: self.SuggestedData.macroPer?.fat ?? 0, divide: 9)
            self.FatSliderLbl.text = "(\(fatVal)g)"
        
        self.CarbsSlider.value = Float(self.SuggestedData.macroPer?.carbs ?? 0)
        self.carbsPercentageLbl.text = "\(self.SuggestedData.macroPer?.carbs ?? 0)%"
        
        let carbsVal = calculateGram(calorieTarget: self.SuggestedData.calories ?? 0, percentage: self.SuggestedData.macroPer?.carbs ?? 0, divide: 4)
            self.CarbsSliderLbl.text = "(\(carbsVal)g)"
        
         
        self.ProteinSlider.value = Float(self.SuggestedData.macroPer?.protein ?? 0)
        self.protienPercentageLbl.text = "\(self.SuggestedData.macroPer?.protein ?? 0)%"
        
        let proteinVal = calculateGram(calorieTarget: self.SuggestedData.calories ?? 0, percentage: self.SuggestedData.macroPer?.protein ?? 0, divide: 4)
            self.ProteinSliderLbl.text = "(\(proteinVal)g)"
         

        if self.heighProtine == ""{
            self.DropDownTxtF.text = "Balanced"
            self.currentDropDownTxt = "Balanced"
            self.infoLbl.text = "Supports overall health"
            self.infoLableTxt = "Supports overall health"
        }else{
            self.DropDownTxtF.text = self.heighProtine
            self.currentDropDownTxt = self.heighProtine
            if let index = macroTypeDataArr.firstIndex(where: {$0.name == self.heighProtine}){
                self.infoLbl.text = macroTypeDataArr[index].desc
                self.infoLableTxt = macroTypeDataArr[index].desc
                    if self.DropDownTxtF.text ?? "" == "Custom" {
                        view.viewWithTag(110)?.isHidden = true
                    }else{
                        view.viewWithTag(110)?.isHidden = false
                    }
            }
        }
        
        CaloriesSlider.addTarget(self, action: #selector(CaloriessliderValueChanged), for: .valueChanged)
        CaloriesSlider.addTarget(self, action: #selector(CaloriessliderDidEndSliding), for: [.touchUpInside, .touchUpOutside, .touchCancel])
        FatSlider.addTarget(self, action: #selector(FatsliderValueChanged), for: .valueChanged)
        FatSlider.addTarget(self, action: #selector(FatsliderDidEnd), for:  [.touchUpInside, .touchUpOutside, .touchCancel])
        
        CarbsSlider.addTarget(self, action: #selector(CarbssliderValueChanged), for: .valueChanged)
        CarbsSlider.addTarget(self, action: #selector(carbsliderDidEnd), for:  [.touchUpInside, .touchUpOutside, .touchCancel])
        ProteinSlider.addTarget(self, action: #selector(ProteinsliderValueChanged), for: .valueChanged)
        ProteinSlider.addTarget(self, action: #selector(protiensliderDidEnd), for:  [.touchUpInside, .touchUpOutside, .touchCancel])
        
       // self.Api_To_Get_NutritionGoalData()
    }
    @objc func FatsliderDidEnd(_ sender: UISlider) {
        evaluateHeadsUpConditions(currentSilder: "fat")
    }
    @objc func carbsliderDidEnd(_ sender: UISlider) {
        evaluateHeadsUpConditions(currentSilder: "carb")
    }
    @objc func protiensliderDidEnd(_ sender: UISlider) {
        evaluateHeadsUpConditions(currentSilder: "protien")
    }
    @objc func CaloriessliderValueChanged(_ sender: UISlider) {
         let currentValue = sender.value
          print("Slider value changing: \(currentValue)")
       // self.infoLbl.text = "Create your own customization"
        self.CaloriesSliderLbl.text = "\(Int(currentValue))"
        self.UpdateallSliderData(calories: Int(currentValue))
        self.currentSlider = "calorie"
    }
    
    @objc func CaloriessliderDidEndSliding(_ sender: UISlider) {
        let originalCalories = Float(self.SuggestedData.calories ?? 0)
        let currentValue = sender.value

        let lowerThreshold = originalCalories * 0.75 // 25% below
        let upperThreshold = originalCalories * 1.15 // 15% above

        let isSliderMoved = !(self.SuggestedData.isCaloriesSliderMoves ?? false)

      
        if (currentValue < lowerThreshold || currentValue > upperThreshold) && isSliderMoved  {
            self.headsupPopupView.isHidden = false
            self.CustomCaloriesPopupView.isHidden = true
            print("Heads Up Popup Shown")
        }
     
        else if isSliderMoved {
            self.headsupPopupView.isHidden = true
            self.CustomCaloriesPopupView.isHidden = false
            print("Custom Calories Popup Shown")
        }
    
        else {
            self.headsupPopupView.isHidden = true
            self.CustomCaloriesPopupView.isHidden = true
            print("No Popup")
        }

        print("Calories: \(originalCalories), Range: [\(lowerThreshold) - \(upperThreshold)], Current: \(currentValue)")
    }

    
    func UpdateallSliderData(calories: Int){
          
        let fatVal = calculateGram(calorieTarget: calories, percentage: self.SuggestedData.macroPer?.fat ?? 0, divide: 9)
            self.FatSliderLbl.text = "(\(fatVal)g)"
        
      
        
        let carbsVal = calculateGram(calorieTarget: calories, percentage: self.SuggestedData.macroPer?.carbs ?? 0, divide: 4)
            self.CarbsSliderLbl.text = "(\(carbsVal)g)"
      
        
        let protienVal = calculateGram(calorieTarget: calories, percentage: self.SuggestedData.macroPer?.protein ?? 0, divide: 4)
            self.ProteinSliderLbl.text = "(\(protienVal)g)"
      
    }
   
    
    
    @objc func FatsliderValueChanged(_ sender: UISlider) {
          let currentValue = sender.value
          print("Slider value: \(currentValue)")

        
        let sel: Double = Double(currentValue)
        let total: Double = 100
        let percentage = Int((sel / total) * 100)
        
        self.SuggestedData.macroPer?.fat = percentage
        self.fatPercentageLbl.text = "\(percentage)%"
        view.viewWithTag(110)?.isHidden = true
        let val = calculateGram(calorieTarget: self.SuggestedData.calories ?? 0, percentage: percentage, divide: 9)
            self.FatSliderLbl.text = "(\(val)g)"
        
        let totalPerc = (self.SuggestedData.macroPer?.fat ?? 0) + (self.SuggestedData.macroPer?.carbs ?? 0) + (self.SuggestedData.macroPer?.protein ?? 0)
        
        self.TotalPercentLbl.text = "\(Int(totalPerc))%"
        
        if Int(totalPerc) == 100 {
            self.TotalPercentLbl.textColor = UIColor.black
            self.updateBtnO.backgroundColor = #colorLiteral(red: 0, green: 0.786260426, blue: 0.4870494008, alpha: 1)
            self.updateBtnO.isUserInteractionEnabled = true
        }else{
            self.TotalPercentLbl.textColor = UIColor.red
            self.updateBtnO.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
            self.updateBtnO.isUserInteractionEnabled = false
        }
      }
    
    @objc func CarbssliderValueChanged(_ sender: UISlider) {
          let currentValue = sender.value
          print("Slider value: \(currentValue)")

     
        let sel: Double = Double(currentValue)
        let total: Double = 100
        let percentage = Int((sel / total) * 100)
 
        self.SuggestedData.macroPer?.carbs = percentage
       
        self.carbsPercentageLbl.text = "\(percentage)%"
        view.viewWithTag(110)?.isHidden = true

        let val = calculateGram(calorieTarget: self.SuggestedData.calories ?? 0, percentage: percentage, divide: 4)
            self.CarbsSliderLbl.text = "(\(val)g)"
        
        let totalPerc = (self.SuggestedData.macroPer?.fat ?? 0) + (self.SuggestedData.macroPer?.carbs ?? 0) + (self.SuggestedData.macroPer?.protein ?? 0)
        
        self.TotalPercentLbl.text = "\(Int(totalPerc))%"
        
        if Int(totalPerc) == 100 {
            self.TotalPercentLbl.textColor = UIColor.black
            self.updateBtnO.backgroundColor = #colorLiteral(red: 0, green: 0.786260426, blue: 0.4870494008, alpha: 1)
            self.updateBtnO.isUserInteractionEnabled = true
        }else{
            self.TotalPercentLbl.textColor = UIColor.red
            self.updateBtnO.backgroundColor = #colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
            self.updateBtnO.isUserInteractionEnabled = false
        }
      }
    
    @objc func ProteinsliderValueChanged(_ sender: UISlider) {
          let currentValue = sender.value
          print("Slider value: \(currentValue)")
      
        let sel: Double = Double(currentValue)
        let total: Double = 100
        let percentage = Int((sel / total) * 100)
        
        self.SuggestedData.macroPer?.protein = percentage

        self.protienPercentageLbl.text = "\(percentage)%"
        view.viewWithTag(110)?.isHidden = true
//        self.DropDownTxtF.text = "Custom"
//        self.infoLbl.text = "Create your own customization"
        
        let val = calculateGram(calorieTarget: self.SuggestedData.calories ?? 0, percentage: percentage, divide: 4)
            self.ProteinSliderLbl.text = "(\(val)g)"
        
        let totalPerc = (self.SuggestedData.macroPer?.fat ?? 0) + (self.SuggestedData.macroPer?.carbs ?? 0) + (self.SuggestedData.macroPer?.protein ?? 0)
        
        self.TotalPercentLbl.text = "\(Int(totalPerc))%"
        
        if Int(totalPerc) == 100 {
            self.TotalPercentLbl.textColor = UIColor.black
            self.updateBtnO.backgroundColor = #colorLiteral(red: 0, green: 0.786260426, blue: 0.4870494008, alpha: 1)
            self.updateBtnO.isUserInteractionEnabled = true
        }else{
            self.TotalPercentLbl.textColor = UIColor.red
            self.updateBtnO.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
            self.updateBtnO.isUserInteractionEnabled = false
        }
      }
    private func evaluateHeadsUpConditions(currentSilder:String) {
        let carbs = Int(CarbsSlider.value)
        let fat = Int(FatSlider.value)
        let protein = Int(ProteinSlider.value)
        currentSlider = currentSilder
        let isFatMoved = !(SuggestedData.isfatSliderMoves ?? false)
        let isCarbMoved = !(SuggestedData.isCarbSliderMoves ?? false)
        let isProteinMoved = !(SuggestedData.isProtienliderMoves ?? false)
        let iscarbFatProtienMoves = !(uNchangedSuggestedData.iscarbFatProtienMoves ?? false)
        
        if (carbs == 0 && protein < 10 && iscarbFatProtienMoves) || (fat == 0 && protein < 10 && iscarbFatProtienMoves) {
            currentSlider = "carfatpro"
            headsupPopupView.isHidden = false
            CustomCaloriesPopupView.isHidden = true
          
            print("Heads Up: carbs & fat = 0, protein < 10 (all moved)")
        }

    
        else if (carbs == 0 && isCarbMoved) ||
                (fat == 0 && isFatMoved) ||
                (protein == 0 && isProteinMoved) {
           
            headsupPopupView.isHidden = false
            CustomCaloriesPopupView.isHidden = true
            print("Heads Up: One value is 0 and moved")
        }
        else {
            headsupPopupView.isHidden = true
            print("Heads Up: Not triggered")
        }
    }
    
   
    func calculateGram(calorieTarget: Int, percentage: Int, divide: Int) -> Int {
        let totalGram = (Double(calorieTarget) * Double(percentage) / 100.0) / Double(divide)
        return Int(round(totalGram))
    }
    
    @IBAction func Backbtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func HighProteinDropDownBtn(_ sender: UIButton) {
          dropDown.dataSource = self.macroTypeDataArr.map { String($0.name) }
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
          dropDown.cellHeight = 50
          dropDown.textFont = UIFont.systemFont(ofSize: 16)
          dropDown.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
 
        dropDown.cellNib = UINib(nibName: "levelDropDownTblVCell", bundle: nil)
        dropDown.customCellConfiguration = { [weak self] (index: Index, item: String, cell: DropDownCell) in
            guard let cell = cell as? levelDropDownTblVCell else { return }
            guard let self = self else { return }
            let desc = macroTypeDataArr[index].desc
            cell.descLbl.text = desc
        }
        
        dropDown.selectionAction = { [weak self] (index: Int, item: String) in
          guard let self = self else { return }
          print(index)
            self.DropDownTxtF.text = item
            self.currentDropDownTxt = item
            self.infoLbl.text = macroTypeDataArr[index].desc
            infoLableTxt = macroTypeDataArr[index].desc
            view.viewWithTag(110)?.isHidden = false
            if item != "Custom"{
                self.SuggestedData.isCaloriesSliderMoves = false
                self.Api_To_Get_NutritionGoalSuggestionData()
                  
                
            }else{
                view.viewWithTag(110)?.isHidden = true
            }
      }
        
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
        print(Int(CaloriesSlider.value),"calories")
        self.backAction(self.DropDownTxtF.text!, Int(CaloriesSlider.value), Int(FatSlider.value), Int(CarbsSlider.value), Int(ProteinSlider.value), self.SuggestedData, self.SuggestedData.isCaloriesSliderMoves ?? false)
        self.navigationController?.popViewController(animated: true)
    }
    
   
    @IBAction func calcelBtn(_ sender: UIButton) {
        self.headsupPopupView.isHidden = true
        
        switch self.currentSlider{
        case "fat" :
            SuggestedData.isfatSliderMoves = false
            self.resetFat(list: uNchangedSuggestedData)
        case "carb" : SuggestedData.isCarbSliderMoves = false
            self.resetCarb(list: uNchangedSuggestedData)
        case "protien" : SuggestedData.isProtienliderMoves = false
            self.resetProtien(list: uNchangedSuggestedData)
        case "carfatpro":
            SuggestedData.iscarbFatProtienMoves = false
            self.resetProtien(list: uNchangedSuggestedData)
        case "calorie":
            self.SuggestedData.isCaloriesSliderMoves = false
            self.resetCalorie(list: uNchangedSuggestedData)
        default:
            self.SuggestedData.isCaloriesSliderMoves = false
            self.setData(list: uNchangedSuggestedData)
        }
        self.infoLbl.text  = self.infoLableTxt
        self.DropDownTxtF.text = self.currentDropDownTxt
         view.viewWithTag(110)?.isHidden = false
        

    }
    
   
    @IBAction func RestorePlanBtn(_ sender: UIButton) {
        self.SuggestedData.isCaloriesSliderMoves = false
        self.resetCalorie(list: uNchangedSuggestedData)
        self.CustomCaloriesPopupView.isHidden = true
        self.infoLbl.text  = self.infoLableTxt
        self.DropDownTxtF.text = self.currentDropDownTxt
        view.viewWithTag(110)?.isHidden = false
    }
    
    @IBAction func ProceedAnywayBtn(_ sender: UIButton) {
        self.SuggestedData.isCaloriesSliderMoves = true
        self.DropDownTxtF.text = "Custom"
        view.viewWithTag(110)?.isHidden = true
        self.infoLbl.text = "Create your own customization"
        self.CustomCaloriesPopupView.isHidden = true
        view.viewWithTag(110)?.isHidden = true
    }
    
    
    @IBAction func `continue`(_ sender: UIButton) {
        switch self.currentSlider{
        case "fat" :
            SuggestedData.isfatSliderMoves = true
        case "carb" :
            SuggestedData.isCarbSliderMoves = true
        case "protien" :
            SuggestedData.isProtienliderMoves = true
        case "carfatpro":
            SuggestedData.iscarbFatProtienMoves = true
            
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
    
    
    
}

extension UIImage {
    func resized(to size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        self.draw(in: CGRect(origin: .zero, size: size))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage
    }
}


extension NutritionGoalVC {
    func Api_To_Get_NutritionGoalSuggestionData(){
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
        print(params,"Params")
        print(loginURL,"loginURL")

        WebService.shared.postServiceURLEncoding(loginURL, VC: self, andParameter: params, withCompletion: { (json, statusCode) in

            self.hideIndicator()

            let data = try! json.rawData()
            
            do{
                let d = try JSONDecoder().decode(HealthSuggestedModelClass.self, from: data)
                if d.success == true {
                    if let list = d.data {
                        self.SuggestedData = list
                        self.setData(list: list)
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
    
    func resetFat(list:HealthSuggestedData){
        self.FatSlider.value = Float(list.macroPer?.fat ?? 0)
        self.fatPercentageLbl.text = "\(list.macroPer?.fat ?? 0)%"
        self.SuggestedData.macroPer?.fat = list.macroPer?.fat
        let fatVal = self.calculateGram(calorieTarget: list.calories ?? 0, percentage: list.macroPer?.fat ?? 0, divide: 9)
            self.FatSliderLbl.text = "(\(fatVal)g)"
        let totalPerc = (self.SuggestedData.macroPer?.fat ?? 0) + (self.SuggestedData.macroPer?.carbs ?? 0) + (self.SuggestedData.macroPer?.protein ?? 0)
        if Int(totalPerc) == 100 {
            self.TotalPercentLbl.textColor = UIColor.black
            self.updateBtnO.backgroundColor = #colorLiteral(red: 0, green: 0.786260426, blue: 0.4870494008, alpha: 1)
            self.updateBtnO.isUserInteractionEnabled = true
        }else{
            self.TotalPercentLbl.textColor = UIColor.red
            self.updateBtnO.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
            self.updateBtnO.isUserInteractionEnabled = false
        }

        self.TotalPercentLbl.text = "\(Int(totalPerc))%"
    }
    
    func resetCalorie(list:HealthSuggestedData){
        self.CaloriesSlider.value = Float(list.calories ?? 0)
        self.CaloriesSliderLbl.text = "\(Int(list.calories ?? 0))"
        self.SuggestedData.calories = list.calories
        self.resetProtien(list: list)
        self.resetCarb(list: list)
        self.resetFat(list: list)
    }
    
    
    func resetCarb(list:HealthSuggestedData){
        self.CarbsSlider.value = Float(list.macroPer?.carbs ?? 0)
        self.carbsPercentageLbl.text = "\(list.macroPer?.carbs ?? 0)%"
        self.SuggestedData.macroPer?.carbs = list.macroPer?.carbs
        let carbsVal = self.calculateGram(calorieTarget:list.calories ?? 0, percentage: list.macroPer?.carbs ?? 0, divide: 4)
            self.CarbsSliderLbl.text = "(\(carbsVal)g)"
        let totalPerc = (self.SuggestedData.macroPer?.fat ?? 0) + (self.SuggestedData.macroPer?.carbs ?? 0) + (self.SuggestedData.macroPer?.protein ?? 0)
        if Int(totalPerc) == 100 {
            self.TotalPercentLbl.textColor = UIColor.black
            self.updateBtnO.backgroundColor = #colorLiteral(red: 0, green: 0.786260426, blue: 0.4870494008, alpha: 1)
            self.updateBtnO.isUserInteractionEnabled = true
        }else{
            self.TotalPercentLbl.textColor = UIColor.red
            self.updateBtnO.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
            self.updateBtnO.isUserInteractionEnabled = false
        }

        
        self.TotalPercentLbl.text = "\(Int(totalPerc))%"
    }
    
    func resetProtien(list:HealthSuggestedData){
        
        self.ProteinSlider.value = Float(list.macroPer?.protein ?? 0)
        self.protienPercentageLbl.text = "\(list.macroPer?.protein ?? 0)%"
        self.SuggestedData.macroPer?.protein = list.macroPer?.protein
        
        let proteinVal = self.calculateGram(calorieTarget:list.calories ?? 0, percentage: list.macroPer?.protein ?? 0, divide: 4)
            self.ProteinSliderLbl.text = "(\(proteinVal)g)"
        
        let totalPerc = (self.SuggestedData.macroPer?.fat ?? 0) + (self.SuggestedData.macroPer?.carbs ?? 0) + (self.SuggestedData.macroPer?.protein ?? 0)
        
        if Int(totalPerc) == 100 {
            self.TotalPercentLbl.textColor = UIColor.black
            self.updateBtnO.backgroundColor = #colorLiteral(red: 0, green: 0.786260426, blue: 0.4870494008, alpha: 1)
            self.updateBtnO.isUserInteractionEnabled = true
        }else{
            self.TotalPercentLbl.textColor = UIColor.red
            self.updateBtnO.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
            self.updateBtnO.isUserInteractionEnabled = false
        }

        
        self.TotalPercentLbl.text = "\(Int(totalPerc))%"
    }
    
    func setData(list:HealthSuggestedData){
        self.SuggestedData = list
         
        
        self.CaloriesSlider.value = Float(self.SuggestedData.calories ?? 0)
        self.CaloriesSliderLbl.text = "\(Int(self.SuggestedData.calories ?? 0))"
        
        
        self.FatSlider.value = Float(self.SuggestedData.macroPer?.fat ?? 0)
        self.fatPercentageLbl.text = "\(self.SuggestedData.macroPer?.fat ?? 0)%"
        
        let fatVal = self.calculateGram(calorieTarget: self.SuggestedData.calories ?? 0, percentage: self.SuggestedData.macroPer?.fat ?? 0, divide: 9)
            self.FatSliderLbl.text = "(\(fatVal)g)"
        
        self.CarbsSlider.value = Float(self.SuggestedData.macroPer?.carbs ?? 0)
        self.carbsPercentageLbl.text = "\(self.SuggestedData.macroPer?.carbs ?? 0)%"
        
        let carbsVal = self.calculateGram(calorieTarget: self.SuggestedData.calories ?? 0, percentage: self.SuggestedData.macroPer?.carbs ?? 0, divide: 4)
            self.CarbsSliderLbl.text = "(\(carbsVal)g)"
        
         
        self.ProteinSlider.value = Float(self.SuggestedData.macroPer?.protein ?? 0)
        self.protienPercentageLbl.text = "\(self.SuggestedData.macroPer?.protein ?? 0)%"
        
        let proteinVal = self.calculateGram(calorieTarget: self.SuggestedData.calories ?? 0, percentage: self.SuggestedData.macroPer?.protein ?? 0, divide: 4)
            self.ProteinSliderLbl.text = "(\(proteinVal)g)"
        
       // self.UpdateallSliderData(calories: self.SuggestedData.calories ?? 0)
        
        let totalPerc = (self.SuggestedData.macroPer?.fat ?? 0) + (self.SuggestedData.macroPer?.carbs ?? 0) + (self.SuggestedData.macroPer?.protein ?? 0)
        
        self.TotalPercentLbl.text = "\(Int(totalPerc))%"
        
        if Int(totalPerc) == 100 {
            self.TotalPercentLbl.textColor = UIColor.black
            self.updateBtnO.backgroundColor = #colorLiteral(red: 0, green: 0.786260426, blue: 0.4870494008, alpha: 1)
            self.updateBtnO.isUserInteractionEnabled = true
        }else{
            self.TotalPercentLbl.textColor = UIColor.red
            self.updateBtnO.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
            self.updateBtnO.isUserInteractionEnabled = false
        }
    }
}
 
