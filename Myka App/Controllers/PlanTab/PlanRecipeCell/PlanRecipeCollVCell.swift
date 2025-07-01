//
//  PlanRecipeCollVCell.swift
//  My Kai
//
//  Created by YES IT Labs on 23/05/25.
//

import UIKit

class PlanRecipeCollVCell: UICollectionViewCell {

    @IBOutlet weak var NameLbl: UILabel!
    @IBOutlet weak var FavBtn: UIButton!
    @IBOutlet weak var TimeLbl: UILabel!
    
    @IBOutlet weak var ImgV: UIImageView!
     
    @IBOutlet weak var AddToPlanBtn: UIButton!
    @IBOutlet weak var CartBtn: UIButton!
 
    @IBOutlet weak var RAtingLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
