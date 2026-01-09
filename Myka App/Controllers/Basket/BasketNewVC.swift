//
//  BasketVC 2.swift
//  My Kai
//
//  Created by YATIN  KALRA on 09/09/25.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation
import DropDown
import Alamofire
import SDWebImage
import CustomBlurEffectView
import SwiftyJSON
 

class BasketNewVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var yourRecipeCollV: UICollectionView!
    @IBOutlet weak var yourRecipeCollVH: NSLayoutConstraint!
    @IBOutlet weak var IngredientsTblV: UITableView!
     @IBOutlet weak var IngredientsTblVH: NSLayoutConstraint!
    
    
 
    @IBOutlet var AddressPopupView: UIView!
    @IBOutlet weak var AddressBgV: UIView!
    @IBOutlet weak var AddressTblV: UITableView!
    
    @IBOutlet weak var AddressTblVH: NSLayoutConstraint!
    @IBOutlet weak var SearchAddTxtF: UITextField!
    @IBOutlet weak var SethomeBtnO: UIButton!
    @IBOutlet weak var SetWorkBtnO: UIButton!
    @IBOutlet weak var SetHomeBgV: UIView!
    @IBOutlet weak var SetWorkBgV: UIView!
    @IBOutlet weak var SearchBgV: UIView!
    @IBOutlet weak var HomeIMg: UIImageView!
    @IBOutlet weak var WorkImg: UIImageView!
    
    @IBOutlet weak var YourRecipeBgV: UIView!
    @IBOutlet weak var IngredientBgV: UIView!
    @IBOutlet weak var checkoutInstacartBtnO: UIButton!
  
    @IBOutlet var DisabledView: UIView!
  
    var mapView = GMSMapView()
    var gmsAddress: GMSAddress?
    var zoomCamera : GMSCameraPosition?
    let marker = GMSMarker()
    var locationManager = CLLocationManager()
    let geoCoder = CLGeocoder()
    private var placesClient: GMSPlacesClient!
    private var searchResults: [GMSAutocompletePrediction] = []
    var dropDown = DropDown()
    
    var StreetName = ""
    var StreetNo = ""
    var ApartmentNo = ""
    var City = ""
    var State = ""
    var Address = ""
    var PostCode = ""
    var country = ""
    var AddressType = ""
    var SavedAddTag = 0
    var addressID = ""
    
    var SuperMarketArr = [MarketModel]()
    var SavedAddressList = [AddressdataModel]()

    
    var BasketListArr = basketNewModelData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GMSPlacesClient.provideAPIKey("AIzaSyA7f3YXlTD-foNwy7phnJJHCsYDiWgURkQ") // Ensure API Key is provided
        placesClient = GMSPlacesClient.shared() // ✅ Initialize it here
        
//        self.SetYourShoppingPrefBgV.frame = self.view.bounds
//        self.view.addSubview(self.SetYourShoppingPrefBgV)
//        self.SetYourShoppingPrefBgV.isHidden = true
//        
        
        self.AddressPopupView.frame = self.view.bounds
        self.view.addSubview(self.AddressPopupView)
        self.AddressPopupView.isHidden = true
        
        self.yourRecipeCollVH.constant = 0
        
        self.SetHomeBgV.borderColor = #colorLiteral(red: 0.02352941176, green: 0.7568627451, blue: 0.4117647059, alpha: 1)
        self.SetWorkBgV.borderColor = #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9529411765, alpha: 1)
        self.SethomeBtnO.isSelected = false
        self.SetWorkBtnO.isSelected = false
        self.HomeIMg.image = UIImage(named: "HomeIcon")
        self.WorkImg.tintColor = #colorLiteral(red: 0.5882352941, green: 0.6666666667, blue: 0.631372549, alpha: 1)
       // self.checkoutInstacartBtnO.isUserInteractionEnabled = false
        self.checkoutInstacartBtnO.isUserInteractionEnabled = true
        self.checkoutInstacartBtnO.backgroundColor = UIColor(red: 0.0235, green: 0.7569, blue: 0.4118, alpha: 1.0)
