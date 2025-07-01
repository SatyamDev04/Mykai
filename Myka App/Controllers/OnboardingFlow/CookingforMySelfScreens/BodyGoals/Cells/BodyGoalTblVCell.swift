//
//  BodyGoalTblVCell.swift
//  Myka App
//
//  Created by YES IT Labs on 27/11/24.
//

import UIKit

protocol AddOtherTxtDelegate: AnyObject {
    func AddOtherTxtTableViewCell(_ TxtTableViewCell: BodyGoalTblVCell, didEndEditingWithText: String?)
}

class BodyGoalTblVCell: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var NameLbl: UILabel!
    @IBOutlet weak var selectedBgImg: UIImageView!
    @IBOutlet weak var TickImg: UIImageView!
    @IBOutlet weak var BottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var AddotherTxtF: UITextField!
    @IBOutlet weak var AddOthherBgV: UIView!
    
    
    var delegate: AddOtherTxtDelegate? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.AddotherTxtF.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == AddotherTxtF{
            if textField.text?.count == 0{
                delegate?.AddOtherTxtTableViewCell(self, didEndEditingWithText: AddotherTxtF.text!)
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == AddotherTxtF{
            AddotherTxtF.resignFirstResponder()
        }
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
      //  if textField.text?.utf8.count == 1 {
        delegate?.AddOtherTxtTableViewCell(self, didEndEditingWithText: AddotherTxtF.text!)
    }
}
