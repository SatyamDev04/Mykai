//
//  DishCollVCell.swift
//  Myka App
//
//  Created by YES IT Labs on 09/01/25.
//

import UIKit
import SkeletonView

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

    private var skeletonViews: [UIView] {
        [
            MealNameLbl,
            SwapBtn,
            MealIMg,
            ServCountLbl,
            MinusBtn,
            PlusBtn,
            TotalTimeLbl,
            PrepTimelbl,
            Calorieslbl,
            Fatlbl,
            Carbslbl,
            Protienlbl
        ]
    }

    private func updateImageAppearance() {
        MealIMg.layoutIfNeeded()
        MealIMg.layer.masksToBounds = true
        MealIMg.skeletonCornerRadius = 10
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        MealIMg.isSkeletonable = true
        MealNameLbl.isSkeletonable = true
        MealNameLbl.linesCornerRadius = 4
        MealNameLbl.skeletonTextNumberOfLines = 2
        MealNameLbl.lastLineFillPercent = 70
        SwapBtn.isSkeletonable = true
        SwapBtn.skeletonCornerRadius = 5
        ServCountLbl.isSkeletonable = true
        ServCountLbl.linesCornerRadius = 4
        MinusBtn.isSkeletonable = true
        MinusBtn.skeletonCornerRadius = 12
        PlusBtn.isSkeletonable = true
        PlusBtn.skeletonCornerRadius = 12
        TotalTimeLbl.isSkeletonable = true
        TotalTimeLbl.linesCornerRadius = 4
        PrepTimelbl.isSkeletonable = true
        PrepTimelbl.linesCornerRadius = 4
        Calorieslbl.isSkeletonable = true
        Calorieslbl.linesCornerRadius = 4
        Fatlbl.isSkeletonable = true
        Fatlbl.linesCornerRadius = 4
        Carbslbl.isSkeletonable = true
        Carbslbl.linesCornerRadius = 4
        Protienlbl.isSkeletonable = true
        Protienlbl.linesCornerRadius = 4
        updateImageAppearance()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updateImageAppearance()
    }

    func setLoading(_ loading: Bool) {
        isUserInteractionEnabled = !loading
        contentView.isUserInteractionEnabled = !loading
        SwapBtn.isUserInteractionEnabled = !loading
        MinusBtn.isUserInteractionEnabled = !loading
        PlusBtn.isUserInteractionEnabled = !loading

        if loading {
            contentView.layoutIfNeeded()
            layoutIfNeeded()
            updateImageAppearance()
            MealIMg.image = nil
            MealNameLbl.text = " "
            ServCountLbl.text = " "
            TotalTimeLbl.text = " "
            PrepTimelbl.text = " "
            Calorieslbl.text = " "
            Fatlbl.text = " "
            Carbslbl.text = " "
            Protienlbl.text = " "
            SwapBtn.setTitle(nil, for: .normal)
            MinusBtn.setImage(nil, for: .normal)
            PlusBtn.setImage(nil, for: .normal)
            skeletonViews.forEach { $0.showAnimatedGradientSkeleton() }
        } else {
            skeletonViews.forEach {
                $0.stopSkeletonAnimation()
                $0.hideSkeleton(reloadDataAfter: false)
            }
        }
    }

}
