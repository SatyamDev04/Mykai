//
//  AddMoreTblVCell.swift
//  Myka App
//
//  Created by Sumit on 15/12/24.
//

import UIKit

class AddMoreTblVCell: UITableViewCell {

    @IBOutlet weak var NameLbl: UILabel!
    @IBOutlet weak var CountLbl: UILabel!
    @IBOutlet weak var MinusBtn: UIButton!
    @IBOutlet weak var PlusBtn: UIButton!
    @IBOutlet weak var RemoveBtn: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
