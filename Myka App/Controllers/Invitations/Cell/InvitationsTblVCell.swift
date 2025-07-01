//
//  InvitationsTblVCell.swift
//  Myka App
//
//  Created by Sumit on 12/12/24.
//

import UIKit

class InvitationsTblVCell: UITableViewCell {

    @IBOutlet weak var NameLbl: UILabel!
    @IBOutlet weak var TypeBgV: UIView!
    @IBOutlet weak var TypeLbl: UILabel!
    @IBOutlet weak var LineLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
