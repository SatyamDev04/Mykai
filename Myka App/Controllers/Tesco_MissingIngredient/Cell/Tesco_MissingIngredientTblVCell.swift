//
//  Tesco_MissingIngredientTblVCell.swift
//  Myka App
//
//  Created by YES IT Labs on 17/12/24.
//

import UIKit

class Tesco_MissingIngredientTblVCell: UITableViewCell {
    
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
