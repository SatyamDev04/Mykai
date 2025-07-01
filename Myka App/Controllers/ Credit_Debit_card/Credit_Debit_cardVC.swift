//
//  Credit_Debit_cardVC.swift
//  My-Kai
//
//  Created by YES IT Labs on 06/03/25.
//

import UIKit
import DropDown
import Alamofire
import StripePayments

class Credit_Debit_cardVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var SavedCardBgV: UIView!
    @IBOutlet weak var SavedCardTblV: UITableView!
    @IBOutlet weak var SavedCardTblVH: NSLayoutConstraint!
    
    @IBOutlet weak var NameTxtF: UITextField!
    @IBOutlet weak var CardNumbTxtF: UITextField!
    @IBOutlet weak var MonthTxt: UITextField!
    @IBOutlet weak var YearTxt: UITextField!
    @IBOutlet weak var CvvTxtF: UITextField!
       
    
    @IBOutlet weak var AddCardbgV: UIView!
    
    @IBOutlet weak var CardTitleBgV: UIView!
    @IBOutlet weak var NameOnCardTxtF: UIView!
    @IBOutlet weak var CardNumTxtF: UIView!
    @IBOutlet weak var CVVTxtF: UIView!
    @IBOutlet weak var ExpMonthTxtF: UIView!
    @IBOutlet weak var ExpYearTxtF: UIView!
    
    @IBOutlet weak var AddCardBtnBgV: UIView!
    
    @IBOutlet weak var MakePreferredBtnO: UIButton!
    
     
    let dropDown = DropDown()
    let MonthdropDown = DropDown()
    let YeardropDown = DropDown()
    
    var MonthArr = ["01", "02", "03", "04", "05", "06","07","08","09","10","11","12"]
  
    var yearsArr: [String] = [String]()
    
    var savedCardListArr = [SavedCardsModelData]()
    
    var backAction:()->() = {}
    
    var EditedCardData = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Get the current year
        let currentYear = Calendar.current.component(.year, from: Date())
        // Create an array of years from the current year to 50 years in the future
        let yearsArray = (currentYear...(currentYear + 50)).map { String($0) }
        yearsArr = yearsArray
        
        self.SavedCardTblV.register(UINib(nibName: "SavedCradTblVCell", bundle: nil), forCellReuseIdentifier: "SavedCradTblVCell")
        self.SavedCardTblV.delegate = self
        self.SavedCardTblV.dataSource = self
        
        self.MakePreferredBtnO.isSelected = true
        
        self.SavedCardBgV.isHidden = true
        self.AddCardbgV.isHidden = false
        self.AddCardBtnBgV.isHidden = true
        self.CardTitleBgV.isHidden = true
        
        CardNumbTxtF.delegate = self
        CvvTxtF.delegate = self
        MonthTxt.delegate = self
        YearTxt.delegate = self
        
        self.SavedCardTblV.addObserver(self, forKeyPath: "contentSize", options: [.new, .old], context: nil)
        
        self.getGetCardsList()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize", let tableView = object as? UITableView {
            let newContentSize = tableView.contentSize
            // Update the height constraint or perform actions as needed
            updateTableViewHeight(newContentSize.height)
        }
    }
    
    func updateTableViewHeight(_ height: CGFloat) {
        SavedCardTblVH.constant = height
        view.layoutIfNeeded()
    }
    
    
    deinit {
        SavedCardTblV.removeObserver(self, forKeyPath: "contentSize")
    }
    
    @IBAction func BackBtn(_ sender: UIButton) {
        if EditedCardData == true{
            EditedCardData = false
            self.backAction()
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func MonthDropBtn(_ sender: UIButton) {
        MonthdropDown.dataSource = MonthArr
        MonthdropDown.anchorView = sender
          
          // Add trailing space (adjust x for horizontal offset)
          let trailingSpace: CGFloat = 0 // Adjust as needed
        MonthdropDown.bottomOffset = CGPoint(x: -trailingSpace, y: sender.bounds.height)
        MonthdropDown.topOffset = CGPoint(x: -trailingSpace, y: -(MonthdropDown.anchorView?.plainView.bounds.height ?? 0))
        MonthdropDown.width = sender.frame.width
        MonthdropDown.setupCornerRadius(10)
          
          // Optional: You may also need to disable shadow for proper clipping
        MonthdropDown.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        MonthdropDown.layer.shadowOpacity = 0
        MonthdropDown.layer.shadowRadius = 4
        MonthdropDown.layer.shadowOffset = CGSize(width: 0, height: 0)
        MonthdropDown.backgroundColor = .white
        MonthdropDown.cellHeight = 32
        MonthdropDown.textFont = UIFont.systemFont(ofSize: 11)
        MonthdropDown.direction = .bottom

        MonthdropDown.selectionAction = { [weak self] (index: Int, item: String) in
            guard let self = self else { return }
            print(index)
            
            let currentDate = Date()
            let currentCalendar = Calendar.current
            let currentYear = currentCalendar.component(.year, from: currentDate)
            let currentMonth = currentCalendar.component(.month, from: currentDate)

            // Selected values
            let selectedMonth = Int(item) ?? 1 // January
            let selectedYear = Int(YearTxt.text!)

            // Check if the selected month and year is valid
            if YearTxt.text != ""{
                if selectedYear == currentYear && selectedMonth < currentMonth {
                    AlertControllerOnr(title: "Invalid Selection", message: "The selected month is invalid as it has already passed in the current year.")
                }else{
                    self.MonthTxt.text = item
                }
            }else{
                self.MonthTxt.text = item
            }
        }
        
        MonthdropDown.show()
    }
    
    @IBAction func YearDropBtn(_ sender: UIButton) {
        YeardropDown.dataSource = yearsArr
        YeardropDown.anchorView = sender
          
          // Add trailing space (adjust x for horizontal offset)
          let trailingSpace: CGFloat = 0 // Adjust as needed
        YeardropDown.bottomOffset = CGPoint(x: -trailingSpace, y: sender.bounds.height)
        YeardropDown.topOffset = CGPoint(x: -trailingSpace, y: -(YeardropDown.anchorView?.plainView.bounds.height ?? 0))
        YeardropDown.width = sender.frame.width
        YeardropDown.setupCornerRadius(10)
          
          // Optional: You may also need to disable shadow for proper clipping
        YeardropDown.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        YeardropDown.layer.shadowOpacity = 0
        YeardropDown.layer.shadowRadius = 4
        YeardropDown.layer.shadowOffset = CGSize(width: 0, height: 0)
        YeardropDown.backgroundColor = .white
        YeardropDown.cellHeight = 32
        YeardropDown.textFont = UIFont.systemFont(ofSize: 11)
        YeardropDown.direction = .bottom

        YeardropDown.selectionAction = { [weak self] (index: Int, item: String) in
            guard let self = self else { return }
            print(index)
            let currentDate = Date()
            let currentCalendar = Calendar.current
            let currentYear = currentCalendar.component(.year, from: currentDate)
            let currentMonth = currentCalendar.component(.month, from: currentDate)

            // Selected values
            let selectedMonth = Int(MonthTxt.text!) ?? 1 // January
            let selectedYear = Int(item)

            if MonthTxt.text != ""{
                // Check if the selected month and year is valid
                if selectedYear == currentYear && selectedMonth < currentMonth {
                    AlertControllerOnr(title: "Invalid Selection", message: "The selected month is invalid as it has already passed in the current year.")
                }else{
                    self.YearTxt.text = item
                }
            }else{
                self.YearTxt.text = item
            }
        }
        
        YeardropDown.show()
    }
    
    @IBAction func AddcardBtn(_ sender: UIButton) {
        self.AddCardbgV.isHidden = false
        self.AddCardBtnBgV.isHidden = true
        self.CardTitleBgV.isHidden = false
    }
    
    func Validation() -> Bool {
        
        if NameTxtF.text == "" {
            self.AlertControllerOnr(title: "Alert", message: "Card Holder Name can’t be empty", BtnTitle: "OK")
            return false
        }
        
        if CardNumbTxtF.text == "" {
            self.AlertControllerOnr(title: "Alert", message: "Please enter card number.", BtnTitle: "OK")
            return false
        }
        if CardNumbTxtF.text!.count < 16  {
            self.AlertControllerOnr(title: "Alert", message: "Please enter a valid card number.", BtnTitle: "OK")
            return false
        }
        if MonthTxt.text == "" {
            self.AlertControllerOnr(title: "Alert", message: "Please enter Expiry Month and Year.", BtnTitle: "OK")
            return false
        }
        if MonthTxt.text!.count < 2 {
            self.AlertControllerOnr(title: "Alert", message: "Please enter a valid Month .", BtnTitle: "OK")
            return false
        }
        
        if YearTxt.text == "" {
            self.AlertControllerOnr(title: "Alert", message: "Please enter Expiry Year.", BtnTitle: "OK")
            return false
        }
        
        if YearTxt.text!.count < 4 {
            self.AlertControllerOnr(title: "Alert", message: "Please enter a valid Year.", BtnTitle: "OK")
            return false
        }
        
        if CvvTxtF.text == "" {
            self.AlertControllerOnr(title: "Alert", message: "Please enter CVV.", BtnTitle: "OK")
            return false
        }
        if CvvTxtF.text!.count < 3 {
            self.AlertControllerOnr(title: "Alert", message: "Please enter a valid CVV.", BtnTitle: "OK")
            return false
        }
        return true
    }
//
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == CardNumbTxtF {
            guard let text = textField.text else { return false }
            let newString = (text as NSString).replacingCharacters(in: range, with: string)
            textField.text = format2(with: "XXXXXXXXXXXXXXXX", phone: newString)
            return false
        } else if textField == MonthTxt {
            guard let text = textField.text else { return false }
            let newString = (text as NSString).replacingCharacters(in: range, with: string)
            textField.text = format2(with: "XX", phone: newString)
            return false
        } else if textField == YearTxt {
            guard let text = textField.text else { return false }
            let newString = (text as NSString).replacingCharacters(in: range, with: string)
            textField.text = format2(with: "XXXX", phone: newString)
            return false
        } else if textField == CvvTxtF {
            guard let text = textField.text else { return false }
            let newString = (text as NSString).replacingCharacters(in: range, with: string)
            textField.text = format2(with: "XXX", phone: newString)
            return false
        }
        return true
    }

    func format2(with mask: String, phone: String) -> String {
           let numbers = phone.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
           var result = ""
           var index = numbers.startIndex
           for ch in mask where index < numbers.endIndex {
               if ch == "X" {
                   result.append(numbers[index])
                   index = numbers.index(after: index)

               } else {
                   result.append(ch)
               }
           }
           return result
       }
//
    
    @IBAction func MakePreferredBtn(_ sender: UIButton) {
        if self.MakePreferredBtnO.isSelected == true{
            self.MakePreferredBtnO.isSelected = false
        }else{
            self.MakePreferredBtnO.isSelected = true
        }
    }
    
    
    @IBAction func SaveCardBtn(_ sender: UIButton) {
        guard Validation() else {
            return
        }
        self.API_TO_Add_Cards()
         
    }
    
}


