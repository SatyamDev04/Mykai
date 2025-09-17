//
//  IngredientsTblVCell.swift
//  My Kai
//
//  Created by YATIN  KALRA on 11/09/25.
//

import UIKit

class IngredientsTblVCell: UITableViewCell {

    @IBOutlet weak var headerLbl: UILabel!
    @IBOutlet weak var img:UIImageView!
    @IBOutlet weak var upperlblV:UIView!
    @IBOutlet weak var amout_MeasurmentLbl:UILabel!
    @IBOutlet weak var ingredientlbl:UILabel!
    @IBOutlet weak var lowerlblV:UIView!
    @IBOutlet weak var lowerLbl:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
}
