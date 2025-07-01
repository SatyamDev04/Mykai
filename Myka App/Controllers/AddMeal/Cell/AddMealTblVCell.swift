//
//  AddMealTblVCell.swift
//  Myka App
//
//  Created by Sumit on 11/12/24.
//

import UIKit

class AddMealTblVCell: UITableViewCell {

    @IBOutlet weak var Img: UIImageView!
    @IBOutlet weak var NameLbl: UILabel!
    @IBOutlet weak var ServiceCountLbl: UILabel!
    @IBOutlet weak var MinusBtn: UIButton!
    @IBOutlet weak var PlusBtn: UIButton!
    @IBOutlet weak var DropImg: UIImageView!  
    @IBOutlet weak var DropDownBtn: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