extension Credit_Debit_cardVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.savedCardListArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SavedCradTblVCell", for: indexPath) as! SavedCradTblVCell
        
        cell.CardNumLbl.text = "**** **** **** \(self.savedCardListArr[indexPath.row].cardNum ?? 0)"
         
        cell.OptionBtn.tag = indexPath.row
        cell.OptionBtn.addTarget(self, action: #selector(OptionBtnClicked(sender:)), for: .touchUpInside)
        
        return cell
    }
    
    
    @objc func OptionBtnClicked(sender: UIButton){
        let cardID = self.savedCardListArr[sender.tag].id ?? 0
        
        let prefferedStatus = self.savedCardListArr[sender.tag].status ?? 0
        
        if prefferedStatus == 0{
            dropDown.dataSource = ["Set as preferred","Delete"]
        }else{
            dropDown.dataSource = ["Delete"]
        }
        
          dropDown.anchorView = sender
          
          // Add trailing space (adjust x for horizontal offset)
          let trailingSpace: CGFloat = 120 // Adjust as needed
          dropDown.bottomOffset = CGPoint(x: -trailingSpace, y: sender.bounds.height)
          dropDown.topOffset = CGPoint(x: -trailingSpace, y: -(dropDown.anchorView?.plainView.bounds.height ?? 0))
          dropDown.width = 140
          dropDown.setupCornerRadius(10)
          
          // Optional: You may also need to disable shadow for proper clipping
          dropDown.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
          dropDown.layer.shadowOpacity = 0
          dropDown.layer.shadowRadius = 4
          dropDown.layer.shadowOffset = CGSize(width: 0, height: 0)
          dropDown.backgroundColor = .white
          dropDown.cellHeight = 35
          dropDown.textFont = UIFont.systemFont(ofSize: 14)

        dropDown.selectionAction = { [weak self] (index: Int, item: String) in
            guard let self = self else { return }
            print(index)
            if item == "Set as preferred" {// to set preffered
                self.API_TO_Set_Preffered_Card(ID: "\(cardID)")
                
            }else{ // delete
                self.API_TO_Delete_Card(ID: "\(cardID)")
            }
        }
        
        dropDown.show()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    

}


