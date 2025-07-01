//
//  SwapTblVCell.swift
//  Myka App
//
//  Created by YES IT Labs on 17/12/24.
//

import UIKit

class SwapTblVCell: UITableViewCell {
    
    @IBOutlet weak var Img: UIImageView!
    @IBOutlet weak var NameLbl: UILabel!
    @IBOutlet weak var Pricelbl: UILabel!
    @IBOutlet weak var ViewDetailBtn: UIButton!
    @IBOutlet weak var Countlbl: UILabel!
    @IBOutlet weak var MinusBtn: UIButton!
    @IBOutlet weak var PlusBtn: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
