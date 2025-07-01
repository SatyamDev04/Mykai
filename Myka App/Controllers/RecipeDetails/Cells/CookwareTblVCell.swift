//
//  CookwareTblVCell.swift
//  Myka App
//
//  Created by Sumit on 10/12/24.
//

import UIKit

class CookwareTblVCell: UITableViewCell {

    @IBOutlet weak var Img: UIImageView!
    
    @IBOutlet weak var NameLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
