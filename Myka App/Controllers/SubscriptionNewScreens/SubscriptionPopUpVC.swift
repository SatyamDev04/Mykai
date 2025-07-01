//
//  SubscriptionPopUpVC.swift
//  My Kai
//
//  Created by YES IT Labs on 22/04/25.
//

import UIKit

class SubscriptionPopUpVC: UIViewController {
    
    @IBOutlet weak var PopupBGV: UIView!
    
    var BackAction:()->() = {}
    
    var BasketBackAction:()->() = {}

    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        PopupBGV.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        print("View was tapped!")
        self.willMove(toParent: nil)
        self.view.removeFromSuperview()
        self.removeFromParent()
    }
    
    @IBAction func CloseBtn(_ sender: UIButton) {
        BasketBackAction()
        self.willMove(toParent: nil)
        self.view.removeFromSuperview()
        self.removeFromParent()
    }
    
    @IBAction func OkayBtn(_ sender: UIButton) {
        self.willMove(toParent: nil)
        self.view.removeFromSuperview()
        self.removeFromParent()
        BackAction()
   }
}
