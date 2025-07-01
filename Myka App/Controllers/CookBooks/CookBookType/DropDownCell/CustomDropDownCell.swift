//
//  CustomDropDownCell.swift
//  Myka App
//
//  Created by Sumit on 15/12/24.
//

import UIKit
import DropDown

class CustomDropDownCell: DropDownCell {
    
    @IBOutlet weak var logoImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
