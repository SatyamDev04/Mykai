//
//  HeightPickerVC.swift
//  My Kai
//
//  Created by YES IT Labs on 09/06/25.
//

import UIKit

class HeightPickerVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var Viewpopup: UIView!
    @IBOutlet weak var DragDownView: UIView!
    
    @IBOutlet weak var ftBtnO: UIButton!
    @IBOutlet weak var cmBtnO: UIButton!
    
    
    var ftInData: [String] = []
    var cmData: [String] = []
    var isFeetSelected = true
    var selectedHeight:String = ""
    var runTimeSelctedHeight:String = ""
    var backAction:(String)->() = {_ in}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        generateFtInData()
        generateCmData()
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        
        if isFeetSelected == true{
            ftBtnO.isSelected = true
            cmBtnO.isSelected = false
            pickerView.reloadAllComponents()
            ftBtnO.setBackgroundImage(UIImage(named: "Rectangle 47"), for: .normal)
            cmBtnO.setBackgroundImage(UIImage(named: ""), for: .normal)
            ftBtnO.setTitleColor(UIColor.white, for: .normal)
            cmBtnO.setTitleColor(#colorLiteral(red: 0, green: 0.786260426, blue: 0.4870494008, alpha: 1), for: .normal)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            
                let heightWithFeet = self.selectedHeight.replacingOccurrences(of: "'", with: " ft")
        let formattedHeight = heightWithFeet.replacingOccurrences(of: "\"", with: " in")
                
                if let index = self.ftInData.firstIndex(where: { $0 == formattedHeight}) {
                    self.runTimeSelctedHeight = formattedHeight
                    self.pickerView.selectRow(index, inComponent: 0, animated: true)
                }
            }
         
        }else{
            ftBtnO.isSelected = false
            cmBtnO.isSelected = true
            pickerView.reloadAllComponents()
            ftBtnO.setBackgroundImage(UIImage(named: ""), for: .normal)
            cmBtnO.setBackgroundImage(UIImage(named: "Rectangle 47"), for: .normal)
            ftBtnO.setTitleColor(#colorLiteral(red: 0, green: 0.786260426, blue: 0.4870494008, alpha: 1), for: .normal)
            cmBtnO.setTitleColor(UIColor.white, for: .normal)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                if let index = self.cmData.firstIndex(where: { $0 == self.selectedHeight}) {
                    self.runTimeSelctedHeight = self.selectedHeight
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
    
    // to change the Picker Seloctor color.
 
 
    
    func generateFtInData() {
            for feet in 2...8 {
                for inch in 0...11 {
                    if inch == 0 {
                        ftInData.append("\(feet) ft")
                    } else {
                        if feet != 8{
                            ftInData.append("\(feet) ft \(inch) in")
                        }
                    }
                }
            }
        }
    
        func generateCmData() {
            for cm in 61...244 {
                cmData.append("\(cm) cm")
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
                 // self.view.backgroundColor = UIColor.clear
              case .changed:
                  // dynamic alpha
                  if touchPoint.y > (initialTouchPoint.y + blankViewHeight)  { // change dim background (alpha)
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
                        
                      })
                    
                  }
              case .failed, .possible:
                  break
              }
          }
    
    // MARK: - Actions
        
    @IBAction func feetBtn(_ sender: UIButton) {
        isFeetSelected = true
        ftBtnO.isSelected = true
        cmBtnO.isSelected = false
        pickerView.reloadAllComponents()
        ftBtnO.setBackgroundImage(UIImage(named: "Rectangle 47"), for: .normal)
        cmBtnO.setBackgroundImage(UIImage(named: ""), for: .normal)
        ftBtnO.setTitleColor(UIColor.white, for: .normal)
        cmBtnO.setTitleColor(#colorLiteral(red: 0, green: 0.786260426, blue: 0.4870494008, alpha: 1), for: .normal)
        print( self.runTimeSelctedHeight," self.runTimeSelctedHeight")
        if  let runft = convertCMStringToFeetInch(self.runTimeSelctedHeight.removeSpaces.replace(string: "cm", withString: "")) {
            print(runft,"runft", self.runTimeSelctedHeight.removeSpaces.replace(string: "cm", withString: ""))
             
            if let index = self.ftInData.firstIndex(where: { $0 == runft}) {
                
                self.pickerView.selectRow(index, inComponent: 0, animated: true)
                self.runTimeSelctedHeight = runft
            }
        }
    }
    
    @IBAction func cmbtn(_ sender: UIButton) {
        isFeetSelected = false
        ftBtnO.isSelected = false
        cmBtnO.isSelected = true
        pickerView.reloadAllComponents()
        
        ftBtnO.setBackgroundImage(UIImage(named: ""), for: .normal)
        cmBtnO.setBackgroundImage(UIImage(named: "Rectangle 47"), for: .normal)
        ftBtnO.setTitleColor(#colorLiteral(red: 0, green: 0.786260426, blue: 0.4870494008, alpha: 1), for: .normal)
        cmBtnO.setTitleColor(UIColor.white, for: .normal)
        print( self.runTimeSelctedHeight," self.runTimeSelctedHeight")
        if let runcm =  self.convertToCentimeterString(from: self.runTimeSelctedHeight) {
            print(runcm,"runcm")
            self.runTimeSelctedHeight = runcm
            if let index = self.cmData.firstIndex(where: { $0.removeSpaces == runcm.removeSpaces}) {
                self.pickerView.selectRow(index, inComponent: 0, animated: true)
            }
        }
    }
 
 
    @IBAction func CcancelBtn(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
       
        if isFeetSelected {
            let selectedRow = pickerView.selectedRow(inComponent: 0)
            let selectedHeight = ftInData[selectedRow]
            print("Saved Height: \(selectedHeight)")
            self.dismiss(animated: true, completion: {

                let components = selectedHeight.components(separatedBy: " ")

                if components.count == 2, let feet = components.first {
                 
                    let formattedHeight = "\(feet)'"
                    print(formattedHeight)
                    self.backAction("\(formattedHeight)")
                } else if components.count == 4,
                          let feet = components.first{
                    let inches = components[2]
                  
                    let formattedHeight = "\(feet)' \(inches)\""
                    print(formattedHeight)
                    self.backAction("\(formattedHeight)")
                } else {
                    print("Invalid format")
                }
            })
            
        } else {
            let selectedRow = pickerView.selectedRow(inComponent: 0)
            let selectedHeight = cmData[selectedRow]
            print("Saved Height: \(selectedHeight)")
            self.dismiss(animated: true, completion: {
                self.backAction("\(selectedHeight)")
            })
        }
    }
    
    // MARK: - PickerView Data Source
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        isFeetSelected ? ftInData.count : cmData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return isFeetSelected ? ftInData[row] : cmData[row]
        }
    
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            if isFeetSelected {
                let selectedHeight = ftInData[row]
                print("Selected Height: \(selectedHeight)")
                self.runTimeSelctedHeight = selectedHeight
            } else {
                let selectedHeight = cmData[row]
                print("Selected Height: \(selectedHeight)")
                self.runTimeSelctedHeight = selectedHeight
            }
        }
    
    func convertToCentimeterString(from input: String) -> String? {
        // Match "5 ft 7 in" or "5 ft"
           let pattern = #"(?:(\d+)\s*ft)?(?:\s*(\d+)\s*in)?"#
           let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive)

           guard let match = regex?.firstMatch(in: input, range: NSRange(input.startIndex..., in: input)) else {
               return nil
           }

           // Extract matched ranges
           let ftRange = Range(match.range(at: 1), in: input)
           let inRange = Range(match.range(at: 2), in: input)

           // Parse values safely
           let feet = ftRange.flatMap { Int(input[$0]) } ?? 0
           let inches = inRange.flatMap { Int(input[$0]) } ?? 0

           let totalInches = (feet * 12) + inches
           let cm = Double(totalInches) * 2.54
           return "\(Int(cm.rounded())) cm"
    }
    
    func convertCMStringToFeetInch(_ cmString: String) -> String? {
        guard let cmValue = Double(cmString.trimmingCharacters(in: .whitespacesAndNewlines)) else {
            return nil
        }

        let totalInches = cmValue / 2.54
        var feet = Int(totalInches / 12)
        var inches = Int(round(totalInches.truncatingRemainder(dividingBy: 12)))

        // Handle case where inches round up to 12
        if inches == 12 {
            feet += 1
            inches = 0
        }

        if inches == 0 {
            return "\(feet) ft"
        } else {
            return "\(feet) ft \(inches) in"
        }
    }


}
