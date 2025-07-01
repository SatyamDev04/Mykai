//
//  ChooseMealTypeVC.swift
//  Myka App
//
//  Created by Sumit on 15/12/24.
//

import UIKit
import Alamofire

class ChooseMealTypeVC: UIViewController {
    
    @IBOutlet weak var ChooseMealTypeTblV: UITableView!
    @IBOutlet weak var ChooseMealTypeBgV: UIView!
    
    var ChooseMealTypeyData = [BodyGoalsModel(Name: "Breakfast", isSelected: false), BodyGoalsModel(Name: "Lunch", isSelected: false), BodyGoalsModel(Name: "Dinner", isSelected: false), BodyGoalsModel(Name: "Snacks", isSelected: false), BodyGoalsModel(Name: "Brunch", isSelected: false)]
    
    var SelDateArray = [[String: String]]()
     var uri = ""
    var type = ""
  //  var backAction:(_ SelDate: Date ) -> () = {_  in}

    override func viewDidLoad() {
        super.viewDidLoad()
        self.type = ""
        
        self.ChooseMealTypeTblV.register(UINib(nibName: "ChooseDaysTblVCell", bundle: nil), forCellReuseIdentifier: "ChooseDaysTblVCell")
        self.ChooseMealTypeTblV.delegate = self
        self.ChooseMealTypeTblV.dataSource = self
        self.ChooseMealTypeTblV.separatorStyle = .none
    
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        ChooseMealTypeBgV.addGestureRecognizer(tapGesture)
       }
     
       // Action method called when the view is tapped
  
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        print("View1 was tapped!")
        for indx in 0..<ChooseMealTypeyData.count{
            ChooseMealTypeyData[indx].isSelected = false
        }
        
        self.willMove(toParent: nil)
        self.view.removeFromSuperview()
        self.removeFromParent()
         
    }
    
 
    @IBAction func DoneBtn(_ sender: UIButton) {
        guard self.type != "" else {
            AlertControllerOnr(title: "", message: "Please select meal type.")
            return
        }
       // self.backAction(self.seldate)
        self.Api_For_AddToPlan()
        }
    }

extension ChooseMealTypeVC: UITableViewDelegate, UITableViewDataSource {
 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return ChooseMealTypeyData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "ChooseDaysTblVCell", for: indexPath) as! ChooseDaysTblVCell
            cell.NameLbl.text = ChooseMealTypeyData[indexPath.row].Name
            cell.TickImg.image = ChooseMealTypeyData[indexPath.row].isSelected ? UIImage(named: "RadioOn") : UIImage(named: "RadioOff")
            cell.DropIMg.isHidden = true
            cell.selectionStyle = .none
            return cell

    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            for i in 0..<ChooseMealTypeyData.count{
                ChooseMealTypeyData[i].isSelected = false
            }
        
            self.type = ChooseMealTypeyData[indexPath.row].Name
        
            ChooseMealTypeyData[indexPath.row].isSelected = true
            ChooseMealTypeTblV.reloadData()
    }
    
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 50
        }
    }

extension ChooseMealTypeVC{
    func Api_For_AddToPlan() {
        
        let dateformatter = DateFormatter()
         
        print(SelDateArray)
        
        
        let paramsDict: [String: Any] = [
            "type": self.type,
            "uri": self.uri,
            "slot": SelDateArray
        ]
        
        
       
        showIndicator(withTitle: "", and: "")
        
        let loginURL = baseURL.baseURL + appEndPoints.AddMeal
        print(paramsDict, "Params")
        print(loginURL, "loginURL")
        
        if let jsonData = JSONStringEncoder().encode(paramsDict) {
            
            WebService.shared.postServiceRaw(loginURL, VC: self, jsonData: jsonData) { (json, statusCode) in
                self.hideIndicator()
                
                guard let dictData = json.dictionaryObject else {
                    return
                }
                
                let Msg = dictData["message"] as? String ?? ""
                
                if dictData["success"] as? Bool == true {
                    self.navigationController?.showToast(Msg)
                    self.willMove(toParent: nil)
                    self.view.removeFromSuperview()
                    self.removeFromParent()
                }else{
                    print("Failed to encode JSON.")
                    self.hideIndicator()
                    self.showToast(Msg)
                }
            }
        }
    }
}