//        let SubscriptionStatus = Int(UserDetail.shared.getSubscriptionStatus())
//        
//        if SubscriptionStatus == 1{
//            self.AddressPopupView.isHidden = true
//        }else{
//            self.AddressPopupView.isHidden = false
//        }
        
        //DisabledView
        let topSpace: CGFloat = 100
        self.DisabledView.frame = CGRect(x: 0, y: topSpace, width: self.view.bounds.width, height: self.view.bounds.height - topSpace)
        self.view.addSubview(DisabledView)
        self.DisabledView.isHidden = true
        
        let customBlurEffectView = CustomBlurEffectView()
        customBlurEffectView.frame = CGRect(x: 0, y: 0, width: DisabledView.frame.width + 20, height: DisabledView.frame.height)//BlurView.frame
        customBlurEffectView.blurRadius = 1.5
        customBlurEffectView.colorTint = .white
        customBlurEffectView.colorTintAlpha = 0.3
        customBlurEffectView.cornerRadius = 0
        customBlurEffectView.layer.masksToBounds = true
        DisabledView.addSubview(customBlurEffectView)
        DisabledView.sendSubviewToBack(customBlurEffectView)
         
        self.SetHomeBgV.borderColor = #colorLiteral(red: 0.02352941176, green: 0.7568627451, blue: 0.4117647059, alpha: 1)
        self.SetWorkBgV.borderColor = #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9529411765, alpha: 1)
        self.SethomeBtnO.isSelected = true
        self.SetWorkBtnO.isSelected = false
        self.HomeIMg.image = UIImage(named: "HomeIcon")
        self.WorkImg.tintColor = #colorLiteral(red: 0.5882352941, green: 0.6666666667, blue: 0.631372549, alpha: 1)
        
        setupCollectionView()
       
        self.IngredientsTblV.register(UINib(nibName: "IngridenttTblVCell", bundle: nil), forCellReuseIdentifier: "IngridenttTblVCell")
        self.IngredientsTblV.delegate = self
        self.IngredientsTblV.dataSource = self
          
        self.AddressTblV.register(UINib(nibName: "AddressTblVCell", bundle: nil), forCellReuseIdentifier: "AddressTblVCell")
        self.AddressTblV.delegate = self
        self.AddressTblV.dataSource = self
    
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        AddressBgV.addGestureRecognizer(tapGesture)
       
        SearchAddTxtF.delegate = self
        SearchAddTxtF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
 
        setupTableView(IngredientsTblV, tag: 1)
        setupTableView(AddressTblV, tag: 2)
        
        self.getBasketListData()
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
                IngredientsTblVH.constant = tableView.contentSize.height
            } else if tableView.tag == 2 {
                AddressTblVH.constant = tableView.contentSize.height
            }
        }
    }
    
    deinit {
        // Remove observers
        IngredientsTblV.removeObserver(self, forKeyPath: "contentSize")
        AddressTblV.removeObserver(self, forKeyPath: "contentSize")
    }
    
     
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
   
        let SubscriptionStatus = Int(UserDetail.shared.getSubscriptionStatus())
        
        if SubscriptionStatus == 1{//
            self.DisabledView.isHidden = false
            SubscriptionPopUp()
        }else{
            self.DisabledView.isHidden = true
        }
      
