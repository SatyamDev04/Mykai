//
//  YourCoockedMealCollVCell.swift
//  Myka App
//
//  Created by Sumit on 11/12/24.
//

import UIKit

class YourCoockedMealCollVCell: UICollectionViewCell {

    @IBOutlet weak var EatBtn: UIButton!
    @IBOutlet weak var FavBtn: UIButton!
    @IBOutlet weak var IMg: UIImageView!
    @IBOutlet weak var NameLbl: UILabel!
    @IBOutlet weak var DayLbl: UILabel!
    @IBOutlet weak var removeBtn: UIButton!
    @IBOutlet weak var removeImg: UIImageView!
    
    @IBOutlet weak var ServeCountLbl: UILabel!
    @IBOutlet weak var PlusBtn: UIButton!
    @IBOutlet weak var MinusBtn: UIButton!
    
    
    var isAnimate: Bool! = true

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        removeBtn.isHidden = true
        removeImg.isHidden = true
    }
    
    func startAnimate() {
        let shakeAnimation = CABasicAnimation(keyPath: "transform.rotation")
        
        // Configure rotation angles (subtle wiggle)
        let startAngle: Float = (-2) * Float.pi / 180  // -2 degrees
        let stopAngle: Float = 2 * Float.pi / 180     // 2 degrees
        
        shakeAnimation.fromValue = NSNumber(value: startAngle)
        shakeAnimation.toValue = NSNumber(value: stopAngle)
        shakeAnimation.duration = 0.1 // Short duration for quick jiggles
        shakeAnimation.autoreverses = true // Reverse back to start angle
        shakeAnimation.repeatCount = Float.infinity // Repeat indefinitely
        
        // Randomize the start time for visual variance between layers
        shakeAnimation.timeOffset = CFTimeInterval(drand48())

        // Apply the animation to the layer
        self.layer.add(shakeAnimation, forKey: "jiggle")
        
        // Bring Remove button to the front and enable interactions
        removeBtn.isHidden = false
        removeImg.isHidden = false
        removeBtn.isUserInteractionEnabled = true
        self.bringSubviewToFront(removeBtn)
        
        // Hide other elements
        EatBtn.isHidden = true
        FavBtn.isHidden = true
        
        // Update animation state
        isAnimate = true
    }

    
   
    func stopAnimate() {
        self.layer.removeAnimation(forKey: "jiggle")
            removeBtn.isHidden = true
            removeImg.isHidden = true
            EatBtn.isHidden = false
            FavBtn.isHidden = false
            isAnimate = false
        }
    
}

