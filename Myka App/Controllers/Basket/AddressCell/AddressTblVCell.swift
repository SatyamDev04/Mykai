//
//  AddressTblVCell.swift
//  My-Kai
//
//  Created by YES IT Labs on 26/02/25.
//

import UIKit

class AddressTblVCell: UITableViewCell {
    @IBOutlet weak var BgV: UIView!
    
    @IBOutlet weak var ImgV: UIImageView!
    @IBOutlet weak var AddTypeLbl: UILabel!
    @IBOutlet weak var Addresslbl: UILabel!
    @IBOutlet weak var EditBtn: UIButton!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
