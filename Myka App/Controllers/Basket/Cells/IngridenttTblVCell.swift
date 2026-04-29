//
//  IngridenttTblVCell.swift
//  Myka App
//
//  Created by Sumit on 15/12/24.
//

import UIKit
import SkeletonView

class IngridenttTblVCell: UITableViewCell {
    
    @IBOutlet weak var CardContainerView: UIView!
    @IBOutlet weak var ImageContainerView: UIView!
    @IBOutlet weak var Img: UIImageView!
    @IBOutlet weak var NameLbl: UILabel!
    @IBOutlet weak var quantityLbl: UILabel!
    @IBOutlet weak var checkBoxBtn: UIButton!

    private var skeletonViews: [UIView] {
        [
            ImageContainerView,
            Img,
            NameLbl,
            quantityLbl,
            checkBoxBtn
        ]
    }

    private func updateImageAppearance() {
        Img.layoutIfNeeded()
        Img.layer.masksToBounds = true
        Img.skeletonCornerRadius = 10
        ImageContainerView.layoutIfNeeded()
        ImageContainerView.skeletonCornerRadius = 10
    }
   
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
        contentView.backgroundColor = .clear

        CardContainerView.isSkeletonable = false
        CardContainerView.layer.cornerRadius = 15

        ImageContainerView.isSkeletonable = true
        Img.isSkeletonable = true
        NameLbl.isSkeletonable = true
        NameLbl.linesCornerRadius = 4
        NameLbl.skeletonTextNumberOfLines = 1
        quantityLbl.isSkeletonable = true
        quantityLbl.linesCornerRadius = 4
        checkBoxBtn.isSkeletonable = true
        checkBoxBtn.skeletonCornerRadius = 12
        updateImageAppearance()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updateImageAppearance()
        checkBoxBtn.imageView?.alpha = isSkeletonActive ? 0.0 : 1.0
    }

    func setLoading(_ loading: Bool) {
        selectionStyle = .none
        isUserInteractionEnabled = !loading
        contentView.isUserInteractionEnabled = !loading
        checkBoxBtn.isUserInteractionEnabled = !loading

        if loading {
            contentView.layoutIfNeeded()
            layoutIfNeeded()
            updateImageAppearance()
            Img.image = nil
            NameLbl.text = " "
            quantityLbl.text = " "
            checkBoxBtn.setImage(nil, for: .normal)
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

    }
    
}
