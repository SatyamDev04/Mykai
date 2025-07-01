//
//  InfoVC.swift
//  Roam
//
//  Created by YES IT Labs on 16/01/24.
//

import UIKit

class InfoVC: UIViewController {
    
    @IBOutlet weak var InfoLbl: UILabel!
    
    var comesFrom = ""
    
    var MSg = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        self.InfoLbl.text = self.MSg
        
        if comesFrom == "StatesForWeekOrYearVC"{
            self.InfoLbl.textColor = #colorLiteral(red: 0.2352941176, green: 0.2705882353, blue: 0.2549019608, alpha: 1)
            self.InfoLbl.font = UIFont(name: "Poppins Regular", size: 12.0)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
