//
//  IngredientsTblVCell.swift
//  My Kai
//
//  Created by YATIN  KALRA on 11/09/25.
//

import UIKit
enum IngredientCellType{
    case withHeader
    case normal
}
class IngredientsTblVCell: UITableViewCell {

    @IBOutlet weak var headerLbl: UILabel!
    @IBOutlet weak var img:UIImageView!
    @IBOutlet weak var upperlblV:UIView!
    @IBOutlet weak var amout_MeasurmentLbl:UILabel!
    @IBOutlet weak var ingredientlbl:UILabel!
    @IBOutlet weak var checkBoxView:UIView!
    @IBOutlet weak var checkBoxBtn:UIButton!
    @IBOutlet weak var paddingView:UIView!
    
    var type: IngredientCellType = .normal {
        didSet {
          if  type == .withHeader{
              paddingView.isHidden = false
          }else{
              paddingView.isHidden = true
          }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
}
