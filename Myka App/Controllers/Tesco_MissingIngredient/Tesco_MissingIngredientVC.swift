//
//  Tesco_MissingIngredientVC.swift
//  Myka App
//  Created by YES IT Labs on 17/12/24.
//


import UIKit

class Tesco_MissingIngredientVC: UIViewController {

    @IBOutlet weak var SearchTxt: UITextField!
    @IBOutlet weak var SelectAllBtnO: UIButton!
    @IBOutlet weak var AddtoBasketBtnO: UIButton!
    @IBOutlet weak var MissingIngredientTblV: UITableView!
    @IBOutlet weak var MissingIngredientTblVH: NSLayoutConstraint!
    
    @IBOutlet weak var viewForSubmitPurchaseDetails: UIView!
    @IBOutlet weak var storeName:UITextField!
    @IBOutlet weak var cartTotal:UITextField!
    @IBOutlet weak var datePurchased:UITextField!
    @IBOutlet weak var checkPopupView: UIView!
    
    @IBOutlet weak var dismissView: UIView!
    
    let datePicker = UIDatePicker()
   
    var selectedIndex = [Int]()
    var missingIngredient =  [WelcomeIngredient]()
    
    let recipesArray: [IngredientModel] = [
        IngredientModel(name: "Olive Oil", image: UIImage(named: "Oilimage")!, Quantity: "20 G"), IngredientModel(name: "Garlic Mayo", image: UIImage(named: "Onion")!, Quantity: "3 Tbsp"), IngredientModel(name: "Butter", image: UIImage(named: "Mayo")!, Quantity: "3 Tbsp"), IngredientModel(name: "Chicken", image: UIImage(named: "Chicken")!, Quantity: "1 kg")]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.MissingIngredientTblV.register(UINib(nibName: "IngredientsTblVCell", bundle: nil), forCellReuseIdentifier: "IngredientsTblVCell")
        self.MissingIngredientTblV.delegate = self
        self.MissingIngredientTblV.dataSource = self
        self.MissingIngredientTblV.addObserver(self, forKeyPath: "contentSize", options: [.new, .old], context: nil)
        self.setupview()
    }
    
    func setupview(){
        let screenWidth = UIScreen.main.bounds.width
       
        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 44.0))
        toolBar.sizeToFit()
        toolBar.tintColor = .systemBlue
        toolBar.isUserInteractionEnabled = true

        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(datePurchasedDoneTapped))
        doneButton.tintColor = .black
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([flexibleSpace, doneButton], animated: false)
        toolBar.backgroundColor = .white
        datePurchased.inputView = datePicker
        datePurchased.inputAccessoryView = toolBar
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date

        // Set today's date as default in MM/dd/yyyy format
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        datePurchased.text = formatter.string(from: Date())

        datePicker.minimumDate = nil
        datePicker.maximumDate = Date()
        datePicker.backgroundColor = .white

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak datePicker] in
            guard let picker = datePicker else { return }

            let sub = picker.subviews[0].subviews
            if sub.count > 1 {
                sub[1].backgroundColor = #colorLiteral(red: 0, green: 0.7843137255, blue: 0.4862745098, alpha: 0.09602649007)
            }
            if sub.count > 2 {
                sub[2].backgroundColor = #colorLiteral(red: 0, green: 0.7843137255, blue: 0.4862745098, alpha: 0.09602649007)
            }
        }
        self.checkPopupView.frame = self.view.bounds
        self.view.addSubview(self.checkPopupView)
        self.checkPopupView.isHidden = true
        self.viewForSubmitPurchaseDetails.frame = self.view.bounds
        dismissView.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(dismissView(_:)))
        dismissView.addGestureRecognizer(gesture)
        self.view.addSubview(self.viewForSubmitPurchaseDetails)
        self.viewForSubmitPurchaseDetails.isHidden = true
        
        // Configure cartTotal with fixed "$" at beginning
        cartTotal.keyboardType = .decimalPad
        
        let dollarLabel = UILabel()
        dollarLabel.text = "  $"
        dollarLabel.font = cartTotal.font
        dollarLabel.sizeToFit()
        cartTotal.leftView = dollarLabel
        cartTotal.leftViewMode = .always
        
        missingIngredient = missingIngredient.map {
            var item = $0
            item.isSelected = false
            return item
        }
    }
    @objc func datePurchasedDoneTapped() {
        if let picker = datePurchased.inputView as? UIDatePicker {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            datePurchased.text = formatter.string(from: picker.date)
        }
        self.view.endEditing(true)
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize", let tableView = object as? UITableView {
            let newContentSize = tableView.contentSize
            updateTableViewHeight(newContentSize.height)
        }
    }
    @objc func dismissView(_ sender: Any) {
        self.viewForSubmitPurchaseDetails.isHidden = true
    }
    func updateTableViewHeight(_ height: CGFloat) {
        MissingIngredientTblVH.constant = height
        view.layoutIfNeeded()
    }
    
    
    deinit {
        MissingIngredientTblV.removeObserver(self, forKeyPath: "contentSize")
    }
    
    @IBAction func BackBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
        @IBAction func SellectAllBtn(_ sender: UIButton) {
            if self.SelectAllBtnO.isSelected {
                self.SelectAllBtnO.isSelected = false
                missingIngredient = missingIngredient.map {
                    var item = $0
                    item.isSelected = false
                    return item
                }
                self.AddtoBasketBtnO.setTitle("I have Purchased Everything", for: .normal)
            
            }else{
                self.SelectAllBtnO.isSelected = true
                missingIngredient = missingIngredient.map {
                    var item = $0
                    item.isSelected = true
                    return item
                }
                self.AddtoBasketBtnO.setTitle("Add to basket", for: .normal)
            }
            self.MissingIngredientTblV.reloadData()
            
        }
    
    @IBAction func AddToBasketBtn(_ sender: UIButton) {
        Api_StorePurchasedIngredients()
     //   self.checkPopupView.isHidden = false
    }
    
    @IBAction func trackSaving(_ sender: UIButton) {
        self.viewForSubmitPurchaseDetails.isHidden = true
        Api_AddGraphData(storeName: self.storeName.text ?? "", total: self.cartTotal.text ?? "", date: self.datePurchased.text ?? "")
    }
    
    @IBAction func yesSaveBtn(_ sender: UIButton) {
        self.checkPopupView.isHidden = true
        self.viewForSubmitPurchaseDetails.isHidden = false
    }
    
   @IBAction func noSaveBtn(_ sender: UIButton) {
       self.checkPopupView.isHidden = true
       navigateToHomeTab()
    }
   
    @IBAction func searchTextChanged(_ sender: UITextField) {
        let text = sender.text?.lowercased() ?? ""

        for i in 0..<missingIngredient.count {
            missingIngredient[i].isVisible = text.isEmpty ||
            missingIngredient[i].name?.lowercased().contains(text) ?? false
        }

        MissingIngredientTblV.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cartTotal.delegate = self
    }
}



