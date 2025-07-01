//
//  RecipeDetail1VC.swift
//  Myka App
//
//  Created by Sumit on 10/12/24.
//

import UIKit
import SDWebImage

class RecipeDetail1VC: UIViewController {
    
    
    @IBOutlet weak var Img: UIImageView!
    
    @IBOutlet weak var ImgDescLbl: UILabel!
   
    
    @IBOutlet weak var TblV: UITableView!
    
    @IBOutlet weak var TblVH: NSLayoutConstraint!
    
    @IBOutlet weak var ImgbottomBorder: UIView!
    
//    @IBOutlet weak var progressView: UIProgressView!
//    @IBOutlet weak var ProgressLbl: UILabel!
    
    var RecipeDetailsData = [RecipeDetailModel]()
    
    var RecipeListArr = [String]()
    
    var MealType = ""
    
    var recipesArray: [RecipeDetailsIngredientModel] = []
    
//    let recipesArray: [IngredientModel] = [
//        IngredientModel(name: "Olive Oil", image: UIImage(named: "Oilimage")!, Quantity: "1 Tbsp"), IngredientModel(name: "Garlic Mayo", image: UIImage(named: "Onion")!, Quantity: "3 Tbsp"), IngredientModel(name: "Butter", image: UIImage(named: "Mayo")!, Quantity: "3 Tbsp"), IngredientModel(name: "Chicken", image: UIImage(named: "Chicken")!, Quantity: "1 kg")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let val = self.RecipeDetailsData.first?.recipe
        let img  = val?.images?.small?.url
        let imgUrl = URL(string: img ?? "")
        self.Img.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
        self.Img.sd_setImage(with: imgUrl, placeholderImage: UIImage(named: "No_Image"))
        
        self.ImgDescLbl.text = val?.label ?? ""
     //   self.ImgDesc1Lbl.text = val?.source ?? ""
         
        
        self.TblV.register(UINib(nibName: "RecipeDetail1TblVCell", bundle: nil), forCellReuseIdentifier: "RecipeDetail1TblVCell")
        self.TblV.delegate = self
        self.TblV.dataSource = self
        
        self.TblV.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
    // KVO observation
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize" {
            if let tableView = object as? UITableView {
                if tableView == TblV {
                    TblVH.constant = tableView.contentSize.height
                    
                }
            }
        }
    }
        
        deinit {
            // Remove observers
            TblV.removeObserver(self, forKeyPath: "contentSize")
        }

    @IBAction func BackBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func NextStepbtn(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Tabbar", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "RecipeDetail2VC") as! RecipeDetail2VC
        vc.MealType = self.MealType
        vc.RecipeDetailsData = self.RecipeDetailsData
        vc.RecipeListArr = self.RecipeListArr
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


extension RecipeDetail1VC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return recipesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
            let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeDetail1TblVCell", for: indexPath) as! RecipeDetail1TblVCell
        cell.NameLbl.text = recipesArray[indexPath.row].name
        
        let img = recipesArray[indexPath.row].image
        cell.Img.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
        cell.Img.sd_setImage(with: URL(string: img), placeholderImage: UIImage(named: "No_Image"))
        
         let quantityString = recipesArray[indexPath.row].Quantity

           let quantity = Double(quantityString) ?? 0
            let formatter = NumberFormatter()
            formatter.minimumFractionDigits = 0  // Show no fractional digits if not needed
            formatter.maximumFractionDigits = 2  // Limit to 2 fractional digits
            formatter.numberStyle = .decimal

            if let formattedQuantity = formatter.string(from: NSNumber(value: quantity)) {
                print(formattedQuantity) // This will give "2" for 2.00 and "2.05" for 2.05
                cell.QuentityLbl.text = "\(formattedQuantity) \(recipesArray[indexPath.row].measure)"
            }else{
                cell.QuentityLbl.text = "\(quantityString) \(recipesArray[indexPath.row].measure)"
            }
          
             
            return cell
    }
    
    
    
      func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
      }
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return UITableView.automaticDimension
        }
    }
