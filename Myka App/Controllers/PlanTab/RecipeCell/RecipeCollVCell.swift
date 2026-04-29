//
//  RecipeCollVCell.swift
//  My Kai
//
//  Created by YES IT Labs on 08/05/25.
//

import UIKit
import SkeletonView

class RecipeCollVCell: UICollectionViewCell {
    
    @IBOutlet weak var NameLbl: UILabel!
    @IBOutlet weak var FavBtn: UIButton!
    @IBOutlet weak var TimeLbl: UILabel!
    
    @IBOutlet weak var ImgV: UIImageView!
     
    @IBOutlet weak var AddToPlanBtn: UIButton!
    @IBOutlet weak var CartBtn: UIButton!
 
    
    override func awakeFromNib() {
        super.awakeFromNib()
        isSkeletonable = true
        contentView.isSkeletonable = true
        ImgV.isSkeletonable = true
        ImgV.skeletonCornerRadius = 10
        NameLbl.isSkeletonable = true
        TimeLbl.isSkeletonable = true
    }

}
