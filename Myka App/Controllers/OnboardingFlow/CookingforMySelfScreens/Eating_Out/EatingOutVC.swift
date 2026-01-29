//
//  EatingOutVC.swift
//  Myka App
//
//  Created by YES IT Labs on 29/11/24.
//

import UIKit
import Alamofire
import SwiftyJSON

class EatingOutVC: UIViewController {
    
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var ProgressLbl: UILabel!
     
    @IBOutlet weak var TblV: UITableView!
    
    @IBOutlet weak var TitleLbl: UILabel!
    @IBOutlet weak var SubTitleLbl: UILabel!
    
    @IBOutlet weak var NextBtnO: UIButton!
    @IBOutlet weak var NextbtnStackV: UIStackView!
    @IBOutlet weak var UpdateBtnO: UIButton!
    
    var type = ""
    var comesfrom = ""
 
    
    var eatingOutArr = [ModelClass]()
    
    var ArrData = [BodyGoalsModel]()//(Name: "No food prepared", isSelected: false), BodyGoalsModel(Name: "Convenience", isSelected: false), BodyGoalsModel(Name: "Cravings", isSelected: false), BodyGoalsModel(Name: "Social  occasions", isSelected: false), BodyGoalsModel(Name: "Add Other", isSelected: false)]
    
    var Duration = ""
    
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
            .foregroundColor: UIColor.black,
            .font: UIFont(name: "Montserrat-Bold", size: 32) ?? UIFont.systemFont(ofSize: 32)
        ]
        let Attributes2: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.init(red: 6/255, green: 193/255, blue: 105/255, alpha: 1),
            .font: UIFont(name: "Montserrat-Bold", size: 32) ?? UIFont.systemFont(ofSize: 32)
        ]
         
        if self.type == "MySelf"{
            self.ProgressLbl.text = "9/10"
            let progressVw = Float(9) / Float(10)
            progressView.progress = Float(progressVw)
            
            let helloString = NSAttributedString(string: "Eating", attributes: Attributes1)
            let worldString = NSAttributedString(string: " Out", attributes: Attributes2)
            let fullString = NSMutableAttributedString()
            fullString.append(helloString)
            fullString.append(worldString)
            self.TitleLbl.attributedText = fullString
            self.SubTitleLbl.text = "How often do you eat out (restaurants or  \ntakeout)?"
             
        }else if self.type == "Partner"{
            self.ProgressLbl.text = "10/11"
            let progressVw = Float(10) / Float(11)
            progressView.progress = Float(progressVw)
             
            let helloString = NSAttributedString(string: "Eating", attributes: Attributes1)
            let worldString = NSAttributedString(string: " Out", attributes: Attributes2)
            let fullString = NSMutableAttributedString()
            fullString.append(helloString)
            fullString.append(worldString)
            self.TitleLbl.attributedText = fullString
            self.SubTitleLbl.text = "How often do you guys eat out (restaurants or takeout)?"
        }else{
            self.ProgressLbl.text = "10/11"
            let progressVw = Float(10) / Float(11)
            progressView.progress = Float(progressVw)
            
            let helloString = NSAttributedString(string: "Eating", attributes: Attributes1)
            let worldString = NSAttributedString(string: " Out", attributes: Attributes2)
            let fullString = NSMutableAttributedString()
            fullString.append(helloString)
            fullString.append(worldString)
            self.TitleLbl.attributedText = fullString
            self.SubTitleLbl.text = "How often do you guys eat out (restaurants or takeout)?"
        }
        
        if comesfrom == ""{
            self.Api_To_GetEatingOut()
        }else{
            self.Api_To_GetPrefrenceBodyGoals()
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
                StateMangerModelClass.shared.onboardingSelectedData.MySelfSeldata[0].EatingOut.removeAll()
                
                self.NextBtnO.setBackgroundImage(UIImage(named: "ButtonGray"), for: .normal)
                self.NextBtnO.isUserInteractionEnabled = false
                self.TblV.reloadData()
                
                
//                let storyboard = UIStoryboard(name: "Login", bundle: nil)
//                let vc = storyboard.instantiateViewController(withIdentifier: "letsStartVC") as! letsStartVC
//                self.navigationController?.pushViewController(vc, animated: false)
                
                let storyboard = UIStoryboard(name: "CookingForMySelf", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "ReasonsforTakeawayVC") as! ReasonsforTakeawayVC
                vc.type = self.type
                self.navigationController?.pushViewController(vc, animated: false)
            }
            vc.modalPresentationStyle = .overCurrentContext
            self.present(vc, animated: false)
            
        }
        
        @IBAction func NextBtn(_ sender: UIButton) {
            let storyboard = UIStoryboard(name: "CookingForMySelf", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "ReasonsforTakeawayVC") as! ReasonsforTakeawayVC
            vc.type = self.type
            self.navigationController?.pushViewController(vc, animated: false)
        }
    
    @IBAction func UpdateBtn(_ sender: UIButton) {
        self.Api_To_UpdatePrefrence()
    }
    
    }