//        self.Api_To_get_SavedAddress()
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
            guard let query = textField.text, !query.isEmpty else {
                searchResults.removeAll()
                dropDown.hide()
                return
            }
        fetchAutocompleteResults(query: query)
        }
         
  
    
    private func fetchAutocompleteResults(query: String) {
  
        guard !query.isEmpty else {
            searchResults.removeAll()
            self.dropDown.hide()
              return
          }

        let filter = GMSAutocompleteFilter()
        filter.types = .none
        
        guard let client = placesClient else {
               print("Error: placesClient is nil")
               return
           }
        
        client.findAutocompletePredictions(fromQuery: query, filter: filter, sessionToken: nil) { (results, error) in
            
            if let error = error {
                print("Error fetching autocomplete: \(error.localizedDescription)")
                self.dropDown.hide()
                return
            }
            self.searchResults = results ?? []
            DispatchQueue.main.async {
                if self.searchResults.isEmpty{
                    self.dropDown.hide()
                }else{
                    self.dropDown.dataSource = self.searchResults.map { $0.attributedFullText.string }
                    self.dropDown.anchorView = self.SearchBgV
                    self.dropDown.bottomOffset = CGPoint(x: 0, y: self.SearchBgV.frame.size.height)
                    self.dropDown.width = self.SearchBgV.frame.width
                    self.dropDown.direction = .bottom
                    self.dropDown.show()
                    self.dropDown.setupCornerRadius(10)
                    self.dropDown.backgroundColor = .white
                    self.dropDown.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
                    self.dropDown.layer.shadowOpacity = 0
                    self.dropDown.layer.shadowRadius = 4
                    self.dropDown.layer.shadowOffset = CGSize(width: 0, height: 0)
                    self.dropDown.selectionAction = { [self] (index: Int, item: String) in
                        print(index)
                        let PlaceID = self.searchResults[index].placeID
                        let coord = self.searchResults[index]
                        SavedAddTag = 1
                        getPlaceDetails(placeID: PlaceID)
                    }
                 
                    self.dropDown.show()
                }
            }
        }
    }
    
    private func getPlaceDetails(placeID: String) {

        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt64(UInt(GMSPlaceField.name.rawValue) | UInt(GMSPlaceField.placeID.rawValue) | UInt(GMSPlaceField.coordinate.rawValue) | UInt(GMSPlaceField.formattedAddress.rawValue) | UInt(GMSPlaceField.addressComponents.rawValue)))
        
          
        placesClient?.fetchPlace(fromPlaceID: placeID, placeFields: fields, sessionToken: nil, callback: {
          (place: GMSPlace?, error: Error?) in
          
    //    placesClient.fetchPlace(with: request) { (place, error) in
            if let error = error {
                print("Error fetching place details: \(error.localizedDescription)")
                return
            }
            if let place = place {
                if let address = place.formattedAddress {
                    self.SearchAddTxtF.text = address
                    print("Selected Address: \(address)")
                    
                    UserDetail.shared.setLocationStatus("yes")
                    AppLocation.lat = "\(place.coordinate.latitude)"
                    AppLocation.long = "\(place.coordinate.longitude)"
                    
                    self.reverseGeocodeCoordinate(place.coordinate, placeName: "")
                    

                    
                } else {
                    print("No address found for this place.")
                }
            }
        })
    }
    
    func getAddressComponent(for type: String, from components: [GMSAddressComponent]) -> String? {
        return components.first(where: { $0.types.contains(type) })?.name
    }
 
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        print("View was tapped!")
        AddressPopupView.isHidden = true
    }
    
    private func setupCollectionView() {
       
      
        yourRecipeCollV.delegate = self
        yourRecipeCollV.dataSource = self
        yourRecipeCollV.register(UINib(nibName: "YouRecipeCollVCell", bundle: nil), forCellWithReuseIdentifier: "YouRecipeCollVCell")
    }
 
 
    @IBAction func DisabledViewBtn(_ sender: UIButton) {
        SubscriptionPopUp()
    }
    
    
    func SubscriptionPopUp()  {
        let storyboard = UIStoryboard(name: "Subscription", bundle: nil)
        
        let vc = storyboard.instantiateViewController(withIdentifier: "SubscriptionPopUpVC") as! SubscriptionPopUpVC
        vc.BackAction = {
            let storyboard = UIStoryboard(name: "Subscription", bundle: nil)
            
            let vc = storyboard.instantiateViewController(withIdentifier: "BupPlanVC") as! BupPlanVC
            vc.comesfrom = "Profile"
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        vc.BasketBackAction = {
            self.navigationController?.popToRootViewController(animated: true)
        }
        
        self.addChild(vc)
        vc.view.frame = self.view.frame
        self.view.addSubview(vc.view)
        self.view.bringSubviewToFront(vc.view)
        vc.didMove(toParent: self)
    }
    

    @IBAction func BackBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func ShoppingListBtn(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Basket", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "Shopping_ListVC") as! Shopping_ListVC
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func checkoutBtn(_ sender: UIButton) {
        self.Api_To_get_SavedAddress()
        
    }
    
    
    @IBAction func SetHomeBtn(_ sender: UIButton) {
        self.SetHomeBgV.borderColor = #colorLiteral(red: 0.02352941176, green: 0.7568627451, blue: 0.4117647059, alpha: 1)
        self.SetWorkBgV.borderColor = #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9529411765, alpha: 1)
        self.SethomeBtnO.isSelected = true
        self.SetWorkBtnO.isSelected = false
        self.AddressType = "Home"
        HomeIMg.image = UIImage(named: "HomeIcon")
        WorkImg.tintColor = #colorLiteral(red: 0.5882352941, green: 0.6666666667, blue: 0.631372549, alpha: 1)
    }
    
    @IBAction func SetWorkBtn(_ sender: UIButton) {
        self.SetWorkBgV.borderColor = #colorLiteral(red: 0.02352941176, green: 0.7568627451, blue: 0.4117647059, alpha: 1)
        self.SetHomeBgV.borderColor = #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9529411765, alpha: 1)
        self.SethomeBtnO.isSelected = false
        self.SetWorkBtnO.isSelected = true
        self.AddressType = "Work"
        WorkImg.tintColor = #colorLiteral(red: 0.9960784314, green: 0.6235294118, blue: 0.2705882353, alpha: 1)
        HomeIMg.image = UIImage(named: "Home1")
    }
    
    @IBAction func CurrentLocationBtnBtn(_ sender: UIButton) {
        SavedAddTag = 1
        self.getUserLocation()
    }
    
    
    @IBAction func AddressDone_Btn(_ sender: UIButton) {
        self.AddressPopupView.isHidden = true
        if SavedAddTag == 1{
            let storyboard = UIStoryboard(name: "Login", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "ConfirmYourAddressVC") as! ConfirmYourAddressVC
            vc.StreetName = self.StreetName
            vc.StreetNo = self.StreetNo
            vc.ApartmentNo = self.ApartmentNo
            vc.City = self.City
            vc.State = self.State
            vc.Address = self.Address
            vc.PostCode = self.PostCode
            vc.comesfrom = "Basket"
            vc.AddressType = self.AddressType
            vc.country = self.country
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            self.Api_To_make_PrimaryAddress()
        }
    }
    
    @IBAction func Yourrecipe_ViewAllBtn(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Basket", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "YourrecipeVC") as! YourrecipeVC
        vc.BackAction = {
            self.getBasketListData()
        }
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func Ingredients_ViewAllBtn(_ sender: UIButton) {

    }
    
}
 
extension BasketNewVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

            return BasketListArr.recipe?.count ?? 0

       }
       
       func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            

               let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "YouRecipeCollVCell", for: indexPath) as! YouRecipeCollVCell
               cell.Namelbl.text = BasketListArr.recipe?[indexPath.item].data?.recipe?.label ?? ""
               
               let img = BasketListArr.recipe?[indexPath.item].data?.recipe?.images?.small?.url ?? ""
               let imgUrl = URL(string: img)
               
               cell.Img.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
               cell.Img.sd_setImage(with: imgUrl, placeholderImage: UIImage(named: "No_Image"))
               
               cell.ServCountLbl.text = "Serves \(BasketListArr.recipe?[indexPath.item].serving ?? "0")"
               
               cell.MinusBtn.tag = indexPath.row
               cell.MinusBtn.addTarget(self, action: #selector(ServCountMinusBtn(_:)), for: .touchUpInside)
               
               cell.plusBtn.tag = indexPath.row
               cell.plusBtn.addTarget(self, action: #selector(ServCountPlusBtn(_:)), for: .touchUpInside)
               
               cell.RemoveBtn.tag = indexPath.item
               cell.RemoveBtn.addTarget(self, action: #selector(removeBtnClick(_:)), for: .touchUpInside)
               
               return cell

       }
    
    @objc func ServCountMinusBtn(_ sender: UIButton) {
        var ServCount = Int(BasketListArr.recipe?[sender.tag].serving ?? "1") ?? 1
        guard ServCount > 1 else{
            return
        }
         ServCount -= 1
        BasketListArr.recipe?[sender.tag].serving = "\(ServCount)"
        self.yourRecipeCollV.reloadData()
        
        let uri = BasketListArr.recipe?[sender.tag].uri ?? ""
        let typ = BasketListArr.recipe?[sender.tag].type ?? ""
        
        if let result = typ.components(separatedBy: "/").first {
            self.Api_To_Plus_Minus_ServesCount(uri: uri, Quenty: "\(ServCount)", type: result)
        }
    }
    
    @objc func ServCountPlusBtn(_ sender: UIButton) {
        var ServCount = Int(BasketListArr.recipe?[sender.tag].serving ?? "1") ?? 1
         ServCount += 1
        BasketListArr.recipe?[sender.tag].serving = "\(ServCount)"
        self.yourRecipeCollV.reloadData()
        
        let uri = BasketListArr.recipe?[sender.tag].uri ?? ""
        let typ = BasketListArr.recipe?[sender.tag].type ?? ""
        if let result = typ.components(separatedBy: "/").first {
            self.Api_To_Plus_Minus_ServesCount(uri: uri, Quenty: "\(ServCount)", type: typ)
        }
    }
    
    
    @objc func removeBtnClick(_ sender: UIButton)   {
        let storyboard = UIStoryboard(name: "Basket", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "RemoveFromBaskedPopUpVC") as! RemoveFromBaskedPopUpVC
        vc.ID = "\(BasketListArr.recipe?[sender.tag].id ?? 0)"
        vc.backAction = { id in
            self.Api_To_RemoveRecipes(Id: id, index: sender.tag)
        }
        self.addChild(vc)
        vc.view.frame = self.view.frame
        self.view.addSubview(vc.view)
        self.view.bringSubviewToFront(vc.view)
        vc.didMove(toParent: self)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

            for i in 0..<(BasketListArr.stores?.count ?? 0){
                BasketListArr.stores?[i].isSlected = 0
            }
            BasketListArr.stores?[indexPath.item].isSlected = 1

            
            let storNme = BasketListArr.stores?[indexPath.item].storeName ?? ""
            let StoreID = BasketListArr.stores?[indexPath.item].storeUUID ?? ""
            
            self.getBasketListDataByMarket(StoreID:StoreID, StoreName:storNme)

    }
 
       func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
               return CGSize(width: collectionView.frame.width/2.3 - 5, height: collectionView.frame.height)
       }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
     
            return 5
        }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            if section == 0 {
                return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
            }else{
                return UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
            }
        }
   
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 5
        }
     }


