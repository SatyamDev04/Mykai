//
//  levelDropDownTblVCell.swift
//  My Kai
//
//  Created by YES IT Labs on 06/06/25.
//

import UIKit
import DropDown

class levelDropDownTblVCell: DropDownCell {

    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var BGV:UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