extension Credit_Debit_cardVC{

    func API_TO_Add_Cards(){
    var params = [String: Any]()
        
        let cardno = self.CardNumbTxtF.text!
        let cardType = detectCardType(cardNumber: "\(cardno)")
  
        params["card_number"] = self.CardNumbTxtF.text!
        params["exp_year"] = self.YearTxt.text!
        params["exp_month"] = self.MonthTxt.text!
        params["cvv"] = self.CvvTxtF.text!
        params["type"] = cardType
        
        if self.MakePreferredBtnO.isSelected == true{
            params["status"] = "1"
        }else{
            params["status"] = "0"
        }
        

     showIndicator(withTitle: "", and: "")
        let loginURL = baseURL.baseURL + appEndPoints.add_card_mealme

        WebService.shared.postServiceURLEncoding(loginURL, VC: self, andParameter: params, withCompletion:  { (json, statusCode) in
 
     self.hideIndicator()
     
     guard let dictData = json.dictionaryObject else{
         return
     }
 
     if dictData["success"] as? Bool == true{
         
         self.AddCardbgV.isHidden = true
         self.AddCardBtnBgV.isHidden = false
         self.SavedCardBgV.isHidden = false
         
         self.CardNumbTxtF.text = ""
         self.YearTxt.text = ""
         self.MonthTxt.text = ""
         self.CvvTxtF.text = ""
         self.NameTxtF.text = ""
         
         let responseMessage = dictData["message"] as! String
         self.showToast(responseMessage)
        // self.navigationController?.popViewController(animated: true)
         self.EditedCardData = true
         self.getGetCardsList()
        }else{
            
            let responseMessage = dictData["message"] as! String
            self.showToast(responseMessage)
        }
 })

 }
    