extension BasketNewVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == IngredientsTblV{
            return BasketListArr.ingredient?.count ?? 0
        }else{
            return self.SavedAddressList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == IngredientsTblV{
            let cell = tableView.dequeueReusableCell(withIdentifier: "IngridenttTblVCell", for: indexPath) as! IngridenttTblVCell
             

            
            let img = BasketListArr.ingredient?[indexPath.item].proImg ?? ""
            let imgUrl = URL(string: img)
            
         
            cell.NameLbl.text = self.BasketListArr.ingredient?[indexPath.row].name?.capitalizedFirst ?? ""
            cell.quantityLbl.text = "\(self.BasketListArr.ingredient?[indexPath.row].quantity ?? 0) \( self.BasketListArr.ingredient?[indexPath.row].measure ?? "")"

            cell.Img.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
            cell.Img.sd_setImage(with: imgUrl, placeholderImage: UIImage(named: "No_Image"))
            
            if self.BasketListArr.ingredient?[indexPath.row].isSelected == true{
                cell.checkBoxBtn.setImage(UIImage(named: "YellowCheck"), for: .normal)
            }else{
                cell.checkBoxBtn.setImage(UIImage(named: "YelloUncheck"), for: .normal)
            }

            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddressTblVCell", for: indexPath) as! AddressTblVCell
            
            cell.AddTypeLbl.text = self.SavedAddressList[indexPath.row].type
            
            let apartNo = self.SavedAddressList[indexPath.row].apartNum ?? ""
            let streetNo = self.SavedAddressList[indexPath.row].streetNum ?? ""
            let streetName = self.SavedAddressList[indexPath.row].streetName ?? ""
            let city = self.SavedAddressList[indexPath.row].city ?? ""
            let state = self.SavedAddressList[indexPath.row].state ?? ""
            let country = self.SavedAddressList[indexPath.row].country ?? ""
            let zipcode = self.SavedAddressList[indexPath.row].zipcode ?? ""
  
            if apartNo != ""{
                cell.Addresslbl.text =  "\(apartNo), \(streetNo) \(streetName), \(city), \(state), \(country), \(zipcode)"
            }else{
                cell.Addresslbl.text =  "\(streetNo) \(streetName), \(city), \(state), \(country), \(zipcode)"
            }
            
            if self.SavedAddressList[indexPath.row].primary == 1{
                cell.BgV.borderColor = #colorLiteral(red: 0.02352941176, green: 0.7568627451, blue: 0.4117647059, alpha: 1)
            }else{
                cell.BgV.borderColor = #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9529411765, alpha: 1)
            }
            
            if self.SavedAddressList[indexPath.row].type == "Work"{
                cell.ImgV.image = UIImage(named: "work")
                cell.ImgV.tintColor = #colorLiteral(red: 0.9960784314, green: 0.6235294118, blue: 0.2705882353, alpha: 1)
            }else{
                cell.ImgV.image = UIImage(named: "HomeIcon")
            }
            
            cell.EditBtn.tag = indexPath.row
            cell.EditBtn.addTarget(self, action: #selector(EditAddressBtnTapped(sender:)), for: .touchUpInside)
           
            return cell
        }
    }
    
    @objc func checkMarkBtn(_ sender: UIButton){
       
    }
    
    
    
    // MARK: - Leading Swipe Actions (Left to Right)
 
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { _, _, completionHandler in
        self.BasketListArr.ingredient?.remove(at: indexPath.row)
            

            tableView.performBatchUpdates({
                tableView.deleteRows(at: [indexPath], with: .fade)
            }) { completed in
                // Step 3: Call the completion handler
                completionHandler(true)
            }
        }
       
        deleteAction.image = UIImage(named: "DeleteIcon 1") // Replace with actual image name
        deleteAction.backgroundColor = .white
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    

    
    @objc func EditAddressBtnTapped(sender: UIButton){
        let index = sender.tag
        let apartNo = self.SavedAddressList[index].apartNum ?? ""
        let streetNo = self.SavedAddressList[index].streetNum ?? ""
        let streetName = self.SavedAddressList[index].streetName ?? ""
        let city = self.SavedAddressList[index].city ?? ""
        let state = self.SavedAddressList[index].state ?? ""
        let country = self.SavedAddressList[index].country ?? ""
        let zipcode = self.SavedAddressList[index].zipcode ?? ""
        let lati = self.SavedAddressList[index].latitude ?? ""
        let longi = self.SavedAddressList[index].longitude ?? ""
         
        let FullAdd =  "\(apartNo) \(streetNo) \(streetName), \(city), \(state), \(country), \(zipcode)"
        
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AddressOnMapVC") as! AddressOnMapVC
        vc.StreetName = self.SavedAddressList[index].streetName ?? ""
        vc.StreetNo = self.SavedAddressList[index].streetNum ?? ""
        vc.ApartmentNo = self.SavedAddressList[index].apartNum ?? ""
        vc.City = self.SavedAddressList[index].city ?? ""
        vc.State = self.SavedAddressList[index].state ?? ""
        vc.Address = FullAdd
        vc.OldAddress = FullAdd
        vc.tag = 1
        vc.PostCode = self.SavedAddressList[index].zipcode ?? ""
        vc.comesFrom = "Basket"
        vc.AddressType = self.SavedAddressList[index].type ?? ""
        vc.country = self.SavedAddressList[index].country ?? ""
        vc.lat = lati
        vc.long = longi
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
      func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          if tableView == AddressTblV{
              for i in 0..<SavedAddressList.count{
                  self.SavedAddressList[i].primary = 0
              }
              self.SavedAddressList[indexPath.row].primary = 1
              self.AddressTblV.reloadData()
              self.addressID = "\(self.SavedAddressList[indexPath.row].id ?? 0)"
              SavedAddTag = 0
          }else{
              print(self.BasketListArr.ingredient?[indexPath.row] ?? false)
              if self.BasketListArr.ingredient?[indexPath.row].isSelected == false{
                  self.BasketListArr.ingredient?[indexPath.row].isSelected = true
              }else{
                  self.BasketListArr.ingredient?[indexPath.row].isSelected = false
              }
             
              if self.BasketListArr.ingredient?.contains(where: { $0.isSelected ?? false }) == true {
            
                  print("Something is selected")
                  checkoutInstacartBtnO.isUserInteractionEnabled = true
                  checkoutInstacartBtnO.backgroundColor = #colorLiteral(red: 0.9854765534, green: 0.5848969817, blue: 0.1648380458, alpha: 1)
              } else {
                  
                  print("Nothing selected")
                  checkoutInstacartBtnO.isUserInteractionEnabled = false
                  checkoutInstacartBtnO.backgroundColor = .lightGray
              }
              self.IngredientsTblV.reloadRows(at: [indexPath], with: .automatic)
          }
      }
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == IngredientsTblV{
            return 80
        }else{
            return 55
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == IngredientsTblV{
            return UITableView.automaticDimension
        }else{
            return UITableView.automaticDimension
        }
        }
    }

