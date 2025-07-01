//
//  SkipPopupVC.swift
//  Myka App
//
//  Created by YES IT Labs on 27/11/24.
//

import UIKit

class SkipPopupVC: UIViewController {

    var backAction:() -> () = {}
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func CancleBtn(_ sender: UIButton) {
        self.dismiss(animated: false){
            
        }
    }
    
    
    @IBAction func SkipBtn(_ sender: UIButton) {
        self.dismiss(animated: false){
            self.backAction()
        }
    }
    
}
