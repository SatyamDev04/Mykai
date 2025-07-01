//
//  PlanTblVCell.swift
//  My Kai
//
//  Created by YES IT Labs on 08/04/25.
//

import UIKit

class PlanTblVCell: UITableViewCell {

    @IBOutlet weak var BgV: UIView!
    @IBOutlet weak var PlanTypeBgV: UIView!
    @IBOutlet weak var TypeTxtLbl: UILabel!
    @IBOutlet weak var TypeOfUserLbl: UILabel!
    
    @IBOutlet weak var RadioIMg: UIImageView!
    
    @IBOutlet weak var OriginalPriceLbl: UILabel!
    @IBOutlet weak var DiscountView: UIView!
    @IBOutlet weak var DiscountedPriceLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