extension BasketNewVC{
    
    func createSelectedIngredientJSON() -> String? {
        
        guard let ingredientList = BasketListArr.ingredient else { return nil }

        var selectedIngredients: [SelectedIngredientPayload] = []

        for ingredient in ingredientList {
            if ingredient.isSelected == true{
                let payload = SelectedIngredientPayload(
                    name: ingredient.name ?? "",
                    quantity: "\(ingredient.quantity ?? 0)",
                    unit: ingredient.unitOfMeasurement ?? ""
                )
                selectedIngredients.append(payload)
            }
        }

        let requestPayload = IngredientRequestPayload(ingredients: selectedIngredients)

        do {
            let jsonData = try JSONEncoder().encode(requestPayload)
            if let jsonStr = String(data: jsonData, encoding: .utf8) {
               
                return jsonStr
            }
          
        } catch {
            print("JSON Encoding Error:", error)
            return nil
        }
        return nil
    }
    
    func createSelectedIngredientDict() {

        guard let str = createSelectedIngredientJSON() else {  return }
        print(str)
        
        guard
            let jsonData = str.data(using: .utf8),
            
                let payload = try? JSONDecoder().decode(IngredientRequestPayload.self, from: jsonData)  else {
            showAlert(for: "Failed to decode recipe payload")
            return
        }
        
        self.uploadIngredient(payload) { result, statusCode in
            guard let dict = result.dictionaryObject,let data = dict["data"] as? [String:Any] , let url = data["products_link_url"] as? String else {return}
            let vc = InstacartContainerVC()
            vc.urlString = url
               self.navigationController?.pushViewController(vc, animated: false)
        }
    }
  
