//
//  RecipeCollVCell.swift
//  My Kai
//
//  Created by YES IT Labs on 08/05/25.
//

import UIKit

class RecipeCollVCell: UICollectionViewCell {
    
    @IBOutlet weak var NameLbl: UILabel!
    @IBOutlet weak var FavBtn: UIButton!
    @IBOutlet weak var TimeLbl: UILabel!
    
    @IBOutlet weak var ImgV: UIImageView!
     
    @IBOutlet weak var AddToPlanBtn: UIButton!
    @IBOutlet weak var CartBtn: UIButton!
 
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
