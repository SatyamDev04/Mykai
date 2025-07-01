//
//  SavedCardBankVC.swift
//  Myka App
//
//  Created by YES IT Labs on 20/12/24.
//

import UIKit
import DropDown
import Alamofire

class SavedCardBankVC: UIViewController {
    
    @IBOutlet weak var BankTblV: UITableView!
    @IBOutlet weak var BankTblVH: NSLayoutConstraint!
    @IBOutlet weak var CardTblV: UITableView!
    @IBOutlet weak var CardTblVH: NSLayoutConstraint!
    
    let dropDown = DropDown()
    
    var SavedCardArrList = [ModelClass]()
    
    var Saved_BankArrList = [ModelClass]()
    
    var SelBankIndex = IndexPath()
    
    var SelCardIndex = IndexPath()
    
    var BackAction:(_ CardID:String, _ CustomerID:String)->() = {CardID,CustomerID in }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.BankTblV.register(UINib(nibName: "SavedCardBankTblVCell", bundle: nil), forCellReuseIdentifier: "SavedCardBankTblVCell")
        self.BankTblV.delegate = self
        self.BankTblV.dataSource = self
        
        self.CardTblV.register(UINib(nibName: "SavedCardBankTblVCell", bundle: nil), forCellReuseIdentifier: "SavedCardBankTblVCell")
        self.CardTblV.delegate = self
        self.CardTblV.dataSource = self
           setupTableView(BankTblV, tag: 1)
           setupTableView(CardTblV, tag: 2)
        