    func uploadIngredient(_ payload: IngredientRequestPayload, completion: @escaping (JSON, Int) -> Void) {
        var apiURL = ""
        apiURL = baseURL.baseURL + appEndPoints.create_order_instacart
        
        
        self.showIndicator(withTitle: "Uploading...", and: "Please wait")
        WebService.shared.uploadModel(apiURL, VC: self, model: payload) { json, statusCode in
            DispatchQueue.main.async {
                self.hideIndicator()
                completion(json, statusCode)
            }
        }
    }
    func getBasketListData() {
        let params:JSONDictionary = [:]
        
        showIndicator(withTitle: "", and: "")
        if UserDetail.shared.getSubscriptionStatus() == "0"{
            showIndicator(withTitle: "", and: "")
        }
         
        let loginURL = baseURL.baseURL + appEndPoints.get_basketlist
        print(params,"Params")
        print(loginURL,"loginURL")
     
        
        WebService.shared.postServiceURLEncoding(loginURL, VC: self, andParameter: params, withCompletion: { (json, statusCode) in
            
            self.hideIndicator()
            
            let data = try! json.rawData()
            do{
                let d = try JSONDecoder().decode(basketNewModelClass.self, from: data)
                if d.success == true {
                    
                    let allData = d.data
                    
                    self.BasketListArr = allData ?? basketNewModelData()
                     
                    self.BasketListArr.stores = self.BasketListArr.stores?.filter { store in
                        store.total != nil && store.total != 0.0
                    }

                    for i in 0..<(self.BasketListArr.ingredient?.count ?? 0){
                        self.BasketListArr.ingredient?[i].isSelected = true
                        
                    }

                        if self.BasketListArr.recipe?.count ?? 0 > 0 {
                            self.YourRecipeBgV.isHidden = false
                            self.yourRecipeCollVH.constant = 220
                        }else{
                            self.YourRecipeBgV.isHidden = true
                            self.yourRecipeCollVH.constant = 0
                        }
                    
                    if self.BasketListArr.ingredient?.count ?? 0 != 0 {
                        self.IngredientBgV.isHidden = false
                    }else{
                        self.IngredientBgV.isHidden = true
                    }
  
                    
                    self.yourRecipeCollV.reloadData()
                    
                    self.IngredientsTblV.reloadData()
                    

                     
                }else{
                    
                    let msg = d.message ?? ""
          
                }
            }catch{
                
                print(error)
            }
        })
    }
    
    func getBasketListDataByMarket(StoreID:String, StoreName:String) {
        var params:JSONDictionary = [:]
        
        params["store_name"] = StoreName
        params["store_id"] = StoreID
        
        showIndicator(withTitle: "", and: "")
         
        let loginURL = baseURL.baseURL + appEndPoints.select_store_product
        print(params,"Params")
        print(loginURL,"loginURL")
        
    
        
        WebService.shared.postServiceURLEncoding(loginURL, VC: self, andParameter: params, withCompletion: { (json, statusCode) in
            
            self.hideIndicator()
            
            guard let dictData = json.dictionaryObject else{
                
                return
            }
            
            if dictData["success"] as? Bool == true{
                self.getBasketListData()
            }else{
                let responseMessage = dictData["message"] as! String
                self.showToast(responseMessage)
            }
        })
    }
    
    
    //get-address
    func Api_To_get_SavedAddress(){
        
   
      //  showIndicator(withTitle: "", and: "")
        
        let loginURL = baseURL.baseURL + appEndPoints.get_address
        
        print(loginURL,"loginURL")
        
        WebService.shared.postServiceURLEncoding(loginURL, VC: self, andParameter: [:], withCompletion: { (json, statusCode) in
            
          //  self.hideIndicator()
            
            let data = try! json.rawData()
            do{
                
                let d = try JSONDecoder().decode(AddressdataModelClass.self, from: data)
                if d.success == true {
                    
                    let allData = d.data
                    
                    self.SavedAddressList = allData ?? []
                    
                    if let indx = self.SavedAddressList.firstIndex(where: {$0.primary == 1}){
                        let latitude = self.SavedAddressList[indx].latitude ?? ""
                        let longitude = self.SavedAddressList[indx].longitude ?? ""
                        print("Latitude: \(latitude), Longitude: \(longitude)")
                        
                        AppLocation.lat = "\(latitude)"
                        AppLocation.long = "\(longitude)"
                        
                        self.addressID = "\(self.SavedAddressList[indx].id ?? 0)"
                        
                        let Addtype = self.SavedAddressList[indx].type ?? ""
                        
                        self.AddressType = Addtype
                        
                        if Addtype == "Home" || Addtype == ""{
                            self.SetHomeBgV.borderColor = #colorLiteral(red: 0.02352941176, green: 0.7568627451, blue: 0.4117647059, alpha: 1)
                            self.SetWorkBgV.borderColor = #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9529411765, alpha: 1)
                            self.SethomeBtnO.isSelected = true
                            self.SetWorkBtnO.isSelected = false
                            self.HomeIMg.image = UIImage(named: "HomeIcon")
                            self.WorkImg.tintColor = #colorLiteral(red: 0.5882352941, green: 0.6666666667, blue: 0.631372549, alpha: 1)
                        }else{
                            self.SetWorkBgV.borderColor = #colorLiteral(red: 0.02352941176, green: 0.7568627451, blue: 0.4117647059, alpha: 1)
                            self.SetHomeBgV.borderColor = #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9529411765, alpha: 1)
                            self.SethomeBtnO.isSelected = false
                            self.SetWorkBtnO.isSelected = true
                            self.WorkImg.tintColor = #colorLiteral(red: 0.9960784314, green: 0.6235294118, blue: 0.2705882353, alpha: 1)
                            self.HomeIMg.image = UIImage(named: "Home1")
                        }
                    }else{
                        self.locationManager.requestWhenInUseAuthorization()
                    }
                    
                    self.AddressTblV.reloadData()
                    self.AddressPopupView.isHidden = false
//                    DispatchQueue.main.asyncAfter(deadline: .now()){
//                        self.getBasketListData()
//                        }
                    
                }else{
                    
                    let msg = d.message ?? ""
                    self.showToast(msg)
                }
            }catch{
                
                print(error)
            }
        })
    }
    
