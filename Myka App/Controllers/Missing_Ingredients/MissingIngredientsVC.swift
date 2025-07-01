//
//  MissingIngredientsVC.swift
//  Myka App
//
//  Created by Sumit on 07/12/24.
//

import UIKit
import Alamofire
import SDWebImage

struct IngredientModel{
    var name: String = ""
    var image : UIImage = UIImage()
    var Quantity: String = ""
}

class MissingIngredientsVC: UIViewController {

    @IBOutlet weak var SelectAllBtnO: UIButton!
    
    @IBOutlet weak var MissingIngredientTblV: UITableView!
    
    @IBOutlet weak var AddedIngredientTblV: UITableView!
    @IBOutlet weak var MissingIngredientTblVH: NSLayoutConstraint!
    @IBOutlet weak var AddedIngredientTblVH: NSLayoutConstraint!
    @IBOutlet weak var Added_IngredientsBgV: UIView!
    
    var MissingIngresientsArray = [MissingIngModel]()
    var AddedIngresientsArray = [MissingIngModel]()
    
    var selectedIndex = [Int]()
    
    var uri = ""
    var sch_id = ""
    var mealtype = ""
    
    var backAction: ()->() = {}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.MissingIngredientTblV.register(UINib(nibName: "MissingIngredientsTblVCell", bundle: nil), forCellReuseIdentifier: "MissingIngredientsTblVCell")
        self.MissingIngredientTblV.delegate = self
        self.MissingIngredientTblV.dataSource = self
        
        self.AddedIngredientTblV.register(UINib(nibName: "MissingIngredientsTblVCell", bundle: nil), forCellReuseIdentifier: "MissingIngredientsTblVCell")
        self.AddedIngredientTblV.delegate = self
        self.AddedIngredientTblV.dataSource = self
         
        MissingIngredientTblV.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        AddedIngredientTblV.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        
        self.Api_To_GetAllIngedients()
       }
        
       
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize" {
            if object as? UITableView == MissingIngredientTblV {
                updateTableViewHeight(for: MissingIngredientTblV, heightConstraint: MissingIngredientTblVH)
            } else if object as? UITableView == AddedIngredientTblV {
                updateTableViewHeight(for: AddedIngredientTblV, heightConstraint: AddedIngredientTblVH)
            }
        }
    }
       
    private func updateTableViewHeight(for tableView: UITableView, heightConstraint: NSLayoutConstraint) {
        // Update the height constraint with the tableView's contentSize height
        heightConstraint.constant = tableView.contentSize.height
    }

    deinit {
        // Remove observers for both table views to avoid memory leaks
        MissingIngredientTblV.removeObserver(self, forKeyPath: "contentSize")
        AddedIngredientTblV.removeObserver(self, forKeyPath: "contentSize")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.MissingIngredientTblV.reloadData()
            self.MissingIngredientTblV.layoutIfNeeded()
            self.MissingIngredientTblVH.constant = self.MissingIngredientTblV.contentSize.height
            self.MissingIngredientTblV.layoutIfNeeded()
            
            DispatchQueue.main.async {
                self.AddedIngredientTblV.reloadData()
                self.AddedIngredientTblV.layoutIfNeeded()
                self.AddedIngredientTblVH.constant = self.AddedIngredientTblV.contentSize.height
                self.AddedIngredientTblV.layoutIfNeeded()
            }
        }
        
        
    }
    
    @IBAction func BackBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func AddToBasketBtn(_ sender: UIButton) {
        guard self.selectedIndex.count > 0 else {
            AlertControllerOnr(title: "", message: "Please select at least one ingredient")
            return
        }
        
        self.Api_To_AddIngedients()
    }
    
    
    
    @IBAction func PurchasedBtn(_ sender: UIButton) {
        guard self.selectedIndex.count > 0 else {
            AlertControllerOnr(title: "", message: "Please select at least one ingredient")
            return
        }
        self.Api_To_Ingedients_Purchased()
    }
    
    @IBAction func SellectAllBtn(_ sender: UIButton) {
        if self.SelectAllBtnO.isSelected {
            self.SelectAllBtnO.isSelected = false
            selectedIndex.removeAll()
        }else{
            self.SelectAllBtnO.isSelected = true
            for i in 0..<MissingIngresientsArray.count {
                selectedIndex.append(i)
            }
        }
        self.MissingIngredientTblV.reloadData()
    }
}


