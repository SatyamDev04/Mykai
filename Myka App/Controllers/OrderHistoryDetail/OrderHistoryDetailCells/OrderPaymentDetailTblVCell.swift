//
//  OrderPaymentDetailTblVCell.swift
//  My-Kai
//
//  Created by YES IT Labs on 28/02/25.
//

import UIKit

class OrderPaymentDetailTblVCell: UITableViewCell {
    
    @IBOutlet weak var CardImg: UIImageView!
    @IBOutlet weak var CardTyp_NumberLbl: UILabel!
    @IBOutlet weak var Datelbl: UILabel!
    @IBOutlet weak var Pricelbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
