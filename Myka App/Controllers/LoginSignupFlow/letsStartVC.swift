//
//  letsStartVC.swift
//  Myka App
//
//  Created by YES IT Labs on 02/12/24.
//

import UIKit

class letsStartVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func LetsCookBtn(_ sender: UIButton) {
        let isOnboardingStatus = UserDetail.shared.getOnboardingStatus()
        let LogoutStatus = UserDetail.shared.getLogoutStatus()
        
        if isOnboardingStatus == true && LogoutStatus != true{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "IntroVC") as! IntroVC
            vc.comesFrom = "letsStart"
            
            self.navigationController?.pushViewController(vc, animated: true)
        }else if isOnboardingStatus == true && LogoutStatus == true{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "IntroVC") as! IntroVC
            vc.comesFrom = "letsStart"
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            let storyboard = UIStoryboard(name: "Login", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    
    @IBAction func LoginBtn(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
    
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
