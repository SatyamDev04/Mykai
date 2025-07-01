//
//  MarketTblVCell.swift
//  My-Kai
//
//  Created by YES IT Labs on 28/02/25.
//

import UIKit

class MarketTblVCell: UITableViewCell {

    @IBOutlet weak var ImgV: UIImageView!
    @IBOutlet weak var OrderIDLbl: UILabel!
    @IBOutlet weak var TotalitmCountLbl: UILabel!
    @IBOutlet weak var TotalPriceLbl: UILabel!
    @IBOutlet weak var InfoBtn: UIButton!
    @IBOutlet weak var ViewItemsBtn: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
