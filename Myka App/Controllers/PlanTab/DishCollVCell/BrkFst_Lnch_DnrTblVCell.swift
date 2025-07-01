//
//  BrkFst_Lnch_DnrTblVCell.swift
//  Myka App
//
//  Created by Sumit on 15/12/24.
//

import UIKit

class BrkFst_Lnch_DnrTblVCell: UITableViewCell {

    @IBOutlet weak var MealNameLbl: UILabel!
    @IBOutlet weak var SwapBtn: UIButton!
    @IBOutlet weak var MealIMg: UIImageView!
    @IBOutlet weak var ServCountLbl: UILabel!
    @IBOutlet weak var MinusBtn: UIButton!
    @IBOutlet weak var PlusBtn: UIButton!
    
    @IBOutlet weak var TotalTimeLbl: UILabel!
    @IBOutlet weak var PrepTimelbl: UILabel!
    
    @IBOutlet weak var Calorieslbl: UILabel!
    @IBOutlet weak var Fatlbl: UILabel!
    @IBOutlet weak var Carbslbl: UILabel!
    @IBOutlet weak var Protienlbl: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
