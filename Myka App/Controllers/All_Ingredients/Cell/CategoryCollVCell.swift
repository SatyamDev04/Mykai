//
//  CategoryCollVCell.swift
//  My Kai
//
//  Created by YES IT Labs on 31/03/25.
//

import UIKit
import SkeletonView

class CategoryCollVCell: UICollectionViewCell {
    
    @IBOutlet weak var NameLbl: UILabel!
    
    @IBOutlet weak var BgV: UIView!

    private var skeletonViews: [UIView] {
        [BgV, NameLbl]
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        BgV.isSkeletonable = true
        BgV.skeletonCornerRadius = 5
        NameLbl.isSkeletonable = true
        NameLbl.linesCornerRadius = 4
    }

    func setLoading(_ loading: Bool) {
        isUserInteractionEnabled = !loading
        contentView.isUserInteractionEnabled = !loading

        if loading {
            NameLbl.text = " "
            skeletonViews.forEach { $0.showAnimatedGradientSkeleton() }
        } else {
            skeletonViews.forEach {
                $0.stopSkeletonAnimation()
                $0.hideSkeleton(reloadDataAfter: false)
            }
        }
    }

}
