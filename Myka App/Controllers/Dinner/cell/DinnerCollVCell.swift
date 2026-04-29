//
//  DinnerCollVCell.swift
//  My-Kai
//
//  Created by Sumit on 11/03/25.
//

import UIKit
import Cosmos
import SkeletonView

class DinnerCollVCell: UICollectionViewCell {
    @IBOutlet weak var CardContainerView: UIView!
    @IBOutlet weak var TimeBadgeView: UIView!
    @IBOutlet weak var AddToPlanContainerView: UIView!
    @IBOutlet weak var CartContainerView: UIView!
    @IBOutlet weak var NameLbl: UILabel!
    @IBOutlet weak var FavBtn: UIButton!
    @IBOutlet weak var TimeLbl: UILabel!
    
    @IBOutlet weak var ImgV: UIImageView!
//    @IBOutlet weak var RatingLbl: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var AddToPlanBtn: UIButton!
    @IBOutlet weak var CartBtn: UIButton!

    private var skeletonViews: [UIView] {
        [
            ImgV,
            TimeBadgeView,
            TimeLbl,
            FavBtn,
            NameLbl,
            AddToPlanContainerView,
            AddToPlanBtn,
            CartContainerView,
            CartBtn
        ]
    }

    private func updateImageAppearance() {
        ImgV.layoutIfNeeded()
        ImgV.clipsToBounds = true
        ImgV.skeletonCornerRadius = 8
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        isSkeletonable = true
        contentView.isSkeletonable = true
        backgroundColor = .clear
        contentView.backgroundColor = .clear

        CardContainerView.isSkeletonable = false
        CardContainerView.layer.cornerRadius = 10
        CardContainerView.clipsToBounds = false

        ImgV.isSkeletonable = true

        TimeBadgeView.isSkeletonable = true
        TimeBadgeView.skeletonCornerRadius = 5
        TimeLbl.isSkeletonable = true
        TimeLbl.linesCornerRadius = 3

        FavBtn.isSkeletonable = true
        FavBtn.skeletonCornerRadius = 11

        NameLbl.isSkeletonable = true
        NameLbl.linesCornerRadius = 4
        NameLbl.skeletonTextNumberOfLines = 2
        NameLbl.lastLineFillPercent = 75

        AddToPlanContainerView.isSkeletonable = true
        AddToPlanContainerView.skeletonCornerRadius = 5
        AddToPlanBtn.isSkeletonable = true
        AddToPlanBtn.skeletonCornerRadius = 5

        CartContainerView.isSkeletonable = true
        CartContainerView.skeletonCornerRadius = 5
        CartBtn.isSkeletonable = true
        CartBtn.skeletonCornerRadius = 5

        ratingView.isSkeletonable = true
        ratingView.cornerRadius = 4
        updateImageAppearance()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updateImageAppearance()
        let shouldHideRating = FavBtn.isSkeletonActive
        ratingView.alpha = shouldHideRating ? 0.0 : 1.0
        FavBtn.imageView?.alpha = shouldHideRating ? 0.0 : 1.0
    }

    func setLoading(_ loading: Bool) {
        isUserInteractionEnabled = !loading
        contentView.isUserInteractionEnabled = !loading
       

        if loading {
            contentView.layoutIfNeeded()
            layoutIfNeeded()
            updateImageAppearance()
            ImgV.image = nil
            NameLbl.text = " "
            TimeLbl.text = " "
            FavBtn.setImage(nil, for: .normal)
            AddToPlanBtn.setTitle(nil, for: .normal)
            CartBtn.setImage(nil, for: .normal)
            skeletonViews.forEach { $0.showAnimatedGradientSkeleton() }
        } else {
            skeletonViews.forEach {
                $0.stopSkeletonAnimation()
                $0.hideSkeleton(reloadDataAfter: false)
            }
        }
        setNeedsLayout()
    }

}
