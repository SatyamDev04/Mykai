//
//  SupermarketCollVCell.swift
//  Myka App
//
//  Created by Sumit on 15/12/24.
//

import UIKit

class SupermarketCollVCell: UICollectionViewCell {
    
    @IBOutlet weak var Img: UIImageView!
    @IBOutlet weak var Namelbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var Mileslbl: UILabel!
    @IBOutlet weak var BgV: UIView!
    
    @IBOutlet weak var PriceLblH: NSLayoutConstraint!
    @IBOutlet weak var PriceLblB: NSLayoutConstraint!
    
    @IBOutlet weak var ClosedBgV: UIView!
    @IBOutlet weak var ClosedLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
