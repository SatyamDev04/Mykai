//
//  PreferencesVC.swift
//  Myka App
//
//  Created by Sumit on 18/12/24.
//

import UIKit

class PreferencesVC: UIViewController {
    
    @IBOutlet weak var TblV: UITableView!
    
    
    var arraData = [PreferencesDataModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
      
        let userTyp = UserDetail.shared.getUserType()
        if userTyp == "1" { 
            self.arraData = PreferencesModelClass.shared.MyselfListArray
        }else if userTyp == "2" {
            self.arraData = PreferencesModelClass.shared.PartnersListArray
        }else{
            self.arraData = PreferencesModelClass.shared.FamilyListArray
        }
        // Do any additional setup after loading the view.
        
        self.TblV.register(UINib(nibName: "PreferencesTblV", bundle: nil), forCellReuseIdentifier: "PreferencesTblV")
        self.TblV.delegate = self
        self.TblV.dataSource = self
    }
    
 
    @IBAction func BackBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}

extension PreferencesVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arraData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PreferencesTblV", for: indexPath) as! PreferencesTblV
        cell.TitleLbl.text = arraData[indexPath.row].title
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let userTyp = UserDetail.shared.getUserType()
        if userTyp == "1" {
            switch indexPath.row{
            case 0:
                let storyboard = UIStoryboard(name: "CookingForMySelf", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "BodyGoalsVC") as! BodyGoalsVC
                    vc.type = "MySelf"
                    vc.comesfrom = "PreferencesVC"
                self.navigationController?.pushViewController(vc, animated: true)
                break
                
            case 1:
                let storyboard = UIStoryboard(name: "CookingForMySelf", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "DietaryRestrictionsVC") as! DietaryRestrictionsVC
                    vc.type = "MySelf"
                    vc.comesfrom = "PreferencesVC"
                self.navigationController?.pushViewController(vc, animated: true)
                break
                
            case 2:
                let storyboard = UIStoryboard(name: "CookingForMySelf", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "FavouriteCuisinesVC") as! FavouriteCuisinesVC
                    vc.type = "MySelf"
                    vc.comesfrom = "PreferencesVC"
                self.navigationController?.pushViewController(vc, animated: true)
                break
                
            case 3:
                let storyboard = UIStoryboard(name: "CookingForMySelf", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "IngredientDislikesVC") as! IngredientDislikesVC
                    vc.type = "MySelf"
                    vc.comesfrom = "PreferencesVC"
                self.navigationController?.pushViewController(vc, animated: true)
                break
                
            case 4:
                let storyboard = UIStoryboard(name: "CookingForMySelf", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "AllergensIngredientsVC") as! AllergensIngredientsVC
                    vc.type = "MySelf"
                    vc.comesfrom = "PreferencesVC"
                self.navigationController?.pushViewController(vc, animated: true)
                break
                
            case 5:
                let storyboard = UIStoryboard(name: "CookingForMySelf", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "MealRoutineVC") as! MealRoutineVC
                    vc.type = "MySelf"
                    vc.comesfrom = "PreferencesVC"
                self.navigationController?.pushViewController(vc, animated: true)
                break
                
            case 6:
                let storyboard = UIStoryboard(name: "CookingForMySelf", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "CookingFrequencyVC") as! CookingFrequencyVC
                    vc.type = "MySelf"
                    vc.comesfrom = "PreferencesVC"
                self.navigationController?.pushViewController(vc, animated: true)
                break
                
            case 7:
                let storyboard = UIStoryboard(name: "CookingForMySelf", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "SpendingonGroceriesVC") as! SpendingonGroceriesVC
                    vc.type = "MySelf"
                    vc.comesfrom = "PreferencesVC"
                self.navigationController?.pushViewController(vc, animated: true)
                break
                
            case 8:
                let storyboard = UIStoryboard(name: "CookingForMySelf", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "EatingOutVC") as! EatingOutVC
                    vc.type = "MySelf"
                    vc.comesfrom = "PreferencesVC"
                self.navigationController?.pushViewController(vc, animated: true)
                break
                
            case 9:
                let storyboard = UIStoryboard(name: "CookingForMySelf", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "ReasonsforTakeawayVC") as! ReasonsforTakeawayVC
                    vc.type = "MySelf"
                    vc.comesfrom = "PreferencesVC"
                self.navigationController?.pushViewController(vc, animated: true)
                break
                
            default:
                break
            }
 
        }else if userTyp == "2" {
            
            switch indexPath.row{
            case 0:
                let storyboard = UIStoryboard(name: "CookingForPartners", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "Cooking__for__Partners__infoVC") as! Cooking__for__Partners__infoVC
                vc.type = "Partner"
                vc.comesfrom = "PreferencesVC"
                self.navigationController?.pushViewController(vc, animated: true)
                break
                
            case 1:
                let storyboard = UIStoryboard(name: "CookingForMySelf", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "BodyGoalsVC") as! BodyGoalsVC
                    vc.type = "MySelf"
                    vc.comesfrom = "PreferencesVC"
                self.navigationController?.pushViewController(vc, animated: true)
                break
                
            case 2:
                let storyboard = UIStoryboard(name: "CookingForMySelf", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "DietaryRestrictionsVC") as! DietaryRestrictionsVC
                    vc.type = "MySelf"
                    vc.comesfrom = "PreferencesVC"
                self.navigationController?.pushViewController(vc, animated: true)
                break
                
            case 3:
                let storyboard = UIStoryboard(name: "CookingForMySelf", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "IngredientDislikesVC") as! IngredientDislikesVC
                    vc.type = "MySelf"
                    vc.comesfrom = "PreferencesVC"
                self.navigationController?.pushViewController(vc, animated: true)
                break
                
            case 4:
                let storyboard = UIStoryboard(name: "CookingForMySelf", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "AllergensIngredientsVC") as! AllergensIngredientsVC
                    vc.type = "MySelf"
                    vc.comesfrom = "PreferencesVC"
                self.navigationController?.pushViewController(vc, animated: true)
                break
                
            case 5:
                let storyboard = UIStoryboard(name: "CookingForMySelf", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "FavouriteCuisinesVC") as! FavouriteCuisinesVC
                    vc.type = "MySelf"
                    vc.comesfrom = "PreferencesVC"
                self.navigationController?.pushViewController(vc, animated: true)
                break
                
            case 6:
                let storyboard = UIStoryboard(name: "CookingForMySelf", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "MealRoutineVC") as! MealRoutineVC
                    vc.type = "MySelf"
                    vc.comesfrom = "PreferencesVC"
                self.navigationController?.pushViewController(vc, animated: true)
                break
                
            case 7:
                let storyboard = UIStoryboard(name: "CookingForMySelf", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "CookingFrequencyVC") as! CookingFrequencyVC
                    vc.type = "MySelf"
                    vc.comesfrom = "PreferencesVC"
                self.navigationController?.pushViewController(vc, animated: true)
                break
                
            case 8:
                let storyboard = UIStoryboard(name: "CookingForMySelf", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "SpendingonGroceriesVC") as! SpendingonGroceriesVC
                    vc.type = "MySelf"
                    vc.comesfrom = "PreferencesVC"
                self.navigationController?.pushViewController(vc, animated: true)
                break
                
            case 9:
                let storyboard = UIStoryboard(name: "CookingForMySelf", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "EatingOutVC") as! EatingOutVC
                    vc.type = "MySelf"
                    vc.comesfrom = "PreferencesVC"
                self.navigationController?.pushViewController(vc, animated: true)
                break
                
            case 10:
                let storyboard = UIStoryboard(name: "CookingForMySelf", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "ReasonsforTakeawayVC") as! ReasonsforTakeawayVC
                    vc.type = "MySelf"
                    vc.comesfrom = "PreferencesVC"
                self.navigationController?.pushViewController(vc, animated: true)
                break
                
            default:
                break
            }
        }else{
          
            switch indexPath.row{
            case 0:
                let storyboard = UIStoryboard(name: "CookingForFamily", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "CookingforFamilyVC") as! CookingforFamilyVC
                vc.type = "Family"
                vc.comesfrom = "PreferencesVC"
                self.navigationController?.pushViewController(vc, animated: true)
                break
                
            case 1:
                let storyboard = UIStoryboard(name: "CookingForMySelf", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "BodyGoalsVC") as! BodyGoalsVC
                    vc.type = "MySelf"
                    vc.comesfrom = "PreferencesVC"
                self.navigationController?.pushViewController(vc, animated: true)
                break
                
            case 2:
                let storyboard = UIStoryboard(name: "CookingForMySelf", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "DietaryRestrictionsVC") as! DietaryRestrictionsVC
                    vc.type = "MySelf"
                    vc.comesfrom = "PreferencesVC"
                self.navigationController?.pushViewController(vc, animated: true)
                break
                
            case 3:
                let storyboard = UIStoryboard(name: "CookingForMySelf", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "IngredientDislikesVC") as! IngredientDislikesVC
                    vc.type = "MySelf"
                    vc.comesfrom = "PreferencesVC"
                self.navigationController?.pushViewController(vc, animated: true)
                break
                
            case 4:
                let storyboard = UIStoryboard(name: "CookingForMySelf", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "AllergensIngredientsVC") as! AllergensIngredientsVC
                    vc.type = "MySelf"
                    vc.comesfrom = "PreferencesVC"
                self.navigationController?.pushViewController(vc, animated: true)
                break
                
            case 5:
                let storyboard = UIStoryboard(name: "CookingForMySelf", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "FavouriteCuisinesVC") as! FavouriteCuisinesVC
                    vc.type = "MySelf"
                    vc.comesfrom = "PreferencesVC"
                self.navigationController?.pushViewController(vc, animated: true)
                break
                
            case 6:
                let storyboard = UIStoryboard(name: "CookingForMySelf", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "MealRoutineVC") as! MealRoutineVC
                    vc.type = "MySelf"
                    vc.comesfrom = "PreferencesVC"
                self.navigationController?.pushViewController(vc, animated: true)
                break
                
            case 7:
                let storyboard = UIStoryboard(name: "CookingForMySelf", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "CookingFrequencyVC") as! CookingFrequencyVC
                    vc.type = "MySelf"
                    vc.comesfrom = "PreferencesVC"
                self.navigationController?.pushViewController(vc, animated: true)
                break
                
            case 8:
                let storyboard = UIStoryboard(name: "CookingForMySelf", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "SpendingonGroceriesVC") as! SpendingonGroceriesVC
                    vc.type = "MySelf"
                    vc.comesfrom = "PreferencesVC"
                self.navigationController?.pushViewController(vc, animated: true)
                break
                
            case 9:
                let storyboard = UIStoryboard(name: "CookingForMySelf", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "EatingOutVC") as! EatingOutVC
                    vc.type = "MySelf"
                    vc.comesfrom = "PreferencesVC"
                self.navigationController?.pushViewController(vc, animated: true)
                break
                
            case 10:
                let storyboard = UIStoryboard(name: "CookingForMySelf", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "ReasonsforTakeawayVC") as! ReasonsforTakeawayVC
                    vc.type = "MySelf"
                    vc.comesfrom = "PreferencesVC"
                self.navigationController?.pushViewController(vc, animated: true)
                break
                
            default:
                break
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
