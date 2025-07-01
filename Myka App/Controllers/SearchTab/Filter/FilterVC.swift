//
//  FilterVC.swift
//  Myka App
//
//  Created by Sumit on 12/12/24.
//

import UIKit
import Alamofire

struct FilterModuel{
    var name = ""
    var id = ""
    var Selcolor: Bool = false
    var value = ""
}


class FilterVC: UIViewController {
    
    @IBOutlet weak var SearchTxt: UITextField!
    @IBOutlet weak var mealCollv: UICollectionView!
    @IBOutlet weak var mealCollvH: NSLayoutConstraint!
    @IBOutlet weak var mealCollvBgV: UIView!
    
    @IBOutlet weak var DietCollv: UICollectionView!
    @IBOutlet weak var DietCollvH: NSLayoutConstraint!
    @IBOutlet weak var DietCollvBgV: UIView!
    
    @IBOutlet weak var CookTimeCollv: UICollectionView!
    @IBOutlet weak var CookTimeCollvH: NSLayoutConstraint!
    @IBOutlet weak var CookTimeCollvBgV: UIView!
    
    @IBOutlet weak var CuisinesCollv: UICollectionView!
    @IBOutlet weak var CuisinesCollvH: NSLayoutConstraint!
    @IBOutlet weak var CuisinesCollvBgV: UIView!
    
    @IBOutlet weak var NutritionCollv: UICollectionView!
    @IBOutlet weak var NutritionCollvH: NSLayoutConstraint!
    @IBOutlet weak var NutritionCollvBgV: UIView!
    
    @IBOutlet weak var ApplyBtnO: UIButton!
    
    
    var MealArray = [FilterModuel]()
    var MealArray0 = [FilterModuel]()
    var MealArray1 = [FilterModuel]()
    
    var DietArray = [FilterModuel]()
    var DietArray0 = [FilterModuel]()
    var DietArray1 = [FilterModuel]()
  
    var CookTimeArray = [FilterModuel]()
    var CookTimeArray0 = [FilterModuel]()
    var CookTimeArray1 = [FilterModuel]()
    
    var CuisinesArray = [FilterModuel]()
    var CuisinesArray0 = [FilterModuel]()
    var CuisinesArray1 = [FilterModuel]()
    
    var NutritionArray = [FilterModuel]()
    var NutritionArray0 = [FilterModuel]()
    var NutritionArray1 = [FilterModuel]()
    
    var FilterDataList = FilterModel() // for api
    
    
    var oneLineHeight: CGFloat {
        return 54.0
    }
    
    var longTagIndex: Int {
        return 1
    }
     
      
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.ApplyBtnO.backgroundColor = UIColor.lightGray
        self.ApplyBtnO.isUserInteractionEnabled = false

