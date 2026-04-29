//
//  SearchIngredientCollVCell.swift
//  My-Kai
//
//  Created by YES IT Labs on 30/01/25.
//

import UIKit
import SkeletonView

class SearchIngredientCollVCell: UICollectionViewCell {
    @IBOutlet weak var Img: UIImageView!
    @IBOutlet weak var NameLbl: UILabel!
    @IBOutlet weak var bgV: UIView!

    private var skeletonViews: [UIView] {
        [Img, NameLbl]
    }

    private func updateImageAppearance() {
        Img.layoutIfNeeded()
        Img.layer.cornerRadius = Img.bounds.width / 2
        Img.layer.masksToBounds = true
        Img.skeletonCornerRadius = Float(Img.bounds.width / 2)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateImageAppearance()
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
