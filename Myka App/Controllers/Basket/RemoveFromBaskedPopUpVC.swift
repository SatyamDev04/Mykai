//
//  RemoveFromBaskedPopUpVC.swift
//  Myka App
//
//  Created by Sumit on 15/12/24.
//

import UIKit

class RemoveFromBaskedPopUpVC: UIViewController {
    
    var ID = ""
    
    var backAction:(_ id: String) -> () = {id in }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func CancelBtn(_ sender: UIButton) {
        self.willMove(toParent: nil)
        self.view.removeFromSuperview()
        self.removeFromParent()
    }
    
    @IBAction func Removebtn(_ sender: UIButton) {
        self.backAction(ID)
        self.willMove(toParent: nil)
        self.view.removeFromSuperview()
        self.removeFromParent()
    }
}