    //
    func Api_To_make_PrimaryAddress(){
        
        var params:JSONDictionary = [:]
        
        params["id"] =  "\(addressID)"
        
      
        showIndicator(withTitle: "", and: "")
        
        let loginURL = baseURL.baseURL + appEndPoints.make_address_primary
        
        print(loginURL,"loginURL")
        
        WebService.shared.postServiceURLEncoding(loginURL, VC: self, andParameter: params, withCompletion: { (json, statusCode) in
            
            self.hideIndicator()
            
            guard let dictData = json.dictionaryObject else{
                
                return
            }
            
            if dictData["success"] as? Bool == true{
           //     self.getBasketListData()
                self.createSelectedIngredientDict()
            }else{
                let responseMessage = dictData["message"] as! String
                self.showToast(responseMessage)
            }
        })
    }
    
    
    // for Recipes
    func Api_To_Plus_Minus_ServesCount(uri:String, Quenty:String, type: String){
        
        var params:JSONDictionary = [:]
        
        params["uri"] = uri
        params["quantity"] = Quenty
        params["type"] = type
        
        showIndicator(withTitle: "", and: "")
        
        let loginURL = baseURL.baseURL + appEndPoints.add_to_basket
        
        print(loginURL,"loginURL")
        
        WebService.shared.postServiceURLEncoding(loginURL, VC: self, andParameter: params, withCompletion: { (json, statusCode) in
            
            self.hideIndicator()
            
            guard let dictData = json.dictionaryObject else{
                
                return
            }
            
            if dictData["success"] as? Bool == true{
         //       self.getBasketListData()
            }else{
                let responseMessage = dictData["message"] as! String
                self.showToast(responseMessage)
            }
        })
    }
    
    func Api_To_RemoveRecipes(Id:String, index: Int?){
        
        var params:JSONDictionary = [:]
        
        params["id"] = Id
    
        
        showIndicator(withTitle: "", and: "")
        
        let loginURL = baseURL.baseURL + appEndPoints.remove_basket
        
        print(loginURL,"loginURL")
        
        WebService.shared.postServiceURLEncoding(loginURL, VC: self, andParameter: params, withCompletion: { (json, statusCode) in
            
            self.hideIndicator()
            
            guard let dictData = json.dictionaryObject else{
                
                return
            }
            
            if dictData["success"] as? Bool == true{
              
                self.BasketListArr.recipe?.remove(at: index ?? 0)
                self.yourRecipeCollV.reloadData()
 
                self.getBasketListData()
            }else{
                let responseMessage = dictData["message"] as! String
                self.showToast(responseMessage)
            }
        })
    }
    //
    
    // for ingredients
    func Api_To_Plus_Minus_ingredientsCount(FoodID:String, Quenty:String){
        
        var params:JSONDictionary = [:]
        
        params["food_id"] = FoodID
        params["quantity"] = Quenty
      
        showIndicator(withTitle: "", and: "")
        
        let loginURL = baseURL.baseURL + appEndPoints.change_cart
        
        print(loginURL,"loginURL")
        
        WebService.shared.postServiceURLEncoding(loginURL, VC: self, andParameter: params, withCompletion: { (json, statusCode) in
            
            self.hideIndicator()
            
            guard let dictData = json.dictionaryObject else{
                
                return
            }
            
            if dictData["success"] as? Bool == true{
               // self.getBasketListData()
               // let responseMessage = dictData["message"] as! String
                //self.showToast("Added Successfully")
            }else{
                let responseMessage = dictData["message"] as! String
                self.showToast(responseMessage)
            }
        })
    }
    //
}

extension BasketNewVC: CLLocationManagerDelegate,GMSMapViewDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // 3
        
