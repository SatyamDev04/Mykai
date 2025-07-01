//
//  AddUrlVC.swift
//  Myka App
//
//  Created by Sumit on 13/12/24.
//

import UIKit

class AddUrlVC: UIViewController {
    
    
    @IBOutlet weak var urlTxtF: UITextField!
    
    var backAction:(_ Url:String) -> () = {Url in }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
     
    
    @IBAction func CrossBtn(_ sender: UIButton) {
        self.willMove(toParent: nil)
        self.view.removeFromSuperview()
        self.removeFromParent()
    }
    
    
    @IBAction func SearchRecipeBtn(_ sender: UIButton) {
        guard urlTxtF.text?.count ?? 0 > 0 else {
            AlertControllerOnr(title: "Please enter the URL", message: "")
            return
        }
        backAction(urlTxtF.text!)
        self.willMove(toParent: nil)
        self.view.removeFromSuperview()
        self.removeFromParent()
    }
}
