//
//  DinnerCollVCell.swift
//  My-Kai
//
//  Created by Sumit on 11/03/25.
//

import UIKit

class DinnerCollVCell: UICollectionViewCell {
    @IBOutlet weak var NameLbl: UILabel!
    @IBOutlet weak var FavBtn: UIButton!
    @IBOutlet weak var TimeLbl: UILabel!
    
    @IBOutlet weak var ImgV: UIImageView!
    @IBOutlet weak var RatingLbl: UILabel!
    
    @IBOutlet weak var AddToPlanBtn: UIButton!
    @IBOutlet weak var CartBtn: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
