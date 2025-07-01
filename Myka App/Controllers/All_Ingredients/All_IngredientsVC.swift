//
//  All_IngredientsVC.swift
//  Myka App
//
//  Created by Sumit on 13/12/24.
//

import UIKit
import Alamofire
import SDWebImage

//struct All_IngredientsModule {
//    var name: String
//    var img: UIImage
//}

class All_IngredientsVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var CatCollV: UICollectionView!
    @IBOutlet weak var CollV: UICollectionView!
    
    @IBOutlet weak var SearchTxt: UITextField!
    
    @IBOutlet weak var SearachRecipeContBtnO: UIButton!
    
     
    var All_IngredientsArr = All_IngredientsModel()
    
    var textChangedWorkItem: DispatchWorkItem?
    
    var CatselIndex = 0
    
    var SelCatName: String = "Fruit"
    
    var numberOfItemsToLoad = 10
    var hasReachedEnd = false
    var lastContentOffset: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CatCollV.delegate = self
        CatCollV.dataSource = self
        CatCollV.register(UINib(nibName: "CategoryCollVCell", bundle: nil), forCellWithReuseIdentifier: "CategoryCollVCell")
        
        CollV.delegate = self
        CollV.dataSource = self
        CollV.register(UINib(nibName: "All_IngredientsCollVCell", bundle: nil), forCellWithReuseIdentifier: "All_IngredientsCollVCell")
        
        self.SearachRecipeContBtnO.isUserInteractionEnabled = false
        self.SearachRecipeContBtnO.backgroundColor = UIColor.lightGray
        
        self.SearchTxt.delegate = self
        self.SearchTxt.addTarget(self, action: #selector(TextSearch(sender: )), for: .editingChanged)
        
        self.Api_To_GetAllRecipeList(catName: self.SelCatName)
    }
    
    @objc func TextSearch(sender: UITextField){
        if self.SearchTxt.text == ""{
            textChangedWorkItem?.cancel()
             SelCatName = "Fruit"
            self.Api_To_GetAllRecipeList(catName: self.SelCatName)
        }else{
            // Cancel the previous work item
            textChangedWorkItem?.cancel()
            // Create a new debounced work item
            textChangedWorkItem = DispatchWorkItem { [weak self] in
                guard let self = self else { return }
                
                self.hideIndicator()
                SelCatName = ""
                self.Api_To_GetAllRecipeList(catName: self.SelCatName)
            }
            
            // Schedule the work item to execute after a debounce time (e.g., 1 second)
            if let workItem = textChangedWorkItem {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: workItem)
            }
        }
    }
   
    @IBAction func BackBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func SearchRecipeBtn(_ sender: UIButton) {
        var selectedNames = All_IngredientsArr.ingredients?
            .filter { $0.isselected == true }
            .compactMap { $0.name } ?? []
        
        let storyboard = UIStoryboard(name: "Tabbar", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "DinnerVc") as! DinnerVc
        vc.SelectedIngNames = selectedNames.joined(separator: ",")
        vc.comesfrom = "All_IngredientsVC"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension All_IngredientsVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == CatCollV{
            return All_IngredientsArr.categories?.count ?? 0
        }else{
            return All_IngredientsArr.ingredients?.count ?? 0
        }
       }
       
       func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
           if collectionView == CatCollV{
               let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollVCell", for: indexPath) as! CategoryCollVCell
               cell.NameLbl.text = All_IngredientsArr.categories?[indexPath.item]
              
               
               //if CatselIndex == indexPath.item{
               if self.SelCatName == All_IngredientsArr.categories?[indexPath.item]{
                   cell.NameLbl.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                   cell.BgV.backgroundColor = #colorLiteral(red: 0.9960784314, green: 0.6235294118, blue: 0.2705882353, alpha: 1)
               }else{
                   cell.NameLbl.textColor = #colorLiteral(red: 0.2352941176, green: 0.2705882353, blue: 0.2549019608, alpha: 1)
                   cell.BgV.backgroundColor = #colorLiteral(red: 1, green: 0.968627451, blue: 0.9411764706, alpha: 1)
               }
               
               return cell
           }else{
               let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "All_IngredientsCollVCell", for: indexPath) as! All_IngredientsCollVCell
               let NAME = All_IngredientsArr.ingredients?[indexPath.item].name
               cell.NameLbl.text = NAME?.capitalizedFirst
               
               let img = All_IngredientsArr.ingredients?[indexPath.item].image ?? ""
               let imgURL = URL(string: img)
               cell.Img.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
               cell.Img.sd_setImage(with: imgURL, placeholderImage: UIImage(named: "No_Image"))
                 //All_IngredientsArr[indexPath.item].img
               
               if All_IngredientsArr.ingredients?[indexPath.item].isselected == true{
                   cell.TickImg.image = UIImage(named: "TickImg")
               }else{
                   cell.TickImg.image = UIImage()
               }
               
               return cell
           }
       }
    
     
       
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == CatCollV{
            self.CatselIndex = indexPath.item
            CatCollV.reloadData()
            let nme = All_IngredientsArr.categories?[indexPath.item] ?? ""
            self.SelCatName = nme
            self.SearchTxt.text = ""
            self.Api_To_GetAllRecipeList(catName: self.SelCatName)
        }else{
            if All_IngredientsArr.ingredients?[indexPath.item].isselected == true{
                All_IngredientsArr.ingredients?[indexPath.item].isselected = false
            }else{
                All_IngredientsArr.ingredients?[indexPath.item].isselected = true
            }
            self.CollV.reloadData()
            
            let selectedCount = All_IngredientsArr.ingredients?.filter { $0.isselected == true }.count ?? 0
            if selectedCount > 0{
                self.SearachRecipeContBtnO.setTitle("Search Recipes(\(selectedCount))", for: .normal)
                self.SearachRecipeContBtnO.isUserInteractionEnabled = true
                self.SearachRecipeContBtnO.backgroundColor = #colorLiteral(red: 0.02352941176, green: 0.7568627451, blue: 0.4117647059, alpha: 1)
            }else{
                self.SearachRecipeContBtnO.setTitle("Search Recipes", for: .normal)
                self.SearachRecipeContBtnO.isUserInteractionEnabled = false
                self.SearachRecipeContBtnO.backgroundColor = UIColor.lightGray
            }
        }
    }
 
       func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
           if collectionView == CatCollV{
               if UIDevice.current.hasNotch {
                   //... consider notch
                   let modelName = UIDevice.modelName
                   if modelName.contains(find: "mini"){//"iPhone 12 mini"{
                       return CGSize(width: collectionView.frame.width/4, height: collectionView.frame.height)
                   }else if modelName.contains(find: "Max"){// == "iPhone 12 mini"{
                       return CGSize(width: collectionView.frame.width/5, height: collectionView.frame.height)
                   }else if modelName.contains(find: "Pro"){
                       return CGSize(width: collectionView.frame.width/5, height: collectionView.frame.height)
                   }else{
                       return CGSize(width: collectionView.frame.width/5, height: collectionView.frame.height)
                   }
               }else{
                   return CGSize(width: collectionView.frame.width/4, height: collectionView.frame.height)
               }
           }else{
               return CGSize(width: collectionView.frame.width/2 - 5, height: 215)
           }
       }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return 5
        }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            if section == 0 {
                return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 5)
            }else{
                return UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
            }
        }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 5
        }
    
    
    // UIScrollViewDelegate method for detecting scroll
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height

        // Detect scrolling direction
        let isScrollingDown = offsetY > lastContentOffset
        lastContentOffset = offsetY

        // Define a buffer to detect nearing the bottom
        let buffer: CGFloat = 0.0 // Adjust as needed

        if isScrollingDown {
            // Reached near the bottom
            if offsetY >= contentHeight - frameHeight - buffer && !hasReachedEnd {
                hasReachedEnd = true
                print("Reached bottom")
                self.numberOfItemsToLoad += 10
            self.Api_To_GetAllRecipeList(catName: self.SelCatName)
            }
        } else {
            // Detect scrolling out of bottom
            if hasReachedEnd && offsetY < contentHeight - frameHeight - buffer {
                hasReachedEnd = false
                print("Scrolled out of bottom")
                // Add actions for scrolling out of bottom if needed
            }
        }
    }
        }


