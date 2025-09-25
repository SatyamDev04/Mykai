//
//  ConvertUnitPopVC.swift
//  My Kai
//
//  Created by YATIN  KALRA on 24/09/25.
//
struct ConvertedUnitsModel: Codable {
    let converted: String?
    let targetUnit, targetSystem: String?
    
    enum CodingKeys: String, CodingKey {
        case converted
        case targetUnit = "target_unit"
        case targetSystem = "target_system"
    }
}

import UIKit

class ConvertUnitPopVC: UIViewController {
    
    @IBOutlet weak var originalRadionBtnO: UIButton!
    @IBOutlet weak var matricRadionBtnO: UIButton!
    @IBOutlet weak var imperialRadionBtnO: UIButton!
    
    var backAction : (String,[ConvertedUnitsModel]) -> () = { _,_ in}
    var ingredientData : [RecipeDataModel] = []
    var quantites = [String]()
    var units = [String]()
    var type = ""
    var convertedData = [ConvertedUnitsModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.isModalInPresentation = false
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeDown(_:)))
        swipeDown.direction = .down
        view.addGestureRecognizer(swipeDown)
        
        if type == "O"{
            originalRadionBtnO.setImage(UIImage(named: "RadioOn"), for: .normal)
            matricRadionBtnO.setImage(UIImage(named: "RadioOff"), for: .normal)
            imperialRadionBtnO.setImage(UIImage(named: "RadioOff"), for: .normal)
        }else if type == "M"{
            matricRadionBtnO.setImage(UIImage(named: "RadioOn"), for: .normal)
            originalRadionBtnO.setImage(UIImage(named: "RadioOff"), for: .normal)
            imperialRadionBtnO.setImage(UIImage(named: "RadioOff"), for: .normal)
        }else{
            imperialRadionBtnO.setImage(UIImage(named: "RadioOn"), for: .normal)
            matricRadionBtnO.setImage(UIImage(named: "RadioOff"), for: .normal)
            originalRadionBtnO.setImage(UIImage(named: "RadioOff"), for: .normal)
        }
        retriveUnits()
        retriveQuantity()
        
    }
    
    @IBAction func originalRadionBtn(_ sender: UIButton) {
        originalRadionBtnO.setImage(UIImage(named: "RadioOn"), for: .normal)
        matricRadionBtnO.setImage(UIImage(named: "RadioOff"), for: .normal)
        imperialRadionBtnO.setImage(UIImage(named: "RadioOff"), for: .normal)
        self.type = "O"
        Api_For_ConvertUnits()
        
    }
    
    @IBAction func matricRadionBtn(_ sender: UIButton) {
        self.type = "M"
        matricRadionBtnO.setImage(UIImage(named: "RadioOn"), for: .normal)
        originalRadionBtnO.setImage(UIImage(named: "RadioOff"), for: .normal)
        imperialRadionBtnO.setImage(UIImage(named: "RadioOff"), for: .normal)
        Api_For_ConvertUnits()
    }
    
    @IBAction func ImperialRadionBtn(_ sender: UIButton) {
        self.type = "I"
        imperialRadionBtnO.setImage(UIImage(named: "RadioOn"), for: .normal)
        matricRadionBtnO.setImage(UIImage(named: "RadioOff"), for: .normal)
        originalRadionBtnO.setImage(UIImage(named: "RadioOff"), for: .normal)
        Api_For_ConvertUnits()
    }
    
}
extension ConvertUnitPopVC  {
    @objc private func handleSwipeDown(_ gesture: UISwipeGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func retriveUnits(){
        units = ingredientData
            .flatMap { $0.ingredients ?? [] }
            .compactMap { $0.unit }
        
        print(units)
    }
    
    func retriveQuantity(){
        quantites = ingredientData
            .flatMap { $0.ingredients ?? [] }
            .compactMap { $0.quantity }
        
        print(quantites)
    }
    
}
extension ConvertUnitPopVC {
    func Api_For_ConvertUnits() {
        let selectType: String
        if self.type == "O" || self.type == "I" {
            selectType = "2"
        }else{
            selectType = "1"
        }
        let paramsDict: [String: Any] = [
            "type": selectType,
            "quantity": quantites,
            "unit": units
        ]
        
        showIndicator(withTitle: "", and: "")
        
        let loginURL = baseURL.baseURL + appEndPoints.convert_units
        print(paramsDict, "Params")
        print(loginURL, "loginURL")
        
        if let jsonData = JSONStringEncoder().encode(paramsDict) {
            
            WebService.shared.postServiceRaw(loginURL, VC: self, jsonData: jsonData) { (json, statusCode) in
                self.hideIndicator()
                
                guard let dictData = json.dictionaryObject else {
                    return
                }
                
                let Msg = dictData["message"] as? String ?? ""
                
                if let success = dictData["success"] as? Bool, success {
                    if let dataArray = dictData["data"] as? [[String: Any]] {
                        do {
                            let jsonData = try JSONSerialization.data(withJSONObject: dataArray, options: [])
                            let decoded = try JSONDecoder().decode([ConvertedUnitsModel].self, from: jsonData)
                            self.convertedData = decoded
                            self.backAction(self.type,self.convertedData)
                            self.dismiss(animated: true)
                            
                        } catch {
                            print("Decoding error: \(error)")
                        }
                    }
                } else {
                    self.showToast(Msg)
                }
            }
        }else{
            print("Failed to encode JSON.")
            self.hideIndicator()
            self.showToast("An error occurred while preparing the request.")
        }
    }
}
