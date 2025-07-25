//
//  WeightPickerVC.swift
//  My Kai
//
//  Created by YES IT Labs on 09/06/25.
//

import UIKit

class WeightPickerVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    // MARK: - Outlets
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var Viewpopup: UIView!
    @IBOutlet weak var headingLbl: UILabel!
    @IBOutlet weak var lbBtnO: UIButton!
    @IBOutlet weak var kgBtnO: UIButton!
    
    // MARK: - Properties
    var Weight = ""
    var targetWeight = ""
    var comesfromWeight = false
    var lbData: [String] = []
    var kgData: [String] = []
    var isPoundsSelected = true
    var runTimeWeght = ""
    var backAction: (String) -> () = {_ in}
    var selectedWeightinKg: Double?
    var selectedWeightinLb: Double?
    var kgEnable = false
    var lbEnable = false
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPicker()
        setupInitialState()
        
    }
    
    // MARK: - Setup Methods
    private func setupPicker() {
        pickerView.delegate = self
        pickerView.dataSource = self
    }
    
    private func setupInitialState() {
        kgEnable = true
        lbEnable = true
        
        if self.isPoundsSelected {
            setupPoundsState()
        } else {
            setupKilogramsState()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.pickerView.subviews[1].backgroundColor = #colorLiteral(red: 0, green: 0.786260426, blue: 0.4870494008, alpha: 0.09602649007)
        }
    }
    
    private func setupPoundsState() {
        lbBtnO.isSelected = true
        kgBtnO.isSelected = false
        pickerView.reloadAllComponents()
        lbBtnO.setBackgroundImage(UIImage(named: "Rectangle 47"), for: .normal)
        kgBtnO.setBackgroundImage(UIImage(named: ""), for: .normal)
        lbBtnO.setTitleColor(UIColor.white, for: .normal)
        kgBtnO.setTitleColor(#colorLiteral(red: 0, green: 0.786260426, blue: 0.4870494008, alpha: 1), for: .normal)
        
        var numericPart = ""
        var weightSource = ""
        
        if comesfromWeight {
            weightSource = self.Weight
            self.headingLbl.text = "Weight"
        } else {
            weightSource = self.targetWeight
            kgEnable = false
            self.headingLbl.text = "Target Weight"
        }
        
        let cleanedWeight = weightSource.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "lb", with: "")
        numericPart = cleanedWeight

        let formattedStrVal: String
        if numericPart.contains(".") {
            let valueToScroll = Double(numericPart) ?? 0.0
            formattedStrVal = "\(valueToScroll)".replacingOccurrences(of: ".", with: " . ")
        } else {
            let value = Int(numericPart) ?? 0
            formattedStrVal = "\(Double(value))".replacingOccurrences(of: ".", with: " . ")
        }
        
        if !comesfromWeight {
            self.selectedWeightinLb = Double(self.Weight.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "lb", with: "").contains(".") ?
                self.Weight.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "lb", with: "") :
                "\(Int(self.Weight.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "lb", with: "")) ?? 0)")
        }
        
        generateWeightData()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if let index = self.lbData.firstIndex(where: { $0.removeSpaces == formattedStrVal.removeSpaces }) {
                self.runTimeWeght = self.lbData[index]
                self.pickerView.selectRow(index, inComponent: 0, animated: false)
            }
        }
    }
    
    private func setupKilogramsState() {
        lbBtnO.isSelected = false
        kgBtnO.isSelected = true
        pickerView.reloadAllComponents()
        lbBtnO.setBackgroundImage(UIImage(named: ""), for: .normal)
        kgBtnO.setBackgroundImage(UIImage(named: "Rectangle 47"), for: .normal)
        lbBtnO.setTitleColor(#colorLiteral(red: 0, green: 0.786260426, blue: 0.4870494008, alpha: 1), for: .normal)
        kgBtnO.setTitleColor(UIColor.white, for: .normal)
        
        var numericPart = ""
        var weightSource = ""
        
        if comesfromWeight {
            weightSource = self.Weight
            self.headingLbl.text = "Weight"
        } else {
            lbEnable = false
            weightSource = self.targetWeight
            self.headingLbl.text = "Target Weight"
        }
        
        let cleanedWeight = weightSource.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "kg", with: "")
        numericPart = cleanedWeight

        var formattedStrVal = ""

        if numericPart.contains(".") {
            let valueToScroll = Double(numericPart) ?? 0.0
            formattedStrVal = "\(valueToScroll)".replacingOccurrences(of: ".", with: " . ")
        } else {
            let value = Int(numericPart) ?? 0
            formattedStrVal = "\(Double(value))".replacingOccurrences(of: ".", with: " . ")
        }
        
        if !comesfromWeight {
            self.selectedWeightinKg = Double(self.Weight.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "kg", with: "").contains(".") ?
                self.Weight.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "kg", with: "") :
                "\(Int(self.Weight.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "kg", with: "")) ?? 0)")
        }
        
        generateWeightData()
        
        DispatchQueue.main.async {
            if let index = self.kgData.firstIndex(where: { $0.removeSpaces == formattedStrVal.removeSpaces }) {
                self.runTimeWeght = self.kgData[index]
                self.pickerView.selectRow(index, inComponent: 0, animated: false)
            }
        }
    }
    
 
    
    // MARK: - Data Generation
    func generateWeightData() {
        if let selectedLb = selectedWeightinLb {
            lbData = stride(from: 66.0, through: 440.0, by: 0.1).compactMap { value in
                if value > (selectedLb - 1.0) && value < (selectedLb + 1.0) {
                    return nil
                }
                return String(format: "%.1f", value).replacingOccurrences(of: ".", with: " . ")
            }
        } else {
            lbData = stride(from: 66.0, through: 440.0, by: 0.1).map {
                String(format: "%.1f", $0).replacingOccurrences(of: ".", with: " . ")
            }
        }

        if let selectedKg = selectedWeightinKg {
            kgData = stride(from: 30.0, through: 200.0, by: 0.1).compactMap { value in
                if value > (selectedKg - 0.5) && value < (selectedKg + 0.5) {
                    return nil
                }
                return String(format: "%.1f", value).replacingOccurrences(of: ".", with: " . ")
            }
        } else {
            kgData = stride(from: 30.0, through: 200.0, by: 0.1).map {
                String(format: "%.1f", $0).replacingOccurrences(of: ".", with: " . ")
            }
        }
    }
    
    
    @IBAction func lbBtn(_ sender: UIButton) {
        if lbEnable {
            isPoundsSelected = true
            lbBtnO.isSelected = true
            kgBtnO.isSelected = false
            pickerView.reloadAllComponents()
            lbBtnO.setBackgroundImage(UIImage(named: "Rectangle 47"), for: .normal)
            kgBtnO.setBackgroundImage(UIImage(named: ""), for: .normal)
            lbBtnO.setTitleColor(UIColor.white, for: .normal)
            kgBtnO.setTitleColor(#colorLiteral(red: 0, green: 0.786260426, blue: 0.4870494008, alpha: 1), for: .normal)
            
            if let lb = kgToLb(from: self.runTimeWeght) {
                if let index = self.lbData.firstIndex(where: { $0.removeSpaces == lb.removeSpaces}) {
                    self.pickerView.selectRow(index, inComponent: 0, animated: false)
                    self.runTimeWeght = self.lbData[index]
                }
            }
        } else {
            self.showToast("Weight is in kg, so lb can't be selected.")
        }
    }
    
    @IBAction func kgbtn(_ sender: UIButton) {
        if kgEnable {
            isPoundsSelected = false
            lbBtnO.isSelected = false
            kgBtnO.isSelected = true
            pickerView.reloadAllComponents()
            lbBtnO.setBackgroundImage(UIImage(named: ""), for: .normal)
            kgBtnO.setBackgroundImage(UIImage(named: "Rectangle 47"), for: .normal)
            lbBtnO.setTitleColor(#colorLiteral(red: 0, green: 0.786260426, blue: 0.4870494008, alpha: 1), for: .normal)
            kgBtnO.setTitleColor(UIColor.white, for: .normal)
            
            if let kg = lbToKg(from: self.runTimeWeght) {
                if let index = self.kgData.firstIndex(where: { $0.removeSpaces == kg.removeSpaces}) {
                    self.pickerView.selectRow(index, inComponent: 0, animated: false)
                    self.runTimeWeght = self.kgData[index]
                }
            }
        } else {
            self.showToast("Weight is in lb, so kg can't be selected.")
        }
    }
    
    @IBAction func cancelBtn(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        if isPoundsSelected {
            let selectedRow = pickerView.selectedRow(inComponent: 0)
            let selectedHeight = lbData[selectedRow]
            self.dismiss(animated: true, completion: {
                self.backAction("\(selectedHeight.replacingOccurrences(of: " . ", with: ".")) lb")
            })
        } else {
            let selectedRow = pickerView.selectedRow(inComponent: 0)
            let selectedHeight = kgData[selectedRow]
            self.dismiss(animated: true, completion: {
                self.backAction("\(selectedHeight.replacingOccurrences(of: " . ", with: ".")) kg")
            })
        }
    }
    
    // MARK: - PickerView Data Source & Delegate
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        isPoundsSelected ? lbData.count : kgData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return isPoundsSelected ? lbData[row] : kgData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if isPoundsSelected {
            self.runTimeWeght = lbData[row]
        } else {
            self.runTimeWeght = kgData[row]
        }
    }
    
    // MARK: - Helper Methods
    func kgToLb(from string: String) -> String? {
        guard let kg = Double(string.removeSpaces) else { return "0.0 lb" }
        let lb = kg * 2.20462
        let rounded = round(lb * 10) / 10
        return "\(rounded)"
    }

    func lbToKg(from string: String) -> String? {
        guard let lb = Double(string.removeSpaces) else { return "0.0 kg" }
        let kg = lb / 2.20462
        let rounded = round(kg * 10) / 10
        return "\(rounded)"
    }
    
    private func showToast(_ message: String) {
        let toast = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        present(toast, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            toast.dismiss(animated: true)
        }
    }
}