        StateMangerModelClass.shared.isCardAdded = false
       }
       
       private func setupTableView(_ tableView: UITableView, tag: Int) {
           tableView.tag = tag
           // Add observer for contentSize
           tableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
       }
       
       // Observe value changes for the contentSize property
       override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
           if keyPath == "contentSize", let tableView = object as? UITableView {
               if tableView.tag == 1 {
                   BankTblVH.constant = tableView.contentSize.height
               } else if tableView.tag == 2 {
                   CardTblVH.constant = tableView.contentSize.height
               }
           }
       }
       
       deinit {
           // Remove observers
           BankTblV.removeObserver(self, forKeyPath: "contentSize")
           CardTblV.removeObserver(self, forKeyPath: "contentSize")
       }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.API_TO_Get_Cards()
    }
    
    @IBAction func BAckBtns(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func AddPaymentMethodsBtns(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AddCardBankContainerVC") as! AddCardBankContainerVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension SavedCardBankVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == BankTblV {
            return self.Saved_BankArrList.count
        } else {
            return self.SavedCardArrList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == BankTblV {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SavedCardBankTblVCell", for: indexPath) as! SavedCardBankTblVCell
            cell.BankNamelbl.text = self.Saved_BankArrList[indexPath.row].bank_name
            cell.Img.image = UIImage(named: "BankImg")
            cell.BankNumLbl.text =  "\(self.Saved_BankArrList[indexPath.row].account_holder_name), \(self.Saved_BankArrList[indexPath.row].last4)(\(self.Saved_BankArrList[indexPath.row].currency))"  //"Bill gilbert, Checking .....4898(USD)"
            if self.SelBankIndex == indexPath{
                cell.SelectedImg.image = UIImage(named: "YelloBorder")
            }else{
                cell.SelectedImg.image = UIImage(named: "")
            }
            
            cell.OptionBtn.tag = indexPath.row
            cell.OptionBtn.addTarget(self, action: #selector(didTapBankOptionBtn(sender:)), for: .touchUpInside)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SavedCardBankTblVCell", for: indexPath) as! SavedCardBankTblVCell
            
            cell.BankNamelbl.text = self.SavedCardArrList[indexPath.row].name//"Card Number"
            cell.Img.image = UIImage(named: "CardImg")
            
            let cardnum = self.SavedCardArrList[indexPath.row].last4
            
            cell.BankNumLbl.text = "**** **** **** \(cardnum)"
            
            if self.SelCardIndex == indexPath{
                cell.SelectedImg.image = UIImage(named: "YelloBorder")
            }else{
                cell.SelectedImg.image = UIImage(named: "")
            }
            
            cell.OptionBtn.tag = indexPath.row
            cell.OptionBtn.addTarget(self, action: #selector(didTapOptionBtn(sender:)), for: .touchUpInside)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == BankTblV {
            self.SelBankIndex = indexPath
            self.BankTblV.reloadData()
           let isBankVerified = self.Saved_BankArrList[indexPath.row].verification_status
            if isBankVerified == true{
                let AccountID = self.Saved_BankArrList[indexPath.row].account
                let bankID = self.SavedCardArrList[indexPath.row].ids
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3){
                    self.BackAction(AccountID, bankID)
                    self.navigationController?.popViewController(animated: true)
                }
            }else{
                AlertControllerOnr(title: "", message: "Your account is not verified yet. Please select another account.")
            }
            
            
        }else {
            self.SelCardIndex = indexPath
            self.CardTblV.reloadData()
            let cardID = self.SavedCardArrList[indexPath.row].card_id
            let CustomerID = self.SavedCardArrList[indexPath.row].customer_id
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3){
                self.BackAction(cardID, CustomerID)
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    @objc func didTapBankOptionBtn(sender: UIButton) {
        let indexP = sender.tag
        dropDown.dataSource = ["Delete"]
          dropDown.anchorView = sender
          
          // Add trailing space (adjust x for horizontal offset)
          let trailingSpace: CGFloat = 70// Adjust as needed
          dropDown.bottomOffset = CGPoint(x: -trailingSpace, y: sender.bounds.height)
          dropDown.topOffset = CGPoint(x: -trailingSpace, y: -(dropDown.anchorView?.plainView.bounds.height ?? 0))
          dropDown.width = 80
          dropDown.setupCornerRadius(10)
          
          // Optional: You may also need to disable shadow for proper clipping
          dropDown.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
          dropDown.layer.shadowOpacity = 0
          dropDown.layer.shadowRadius = 4
          dropDown.layer.shadowOffset = CGSize(width: 0, height: 0)
          dropDown.backgroundColor = .white
          dropDown.cellHeight = 32
          dropDown.textFont = UIFont.systemFont(ofSize: 11)

        dropDown.selectionAction = { [weak self] (index: Int, item: String) in
            guard let self = self else { return }
            print(index)
            let AccID = self.Saved_BankArrList[sender.tag].account
           // let CustomerID = self.Saved_BankArrList[sender.tag].customer_id
            
            self.API_TO_Delete_Bank(BankId: AccID)
        }
        
        dropDown.show()
    }
    
    @objc func didTapOptionBtn(sender: UIButton) {
        var index = sender.tag
        
        dropDown.dataSource = ["Delete"]
          dropDown.anchorView = sender
          
          // Add trailing space (adjust x for horizontal offset)
          let trailingSpace: CGFloat = 70// Adjust as needed
          dropDown.bottomOffset = CGPoint(x: -trailingSpace, y: sender.bounds.height)
          dropDown.topOffset = CGPoint(x: -trailingSpace, y: -(dropDown.anchorView?.plainView.bounds.height ?? 0))
          dropDown.width = 80
          dropDown.setupCornerRadius(10)
          
          // Optional: You may also need to disable shadow for proper clipping
          dropDown.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
          dropDown.layer.shadowOpacity = 0
          dropDown.layer.shadowRadius = 4
          dropDown.layer.shadowOffset = CGSize(width: 0, height: 0)
          dropDown.backgroundColor = .white
          dropDown.cellHeight = 32
          dropDown.textFont = UIFont.systemFont(ofSize: 11)

        dropDown.selectionAction = { [weak self] (index: Int, item: String) in
            guard let self = self else { return }
            print(index)
            let cardID = self.SavedCardArrList[sender.tag].card_id
            let CustomerID = self.SavedCardArrList[sender.tag].customer_id
            
            self.API_TO_Delete_Cards(CardId: cardID, CustomerID: CustomerID)
        }
        
        dropDown.show()
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

extension SavedCardBankVC {
    func API_TO_Get_Cards(){
    var params = [String: Any]()
      
 
     showIndicator(withTitle: "", and: "")
        let loginURL = baseURL.baseURL + appEndPoints.get_card_Bank_details

        WebService.shared.postServiceURLEncoding(loginURL, VC: self, andParameter: params, withCompletion:  { (json, statusCode) in
 
     self.hideIndicator()
     
     guard let dictData = json.dictionaryObject else{
         return
     }
 
     if dictData["success"] as? Bool == true{
         
         let val = dictData["data"] as? NSDictionary ?? NSDictionary()
         
         let BankResult = val["bank_details"] as? [[String: Any]] ?? [[String: Any]]()
         
         self.Saved_BankArrList.removeAll()
         self.Saved_BankArrList = ModelClass.Get_Saved_BankListtDetails(responseArray: BankResult)
         self.BankTblV.reloadData()
          
         
         let CardResult = val["card_details"] as? [[String: Any]] ?? [[String: Any]]()
         
         self.SavedCardArrList.removeAll()
         self.SavedCardArrList = ModelClass.Get_Saved_CardsListtDetails(responseArray: CardResult)
         self.CardTblV.reloadData()
     
        }else{
            let responseMessage = dictData["message"] as! String
            self.showToast(responseMessage)
        }
   })

 }
    
    
    func API_TO_Delete_Bank(BankId: String){
    var params = [String: Any]()
        
        params["stripe_account_id"] = BankId
        
    
        showIndicator(withTitle: "", and: "")
        let loginURL = baseURL.baseURL + appEndPoints.delete_Bank_Account

        WebService.shared.postServiceURLEncoding(loginURL, VC: self, andParameter: params, withCompletion:  { (json, statusCode) in
 
     self.hideIndicator()
     
     guard let dictData = json.dictionaryObject else{
         return
     }
 
     if dictData["success"] as? Bool == true{
         let responseMessage = dictData["message"] as! String
         self.showToast(responseMessage)
          
         self.API_TO_Get_Cards()
        }else{
            let responseMessage = dictData["message"] as! String
            self.showToast(responseMessage)
        }
 })

 }
    
    func API_TO_Delete_Cards(CardId: String, CustomerID: String){
    var params = [String: Any]()
        
        params["card_id"] = CardId
        params["customer_id"] = CustomerID
   
        showIndicator(withTitle: "", and: "")
        let loginURL = baseURL.baseURL + appEndPoints.delete_card

        WebService.shared.postServiceURLEncoding(loginURL, VC: self, andParameter: params, withCompletion:  { (json, statusCode) in
 
     self.hideIndicator()
     
     guard let dictData = json.dictionaryObject else{
         return
     }
 
     if dictData["success"] as? Bool == true{
         let responseMessage = dictData["message"] as! String
         self.showToast(responseMessage)
          
         self.API_TO_Get_Cards()
        }else{
            let responseMessage = dictData["message"] as! String
            self.showToast(responseMessage)
        }
 })

 }
    
}

 
