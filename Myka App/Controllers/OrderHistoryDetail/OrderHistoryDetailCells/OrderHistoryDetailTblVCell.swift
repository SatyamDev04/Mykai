//
//  OrderHistoryDetailTblVCell.swift
//  My-Kai
//
//  Created by YES IT Labs on 28/02/25.
//

import UIKit

class OrderHistoryDetailTblVCell: UITableViewCell {
    
    @IBOutlet weak var ItemCountLbl: UILabel!
    @IBOutlet weak var ItemNameLbl: UILabel!
    @IBOutlet weak var PriceLbl: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
