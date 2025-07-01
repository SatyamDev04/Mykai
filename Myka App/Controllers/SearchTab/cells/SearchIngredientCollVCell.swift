//
//  SearchIngredientCollVCell.swift
//  My-Kai
//
//  Created by YES IT Labs on 30/01/25.
//

import UIKit

class SearchIngredientCollVCell: UICollectionViewCell {
    @IBOutlet weak var Img: UIImageView!
    @IBOutlet weak var NameLbl: UILabel!
    @IBOutlet weak var bgV: UIView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        Img.layoutIfNeeded() // Ensure layout is finalized
        Img.layer.cornerRadius = Img.bounds.width / 2
        Img.layer.masksToBounds = true
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        Img.layer.cornerRadius = Img.bounds.width / 2
        Img.layer.masksToBounds = true
    }
}
