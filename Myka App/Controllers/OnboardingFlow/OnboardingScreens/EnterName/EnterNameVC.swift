//
//  EnterNameVC.swift
//  Myka App
//
//  Created by YES IT Labs on 26/11/24.
//

import UIKit

class EnterNameVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var NameTxtF: UITextField!
    @IBOutlet weak var SelectGenderTxtF: UITextField!
    @IBOutlet weak var GenderDropBtnO: UIButton!
    @IBOutlet weak var DropImg: UIImageView!
    @IBOutlet weak var MaleBgV: UIView!
    @IBOutlet weak var FemaleBgV: UIView!
    @IBOutlet weak var MaleBtnO: UIButton!
    @IBOutlet weak var FemaleBtnO: UIButton!
     
    @IBOutlet weak var NextBtnO: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.MaleBgV.isHidden = true
        self.FemaleBgV.isHidden = true
        self.DropImg.image = UIImage(named: "DropDown")
        
        self.NameTxtF.delegate = self
        
        NextBtnO.backgroundColor = UIColor.lightGray
        NextBtnO.isUserInteractionEnabled = false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == self.NameTxtF {
            // Get the current text
            let currentText = textField.text ?? ""
            
            // Calculate the new text after the change
            let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
           
            if newText.isEmpty {
                // If the text is empty, clear the field
                textField.text = ""
                NextBtnO.backgroundColor = UIColor.lightGray
                NextBtnO.isUserInteractionEnabled = false
                
            } else {
                textField.text = newText
                
                // Adjust the cursor position
                if let newPosition = textField.position(from: textField.beginningOfDocument, offset: range.location + string.count + 1) {
                    textField.selectedTextRange = textField.textRange(from: newPosition, to: newPosition)
                }
                
                // Enable or disable the button based on the conditions
                if self.SelectGenderTxtF.text!.isEmpty {
                    NextBtnO.backgroundColor = UIColor.lightGray
                    NextBtnO.isUserInteractionEnabled = false
                } else {
                    NextBtnO.backgroundColor = #colorLiteral(red: 0.02352941176, green: 0.7568627451, blue: 0.4117647059, alpha: 1)
                    NextBtnO.isUserInteractionEnabled = true
                }
            }
            return false // Prevent the default behavior as we are updating the text manually
        }
        return true
    }
    
    
    @IBAction func GenderBtn(_ sender: UIButton) {
        if GenderDropBtnO.isSelected {
            GenderDropBtnO.isSelected = false
            self.MaleBgV.isHidden = true
            self.FemaleBgV.isHidden = true
            self.DropImg.image = UIImage(named: "DropDown")
        }else{
            self.GenderDropBtnO.isSelected = true
            self.MaleBgV.isHidden = false
            self.FemaleBgV.isHidden = false
            self.DropImg.image = UIImage(named: "DropUp")
        }
    }
    
    @IBAction func MaleBtn(_ sender: UIButton) {
        self.GenderDropBtnO.isSelected = false
        self.MaleBgV.isHidden = true
        self.FemaleBgV.isHidden = true
        self.DropImg.image = UIImage(named: "DropDown")
        self.SelectGenderTxtF.text = "Male"
        
        if self.NameTxtF.text!.isEmpty {
            NextBtnO.backgroundColor = UIColor.lightGray
            NextBtnO.isUserInteractionEnabled = false
        } else {
            NextBtnO.backgroundColor = #colorLiteral(red: 0.02352941176, green: 0.7568627451, blue: 0.4117647059, alpha: 1)
            NextBtnO.isUserInteractionEnabled = true
        }
    }
    
    @IBAction func FemaleBtn(_ sender: UIButton) {
        self.GenderDropBtnO.isSelected = false
        self.MaleBgV.isHidden = true
        self.FemaleBgV.isHidden = true
        self.DropImg.image = UIImage(named: "DropDown")
        self.SelectGenderTxtF.text = "Female"
        
        if self.NameTxtF.text!.isEmpty {
            NextBtnO.backgroundColor = UIColor.lightGray
            NextBtnO.isUserInteractionEnabled = false
        } else {
            NextBtnO.backgroundColor = #colorLiteral(red: 0.02352941176, green: 0.7568627451, blue: 0.4117647059, alpha: 1)
            NextBtnO.isUserInteractionEnabled = true
        }
    }
    
    @IBAction func NextBtn(_ sender: UIButton) {
        
        StateMangerModelClass.shared.onboardingSelectedData.Username = self.NameTxtF.text ?? ""
        
        if self.SelectGenderTxtF.text! != "Gender"{
            StateMangerModelClass.shared.onboardingSelectedData.UserGender = self.SelectGenderTxtF.text!
        }
        let nextVc = self.storyboard?.instantiateViewController(identifier: "CookingForVC") as! CookingForVC
    self.navigationController?.pushViewController(nextVc, animated: true)
    }
}
