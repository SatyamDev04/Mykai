//
//  CardCell.swift
//  My Kai
//
//  Created by YES IT Labs on 24/04/25.
//

import UIKit

class CardCell: UITableViewCell {
    
    @IBOutlet weak var PrefferedLbl: UILabel!
    @IBOutlet weak var CArdImg: UIImageView!
    @IBOutlet weak var CardName: UILabel!
    @IBOutlet weak var CardNumber: UILabel!
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