//        guard status == .authorizedWhenInUse || status == .authorizedAlways else {
//            CLLocationManager.authorizationStatus()
//            return
//        }
        guard status == .authorizedWhenInUse || status == .authorizedAlways else {
                    print("Location access not authorized")
            locationManager.requestAlwaysAuthorization()
                    return
                }
        
        // 4
        locationManager.startUpdatingLocation()
        
        //5
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
    }
    
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        
        if #available(iOS 14.0, *) {
            switch manager.authorizationStatus {
            case .notDetermined:
                // If status has not yet been determied, ask for authorization
                manager.requestWhenInUseAuthorization()
                break
            case .authorizedWhenInUse:
                // If authorized when in use
                manager.startUpdatingLocation()
                //stopTimer()
                self.mapView.delegate = self
                self.locationManager.requestAlwaysAuthorization()
                self.locationManager.requestWhenInUseAuthorization()
                self.locationManager.delegate = self
                self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
                self.locationManager.distanceFilter = kCLDistanceFilterNone
                self.locationManager.startUpdatingLocation()
                guard let location: CLLocationCoordinate2D = locationManager.location?.coordinate else { return }
                AppLocation.lat = "\(location.latitude)"
                AppLocation.long = "\(location.longitude)"
                
                reverseGeocodeCoordinate(locationManager.location!.coordinate, placeName: "")
                
                break
            case .authorizedAlways:
                // If always authorized
                manager.startUpdatingLocation()
                self.mapView.delegate = self
                self.locationManager.requestAlwaysAuthorization()
                self.locationManager.requestWhenInUseAuthorization()
                self.locationManager.delegate = self
                self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
                self.locationManager.distanceFilter = kCLDistanceFilterNone
                self.locationManager.startUpdatingLocation()
                guard let location: CLLocationCoordinate2D = locationManager.location?.coordinate else { return }
            
                AppLocation.lat = "\(location.latitude)"
                AppLocation.long = "\(location.longitude)"
                
                reverseGeocodeCoordinate(locationManager.location!.coordinate, placeName: "")
                
                break
            case .restricted, .denied:
                // If restricted by e.g. parental controls. User can't enable Location Services
                // If user denied your app access to Location Services, but can grant access from Settings.app
                // Disable location features
                
                let alert = UIAlertController(title: "Allow Location Access", message: "My Kai App needs to access your current location to show data according to your locaton. Turn on Location Services in your device settings.", preferredStyle: UIAlertController.Style.alert)
                
                // Button to Open Settings
                alert.addAction(UIAlertAction(title: "Settings", style: UIAlertAction.Style.default, handler: { action in
                    guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                        return
                    }
                    if UIApplication.shared.canOpenURL(settingsUrl) {
                        UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                            print("Settings opened: \(success)")
                        })
                    }
                }))
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                break
                
            default:
                break
            }
        } else {
            // Fallback on earlier versions
        }
        // 4
        locationManager.startUpdatingLocation()
        
        //5
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
    }
    
    
    // 6
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        let lattitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        print(" lat in  updating \(lattitude) ")
        print(" long in  updating \(longitude)")
        // 7
        mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
        AppLocation.lat = "\(lattitude)"
        AppLocation.long = "\(longitude)"
        // 8
        locationManager.stopUpdatingLocation()
    }
    
    func getUserLocation() {
        let status  = self.locationManager.authorizationStatus
        
        if status == .denied || status == .restricted {
            guard URL(string: UIApplication.openSettingsURLString) != nil else {
                self.AlertControllerOnr(title: "Error", message: "", BtnTitle: "OK")
                return
            }
            self.AlertControllerCuston(title: "Location Services Disabled", message: "Please enable location service for this app in ALLOW LOCATION ACCESS: Always, Go to Setting?", BtnTitle: ["Not Now","Open Setting"]) { (str) in
                if str == "Open Setting" {
                    let appSettings = URL(string: UIApplication.openSettingsURLString + Bundle.main.bundleIdentifier!)
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(appSettings!, options: [:], completionHandler: { (success) in
                            print("Settings opened: \(success)") // Prints true
                        })
                    } else {
                        UIApplication.shared.openURL(appSettings!)
                        print("Settings opened:")
                    }}
            }
            return
        }
             requestLocationPermission()

     }
    
    // Check if location services are enabled before requesting location
    func requestLocationPermission() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            self.locationManager.requestWhenInUseAuthorization() // or requestAlwaysAuthorization depending on your needs
        }
    }
    
    
    private func reverseGeocodeCoordinate(_ coordinate: CLLocationCoordinate2D,placeName: String) {
        print(coordinate.latitude, "lat")
        print(coordinate.longitude, "lat")
        let geocoder = GMSGeocoder()
        // 2
        geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
            guard let address = response?.firstResult(), let lines = address.lines else {
                return
            }
            // 3
            //        if self.locationTF.text == ""{
            self.SearchAddTxtF.text = lines.joined(separator: "\n")
         
             
            // 🔹 Street Number + Name from `thoroughfare`
                   if let thoroughfare = address.thoroughfare {
                       let parts = thoroughfare.split(separator: " ", maxSplits: 1).map { String($0) }
                       self.StreetNo = parts.first ?? ""
                       self.StreetName = parts.count > 1 ? parts[1] : ""
                   } else {
                       self.StreetNo = ""
                       self.StreetName = ""
                   }

                   // 🔹 ApartmentNo is not available from GMSAddress, leave it empty or parse from `subPremise` (if using CLPlacemark)
                   self.ApartmentNo = ""

                   // 🔹 City, State, PostalCode, Full Address
                   self.City = address.locality ?? ""
                   self.State = address.administrativeArea ?? ""
                   self.PostCode = address.postalCode ?? ""
                   self.country = address.country ?? ""
                   self.Address = lines.joined(separator: ", ")
            

               self.SearchAddTxtF.text = lines.joined(separator: "\n")
            
     
            // 4
            UIView.animate(withDuration: 0.25) {
                self.view.layoutIfNeeded()
                
            }
        }
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        // reverseGeocodeCoordinate(position.target, placeName: "")
        reverseGeocodeCoordinate(locationManager.location!.coordinate, placeName: "")
    }
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        // self.addressLabel.lock()
        // addressLabel.lock()
    }
}
