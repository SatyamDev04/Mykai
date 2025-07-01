//
//  MissingIngredientsTblVCell.swift
//  Myka App
//
//  Created by Sumit on 07/12/24.
//

import UIKit

class MissingIngredientsTblVCell: UITableViewCell {

    @IBOutlet weak var NameLbl: UILabel!
    
    @IBOutlet weak var QuentityLbl: UILabel!
    
    @IBOutlet weak var Img: UIImageView!
    
    @IBOutlet weak var CheckBtn: UIButton!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
