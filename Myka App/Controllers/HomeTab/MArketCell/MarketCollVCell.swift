//
//  MarketCollVCell.swift
//  Myka App
//
//  Created by Sumit on 10/12/24.
//

import UIKit

class MarketCollVCell: UICollectionViewCell {
    
    @IBOutlet weak var Img: UIImageView!
    @IBOutlet weak var MileLbl: UILabel!
    @IBOutlet weak var NameLbl: UILabel!
    @IBOutlet weak var PriceLbl: UILabel!
    
    @IBOutlet weak var BgV: UIView!
    
    @IBOutlet weak var ClosedBgV: UIView!
    @IBOutlet weak var ClosedLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
