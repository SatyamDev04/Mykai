//
//  ChooseDaysTblVCell.swift
//  Myka App
//
//  Created by YES IT Labs on 06/12/24.
//

import UIKit

class ChooseDaysTblVCell: UITableViewCell {
    @IBOutlet weak var NameLbl: UILabel!
    @IBOutlet weak var selectedBgImg: UIImageView!
    @IBOutlet weak var DropIMg: UIImageView!
    @IBOutlet weak var TickImg: UIImageView!
    @IBOutlet weak var ViewBottomConstant: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
