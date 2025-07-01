//
//  OrderHistoryVCTblVCell.swift
//  My-Kai
//
//  Created by YES IT Labs on 27/02/25.
//

import UIKit

class OrderHistoryVCTblVCell: UITableViewCell {
    
    @IBOutlet weak var ImgV: UIImageView!
    @IBOutlet weak var TxtLbl: UILabel!
    @IBOutlet weak var ViewOrdrBtn: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
