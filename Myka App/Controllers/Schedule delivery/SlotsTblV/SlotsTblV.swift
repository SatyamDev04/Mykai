//
//  SlotsTblV.swift
//  My Kai
//
//  Created by YES IT Labs on 02/06/25.
//

import UIKit

class SlotsTblV: UITableViewCell {

    @IBOutlet weak var SlotLbl: UILabel!
    @IBOutlet weak var DiscountLbl: UILabel!
    @IBOutlet weak var RadioBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