        mealCollv.register(UINib(nibName: "TagCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TagCollectionViewCell")
        mealCollv.delegate = self
        mealCollv.dataSource = self
        
        
        DietCollv.register(UINib(nibName: "TagCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TagCollectionViewCell")
        DietCollv.delegate = self
        DietCollv.dataSource = self
        
        
        CookTimeCollv.register(UINib(nibName: "TagCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TagCollectionViewCell")
        CookTimeCollv.delegate = self
        CookTimeCollv.dataSource = self
        
        CuisinesCollv.register(UINib(nibName: "TagCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TagCollectionViewCell")
        CuisinesCollv.delegate = self
        CuisinesCollv.dataSource = self
        
        NutritionCollv.register(UINib(nibName: "TagCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TagCollectionViewCell")
        NutritionCollv.delegate = self
        NutritionCollv.dataSource = self
         
        
        self.Api_To_Get_FilterData()
        
        DispatchQueue.main.async {
            let tagCellLayout = TagCellLayout(alignment: .left, delegate: self)
            self.mealCollv?.collectionViewLayout = tagCellLayout
            DispatchQueue.main.async {
                let tagCellLayout1 = TagCellLayout(alignment: .left, delegate: self)
                self.DietCollv?.collectionViewLayout = tagCellLayout1
                DispatchQueue.main.async {
                    let tagCellLayout2 = TagCellLayout(alignment: .left, delegate: self)
                    self.CookTimeCollv?.collectionViewLayout = tagCellLayout2
                    DispatchQueue.main.async {
                        let tagCellLayout2 = TagCellLayout(alignment: .left, delegate: self)
                        self.CuisinesCollv?.collectionViewLayout = tagCellLayout2
                        DispatchQueue.main.async {
                            let tagCellLayout2 = TagCellLayout(alignment: .left, delegate: self)
                            self.NutritionCollv?.collectionViewLayout = tagCellLayout2
                        }
                    }
                }
            }
        }
         
        // Adjust initial heights
            adjustAllCollectionViewHeights()
        //
         
        self.SearchTxt.addTarget(self, action: #selector(TextSearch(sender: )), for: .editingChanged)
    }
    
    //
    @objc func TextSearch(sender: UITextField) {
        guard let searchText = sender.text, !searchText.isEmpty else {
            // If the text field is empty, reset the arrays to their original values
            if MealArray0.contains(where: { $0.name == "More" }) {
                print("MealArray contains 'More'")
                MealArray = MealArray0
            } else {
                MealArray = MealArray1
            }
            
            if DietArray0.contains(where: { $0.name == "More" }) {
                print("MealArray contains 'More'")
                DietArray = DietArray0
            } else {
                DietArray = DietArray1
            }
            
            if CookTimeArray0.contains(where: { $0.name == "More" }) {
                print("MealArray contains 'More'")
                CookTimeArray = CookTimeArray0
            } else {
                CookTimeArray = CookTimeArray1
            }
            
            if CuisinesArray0.contains(where: { $0.name == "More" }) {
                print("MealArray contains 'More'")
                CuisinesArray = CuisinesArray0
            } else {
                CuisinesArray = CuisinesArray1
            }
            
            if NutritionArray0.contains(where: { $0.name == "More" }) {
                print("MealArray contains 'More'")
                NutritionArray = NutritionArray0
            } else {
                NutritionArray = NutritionArray1
            }
  
            Show_or_Hide_FilterView()
            return
        }
        
        // For search with name only.
        MealArray = MealArray1.filter { (item) -> Bool in
            let value: FilterModuel = item as FilterModuel
            return value.name.range(of: searchText, options: .caseInsensitive) != nil
        }
        
        DietArray = DietArray1.filter { (item) -> Bool in
            let value: FilterModuel = item as FilterModuel
            return value.name.range(of: searchText, options: .caseInsensitive) != nil
        }
        
        CookTimeArray = CookTimeArray1.filter { (item) -> Bool in
            let value: FilterModuel = item as FilterModuel
            return value.name.range(of: searchText, options: .caseInsensitive) != nil
        }
        
        CuisinesArray = CuisinesArray1.filter { (item) -> Bool in
            let value: FilterModuel = item as FilterModuel
            return value.name.range(of: searchText, options: .caseInsensitive) != nil
        }
        
        NutritionArray = NutritionArray1.filter { (item) -> Bool in
            let value: FilterModuel = item as FilterModuel
            return value.name.range(of: searchText, options: .caseInsensitive) != nil
        }
        
        Show_or_Hide_FilterView()
    }
    
    func Show_or_Hide_FilterView(){
        if MealArray.count > 0 {
            mealCollvBgV.isHidden = false
        }else{
            mealCollvBgV.isHidden = true
        }
        
        if DietArray.count > 0 {
            DietCollvBgV.isHidden = false
        }else{
            DietCollvBgV.isHidden = true
        }
        
        if CookTimeArray.count > 0 {
            CookTimeCollvBgV.isHidden = false
        }else{
            CookTimeCollvBgV.isHidden = true
        }
        
        if CuisinesArray.count > 0 {
            CuisinesCollvBgV.isHidden = false
        }else{
            CuisinesCollvBgV.isHidden = true
        }
        
        if NutritionArray.count > 0 {
            NutritionCollvBgV.isHidden = false
        }else{
            NutritionCollvBgV.isHidden = true
        }
        
        self.reloadAllCollectionViews()
    }
   
     
    @IBAction func BackBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func ApplyBtn(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Tabbar", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "DinnerVc") as! DinnerVc
        vc.MealArray = self.MealArray
        vc.DietArray = self.DietArray
        vc.CookTimeArray = self.CookTimeArray
        vc.CuisinesArray = self.CuisinesArray
        vc.NutritionArray = self.NutritionArray
        vc.comesfrom = "Filter"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}


extension FilterVC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == mealCollv{
            return MealArray.count
        }else if collectionView == DietCollv{
            return DietArray.count
        }else if collectionView == CookTimeCollv{
            return CookTimeArray.count
        }else if collectionView == CuisinesCollv{
            return CuisinesArray.count
        }else{
            return NutritionArray.count
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == mealCollv{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagCollectionViewCell", for: indexPath) as! TagCollectionViewCell
            cell.tagView?.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            cell.tagView?.textColor = #colorLiteral(red: 0.2352941176, green: 0.2705882353, blue: 0.2549019608, alpha: 1)
            
            cell.tagView?.text = MealArray[indexPath.row].name
            
            if MealArray[indexPath.row].Selcolor == true{
                cell.tagView?.borderColor = #colorLiteral(red: 0.9960784314, green: 0.6235294118, blue: 0.2705882353, alpha: 1)
            }else{
                cell.tagView?.borderColor = #colorLiteral(red: 0.8977110982, green: 0.8977110982, blue: 0.8977110982, alpha: 1)
            }
            
            cell.tagView?.sizeToFit()
            
            if MealArray[indexPath.row].name == "More"{
                cell.tagView?.borderColor = UIColor.clear
                cell.tagView?.backgroundColor = UIColor.clear
                cell.tagView?.textColor = #colorLiteral(red: 0.02352941176, green: 0.7568627451, blue: 0.4117647059, alpha: 1)
            }
        
            return cell
        }else if collectionView == DietCollv{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagCollectionViewCell", for: indexPath) as! TagCollectionViewCell
            
            cell.tagView?.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            
            cell.tagView?.textColor = #colorLiteral(red: 0.2352941176, green: 0.2705882353, blue: 0.2549019608, alpha: 1)
            
            cell.tagView?.text = DietArray[indexPath.row].name
            
            if DietArray[indexPath.row].Selcolor == true{
                cell.tagView?.borderColor = #colorLiteral(red: 0.9960784314, green: 0.6235294118, blue: 0.2705882353, alpha: 1)
            }else{
                cell.tagView?.borderColor = #colorLiteral(red: 0.8977110982, green: 0.8977110982, blue: 0.8977110982, alpha: 1)
            }
            
            cell.tagView?.sizeToFit()
            
            if DietArray[indexPath.row].name == "More"{
                cell.tagView?.borderColor = UIColor.clear
                cell.tagView?.backgroundColor = UIColor.clear
                cell.tagView?.textColor = #colorLiteral(red: 0.02352941176, green: 0.7568627451, blue: 0.4117647059, alpha: 1)
            }
       
            return cell
        }else if collectionView == CookTimeCollv{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagCollectionViewCell", for: indexPath) as! TagCollectionViewCell
            cell.tagView?.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            cell.tagView?.textColor = #colorLiteral(red: 0.2352941176, green: 0.2705882353, blue: 0.2549019608, alpha: 1)
            
            cell.tagView?.text = CookTimeArray[indexPath.row].name
            if CookTimeArray[indexPath.row].Selcolor == true{
                cell.tagView?.borderColor = #colorLiteral(red: 0.9960784314, green: 0.6235294118, blue: 0.2705882353, alpha: 1)
            }else{
                cell.tagView?.borderColor = #colorLiteral(red: 0.8977110982, green: 0.8977110982, blue: 0.8977110982, alpha: 1)
            }
            cell.tagView?.sizeToFit()
            
            if CookTimeArray[indexPath.row].name == "More"{
                cell.tagView?.borderColor = UIColor.clear
                cell.tagView?.backgroundColor = UIColor.clear
                cell.tagView?.textColor = #colorLiteral(red: 0.02352941176, green: 0.7568627451, blue: 0.4117647059, alpha: 1)
            }
  
            return cell
        }else if collectionView == CuisinesCollv{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagCollectionViewCell", for: indexPath) as! TagCollectionViewCell
            cell.tagView?.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            cell.tagView?.textColor = #colorLiteral(red: 0.2352941176, green: 0.2705882353, blue: 0.2549019608, alpha: 1)
            
            cell.tagView?.text = CuisinesArray[indexPath.row].name
            if CuisinesArray[indexPath.row].Selcolor == true{
                cell.tagView?.borderColor = #colorLiteral(red: 0.9960784314, green: 0.6235294118, blue: 0.2705882353, alpha: 1)
            }else{
                cell.tagView?.borderColor = #colorLiteral(red: 0.8977110982, green: 0.8977110982, blue: 0.8977110982, alpha: 1)
            }
            cell.tagView?.sizeToFit()
            
            if CuisinesArray[indexPath.row].name == "More"{
                cell.tagView?.borderColor = UIColor.clear
                cell.tagView?.backgroundColor = UIColor.clear
                cell.tagView?.textColor = #colorLiteral(red: 0.02352941176, green: 0.7568627451, blue: 0.4117647059, alpha: 1)
            }
  
            return cell
        }else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagCollectionViewCell", for: indexPath) as! TagCollectionViewCell
            cell.tagView?.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            cell.tagView?.textColor = #colorLiteral(red: 0.2352941176, green: 0.2705882353, blue: 0.2549019608, alpha: 1)
            
            cell.tagView?.text = NutritionArray[indexPath.row].name
            if NutritionArray[indexPath.row].Selcolor == true{
                cell.tagView?.borderColor = #colorLiteral(red: 0.9960784314, green: 0.6235294118, blue: 0.2705882353, alpha: 1)
            }else{
                cell.tagView?.borderColor = #colorLiteral(red: 0.8977110982, green: 0.8977110982, blue: 0.8977110982, alpha: 1)
            }
            cell.tagView?.sizeToFit()
            
            if NutritionArray[indexPath.row].name == "More"{
                cell.tagView?.borderColor = UIColor.clear
                cell.tagView?.backgroundColor = UIColor.clear
                cell.tagView?.textColor = #colorLiteral(red: 0.02352941176, green: 0.7568627451, blue: 0.4117647059, alpha: 1)
            }
  
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == mealCollv{
             
            if MealArray[indexPath.row].Selcolor == true{
                MealArray[indexPath.row].Selcolor = false
                MealArray1[indexPath.row].Selcolor = false
                self.MealArray0[indexPath.row].Selcolor = false
                self.mealCollv.reloadData()
            }else{
                MealArray[indexPath.row].Selcolor = true
                MealArray1[indexPath.row].Selcolor = true
                self.MealArray0[indexPath.row].Selcolor = true
                self.mealCollv.reloadData()
            }
             
             
            if MealArray[indexPath.row].name == "More"{
                MealArray1[indexPath.row].Selcolor = false
                self.MealArray.removeAll()
                MealArray = MealArray1
                self.MealArray0.remove(at: indexPath.item)
                self.reloadAllCollectionViews()
            }
            
        }else if collectionView == DietCollv{
             
            if DietArray[indexPath.row].Selcolor == true{
                DietArray[indexPath.row].Selcolor = false
                DietArray1[indexPath.row].Selcolor = false
                DietArray0[indexPath.row].Selcolor = false
                self.DietCollv.reloadData()
            }else{
                DietArray[indexPath.row].Selcolor = true
                DietArray1[indexPath.row].Selcolor = true
                DietArray0[indexPath.row].Selcolor = true
                self.DietCollv.reloadData()
            }
            
            if DietArray[indexPath.row].name == "More"{
                DietArray1[indexPath.row].Selcolor = false
                self.DietArray.removeAll()
                self.DietArray = self.DietArray1
                self.DietArray0.remove(at: indexPath.item)
                self.reloadAllCollectionViews()
            }
            
        }else if collectionView == CookTimeCollv{
             
             if CookTimeArray[indexPath.row].Selcolor == true {
                 CookTimeArray[indexPath.row].Selcolor = false
                 CookTimeArray1[indexPath.row].Selcolor = false
                 CookTimeArray0[indexPath.row].Selcolor = false
                 self.CookTimeCollv.reloadData()
             }else{
                 CookTimeArray[indexPath.row].Selcolor = true
                 CookTimeArray1[indexPath.row].Selcolor = true
                 CookTimeArray0[indexPath.row].Selcolor = true
                 self.CookTimeCollv.reloadData()
             }
             
             if CookTimeArray[indexPath.row].name == "More"{
                 CookTimeArray1[indexPath.row].Selcolor = false
                 self.CookTimeArray.removeAll()
                 self.CookTimeArray = self.CookTimeArray1
                 self.CookTimeArray0.remove(at: indexPath.item)
                 self.reloadAllCollectionViews()
             }
        }else if collectionView == CuisinesCollv {
             
            if CuisinesArray[indexPath.row].Selcolor == true {
                CuisinesArray[indexPath.row].Selcolor = false
                CuisinesArray1[indexPath.row].Selcolor = false
                CuisinesArray0[indexPath.row].Selcolor = false
                self.CuisinesCollv.reloadData()
             }else{
                 CuisinesArray[indexPath.row].Selcolor = true
                 CuisinesArray1[indexPath.row].Selcolor = true
                 CuisinesArray0[indexPath.row].Selcolor = true
                 self.CuisinesCollv.reloadData()
             }
             
            if CuisinesArray[indexPath.row].name == "More"{
                CuisinesArray1[indexPath.row].Selcolor = false
                self.CuisinesArray.removeAll()
                self.CuisinesArray = self.CuisinesArray1
                self.CuisinesArray0.remove(at: indexPath.item)
                 self.reloadAllCollectionViews()
             }
        }else {
            
            if NutritionArray[indexPath.row].Selcolor == true {
                NutritionArray[indexPath.row].Selcolor = false
                NutritionArray1[indexPath.row].Selcolor = false
                NutritionArray0[indexPath.row].Selcolor = false
                self.NutritionCollv.reloadData()
            }else{
                NutritionArray[indexPath.row].Selcolor = true
                NutritionArray1[indexPath.row].Selcolor = true
                NutritionArray0[indexPath.row].Selcolor = true
                self.NutritionCollv.reloadData()
            }
            
            if NutritionArray[indexPath.row].name == "More"{
                NutritionArray1[indexPath.row].Selcolor = false
                self.NutritionArray.removeAll()
                self.NutritionArray = self.NutritionArray1
                self.NutritionArray0.remove(at: indexPath.item)
                self.reloadAllCollectionViews()
            }
       }
        
        
        let selectedMealCount = MealArray.filter { $0.Selcolor == true }.count
        let selectedDietCount = DietArray.filter { $0.Selcolor == true }.count
        let selectedCookTimeCount = CookTimeArray.filter { $0.Selcolor == true }.count
        let selectedCuisinesCount = CuisinesArray.filter { $0.Selcolor == true }.count
        let selectedNutritionCount = NutritionArray.filter { $0.Selcolor == true }.count
        
        let finalCount = selectedMealCount + selectedDietCount + selectedCookTimeCount + selectedCuisinesCount + selectedNutritionCount
        
        self.ApplyBtnO.setTitle("Apply (\(finalCount))", for: .normal)
        
        if finalCount > 0{
            self.ApplyBtnO.backgroundColor = #colorLiteral(red: 0.02352941176, green: 0.7568627451, blue: 0.4117647059, alpha: 1)
            self.ApplyBtnO.isUserInteractionEnabled = true
        }else{
            self.ApplyBtnO.backgroundColor = UIColor.lightGray
            self.ApplyBtnO.isUserInteractionEnabled = false
        }
    }
    
    func adjustAllCollectionViewHeights() {
        adjustCollectionViewHeight(collectionView: mealCollv, heightConstraint: mealCollvH)
        adjustCollectionViewHeight(collectionView: DietCollv, heightConstraint: DietCollvH)
        adjustCollectionViewHeight(collectionView: CookTimeCollv, heightConstraint: CookTimeCollvH)
        adjustCollectionViewHeight(collectionView: CuisinesCollv, heightConstraint: CuisinesCollvH)
        adjustCollectionViewHeight(collectionView: NutritionCollv, heightConstraint: NutritionCollvH)
    }

        func adjustCollectionViewHeight(collectionView: UICollectionView, heightConstraint: NSLayoutConstraint) {
            collectionView.layoutIfNeeded()
            let contentHeight = collectionView.collectionViewLayout.collectionViewContentSize.height
            heightConstraint.constant = contentHeight
            self.view.layoutIfNeeded()
        }

        func reloadAllCollectionViews() {
            mealCollv.reloadData()
            DietCollv.reloadData()
            CookTimeCollv.reloadData()
            CuisinesCollv.reloadData()
            NutritionCollv.reloadData()
            DispatchQueue.main.async {
                self.adjustAllCollectionViewHeights()
            }
        }
}


extension FilterVC: TagCellLayoutDelegate {
    func tagCellLayoutTagSize(layout: TagCellLayout, atIndex index: Int) -> CGSize {
            let text: String

            // Determine the data array based on the layout's collection view
        if layout.collectionView == mealCollv {
            text = MealArray[index].name
        } else if layout.collectionView == DietCollv {
            text = DietArray[index].name
        }else if layout.collectionView == CookTimeCollv {
            text = CookTimeArray[index].name
        }else if layout.collectionView == CuisinesCollv {
            text = CuisinesArray[index].name
        }else {
            text = NutritionArray[index].name
        }

            // Calculate size dynamically
            let customFont = UIFont(name: "Poppins Regular", size: 13) as Any
            let textAttributes = [NSAttributedString.Key.font: customFont]
            let size = (text as NSString).boundingRect(
                with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude),
                options: .usesLineFragmentOrigin,
                attributes: textAttributes,
                context: nil
            ).size

            let padding: CGFloat = 18
            return CGSize(width: size.width + padding + 20, height: 50)//size.height + 10)
        }
    }



extension FilterVC{
    func Api_To_Get_FilterData(){
      //  var params = [String: Any]()
       
       // params["q"] = ""
       
    
        showIndicator(withTitle: "", and: "")
        
        let loginURL = baseURL.baseURL + appEndPoints.for_filter_search
    
        print(loginURL,"loginURL")
        
        WebService.shared.postServiceURLEncoding(loginURL, VC: self, andParameter: [:], withCompletion: { (json, statusCode) in
            
            self.hideIndicator()
            
            let data = try! json.rawData()
            
            do{
                let d = try JSONDecoder().decode(FilterModelClass.self, from: data)
                if d.success == true {
                    let list = d.data
                    self.FilterDataList = list ?? FilterModel()
                    
                    self.MealArray1.removeAll()
                    for itm in self.FilterDataList.mealType ?? []{
                        let id = "\(itm.id ?? 0)"
                        self.MealArray1.append(FilterModuel(name: itm.name ?? "", id: id, Selcolor: false, value: ""))
                        }
                        
                    for itm in self.FilterDataList.mealType ?? []{
                        let id = "\(itm.id ?? 0)"
                        if self.MealArray.count == 5{
                            self.MealArray.append(FilterModuel(name: "More", id: "", Selcolor: false, value: ""))
                        }else{
                            if self.MealArray.count < 5{
                                self.MealArray.append(FilterModuel(name: itm.name ?? "", id: id, Selcolor: false, value: ""))
                            }
                        }
                    }
                    
                    self.DietArray1.removeAll()
                    for itm in self.FilterDataList.diet ?? []{
                        self.DietArray1.append(FilterModuel(name: itm.name ?? "", id: "", Selcolor: false, value: itm.value ?? ""))
                      }
                    
                    for itm in self.FilterDataList.diet ?? []{
                        if self.DietArray.count == 5{
                            self.DietArray.append(FilterModuel(name: "More", id: "", Selcolor: false, value: ""))
                        }else{
                            if self.DietArray.count < 5{
                                self.DietArray.append(FilterModuel(name: itm.name ?? "", id: "", Selcolor: false, value: itm.value ?? ""))
                            }
                        }
                    }
                    
                    self.CookTimeArray1.removeAll()
                    for itm in self.FilterDataList.cookTime ?? []{
                        self.CookTimeArray1.append(FilterModuel(name: itm.name ?? "", id: "", Selcolor: false, value: itm.value ?? ""))
                      }
                    
                    for itm in self.FilterDataList.cookTime ?? []{
                        if self.CookTimeArray.count == 5{
                            self.CookTimeArray.append(FilterModuel(name: "More", id: "", Selcolor: false, value: ""))
                        }else{
                            if self.CookTimeArray.count < 5{
                                self.CookTimeArray.append(FilterModuel(name: itm.name ?? "", id: "", Selcolor: false, value: itm.value ?? ""))
                            }
                        }
                    }
                    
                    self.CuisinesArray1.removeAll()
                    for itm in self.FilterDataList.dishType ?? []{
                        self.CuisinesArray1.append(FilterModuel(name: itm.name ?? "", id: "", Selcolor: false, value: itm.name ?? ""))
                      }
                    
                    for itm in self.FilterDataList.dishType ?? []{
                        if self.CuisinesArray.count == 5{
                            self.CuisinesArray.append(FilterModuel(name: "More", id: "", Selcolor: false, value: ""))
                        }else{
                            if self.CuisinesArray.count < 5{
                                self.CuisinesArray.append(FilterModuel(name: itm.name ?? "", id: "", Selcolor: false, value: itm.name ?? ""))
                            }
                        }
                    }
                    
                    self.NutritionArray1.removeAll()
                    for itm in self.FilterDataList.protein ?? []{
                        self.NutritionArray1.append(FilterModuel(name: itm.name ?? "", id: "", Selcolor: false, value: itm.name ?? ""))
                      }
                    
                    for itm in self.FilterDataList.protein ?? []{
                        if self.NutritionArray.count == 5{
                            self.NutritionArray.append(FilterModuel(name: "More", id: "", Selcolor: false, value: ""))
                        }else{
                            if self.NutritionArray.count < 5{
                                self.NutritionArray.append(FilterModuel(name: itm.name ?? "", id: "", Selcolor: false, value: itm.name ?? ""))
                            }
                        }
                    }
                    
                    self.MealArray0 = self.MealArray
                    self.DietArray0 = self.DietArray
                    self.CookTimeArray0 = self.CookTimeArray
                    self.CuisinesArray0 = self.CuisinesArray
                    self.NutritionArray0 = self.NutritionArray
                       
                    self.Show_or_Hide_FilterView()
 
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
