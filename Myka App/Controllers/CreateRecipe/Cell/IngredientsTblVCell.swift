//
//  IngredientsTblVCell.swift
//  My Kai
//
//  Created by YATIN  KALRA on 11/09/25.
//

import UIKit
import SkeletonView
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

    private var skeletonViews: [UIView] {
        [img, ingredientlbl, amout_MeasurmentLbl, checkBoxView]
    }

    private func updateImageAppearance() {
        img.clipsToBounds = true
        img.layer.cornerRadius = img.bounds.height / 2
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
    
    func configure(with model: IngredientDataModel, type: IngredientCellType) {
        self.type = type
        self.ingredientlbl?.text = model.name
        if let quantity = model.quantity, let unit = model.unit {
            self.amout_MeasurmentLbl?.text = "\(quantity) \(unit)".trimmingCharacters(in: .whitespaces)
        } else {
            self.amout_MeasurmentLbl?.text = ""
        }
        self.img.setRemoteImage(URL(string: model.img ?? ""), placeholder: UIImage(named: "No_Image"))
     //   self.checkBoxView.isHidden = true
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        updateImageAppearance()
        img.isSkeletonable = true
        img.skeletonCornerRadius = Float(img.bounds.height / 2)
        ingredientlbl.isSkeletonable = true
        ingredientlbl.linesCornerRadius = 4
        amout_MeasurmentLbl.isSkeletonable = true
        amout_MeasurmentLbl.linesCornerRadius = 4
        checkBoxView.isSkeletonable = true
        checkBoxView.skeletonCornerRadius = 12
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
            img.image = nil
            ingredientlbl.text = " "
            amout_MeasurmentLbl.text = " "
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
