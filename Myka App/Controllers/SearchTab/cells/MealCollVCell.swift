//
//  MealCollVCell.swift
//  Myka App
//
//  Created by Sumit on 12/12/24.
//

import UIKit
import SkeletonView

class MealCollVCell: UICollectionViewCell {

    @IBOutlet weak var Img: UIImageView!
    @IBOutlet weak var NameLbl: UILabel!
  //  @IBOutlet weak var NameLblH: NSLayoutConstraint!

    private var skeletonViews: [UIView] {
        [Img, NameLbl]
    }

    private func updateImageAppearance() {
        Img.layoutIfNeeded()
        Img.layer.masksToBounds = true
        Img.skeletonCornerRadius = 8
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        Img.isSkeletonable = true
        NameLbl.isSkeletonable = true
        NameLbl.linesCornerRadius = 4
        NameLbl.skeletonTextNumberOfLines = 2
        NameLbl.lastLineFillPercent = 70
        updateImageAppearance()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updateImageAppearance()
    }

    func setLoading(_ loading: Bool) {
        isUserInteractionEnabled = !loading
        contentView.isUserInteractionEnabled = !loading

        if loading {
            contentView.layoutIfNeeded()
            layoutIfNeeded()
            updateImageAppearance()
            Img.image = nil
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
