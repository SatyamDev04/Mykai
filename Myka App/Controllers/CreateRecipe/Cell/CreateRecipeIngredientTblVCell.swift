//
//  CreateRecipeIngredientTblVCell.swift
//  My-Kai
//
//  Created by YES IT Labs on 28/01/25.
//

import UIKit
import DropDown

protocol CreateIngredientsDelegate: AnyObject {
    func IngredientsTxtTableViewCell(_ TxtTableViewCell: CreateRecipeIngredientTblVCell, didEndEditingWithText: String?, QntText: String?)
}

class CreateRecipeIngredientTblVCell: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var TxtField: UITextField!
    @IBOutlet weak var BgV: UIView!
    
    @IBOutlet weak var Img: UIImageView!
    @IBOutlet weak var ImgBtn: UIButton!
    
    @IBOutlet weak var QntTxtF: UITextField!
    
    @IBOutlet weak var UnitLbl: UILabel!
    
    @IBOutlet weak var DropBtn: UIButton!
    
    var delegate: CreateIngredientsDelegate? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        TxtField.delegate = self
        
        QntTxtF.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == TxtField  || textField == QntTxtF{
            if textField.text?.count == 0{
                delegate?.IngredientsTxtTableViewCell(self, didEndEditingWithText: TxtField.text!, QntText: QntTxtF.text!)
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == TxtField{
            TxtField.resignFirstResponder()
        }else{
            QntTxtF.resignFirstResponder()
        }
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
      //  if textField.text?.utf8.count == 1 {
        delegate?.IngredientsTxtTableViewCell(self, didEndEditingWithText: TxtField.text!, QntText: QntTxtF.text!)
    }
}
