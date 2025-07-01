//
//  TableViewCell.swift
//  My Kai
//
//  Created by YES IT Labs on 01/05/25.
//

import UIKit

class ItemsTblVCell: UITableViewCell {
    @IBOutlet weak var itemCountLbl: UILabel!
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