extension EatingOutVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ArrData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BodyGoalTblVCell", for: indexPath) as! BodyGoalTblVCell
        //cell.BottomConstraint.constant = 2
        cell.NameLbl.text = ArrData[indexPath.row].Name
        cell.TickImg.image = ArrData[indexPath.row].isSelected ? UIImage(named: "Tick1") : UIImage(named: "")
        cell.selectedBgImg.image = ArrData[indexPath.row].isSelected ? UIImage(named: "YelloBorder") : UIImage(named: "Group 1171276489")
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        for index in 0..<ArrData.count {
            ArrData[index].isSelected = false
        }
        
        ArrData[indexPath.row].isSelected = true
        NextBtnO.setBackgroundImage(UIImage(named: "Button"), for: .normal)
        NextBtnO.isUserInteractionEnabled = true
            TblV.reloadData()
        
     
        saveDraftEatingOut()
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
 
extension EatingOutVC {
    
    func Api_To_GetEatingOut(){
        var params = [String: Any]()
        if self.type == "MySelf"{
            params["type"] = "1"
             
        }else if self.type == "Partner"{
            params["type"] = "2"
        }else{
            params["type"] = "3"
        }

         
        showIndicator(withTitle: "", and: "")
        
        let loginURL = baseURL.baseURL + appEndPoints.eatingOut
        print(params,"Params")
        print(loginURL,"loginURL")
        
        WebService.shared.getServiceURLEncodingwithParams(loginURL, VC: self, andParameter: params, withCompletion: { (json, statusCode) in
            
            self.hideIndicator()
            
            guard let dictData = json.dictionaryObject else{
                return
            }
            
            if dictData["success"] as? Bool == true{
                let responseArray = dictData["data"] as? [[String : Any]] ?? [[String: Any]]()
                
                self.eatingOutArr.removeAll()
                self.eatingOutArr = ModelClass.getBodyGoalsDetails(responseArray: responseArray)
                self.ArrData.removeAll()
                
                for i in self.eatingOutArr{
                    self.ArrData.append(contentsOf: [BodyGoalsModel(Name: i.name, id: i.id, isSelected: false)])
                }
                
                self.TblV.reloadData()
                self.restoreDraftEatingOut()
            }else{
                let responseMessage = dictData["message"] as! String
                self.showToast(responseMessage)
            }
        })
    }
    
    // MARK: - Draft Restore
    private func restoreDraftEatingOut() {
        let state = StateMangerModelClass.shared

        guard
            !state.onboardingSelectedData.MySelfSeldata.isEmpty
        else { return }

        let savedValue = state.onboardingSelectedData.MySelfSeldata[0].EatingOut
        guard !savedValue.isEmpty else { return }

        for index in 0..<ArrData.count {
            ArrData[index].isSelected = "\(ArrData[index].id ?? 0)" == savedValue
        }

        NextBtnO.setBackgroundImage(UIImage(named: "Button"), for: .normal)
        NextBtnO.isUserInteractionEnabled = true
        TblV.reloadData()
    }
    
