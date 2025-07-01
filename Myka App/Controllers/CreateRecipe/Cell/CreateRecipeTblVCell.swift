//
//  CreateRecipeTblVCell.swift
//  Myka App
//
//  Created by Sumit on 13/12/24.
//

import UIKit

protocol CreateRecipeDelegate: AnyObject {
    func TxtTableViewCell(_ TxtTableViewCell: CreateRecipeTblVCell, didEndEditingWithText: String?)
}


class CreateRecipeTblVCell: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var TxtField: UITextField!
    @IBOutlet weak var BgV: UIView!
    @IBOutlet weak var TitleBgV: UIView!
    @IBOutlet weak var TitleTxt: UITextField!
    
    var delegate: CreateRecipeDelegate? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        TxtField.delegate = self
        
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == TxtField  && TxtField.text?.count == 0{
            delegate?.TxtTableViewCell(self, didEndEditingWithText: TxtField.text!)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        TxtField.resignFirstResponder()
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
      //  if textField.text?.utf8.count == 1 {
        delegate?.TxtTableViewCell(self, didEndEditingWithText: TxtField.text!)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
