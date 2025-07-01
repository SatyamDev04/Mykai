//
//  targetDateDropDownTblVCell.swift
//  My Kai
//
//  Created by YES IT Labs on 13/06/25.
//

import UIKit
import DropDown

class targetDateDropDownTblVCell: DropDownCell {
    
    @IBOutlet weak var EstimateLbl: UILabel!
    @IBOutlet weak var lbPerWeekLbl: UILabel!
    @IBOutlet weak var BgV: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