extension Tesco_MissingIngredientVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let visibleItems = missingIngredient.filter { $0.isVisible ?? false }
        
            return visibleItems.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientsTblVCell", for: indexPath) as! IngredientsTblVCell
        let visibleItems = missingIngredient.filter { $0.isVisible ?? false }
        let ingredient = visibleItems[indexPath.row]
        cell.ingredientlbl?.text = ingredient.name
        cell.amout_MeasurmentLbl?.text = "\(ingredient.quantity ?? 0) \(ingredient.unitOfMeasurement ?? "")"
        cell.img.sd_setImage(with: URL(string: ingredient.image ?? ""), placeholderImage: UIImage(named: "NewRec"))
        
        if missingIngredient[indexPath.row].isSelected ?? false{
            cell.checkBoxBtn.setImage(UIImage(named: "YellowCheck"), for: .normal)
        }else{
            cell.checkBoxBtn.setImage(UIImage(named: "YelloUncheck"), for: .normal)
        }
        cell.checkBoxBtn.tag = indexPath.row
        cell.checkBoxBtn.addTarget(self, action: #selector(AddIngredientBtnTapped(sender:)), for: .touchUpInside)
        return cell
    }
    
    
    
    @objc func AddIngredientBtnTapped(sender: UIButton) {
        let index = sender.tag
        
        missingIngredient[index].isSelected?.toggle()
        
        let anySelected = missingIngredient.contains { $0.isSelected ?? false }
        
        let allSelected = missingIngredient.allSatisfy { $0.isSelected ?? false }
        self.SelectAllBtnO.isSelected = allSelected
        
        
        if anySelected {
            self.AddtoBasketBtnO.setTitle("Add to basket", for: .normal)
        } else {
            self.AddtoBasketBtnO.setTitle("I have Purchased Everything", for: .normal)
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

extension Tesco_MissingIngredientVC {
    private func navigateToHomeTab() {
        DispatchQueue.main.async {
            let resolvedTabBarController = self.tabBarController ?? self.findTabBarController(from: self.view.window?.rootViewController)
            guard let tabBarController = resolvedTabBarController else { return }

            self.navigationController?.popToRootViewController(animated: false)

            if let viewControllers = tabBarController.viewControllers,
               viewControllers.indices.contains(0),
               let homeNavigationController = viewControllers[0] as? UINavigationController {
                homeNavigationController.popToRootViewController(animated: false)
            }

            tabBarController.tabBar.isHidden = false

            let tabBar = tabBarController.tabBar
            if let items = tabBar.items,
               items.indices.contains(0),
               let delegate = tabBarController.delegate,
               let homeViewController = tabBarController.viewControllers?[0] {
                let canSelect = delegate.tabBarController?(tabBarController, shouldSelect: homeViewController) ?? true
                if canSelect {
                    tabBarController.tabBar(tabBar, didSelect: items[0])
                }
            }

            tabBarController.selectedIndex = 0
        }
    }

    private func findTabBarController(from viewController: UIViewController?) -> UITabBarController? {
        if let tabBarController = viewController as? UITabBarController {
            return tabBarController
        }

        if let navigationController = viewController as? UINavigationController {
            return findTabBarController(from: navigationController.viewControllers.first)
        }

        if let presentedViewController = viewController?.presentedViewController {
            return findTabBarController(from: presentedViewController)
        }

        for child in viewController?.children ?? [] {
            if let found = findTabBarController(from: child) {
                return found
            }
        }

        return nil
    }
    
    func Api_StorePurchasedIngredients() {
        
        // Send only selected ingredient IDs
        let ids = missingIngredient
            .filter { $0.isSelected ?? false }
            .compactMap { "\($0.id ?? 0)" }

        // If nothing selected, do not send anything
//        if ids.isEmpty {
//            print("No ingredient selected. Nothing to send.")
//            return
//        }
        
        print("IDs sending: \(ids)")
        
        // API URL
        let apiURL = baseURL.baseURL + appEndPoints.store_purchased_ingredients
        print("API URL: \(apiURL)")
        
       
        showIndicator(withTitle: "", and: "")
        
        let params: [String: Any] = [
               "id": ids
           ]
           
        print("Params Dictionary: \(params)")
        
        // Encode JSON and Send
        WebService.shared.postServiceMultipart(apiURL, VC: self, andParameter: params) { json, statusCode in
             
             self.hideIndicator()
             
             print("API Response:", json)
             
             let success = json["success"].boolValue
             let message = json["message"].stringValue
             
             if success {
                 self.checkPopupView.isHidden = false
                 self.showToast(message)
             } else {
                 self.showToast(message)
             }
         }
    }
    
    func Api_AddGraphData(storeName: String?, total: String?, date: String?) {
        guard let store = storeName?.trimmingCharacters(in: .whitespacesAndNewlines), !store.isEmpty else {
               self.showToast("Please enter store name")
               return
           }
           
           // Total
           guard let totalStr = total?.trimmingCharacters(in: .whitespacesAndNewlines), !totalStr.isEmpty else {
               self.showToast("Please enter total amount")
               return
           }
           
           // Check numeric (optional based on backend)
           guard Double(totalStr) != nil else {
               self.showToast("Total must be a valid number")
               return
           }
           
        let params: [String:Any] = [
            "store_name": storeName ?? "",
            "total": total ?? "",
            "date": date ?? ""
        ]
        
        let url = baseURL.baseURL + appEndPoints.userPurchasedURL
        
        print("Params:", params)
        print("url:", url)
        showIndicator(withTitle: "", and: "")
        
        WebService.shared.postServiceURLEncoding(url, VC: self, andParameter: params) { json, statusCode in
            
            self.hideIndicator()
            
            print("Response JSON:", json)
            
            let success = json["success"].boolValue
            let message = json["message"].stringValue
        
            if success {
                self.showToast(message)
                self.navigateToHomeTab()
            } else {
                self.showToast(message)
            }
        }
    }
}

extension Tesco_MissingIngredientVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == cartTotal {
            
            // Allow only numbers and decimal point
            let allowedCharacters = CharacterSet(charactersIn: "0123456789.")
            let characterSet = CharacterSet(charactersIn: string)
            
            if !allowedCharacters.isSuperset(of: characterSet) {
                return false
            }
            
            // Prevent multiple decimal points
            if string == "." && textField.text?.contains(".") == true {
                return false
            }
        }
        
        return true
    }
}