extension All_IngredientsVC {
    func Api_To_GetAllRecipeList(catName: String){
        var params = [String: Any]()
        
        params["category"] = self.SelCatName
        params["search"] = self.SearchTxt.text ?? ""
        params["number"] = self.numberOfItemsToLoad
     
        showIndicator(withTitle: "", and: "")
        
        let loginURL = baseURL.baseURL + appEndPoints.ingredients
        print(params,"Params")
        print(loginURL,"loginURL")
        
        WebService.shared.postServiceURLEncoding(loginURL, VC: self, andParameter: params, withCompletion: { (json, statusCode) in
            
            self.hideIndicator()
            
            let data = try! json.rawData()
            
            do{
                let d = try JSONDecoder().decode(All_IngredientsModelClass.self, from: data)
                if d.success == true {
                    let list = d.data ?? All_IngredientsModel()
                     
                    if self.All_IngredientsArr.categories?.count ?? 0 > 0{
                        if let ingredients = list.ingredients {
                            let uniqueIngredients = Array(
                                Dictionary(grouping: ingredients) { $0.name }
                                    .values
                                    .compactMap { $0.first }
                            )
                            
                            // Assign back to your array if needed
                            self.All_IngredientsArr.ingredients?.append(contentsOf: uniqueIngredients)
                        }
                         
                    }else{
                        self.All_IngredientsArr = list
                        if let ingredients = self.All_IngredientsArr.ingredients {
                            let uniqueIngredients = Array(
                                Dictionary(grouping: ingredients) { $0.name }
                                    .values
                                    .compactMap { $0.first }
                            )
                            
                            // Assign back to your array if needed
                            self.All_IngredientsArr.ingredients = uniqueIngredients
                        }
                    }
                     
                    self.hasReachedEnd = false
                    
                    if self.All_IngredientsArr.ingredients?.count ?? 0 > 0{
                        self.CollV.setEmptyMessage("", UIImage())
                    }else{
                        self.CollV.setEmptyMessage("No recipe found.", UIImage())
                    }
                    
                    self.SearachRecipeContBtnO.setTitle("Search Recipes", for: .normal)
                    
                    self.SearachRecipeContBtnO.isUserInteractionEnabled = false
                    self.SearachRecipeContBtnO.backgroundColor = UIColor.lightGray
                     
                    self.CollV.reloadData()
                    
                    self.CatCollV.reloadData()
                    
                }else{
                    let msg = d.message ?? ""
                    self.showToast(msg)
                }
            }catch{
                print(error)
            }
        })
    }
}
