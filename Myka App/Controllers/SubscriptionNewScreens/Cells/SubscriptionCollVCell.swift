//
//  SubscriptionCollVCell.swift
//  My Kai
//
//  Created by YES IT Labs on 08/04/25.
//

import UIKit
import SwiftGifOrigin

class SubscriptionCollVCell: UICollectionViewCell {

    // this is only for First index of the cell Outlets.
    @IBOutlet weak var ProfileImg: UIImageView!
    @IBOutlet weak var TitleLbl: UILabel!
    @IBOutlet weak var UserCookBookLbl: UILabel!
    @IBOutlet weak var GifImageV: UIImageView!
    //
    
    @IBOutlet weak var FirstIndxBgV: UIView!
    @IBOutlet weak var SecondIndxBgV: UIView!
    @IBOutlet weak var ImgV: UIImageView!
    
    @IBOutlet weak var LifeTimeLbl: UILabel!
    
    @IBOutlet weak var GiftIconTopConst: NSLayoutConstraint!
    
    @IBOutlet weak var GIFBottomConst: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        TitleLbl.adjustsFontSizeToFitWidth = true
        TitleLbl.minimumScaleFactor = 0.5
        
        LifeTimeLbl.adjustsFontSizeToFitWidth = true
        LifeTimeLbl.minimumScaleFactor = 0.5
        
        UserCookBookLbl.adjustsFontSizeToFitWidth = true
        UserCookBookLbl.minimumScaleFactor = 0.5
        
        self.setCollVSpaceAccordingToDevice()
    }
    
    func setCollVSpaceAccordingToDevice() {
        if UIDevice.current.hasNotch {
            //... consider notch
            let modelName = UIDevice.modelName
            print(modelName, "modelName")
            if modelName.contains(find: "mini"){//"iPhone 12 mini"{
                self.GiftIconTopConst.constant = 10
                self.GIFBottomConst.constant = 15
            }else if modelName.contains(find: "Max"){
                self.GiftIconTopConst.constant = 45
                self.GIFBottomConst.constant = 45
            }else if modelName.contains(find: "Pro"){
                self.GiftIconTopConst.constant = 45
                self.GIFBottomConst.constant = 45
            }else{
                self.GiftIconTopConst.constant = 40
                self.GIFBottomConst.constant = 40
            }
        }else{
            self.GiftIconTopConst.constant = 10
            self.GIFBottomConst.constant = 15
        }
    }

}
