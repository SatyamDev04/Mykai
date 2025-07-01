//
//  IntroVC.swift
//  Myka
//
//  Created by YES IT Labs on 26/11/24.
//

import UIKit

class IntroVC: UIViewController {
    
    var comesFrom = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        StateMangerModelClass.shared.onboardingSelectedData.MySelfSeldata.removeAll()
            
        StateMangerModelClass.shared.onboardingSelectedData.MySelfSeldata.append(
            MyselfModelClass(
                bodyGoals: "",
                DietaryPreferences: [],
                FavCuisines: [],
                DislikeIngredient: [],
                AllergensIngredients: [],
                MealRoutine: [],
                CookingFrequency: "",
                SpendingOnGroceries: SpendingOnGroceriesModelClass(Amount: "", duration: ""),
                EatingOut: "",
                Takeway: ""
            )
        )
         
        
        let isOnboarding = UserDetail.shared.getOnboardingStatus()
        let isLoginSession = UserDetail.shared.getLoginSession()
          
        if isLoginSession == true && isOnboarding == true && comesFrom != "letsStart"{
            let storyboard = UIStoryboard(name: "Tabbar", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "TabbarVC") as! TabbarVC
            self.navigationController?.pushViewController(vc, animated: true)
        }else if isLoginSession == false && isOnboarding == true && comesFrom != "letsStart"{
            let storyboard = UIStoryboard(name: "Login", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "letsStartVC") as! letsStartVC
            self.navigationController?.pushViewController(vc, animated: false)
        }
    }
    

    @IBAction func NextVC(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "IntroVC1") as? IntroVC1
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}
