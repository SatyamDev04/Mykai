//
//  DishCollVCell.swift
//  Myka App
//
//  Created by YES IT Labs on 09/01/25.
//

import UIKit

class DishCollVCell: UICollectionViewCell {
    
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

}
