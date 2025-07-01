//
//  SavedCardBankTblVCell.swift
//  Myka App
//
//  Created by YES IT Labs on 20/12/24.
//

import UIKit

class SavedCardBankTblVCell: UITableViewCell {

    @IBOutlet weak var Img: UIImageView!
    @IBOutlet weak var BankNamelbl: UILabel!
    @IBOutlet weak var BankNumLbl: UILabel!
    @IBOutlet weak var OptionBtn: UIButton!
    @IBOutlet weak var SelectedImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
