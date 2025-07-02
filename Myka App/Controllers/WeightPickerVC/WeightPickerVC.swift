//
//  WeightPickerVC.swift
//  My Kai
//
//  Created by YES IT Labs on 09/06/25.
//

import UIKit

class WeightPickerVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var Viewpopup: UIView!
    @IBOutlet weak var DragDownView: UIView!
    
    @IBOutlet weak var lbBtnO: UIButton!
    @IBOutlet weak var kgBtnO: UIButton!
    
    var Weight = ""
    var targetWeight = ""
    var comesfromWeight = false
     
    var lbData: [String] = []
    var kgData: [String] = []
    var isPoundsSelected = true
    var runTimeWeght = ""
    var backAction:(String)->() = {_ in}
    var selectedWeightinKg : Double?
    var selectedWeightinLb : Double?
    var kgEnable:Bool = false
    var lbEnable:Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        pickerView.delegate = self
        pickerView.dataSource = self
        kgEnable = true
        lbEnable = true
        if self.isPoundsSelected == true{
            lbBtnO.isSelected = true
            kgBtnO.isSelected = false
            pickerView.reloadAllComponents()
            lbBtnO.setBackgroundImage(UIImage(named: "Rectangle 47"), for: .normal)
            kgBtnO.setBackgroundImage(UIImage(named: ""), for: .normal)
            lbBtnO.setTitleColor(UIColor.white, for: .normal)
            kgBtnO.setTitleColor(#colorLiteral(red: 0, green: 0.786260426, blue: 0.4870494008, alpha: 1), for: .normal)
 
            var numericPart = ""
            var weightSource = ""
       
            if comesfromWeight == true{
                weightSource = self.Weight
            }else{
                weightSource = self.targetWeight
                kgEnable = false
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
            print(formattedStrVal,"formattedStrVal")
            if !comesfromWeight {
                self.selectedWeightinLb = Double(self.Weight.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "lb", with: "").contains(".") ? self.Weight.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "lb", with: "") : "\(Int(self.Weight.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "lb", with: "")) ?? 0)") ?? 0.0
                
                print(self.selectedWeightinLb ?? 0.0,"self.selectedWeightinLb")
            }
            generateWeightData()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                if let index = self.lbData.firstIndex(where: { $0.removeSpaces == formattedStrVal.removeSpaces }) {
                    self.runTimeWeght = self.lbData[index]
                    self.pickerView.selectRow(index, inComponent: 0, animated: true)
                }
            }
            
        }else{
            
            lbBtnO.isSelected = false
            kgBtnO.isSelected = true
            
            pickerView.reloadAllComponents()
            
            lbBtnO.setBackgroundImage(UIImage(named: ""), for: .normal)
            kgBtnO.setBackgroundImage(UIImage(named: "Rectangle 47"), for: .normal)
            lbBtnO.setTitleColor(#colorLiteral(red: 0, green: 0.786260426, blue: 0.4870494008, alpha: 1), for: .normal)
            kgBtnO.setTitleColor(UIColor.white, for: .normal)
            
           
            var numericPart = ""
 
            var weightSource = ""
            
            if comesfromWeight == true{
                weightSource = self.Weight
            }else{
                lbEnable = false
                weightSource = self.targetWeight
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
                self.selectedWeightinKg = Double(self.Weight.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "kg", with: "").contains(".") ? self.Weight.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "kg", with: "") : "\(Int(self.Weight.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "kg", with: "")) ?? 0)") ?? 0.0
                
                
                print(self.selectedWeightinKg ?? 0.0,"self.selectedWeightinKg")
            }
            generateWeightData()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                if let index = self.kgData.firstIndex(where: { $0.removeSpaces == formattedStrVal.removeSpaces }) {
                    self.runTimeWeght = self.kgData[index]
                    self.pickerView.selectRow(index, inComponent: 0, animated: true)
                }
            }
        }
       
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.pickerView.subviews[1].backgroundColor = #colorLiteral(red: 0, green: 0.786260426, blue: 0.4870494008, alpha: 0.09602649007)
        }
        
        
        
        let gestureRecognizer = UIPanGestureRecognizer(target: self,
                                                                   action: #selector(panGestureRecognizerHandler(_:)))
        DragDownView.addGestureRecognizer(gestureRecognizer)
    }
    
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
    
    @objc func panGestureRecognizerHandler(_ sender: UIPanGestureRecognizer) {
              guard let rootView = Viewpopup, let rootWindow = rootView.window else { return }
              let rootWindowHeight: CGFloat = rootWindow.frame.size.height
    
              let touchPoint = sender.location(in: Viewpopup?.window)
              var initialTouchPoint = CGPoint.zero
              let blankViewHeight =  (rootWindowHeight - Viewpopup.frame.size.height)
              let dismissDragSize: CGFloat = 200.00
    
              switch sender.state {
              case .began:
                  initialTouchPoint = touchPoint
                
              case .changed:
                  if touchPoint.y > (initialTouchPoint.y + blankViewHeight)  {
                      Viewpopup.frame.origin.y = (touchPoint.y - blankViewHeight) - initialTouchPoint.y
                  }
    
              case .ended, .cancelled:
                  if touchPoint.y - initialTouchPoint.y > (dismissDragSize + blankViewHeight) {
                      self.view.backgroundColor = UIColor.clear
                      dismiss(animated: true, completion: nil)
                  } else {
                      UIView.animate(withDuration: 0.2, animations: {
                          self.Viewpopup.frame = CGRect(x: 0,
                                                   y: 0,
                                                   width: self.Viewpopup.frame.size.width,
                                                   height: self.Viewpopup.frame.size.height)
                         // self.view.backgroundColor = #colorLiteral(red: 0.3333333333, green: 0.3333333333, blue: 0.3333333333, alpha: 0.5)
                      })
                      // alpha = 1
                  }
              case .failed, .possible:
                  break
              }
          }
    
    // MARK: - Actions
        
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
            print(self.runTimeWeght)
            if let lb = kgToLb(from: self.runTimeWeght){
                print(lb, "lb")
                if let index = self.lbData.firstIndex(where: { $0.removeSpaces == lb.removeSpaces}) {
                    self.pickerView.selectRow(index, inComponent: 0, animated: true)
                    self.runTimeWeght = self.lbData[index]
                }
            }
        }else{
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
            print(self.runTimeWeght)
            if let kg = lbToKg(from: self.runTimeWeght){
                print(kg, "Kg")
                if let index = self.kgData.firstIndex(where: { $0.removeSpaces == kg.removeSpaces}) {
                    self.pickerView.selectRow(index, inComponent: 0, animated: true)
                    self.runTimeWeght = self.kgData[index]
                }
            }
        }else{
            self.showToast("Weight is in lb, so kg can't be selected.")
        }
    }
 
 
    @IBAction func cancelBtn(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
  
        // Handle saving the selected height
        if isPoundsSelected {
            let selectedRow = pickerView.selectedRow(inComponent: 0)
            let selectedHeight = lbData[selectedRow]
            print("Saved Height: \(selectedHeight)")
            self.dismiss(animated: true, completion: {
                self.backAction("\(selectedHeight.replacingOccurrences(of: " . ", with: ".")) lb")
            })
            
        } else {
            let selectedRow = pickerView.selectedRow(inComponent: 0)
            let selectedHeight = kgData[selectedRow]
            print("Saved Height: \(selectedHeight)")
            self.dismiss(animated: true, completion: {
                self.backAction("\(selectedHeight.replacingOccurrences(of: " . ", with: ".")) kg")
            })
        }
    }
    
 
    
    // MARK: - PickerView Data Source
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
                let selectedHeight = lbData[row]
                print("Selected Height: \(selectedHeight)")
                self.runTimeWeght = selectedHeight
            } else {
                let selectedHeight = kgData[row]
                print("Selected Height: \(selectedHeight)")
                self.runTimeWeght = selectedHeight
            }
        }


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
}
