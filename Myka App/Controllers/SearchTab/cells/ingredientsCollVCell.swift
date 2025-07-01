//
//  ingredientsCollVCell.swift
//  Myka App
//
//  Created by Sumit on 12/12/24.
//

import UIKit

class ingredientsCollVCell: UICollectionViewCell {
    
    @IBOutlet weak var Img: UIImageView!
    @IBOutlet weak var NameLbl: UILabel!
    @IBOutlet weak var bgV: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.Img.layer.cornerRadius = self.Img.frame.size.width / 2
        self.Img.layer.masksToBounds = true
    }

}
