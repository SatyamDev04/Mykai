//
//  CookBooksCollVCell.swift
//  Myka App
//
//  Created by Sumit on 15/12/24.
//

import UIKit

class CookBooksCollVCell: UICollectionViewCell {
    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var NameLbl: UILabel!
    @IBOutlet weak var DotBtn: UIButton!
    @IBOutlet weak var TimeLbl: UILabel!
    @IBOutlet weak var AddToPlanBtn: UIButton!
    @IBOutlet weak var CartBtn: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
