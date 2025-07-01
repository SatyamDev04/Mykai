//
//  BrealFLunchDinnerCollV.swift
//  Myka App
//
//  Created by YES IT Labs on 05/12/24.
//

import UIKit

class BrealFLunchDinnerCollV: UICollectionViewCell {
    
    @IBOutlet weak var MinLbl: UILabel!
    @IBOutlet weak var FavBtn: UIButton!
    @IBOutlet weak var IMg: UIImageView!
    @IBOutlet weak var NameLbl: UILabel!
    @IBOutlet weak var IngredientLbl: UILabel!
    @IBOutlet weak var IngredientImg: UIImageView!
    @IBOutlet weak var CheckImg: UIImageView!
    @IBOutlet weak var CheckBtn: UIButton!
    @IBOutlet weak var TimeBgV: UIView!
    @IBOutlet weak var removeBtn: UIButton!
    @IBOutlet weak var removeImg: UIImageView!
    
    
    var isAnimate: Bool! = true

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        removeBtn.isHidden = true
        removeImg.isHidden = true
    }
    
//    func startAnimate() {
//        let shakeAnimation = CABasicAnimation(keyPath: "transform.rotation")
//        
//        // Configure rotation angles (small, subtle wiggle)
//        let startAngle: Float = (-2) * Float.pi / 180  // -2 degrees
//        let stopAngle: Float = 2 * Float.pi / 180     // 2 degrees
//        
//        shakeAnimation.fromValue = NSNumber(value: startAngle)
//        shakeAnimation.toValue = NSNumber(value: stopAngle)
//        shakeAnimation.duration = 0.1 // Short duration for quick jiggles
//        shakeAnimation.autoreverses = true // Reverse back to start angle
//        shakeAnimation.repeatCount = Float.infinity // Repeat indefinitely
//        
//        // Randomize the start time for visual variance between layers
//        shakeAnimation.timeOffset = CFTimeInterval(drand48())
//
//        // Apply the animation to the layer
//        self.layer.add(shakeAnimation, forKey: "jiggle")
//        
//        // Show or hide additional UI elements as needed
//        removeBtn.isHidden = false
//        TimeBgV.isHidden = true
//        FavBtn.isHidden = true
//        isAnimate = true
//    }
    func startAnimate() {
        let shakeAnimation = CABasicAnimation(keyPath: "transform.rotation")
        
        // Configure rotation angles (subtle wiggle)
        let startAngle: Float = (-1) * Float.pi / 180  // -2 degrees
        let stopAngle: Float = 1 * Float.pi / 180     // 2 degrees
        
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
        TimeBgV.isHidden = true
        FavBtn.isHidden = true
        
        // Update animation state
        isAnimate = true
    }

    
   
    func stopAnimate() {
        self.layer.removeAnimation(forKey: "jiggle")
            removeBtn.isHidden = true
            removeImg.isHidden = true
            TimeBgV.isHidden = false
            FavBtn.isHidden = false
            isAnimate = false
        }
    
}
