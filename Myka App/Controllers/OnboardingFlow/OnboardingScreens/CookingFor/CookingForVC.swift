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

    var type = "MySelf"

    override func viewDidLoad() {
        super.viewDidLoad()
        restoreDraft()
    }

    // MARK: - Restore Saved Data
    private func restoreDraft() {
        let savedType = StateMangerModelClass.shared.onboardingSelectedData.Cookingfortype

        if savedType.isEmpty {
            selectType("MySelf") // default
        } else {
            selectType(savedType)
        }
    }

    // MARK: - Central UI Handler
    private func selectType(_ selectedType: String) {
        type = selectedType

        StateMangerModelClass.shared.onboardingSelectedData.Cookingfortype = selectedType

        MyselfBgImg.image = UIImage(named: selectedType == "MySelf" ? "YelloBorder" : "Rectangle 4475")
        PartnerBgImg.image = UIImage(named: selectedType == "Partner" ? "YelloBorder" : "Rectangle 4475")
        FamilyBgImg.image = UIImage(named: selectedType == "Family" ? "YelloBorder" : "Rectangle 4475")

        MySelfTickImg.image = UIImage(named: selectedType == "MySelf" ? "Tick" : "")
        PartnerTickImg.image = UIImage(named: selectedType == "Partner" ? "Tick" : "")
        FamilyTickImg.image = UIImage(named: selectedType == "Family" ? "Tick" : "")
    }

    // MARK: - Actions
    @IBAction func MySelfBtn(_ sender: UIButton) {
        selectType("MySelf")
    }

    @IBAction func myPartnerBtn(_ sender: UIButton) {
        selectType("Partner")
    }

    @IBAction func MyFamilyBtn(_ sender: UIButton) {
        selectType("Family")
    }

    @IBAction func NextBtn(_ sender: UIButton) {

        StateMangerModelClass.shared.onboardingSelectedData.Cookingfortype = type

        if type == "MySelf" {
            let storyboard = UIStoryboard(name: "CookingForMySelf", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "BodyGoalsVC") as! BodyGoalsVC
            vc.type = type
            navigationController?.pushViewController(vc, animated: true)

        } else if type == "Partner" {
            let storyboard = UIStoryboard(name: "CookingForPartners", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "Cooking__for__Partners__infoVC") as! Cooking__for__Partners__infoVC
            vc.type = type
            navigationController?.pushViewController(vc, animated: true)

        } else {
            let storyboard = UIStoryboard(name: "CookingForFamily", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "CookingforFamilyVC") as! CookingforFamilyVC
            vc.type = type
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
