//
//  IngridenttTblVCell.swift
//  Myka App
//
//  Created by Sumit on 15/12/24.
//

import UIKit

class IngridenttTblVCell: UITableViewCell {
    
    @IBOutlet weak var Img: UIImageView!
    @IBOutlet weak var NameLbl: UILabel!
    @IBOutlet weak var quantityLbl: UILabel!
    @IBOutlet weak var checkBoxBtn: UIButton!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}

