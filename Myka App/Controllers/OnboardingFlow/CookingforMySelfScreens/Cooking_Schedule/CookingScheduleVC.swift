//
//  CookingScheduleVC.swift
//  Myka App
//
//  Created by YES IT Labs on 28/11/24.
//

import UIKit

class CookingScheduleVC: UIViewController {

    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var TblV: UITableView!
    @IBOutlet weak var ProgressLbl: UILabel!
    @IBOutlet weak var TitleLbl: UILabel!
    @IBOutlet weak var SubTitleLbl: UILabel!
    
    @IBOutlet weak var NextBtnO: UIButton!
    @IBOutlet weak var NextbtnStackV: UIStackView!
    @IBOutlet weak var UpdateBtnO: UIButton!
    
    var type = ""
    var comesfrom = ""
    
        var ArrData = [BodyGoalsModel(Name: "Monday", isSelected: false), BodyGoalsModel(Name: "Tuesday", isSelected: false), BodyGoalsModel(Name: "Wednesday", isSelected: false), BodyGoalsModel(Name: "Thursday", isSelected: false), BodyGoalsModel(Name: "Friday", isSelected: false), BodyGoalsModel(Name: "Saturday", isSelected: false), BodyGoalsModel(Name: "Sunday", isSelected: false)]
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
        if comesfrom == ""{
            self.NextbtnStackV.isHidden = false
            self.UpdateBtnO.isHidden = true
        }else{
            self.NextbtnStackV.isHidden = true
            self.UpdateBtnO.isHidden = false
        }
        
        self.TblV.register(UINib(nibName: "BodyGoalTblVCell", bundle: nil), forCellReuseIdentifier: "BodyGoalTblVCell")
        self.TblV.delegate = self
        self.TblV.dataSource = self
        
        self.TblV.separatorStyle = .none
        
        NextBtnO.setBackgroundImage(UIImage(named: "ButtonGray"), for: .normal)
        NextBtnO.isUserInteractionEnabled = false
         
        let Attributes1: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.black
        ]
        let Attributes2: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.init(red: 6/255, green: 193/255, blue: 105/255, alpha: 1)
        ]
         
        if self.type == "MySelf"{
            self.ProgressLbl.text = "8/10"
            let progressVw = Float(8) / Float(10)
            progressView.progress = Float(progressVw)
            
            let helloString = NSAttributedString(string: "Cooking", attributes: Attributes1)
            let worldString = NSAttributedString(string: " Schedule", attributes: Attributes2)
            let fullString = NSMutableAttributedString()
            fullString.append(helloString)
            fullString.append(worldString)
            self.TitleLbl.attributedText = fullString
            self.SubTitleLbl.text = "Select the days you usually cook or prep \nmeals"
             
        }else if self.type == "Partner"{
            self.ProgressLbl.text = "7/11"
            let progressVw = Float(7) / Float(11)
            progressView.progress = Float(progressVw)
             
            let helloString = NSAttributedString(string: "Cooking", attributes: Attributes1)
            let worldString = NSAttributedString(string: " Schedule", attributes: Attributes2)
            let fullString = NSMutableAttributedString()
            fullString.append(helloString)
            fullString.append(worldString)
            self.TitleLbl.attributedText = fullString
            self.SubTitleLbl.text = "Select the days you usually cook or prep \nmeals"
        }else{
            self.ProgressLbl.text = "9/11"
            let progressVw = Float(9) / Float(11)
            progressView.progress = Float(progressVw)
            
            let helloString = NSAttributedString(string: "Meal", attributes: Attributes1)
            let worldString = NSAttributedString(string: " Prep Days", attributes: Attributes2)
            let fullString = NSMutableAttributedString()
            fullString.append(helloString)
            fullString.append(worldString)
            self.TitleLbl.attributedText = fullString
            self.SubTitleLbl.text = "Which days do you normally meal prep or \ncook for your family?"
        }
        
    }
    
        
        @IBAction func BackBtn(_ sender: UIButton) {
            self.navigationController?.popViewController(animated: false)
        }
        
        @IBAction func SkipBtn(_ sender: UIButton) {
            let storyboard = UIStoryboard(name: "CookingForMySelf", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "SkipPopupVC") as! SkipPopupVC
            vc.backAction = {
                
                for index in 0..<self.ArrData.count {
                    self.ArrData[index].isSelected = false
                    }
                self.NextBtnO.setBackgroundImage(UIImage(named: "ButtonGray"), for: .normal)
                self.NextBtnO.isUserInteractionEnabled = false
                self.TblV.reloadData()
                
                if self.type == "MySelf"{
                    let storyboard = UIStoryboard(name: "CookingForMySelf", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "SpendingonGroceriesVC") as! SpendingonGroceriesVC
                    vc.type = self.type
                    self.navigationController?.pushViewController(vc, animated: false)
                }else if self.type == "Partner"{
                    let storyboard = UIStoryboard(name: "CookingForMySelf", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "MealRoutineVC") as! MealRoutineVC
                    vc.type = self.type
                    self.navigationController?.pushViewController(vc, animated: false)
                }else{
                    let storyboard = UIStoryboard(name: "CookingForMySelf", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "SpendingonGroceriesVC") as! SpendingonGroceriesVC
                    vc.type = self.type
                    self.navigationController?.pushViewController(vc, animated: false)
                }
            }
            vc.modalPresentationStyle = .overCurrentContext
            self.present(vc, animated: false)
        }
        
        @IBAction func NextBtn(_ sender: UIButton) {
            if self.type == "MySelf"{
                let storyboard = UIStoryboard(name: "CookingForMySelf", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "SpendingonGroceriesVC") as! SpendingonGroceriesVC
                vc.type = self.type
                self.navigationController?.pushViewController(vc, animated: false)
            }else if self.type == "Partner"{
                let storyboard = UIStoryboard(name: "CookingForMySelf", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "MealRoutineVC") as! MealRoutineVC
                vc.type = self.type
                self.navigationController?.pushViewController(vc, animated: false)
            }else{
                let storyboard = UIStoryboard(name: "CookingForMySelf", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "SpendingonGroceriesVC") as! SpendingonGroceriesVC
                vc.type = self.type
                self.navigationController?.pushViewController(vc, animated: false)
            }
        }
    
    @IBAction func UpdateBtn(_ sender: UIButton) {
        
    }
    }

    extension CookingScheduleVC: UITableViewDelegate, UITableViewDataSource {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return ArrData.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BodyGoalTblVCell", for: indexPath) as! BodyGoalTblVCell
            cell.NameLbl.text = ArrData[indexPath.row].Name
            cell.TickImg.image = ArrData[indexPath.row].isSelected ? UIImage(named: "Tick1") : UIImage(named: "")
            cell.selectedBgImg.image = ArrData[indexPath.row].isSelected ? UIImage(named: "YelloBorder") : UIImage(named: "Group 1171276489")
            cell.selectionStyle = .none
            return cell
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            if ArrData[indexPath.row].isSelected {
                ArrData[indexPath.row].isSelected = false
            }else{
                ArrData[indexPath.row].isSelected = true
            }
            
            if ArrData.allSatisfy({ ($0.isSelected) == false }) {
                // All items are unselected
                print("All items are unselected.")
                NextBtnO.setBackgroundImage(UIImage(named: "ButtonGray"), for: .normal)
                NextBtnO.isUserInteractionEnabled = false
            } else {
                // At least one item is selected
                print("Some items are selected.")
                NextBtnO.setBackgroundImage(UIImage(named: "Button"), for: .normal)
                NextBtnO.isUserInteractionEnabled = true
            }
            
            TblV.reloadData()
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 60
        }
    }


