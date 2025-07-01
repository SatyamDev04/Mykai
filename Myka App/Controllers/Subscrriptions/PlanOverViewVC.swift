//
//  PlanOverViewVC.swift
//  Myka App
//
//  Created by Sumit on 09/12/24.
//

import UIKit

class PlanOverViewVC: UIViewController {

    @IBOutlet weak var PlansBgView: UIView!
    @IBOutlet weak var SeeAllPlansBgV: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        PlansBgView.isHidden = true
        SeeAllPlansBgV.isHidden = false
    }
    
    
    @IBAction func BackBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func BasicPlanBtn(_ sender: UIButton) {
    }
    
    @IBAction func StandardPlanBtn(_ sender: UIButton) {
    }
    
    
    @IBAction func AnnualPlanBtn(_ sender: UIButton) {
    }
    
    @IBAction func SeeAllPlansBtn(_ sender: UIButton) {
        PlansBgView.isHidden = false
        SeeAllPlansBgV.isHidden = true
    }
    
}
