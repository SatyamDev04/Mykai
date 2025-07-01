//
//  TescoVC.swift
//  Myka App
//
//  Created by YES IT Labs on 16/12/24.
//

import UIKit

class TescoVC: UIViewController {

    @IBOutlet weak var SiteLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SiteLbl.isUserInteractionEnabled = true
        SiteLbl.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapOnLabel(_:))))
    }
    
    @objc func handleTapOnLabel(_ gesture: UITapGestureRecognizer) {
        guard let text = self.SiteLbl.attributedText?.string else { return }
        let clickableTextRange = (text as NSString).range(of: "Tesco.com")
         
        if gesture.didTapAttributedTextInLabel(label: self.SiteLbl, inRange: clickableTextRange) {
            print("Tesco.com tapped")
            navigateToPolicy(type: "Tesco")
        }
    }
    
    private func navigateToPolicy(type: String) {
 
    }
  
    @IBAction func BAckBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func AddToTescoBtn(_ sender: UIButton) {
    }
}