    func getGetCardsList() {
        //var params:JSONDictionary = [:]
        
//        params["latitude"] = AppLocation.lat
//        params["longitude"] = AppLocation.long
        
        showIndicator(withTitle: "", and: "")
         
        let loginURL = baseURL.baseURL + appEndPoints.get_card_mealme
      //  print(params,"Params")
        print(loginURL,"loginURL")
        
    
        
        WebService.shared.postServiceURLEncoding(loginURL, VC: self, andParameter: [:], withCompletion: { (json, statusCode) in
            
            self.hideIndicator()
            
            let data = try! json.rawData()
            do{
                
                let d = try JSONDecoder().decode(SavedCardsModelClass.self, from: data)
                if d.success == true {
                    
                    let allData = d.data
                      
                    self.savedCardListArr = allData ?? []
                     
                    self.SavedCardTblV.reloadData()
                    
                    if self.savedCardListArr.count > 0{
                        self.SavedCardBgV.isHidden = false
                        self.AddCardbgV.isHidden = true
                        self.AddCardBtnBgV.isHidden = false
                        self.CardTitleBgV.isHidden = true
                    }else{
                        self.SavedCardBgV.isHidden = true
                        self.AddCardbgV.isHidden = false
                        self.AddCardBtnBgV.isHidden = true
                        self.CardTitleBgV.isHidden = true
                    }
        
                }else{
                    
                    let msg = d.message ?? ""
                    self.showToast(msg)
                }
            }catch{
                
                print(error)
            }
        })
    }
    
    //delete-card-mealme
    func API_TO_Delete_Card(ID: String){
    var params = [String: Any]()
  
        params["id"] = ID
        
        
        if self.MakePreferredBtnO.isSelected == true{
            params["status"] = "1"
        }else{
            params["status"] = "0"
        }
   
 
     showIndicator(withTitle: "", and: "")
        let loginURL = baseURL.baseURL + appEndPoints.delete_card_mealme

        WebService.shared.postServiceURLEncoding(loginURL, VC: self, andParameter: params, withCompletion:  { (json, statusCode) in
 
     self.hideIndicator()
     
     guard let dictData = json.dictionaryObject else{
         return
     }
 
     if dictData["success"] as? Bool == true{
         let responseMessage = dictData["message"] as! String
         self.showToast(responseMessage)
         self.EditedCardData = true
         self.getGetCardsList()
        }else{
            let responseMessage = dictData["message"] as! String
            self.showToast(responseMessage)
        }
 })

 }
    
    
    func API_TO_Set_Preffered_Card(ID: String){
    var params = [String: Any]()
  
        params["id"] = ID
        
        
        if self.MakePreferredBtnO.isSelected == true{
            params["status"] = "1"
        }else{
            params["status"] = "0"
        }
 
 
     showIndicator(withTitle: "", and: "")
        let loginURL = baseURL.baseURL + appEndPoints.set_preferred_card

        WebService.shared.postServiceURLEncoding(loginURL, VC: self, andParameter: params, withCompletion:  { (json, statusCode) in
 
     self.hideIndicator()
     
     guard let dictData = json.dictionaryObject else{
         return
     }
 
     if dictData["success"] as? Bool == true{
         let responseMessage = dictData["message"] as! String
         self.showToast(responseMessage)
         self.EditedCardData = true
         self.getGetCardsList()
        }else{
            let responseMessage = dictData["message"] as! String
            self.showToast(responseMessage)
        }
 })

 }
}
