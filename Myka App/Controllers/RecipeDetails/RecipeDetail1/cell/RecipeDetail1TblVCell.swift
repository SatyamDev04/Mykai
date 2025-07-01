//
//  RecipeDetail1TblVCell.swift
//  Myka App
//
//  Created by Sumit on 10/12/24.
//

import UIKit

class RecipeDetail1TblVCell: UITableViewCell {
    
    @IBOutlet weak var NameLbl: UILabel!
    
    @IBOutlet weak var QuentityLbl: UILabel!
    
    @IBOutlet weak var Img: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