extension MissingIngredientsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.MissingIngredientTblV {
            return self.MissingIngresientsArray.count
        }else{
            return self.AddedIngresientsArray.count
        }
    }
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.MissingIngredientTblV {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MissingIngredientsTblVCell", for: indexPath) as! MissingIngredientsTblVCell
            cell.NameLbl.text = MissingIngresientsArray[indexPath.row].food
            
            let img = MissingIngresientsArray[indexPath.row].image ?? ""
            cell.Img.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
            cell.Img.sd_setImage(with: URL(string: img), placeholderImage: UIImage(named:"No_Image"))
             
            let Qnt = MissingIngresientsArray[indexPath.row].quantity ?? 0
            let roundedValue = roundedFormattedValue(Qnt, decimalPlaces: 2)
            
            cell.QuentityLbl.text = "\(roundedValue) \(MissingIngresientsArray[indexPath.row].measure ?? "")"
            
            if selectedIndex.contains(indexPath.row){
                cell.CheckBtn.setImage(UIImage(named: "YellowCheck"), for: .normal)
            }else{
                cell.CheckBtn.setImage(UIImage(named: "YelloUncheck"), for: .normal)
            }
            
            cell.CheckBtn.tag = indexPath.item
            cell.CheckBtn.addTarget(self, action: #selector(AddIngredientBtnTapped(sender: )), for: .touchUpInside)
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "MissingIngredientsTblVCell", for: indexPath) as! MissingIngredientsTblVCell
            cell.NameLbl.text = AddedIngresientsArray[indexPath.row].food
            
            let img = AddedIngresientsArray[indexPath.row].image ?? ""
            cell.Img.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
            cell.Img.sd_setImage(with: URL(string: img), placeholderImage: UIImage(named:"No_Image"))
             
            let Qnt = AddedIngresientsArray[indexPath.row].quantity ?? 0
            let roundedValue = roundedFormattedValue(Qnt, decimalPlaces: 2)
            cell.QuentityLbl.text = "\(roundedValue) \(AddedIngresientsArray[indexPath.row].measure ?? "")"
            
            cell.CheckBtn.setImage(UIImage(named: "YellowCheck"), for: .normal)
            return cell
        }
    }
    
    
    
    @objc func AddIngredientBtnTapped(sender: UIButton){
        let index = sender.tag
        if selectedIndex.contains(index){
            selectedIndex.remove(at: selectedIndex.firstIndex(of: index)!)
        }else{
            selectedIndex.append(index)
        }
        
        if selectedIndex.count == MissingIngresientsArray.count{
            self.SelectAllBtnO.isSelected = true
        }else {
            self.SelectAllBtnO.isSelected = false
        }
        
        self.MissingIngredientTblV.reloadData()
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension MissingIngredientsVC {
    
    func Api_To_GetAllIngedients(){
        var params = [String: Any]()
        
        params["uri"] = self.uri
        params["sch_id"] = self.sch_id
        
       
        
        showIndicator(withTitle: "", and: "")
        let loginURL = baseURL.baseURL + appEndPoints.get_missing_ingredient
        
        WebService.shared.postServiceURLEncoding(loginURL, VC: self, andParameter: params, withCompletion: { (json, statusCode) in
            
            self.hideIndicator()
            
            let data = try! json.rawData()
            
            do{
                let d = try JSONDecoder().decode(MissingIngModelClass.self, from: data)
                if d.success == true {
                    let list = d.data
                    
                    let AllIngredientList  = list ?? []
                     
                    self.selectedIndex.removeAll()
                    self.MissingIngresientsArray.removeAll()
                    self.AddedIngresientsArray.removeAll()
                    
                    for itm in AllIngredientList {
                        if itm.isMissing ?? 0 == 0 {
                            self.MissingIngresientsArray.append(itm)
                        }else{
                            self.AddedIngresientsArray.append(itm)
                        }
                    }
                    
                    if self.AddedIngresientsArray.count == 0 {
                        self.Added_IngredientsBgV.isHidden = true
                    }else{
                        self.Added_IngredientsBgV.isHidden = false
                    }
                    
                    self.MissingIngredientTblV.reloadData()
                    self.AddedIngredientTblV.reloadData()
                    
                    if self.MissingIngresientsArray.count == 0 {
                        self.backAction()
                        self.navigationController?.popViewController(animated: true)
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
    
    func Api_To_AddIngedients(){
        var params = [String: Any]()
        
        var foodIds : [String] = []
        var names : [String] = []
        var Status : [String] = []
        
        for indx in selectedIndex{
            let id = self.MissingIngresientsArray[indx].foodID  ?? ""
            let name = self.MissingIngresientsArray[indx].food  ?? ""
            
            foodIds.append(id)
            names.append(name)
            Status.append("0")
        }
        
//        let string = self.SelSearchAllRecipeArr[indexPath.row].recipe?.mealType?.first ?? ""
//        if let result = string.components(separatedBy: "/").first {
//            cell.NameLbl.text = result
//        }
        
        params["food_ids"] = foodIds
        params["sch_id"] = "1"//self.sch_id
        params["names"] = names
        params["status"] = Status
        params["uri"] = self.uri
        params["type"] = self.mealtype
        
      
        
        showIndicator(withTitle: "", and: "")
        let loginURL = baseURL.baseURL + appEndPoints.add_to_cart
        
        WebService.shared.postServiceURLEncoding(loginURL, VC: self, andParameter: params, withCompletion: { (json, statusCode) in
            
            self.hideIndicator()
            
            guard let dictData = json.dictionaryObject else{
                return
            }
        
            if dictData["success"] as? Bool == true{
                let responseMessage = dictData["message"] as? String ?? ""
                self.navigationController?.showToast(responseMessage)
                self.backAction()
                self.navigationController?.popViewController(animated: true)
               }else{
                   let responseMessage = dictData["message"] as? String ?? ""
                   self.showToast(responseMessage)
               }
          })
         }
    
    func Api_To_Ingedients_Purchased(){
        var params = [String: Any]()
        
        var foodIds : [String] = []
        var names : [String] = []
        var Status : [String] = []
        
        for indx in selectedIndex{
            let id = self.MissingIngresientsArray[indx].foodID  ?? ""
            let name = self.MissingIngresientsArray[indx].food  ?? ""
            
            foodIds.append(id)
            names.append(name)
            Status.append("1")
        }
        
        params["food_ids"] = foodIds
        params["sch_id"] = self.sch_id
        params["names"] = names
        params["status"] = Status
        params["uri"] = self.uri
        params["type"] = self.mealtype
        
        
        showIndicator(withTitle: "", and: "")
        let loginURL = baseURL.baseURL + appEndPoints.add_to_cart
        
        WebService.shared.postServiceURLEncoding(loginURL, VC: self, andParameter: params, withCompletion: { (json, statusCode) in
            
            self.hideIndicator()
            
            guard let dictData = json.dictionaryObject else{
                return
            }
        
            if dictData["success"] as? Bool == true{
                self.Api_To_GetAllIngedients()
               }else{
                   let responseMessage = dictData["message"] as? String ?? ""
                   self.showToast(responseMessage)
               }
          })
         }
}