    // MARK: - Draft Save
    private func saveDraftEatingOut() {
        let state = StateMangerModelClass.shared

        // Ensure draft exists
         state.ensureMySelfDraftExists()
        var selectedValue = ""
        for item in ArrData where item.isSelected {
            selectedValue = "\(item.id ?? 0)"
        }

        state.onboardingSelectedData.MySelfSeldata[0].EatingOut = selectedValue
    }
}


extension EatingOutVC {
    func Api_To_GetPrefrenceBodyGoals(){
        var params = [String: Any]()
  
         
        showIndicator(withTitle: "", and: "")
        
        let loginURL = baseURL.baseURL + appEndPoints.Getprefrence
        print(params,"Params")
        print(loginURL,"loginURL")
        
        WebService.shared.postServiceURLEncoding(loginURL, VC: self, andParameter: params, withCompletion: { (json, statusCode) in
            
            self.hideIndicator()
            
            guard let dictData = json.dictionaryObject else{
                return
            }
            
            if dictData["success"] as? Bool == true{
                let result = dictData["data"] as? NSDictionary ?? NSDictionary()
                
                let responseArray = result["eatingout"] as? [[String : Any]] ?? [[String: Any]]()
                
                self.eatingOutArr.removeAll()
                self.eatingOutArr = ModelClass.getBodyGoalsDetails(responseArray: responseArray)
                self.ArrData.removeAll()
                
                for i in self.eatingOutArr{
                    self.ArrData.append(contentsOf: [BodyGoalsModel(Name: i.name, id: i.id, isSelected: i.selected)])
                }
                
                self.TblV.reloadData()
               
            }else{
                let responseMessage = dictData["message"] as! String
                self.showToast(responseMessage)
            }
        })
    }
    
    func Api_To_UpdatePrefrence(){
        var params : [String:Any] = [:]
        
        var Eatout = String()
        
        for i in 0..<ArrData.count {
            if ArrData[i].isSelected {
                Eatout = ("\(ArrData[i].id ?? Int())")
            }
        }
        
        params["eating_out"] = Eatout
  
        let token  = UserDetail.shared.getTokenWith()
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        
        
        
        let loginURL = baseURL.baseURL + appEndPoints.Updateprefrence
        
        showIndicator(withTitle: "", and: "")
        
        AF.upload(multipartFormData: { multipartFormData in
            for (key, value) in params {
                if let temp = value as? String {
                    multipartFormData.append(temp.data(using: .utf8)!, withName: key)
                }
                if let temp = value as? Int {
                    multipartFormData.append("\(temp)".data(using: .utf8)!, withName: key)
                }
                if let temp = value as? NSArray {
                    temp.forEach({ element in
                        let keyObj = key + "[]"
                        if let string = element as? String {
                            multipartFormData.append(string.data(using: .utf8)!, withName: keyObj)
                        } else
                        if let num = element as? Int {
                            let value = "\(num)"
                            multipartFormData.append(value.data(using: .utf8)!, withName: keyObj)
                        }
                    })
                }
            }
        },to: loginURL, method: .post , headers: headers)
        .responseJSON(completionHandler: { (encodingResult) in
            self.hideIndicator()
            
            do {
                if let err = encodingResult.error{
                    //                    if loader { CommonFunctions.hideActivityLoader() }
                    
                    if (err as NSError).code == NSURLErrorNotConnectedToInternet {
                        
                    }
                    print(err as NSError)
                    if let f = encodingResult.data {
                        print("Print Server Error: " + String(data: f, encoding: String.Encoding.utf8)!)
                    }
                    
                    return
                }
                
                //                if loader { CommonFunctions.hideActivityLoader() }
                
                print(encodingResult.data!)
                let value = try JSON(data: encodingResult.data!)
                print(JSON(value))
                
                guard  let dict = value.dictionaryObject else {
                    return
                }
                if (dict["success"] as? Bool) == true {
                    self.navigationController?.popViewController(animated: true)
                }else{
                   let msg = dict["msg"] as? String ?? ""
                    self.showToast(msg)
                }
            }catch {
                self.hideIndicator()
                print("===================== FAILURE =======================")
                print(error.localizedDescription)
                
            }
        })
    }
}
