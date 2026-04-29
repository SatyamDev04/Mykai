//
//  YouRecipeCollVCell.swift
//  Myka App
//
//  Created by Sumit on 15/12/24.
//

import UIKit
import SkeletonView

class YouRecipeCollVCell: UICollectionViewCell {
    
    @IBOutlet weak var CardContainerView: UIView!
    @IBOutlet weak var ContentContainerView: UIView!
    @IBOutlet weak var ServingsContainerView: UIView!
    @IBOutlet weak var Img: UIImageView!
    @IBOutlet weak var Namelbl: UILabel!
    @IBOutlet weak var ServCountLbl: UILabel!
    @IBOutlet weak var RemoveBtn: UIButton!
    @IBOutlet weak var MinusBtn: UIButton!
    @IBOutlet weak var plusBtn: UIButton!
    
    private var skeletonViews: [UIView] {
        [
            Img,
            Namelbl,
            ServingsContainerView,
            ServCountLbl,
            MinusBtn,
            plusBtn,
            RemoveBtn
        ]
    }

    private func updateImageAppearance() {
        Img.layoutIfNeeded()
        Img.layer.masksToBounds = true
        Img.skeletonCornerRadius = 8
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
        contentView.backgroundColor = .clear

        CardContainerView.isSkeletonable = false
        ContentContainerView.isSkeletonable = false
        CardContainerView.layer.cornerRadius = 10

        Img.isSkeletonable = true
        Namelbl.isSkeletonable = true
        Namelbl.linesCornerRadius = 4
        Namelbl.skeletonTextNumberOfLines = 2
        Namelbl.lastLineFillPercent = 70

        ServingsContainerView.isSkeletonable = true
        ServingsContainerView.skeletonCornerRadius = 12
        ServCountLbl.isSkeletonable = true
        ServCountLbl.linesCornerRadius = 4

        MinusBtn.isSkeletonable = true
        MinusBtn.skeletonCornerRadius = 12
        plusBtn.isSkeletonable = true
        plusBtn.skeletonCornerRadius = 12
        RemoveBtn.isSkeletonable = true
        RemoveBtn.skeletonCornerRadius = 16
        updateImageAppearance()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updateImageAppearance()
        RemoveBtn.imageView?.alpha = RemoveBtn.sk.isSkeletonActive ? 0.0 : 1.0
    }

    func setLoading(_ loading: Bool) {
        isUserInteractionEnabled = !loading
        contentView.isUserInteractionEnabled = !loading


        if loading {
            contentView.layoutIfNeeded()
            layoutIfNeeded()
            updateImageAppearance()
            Img.image = nil
            Namelbl.text = " "
            ServCountLbl.text = " "
           
            skeletonViews.forEach { $0.showAnimatedGradientSkeleton() }
        } else {
            skeletonViews.forEach {
                $0.stopSkeletonAnimation()
                $0.hideSkeleton(reloadDataAfter: false)
            }
        }
    }

}
