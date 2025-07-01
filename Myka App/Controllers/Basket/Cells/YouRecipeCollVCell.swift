//
//  YouRecipeCollVCell.swift
//  Myka App
//
//  Created by Sumit on 15/12/24.
//

import UIKit

class YouRecipeCollVCell: UICollectionViewCell {
    
    @IBOutlet weak var Img: UIImageView!
    @IBOutlet weak var Namelbl: UILabel!
    @IBOutlet weak var ServCountLbl: UILabel!
    @IBOutlet weak var RemoveBtn: UIButton!
    @IBOutlet weak var MinusBtn: UIButton!
    @IBOutlet weak var plusBtn: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
