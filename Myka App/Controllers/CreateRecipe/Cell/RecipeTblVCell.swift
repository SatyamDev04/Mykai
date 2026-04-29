//
//  RecipeTblVCell.swift
//  My Kai
//
//  Created by YATIN  KALRA on 11/09/25.
//



import UIKit
import SkeletonView

class RecipeTblVCell: UITableViewCell {

    @IBOutlet weak var stepLbl: UILabel!
    @IBOutlet weak var recipeLbl: UILabel!
    @IBOutlet weak var paddingView:UIView!

    private var skeletonViews: [UIView] {
        [stepLbl, recipeLbl]
    }
    
    
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
        stepLbl.isSkeletonable = true
        stepLbl.linesCornerRadius = 4
        recipeLbl.isSkeletonable = true
        recipeLbl.linesCornerRadius = 4
        recipeLbl.skeletonTextNumberOfLines = 3
        recipeLbl.lastLineFillPercent = 70
    }

    func setLoading(_ loading: Bool) {
        isUserInteractionEnabled = !loading
        contentView.isUserInteractionEnabled = !loading

        if loading {
            contentView.layoutIfNeeded()
            layoutIfNeeded()
            stepLbl.text = " "
            recipeLbl.text = " "
            skeletonViews.forEach { $0.showAnimatedGradientSkeleton() }
        } else {
            skeletonViews.forEach {
                $0.stopSkeletonAnimation()
                $0.hideSkeleton(reloadDataAfter: false)
            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
