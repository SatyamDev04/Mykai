//
//  CookingForVC.swift
//  Myka App
//
//  Created by YES IT Labs on 27/11/24.
//

import UIKit

class CookingForVC: UIViewController {
    
    @IBOutlet weak var MyselfBgImg: UIImageView!
    @IBOutlet weak var PartnerBgImg: UIImageView!
    @IBOutlet weak var FamilyBgImg: UIImageView!
    
    @IBOutlet weak var MySelfTickImg: UIImageView!
    @IBOutlet weak var PartnerTickImg: UIImageView!
    @IBOutlet weak var FamilyTickImg: UIImageView!
    
    var type = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.MyselfBgImg.image = UIImage(named: "YelloBorder")
        self.PartnerBgImg.image = UIImage(named: "Rectangle 4475")
        self.FamilyBgImg.image = UIImage(named: "Rectangle 4475")
        
        self.MySelfTickImg.image = UIImage(named: "Tick")
        self.PartnerTickImg.image = UIImage(named: "")
        self.FamilyTickImg.image = UIImage(named: "")
        self.type = "MySelf"
    }
    
 
    @IBAction func MySelfBtn(_ sender: UIButton) {
        self.MyselfBgImg.image = UIImage(named: "YelloBorder")
        self.PartnerBgImg.image = UIImage(named: "Rectangle 4475")
        self.FamilyBgImg.image = UIImage(named: "Rectangle 4475")
        
        self.MySelfTickImg.image = UIImage(named: "Tick")
        self.PartnerTickImg.image = UIImage(named: "")
        self.FamilyTickImg.image = UIImage(named: "")
        self.type = "MySelf"
    }
    
    
    @IBAction func myPartnerBtn(_ sender: UIButton) {
        self.MyselfBgImg.image = UIImage(named: "Rectangle 4475")
        self.PartnerBgImg.image = UIImage(named: "YelloBorder")
        self.FamilyBgImg.image = UIImage(named: "Rectangle 4475")
        
        self.MySelfTickImg.image = UIImage(named: "")
        self.PartnerTickImg.image = UIImage(named: "Tick")
        self.FamilyTickImg.image = UIImage(named: "")
        self.type = "Partner"
    }
    
    @IBAction func MyFamilyBtn(_ sender: UIButton) {
        self.MyselfBgImg.image = UIImage(named: "Rectangle 4475")
        self.PartnerBgImg.image = UIImage(named: "Rectangle 4475")
        self.FamilyBgImg.image = UIImage(named: "YelloBorder")
        
        self.MySelfTickImg.image = UIImage(named: "")
        self.PartnerTickImg.image = UIImage(named: "")
        self.FamilyTickImg.image = UIImage(named: "Tick")
        self.type = "Family"
    }
    
    @IBAction func NextBtn(_ sender: UIButton) {
        StateMangerModelClass.shared.onboardingSelectedData.Cookingfortype = self.type
        
        if self.type == "MySelf"{
            let storyboard = UIStoryboard(name: "CookingForMySelf", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "BodyGoalsVC") as! BodyGoalsVC
            vc.type = self.type
            self.navigationController?.pushViewController(vc, animated: true)
        }else if self.type == "Partner"{
            let storyboard = UIStoryboard(name: "CookingForPartners", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "Cooking__for__Partners__infoVC") as! Cooking__for__Partners__infoVC
            vc.type = self.type
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            let storyboard = UIStoryboard(name: "CookingForFamily", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "CookingforFamilyVC") as! CookingforFamilyVC
            vc.type = self.type
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
