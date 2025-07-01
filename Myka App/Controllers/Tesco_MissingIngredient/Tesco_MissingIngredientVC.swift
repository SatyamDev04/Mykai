//
//  Tesco_MissingIngredientVC.swift
//  Myka App
//
//  Created by YES IT Labs on 17/12/24.
//

import UIKit

class Tesco_MissingIngredientVC: UIViewController {

    @IBOutlet weak var SearchTxt: UITextField!
    
    @IBOutlet weak var SelectAllBtnO: UIButton!
    @IBOutlet weak var AddtoBasketBtnO: UIButton!
    @IBOutlet weak var MissingIngredientTblV: UITableView!
    @IBOutlet weak var MissingIngredientTblVH: NSLayoutConstraint!
    
    var selectedIndex = [Int]()
    
    let recipesArray: [IngredientModel] = [
        IngredientModel(name: "Olive Oil", image: UIImage(named: "Oilimage")!, Quantity: "20 G"), IngredientModel(name: "Garlic Mayo", image: UIImage(named: "Onion")!, Quantity: "3 Tbsp"), IngredientModel(name: "Butter", image: UIImage(named: "Mayo")!, Quantity: "3 Tbsp"), IngredientModel(name: "Chicken", image: UIImage(named: "Chicken")!, Quantity: "1 kg")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.MissingIngredientTblV.register(UINib(nibName: "Tesco_MissingIngredientTblVCell", bundle: nil), forCellReuseIdentifier: "Tesco_MissingIngredientTblVCell")
        self.MissingIngredientTblV.delegate = self
        self.MissingIngredientTblV.dataSource = self
        self.MissingIngredientTblV.addObserver(self, forKeyPath: "contentSize", options: [.new, .old], context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize", let tableView = object as? UITableView {
            let newContentSize = tableView.contentSize
            // Update the height constraint or perform actions as needed
            updateTableViewHeight(newContentSize.height)
        }
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
                selectedIndex.removeAll()
                self.AddtoBasketBtnO.setTitle("Add to basket", for: .normal)
            }else{
                self.SelectAllBtnO.isSelected = true
                for i in 0..<recipesArray.count {
                    selectedIndex.append(i)
                }
                self.AddtoBasketBtnO.setTitle("I have Purchased Everything", for: .normal)
            }
            self.MissingIngredientTblV.reloadData()
            
        }
    
    
    @IBAction func AddToBasketBtn(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Basket", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "BasketDetailSuperMarketVC") as! BasketDetailSuperMarketVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func PurchasedEverythingBtn(_ sender: UIButton) {
        
    }
}

extension Tesco_MissingIngredientVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return recipesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Tesco_MissingIngredientTblVCell", for: indexPath) as! Tesco_MissingIngredientTblVCell
            cell.NameLbl.text = recipesArray[indexPath.row].name
            cell.Img.image = recipesArray[indexPath.row].image
            cell.QuentityLbl.text = recipesArray[indexPath.row].Quantity
            
            if selectedIndex.contains(indexPath.row){
                cell.CheckBtn.setImage(UIImage(named: "YellowCheck"), for: .normal)
            }else{
                cell.CheckBtn.setImage(UIImage(named: "YelloUncheck"), for: .normal)
            }
            
            cell.CheckBtn.tag = indexPath.item
            cell.CheckBtn.addTarget(self, action: #selector(AddIngredientBtnTapped(sender: )), for: .touchUpInside)
            return cell
    }
    
    
    
    @objc func AddIngredientBtnTapped(sender: UIButton){
        let index = sender.tag
        if selectedIndex.contains(index){
            selectedIndex.remove(at: selectedIndex.firstIndex(of: index)!)
        }else{
            selectedIndex.append(index)
        }
        
        if selectedIndex.count == recipesArray.count{
            self.SelectAllBtnO.isSelected = true
            self.AddtoBasketBtnO.setTitle("I have Purchased Everything", for: .normal)
        }else {
            self.SelectAllBtnO.isSelected = false
            self.AddtoBasketBtnO.setTitle("Add to basket", for: .normal)
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
