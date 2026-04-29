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
import SkeletonView

// MARK: - BasketNewVC

class BasketNewVC: UIViewController, UITextFieldDelegate {
    
    // MARK: - UI Outlets
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

    // MARK: - Empty State View
    private var emptyStateView: UIView?
  
    // MARK: - Properties
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
    private var originalIngredients: [WelcomeIngredient] = []
    private var isLoadingBasketContent = false
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        GMSPlacesClient.provideAPIKey("AIzaSyA7f3YXlTD-foNwy7phnJJHCsYDiWgURkQ")
        placesClient = GMSPlacesClient.shared()

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
        
        setupEmptyStateView()
        setupCollectionView()
       
        self.IngredientsTblV.register(UINib(nibName: "IngridenttTblVCell", bundle: nil), forCellReuseIdentifier: "IngridenttTblVCell")
        self.IngredientsTblV.delegate = self
        self.IngredientsTblV.dataSource = self
     //   self.IngredientsTblV.isSkeletonable = false
          
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
    
    // Observe value changes for the contentSize property to adjust height constraint dynamically
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize", let tableView = object as? UITableView {
            DispatchQueue.main.async {
                if tableView.tag == 1 {
                    self.IngredientsTblVH.constant = tableView.contentSize.height
                } else if tableView.tag == 2 {
                    self.AddressTblVH.constant = tableView.contentSize.height
                }
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
      
      self.Api_To_get_SavedAddress()
    }
    
    // MARK: - UI Setup & Helpers
    
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
    
    // Fetch place details for a selected placeID and update address fields
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

    private func setBasketContentSkeletonVisible(_ visible: Bool) {
        if visible {
            YourRecipeBgV.isHidden = false
            IngredientBgV.isHidden = false
            yourRecipeCollVH.constant = 220
            IngredientsTblVH.constant = 83 * 4
            view.layoutIfNeeded()
            yourRecipeCollV.reloadData()
            IngredientsTblV.reloadData()
        } else {
            IngredientsTblV.reloadData()
            yourRecipeCollV.reloadData()
        }
    }
 
    // MARK: - Button Actions

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
        self.Api_To_get_SavedAddress(hideOrNot: false)
        
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
 
// MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension BasketNewVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isLoadingBasketContent {
            return 4
        }
        return BasketListArr.recipe?.count ?? 0
    }
       
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "YouRecipeCollVCell", for: indexPath) as! YouRecipeCollVCell
        
        if isLoadingBasketContent {
            cell.setLoading(true)
            return cell
        }
        
        cell.setLoading(false)
        cell.Namelbl.text = BasketListArr.recipe?[indexPath.item].data?.recipe?.label ?? ""
               
        let img = BasketListArr.recipe?[indexPath.item].data?.recipe?.images?.small?.url ?? ""
        let imgUrl = URL(string: img)
               
        cell.Img.setRemoteImage(imgUrl, placeholder: UIImage(named: "No_Image"))
               
//        cell.ServCountLbl.text = "Serves \(BasketListArr.recipe?[indexPath.item].serving ?? "0")"
               
        let serv1 = Int(BasketListArr.recipe?[indexPath.item].serving ?? "1") ?? 1
        let serv2 = BasketListArr.recipe?[indexPath.item].data?.recipe?.servings ?? 0
        cell.ServCountLbl.text = "Serves \(serv1 * serv2)"
        
        cell.MinusBtn.tag = indexPath.row
        cell.MinusBtn.addTarget(self, action: #selector(ServCountMinusBtn(_:)), for: .touchUpInside)
               
        cell.plusBtn.tag = indexPath.row
        cell.plusBtn.addTarget(self, action: #selector(ServCountPlusBtn(_:)), for: .touchUpInside)
               
        cell.RemoveBtn.tag = indexPath.item
        cell.RemoveBtn.addTarget(self, action: #selector(removeBtnClick(_:)), for: .touchUpInside)
               
        return cell
    }
    
//    @objc func ServCountMinusBtn(_ sender: UIButton) {
//        var ServCount = Int(BasketListArr.recipe?[sender.tag].serving ?? "1") ?? 1
//        
//        guard ServCount > 1 else { return }
//        
//        ServCount -= 1
//        
//        BasketListArr.recipe?[sender.tag].serving = "\(ServCount)"
//        
//        // ✅ STEP 1 (ADD THIS)
//        updateIngredientServings(for: sender.tag, newServing: ServCount)
//        
//        self.yourRecipeCollV.reloadData()
//        
//        // ✅ STEP 2
//        self.recalculateAndMergeIngredients()
//    }
    
    @objc func ServCountMinusBtn(_ sender: UIButton) {
        
        var ServCount = Int(BasketListArr.recipe?[sender.tag].serving ?? "1") ?? 1
        guard ServCount > 1 else { return }
        
        ServCount -= 1
        BasketListArr.recipe?[sender.tag].serving = "\(ServCount)"
        
        // ✅ STEP 1: Update ingredient servings
        updateIngredientServings(for: sender.tag, newServing: ServCount)
        
        // ✅ STEP 2: Reload UI
        self.yourRecipeCollV.reloadData()
        
        // ✅ STEP 3: Recalculate ingredients
        self.recalculateAndMergeIngredients()
        
        // ✅ STEP 4: HIT API (ADD THIS)
        let uri = BasketListArr.recipe?[sender.tag].uri ?? ""
        let typ = BasketListArr.recipe?[sender.tag].type ?? ""
        
        if let result = typ.components(separatedBy: "/").first {
            self.Api_To_Plus_Minus_ServesCount(
                uri: uri,
                Quenty: "\(ServCount)",
                type: result,
                index: sender.tag
            )
        }
    }
    
    @objc func ServCountPlusBtn(_ sender: UIButton) {
        
        var ServCount = Int(BasketListArr.recipe?[sender.tag].serving ?? "1") ?? 1
        ServCount += 1
        
        BasketListArr.recipe?[sender.tag].serving = "\(ServCount)"
        
        // ✅ STEP 1: Update ingredient servings
        updateIngredientServings(for: sender.tag, newServing: ServCount)
        
        // ✅ STEP 2: Reload UI
        self.yourRecipeCollV.reloadData()
        
        // ✅ STEP 3: Recalculate ingredients
        self.recalculateAndMergeIngredients()
        
        // ✅ STEP 4: HIT API (ADD THIS)
        let uri = BasketListArr.recipe?[sender.tag].uri ?? ""
        let typ = BasketListArr.recipe?[sender.tag].type ?? ""
        
        if let result = typ.components(separatedBy: "/").first {
            self.Api_To_Plus_Minus_ServesCount(
                uri: uri,
                Quenty: "\(ServCount)",
                type: result,
                index: sender.tag
            )
        }
    }
    
//    @objc func ServCountPlusBtn(_ sender: UIButton) {
//        var ServCount = Int(BasketListArr.recipe?[sender.tag].serving ?? "1") ?? 1
//        ServCount += 1
//        
//        BasketListArr.recipe?[sender.tag].serving = "\(ServCount)"
//        
//        // ✅ STEP 1 (ADD THIS)
//        updateIngredientServings(for: sender.tag, newServing: ServCount)
//        
//        self.yourRecipeCollV.reloadData()
//        
//        // ✅ STEP 2
//        self.recalculateAndMergeIngredients()
//        
//    }
    
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
    
    func updateIngredientServings(for recipeIndex: Int, newServing: Int) {
        
        let recipeId = BasketListArr.recipe?[recipeIndex].uri ?? ""

        for i in 0..<originalIngredients.count {
            if originalIngredients[i].productID == recipeId {
                originalIngredients[i].servings = "\(newServing)"
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "CreateRecipeSB", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "RecipeDetailNewVC") as! RecipeDetailNewVC
        let Type = BasketListArr.recipe?[indexPath.item].type ?? ""
        let type = Type.prefix(while: { $0 != "," })
        vc.MealType = "\(type)"
        vc.uri = BasketListArr.recipe?[indexPath.item].uri ?? ""
        vc.Id = "\(BasketListArr.recipe?[indexPath.item].id ?? 0)"
        vc.ServCount = Int(BasketListArr.recipe?[indexPath.item].serving ?? "1") ?? 1
        vc.type = "0"
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
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

// MARK: - UITableViewDelegate, UITableViewDataSource
extension BasketNewVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == IngredientsTblV{
            if isLoadingBasketContent {
                return 4
            }
            return BasketListArr.ingredient?.count ?? 0
        }else{
            return self.SavedAddressList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == IngredientsTblV{
            let cell = tableView.dequeueReusableCell(withIdentifier: "IngridenttTblVCell", for: indexPath) as! IngridenttTblVCell
            
            if isLoadingBasketContent {
                cell.setLoading(true)
                return cell
            }
            
            cell.setLoading(false)
            
            let img = BasketListArr.ingredient?[indexPath.item].proImg ?? ""
            let imgUrl = URL(string: img)
            
            cell.NameLbl.text = self.BasketListArr.ingredient?[indexPath.row].name?.capitalizedFirst ?? ""
            
            let qtyValue: Double = {
                if let qty = self.BasketListArr.ingredient?[indexPath.row].quantity, qty > 0 {
                    return Double(qty)
                } else {
                    return 1.0
                }
            }()
            let unit = (self.BasketListArr.ingredient?[indexPath.row].measure ?? "").lowercased()
            let formatted = qtyValue.truncatingRemainder(dividingBy: 1) == 0
                ? String(format: "%.0f", qtyValue)
                : String(format: "%.2f", qtyValue)
            let hiddenUnits = ["each"]

            if hiddenUnits.contains(unit) {
                cell.quantityLbl.text = formatted
            } else {
                cell.quantityLbl.text = "\(formatted) \(unit)"
            }
         
            cell.Img.setRemoteImage(imgUrl, placeholder: UIImage(named: "No_Image"))
            
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
               // checkoutInstacartBtnO.backgroundColor = #colorLiteral(red: 0.9854765534, green: 0.5848969817, blue: 0.1648380458, alpha: 1)
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
            return isLoadingBasketContent ? 83 : UITableView.automaticDimension
        }else{
            return UITableView.automaticDimension
        }
    }
}

//extension BasketNewVC: SkeletonCollectionViewDataSource, SkeletonTableViewDataSource {
//    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 4
//    }
//
//    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> SkeletonView.ReusableCellIdentifier {
//        return "YouRecipeCollVCell"
//    }
//
//    func numSections(in collectionSkeletonView: UICollectionView) -> Int {
//        return 1
//    }
//
//    func numSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//
//    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 6
//    }
//
//    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> SkeletonView.ReusableCellIdentifier {
//        return "IngridenttTblVCell"
//    }
//}

    // MARK: - Empty State Setup
extension BasketNewVC{
    
    private func setupEmptyStateView() {
        let emptyView = UIView(frame: CGRect(x: 0, y: 100, width: view.frame.width, height: view.frame.height - 100))
        emptyView.backgroundColor = .white
        emptyView.isHidden = true
        
        // First Image (200x200)
        let topImageView = UIImageView()
        topImageView.translatesAutoresizingMaskIntoConstraints = false
        topImageView.contentMode = .scaleAspectFit
        topImageView.image = UIImage(named: "basket_empty") // 🔹 Add your first image name here
        
        // Second Image (below first image)
        let bottomImageView = UIImageView()
        bottomImageView.translatesAutoresizingMaskIntoConstraints = false
        bottomImageView.contentMode = .scaleAspectFit
        bottomImageView.image = UIImage(named: "plan_meals_button") // 🔹 Add your second image name here
        bottomImageView.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(emptyBottomImageTapped))
        bottomImageView.addGestureRecognizer(tapGesture)
        
        emptyView.addSubview(topImageView)
        emptyView.addSubview(bottomImageView)
        
        NSLayoutConstraint.activate([
            
            // Top Image Constraints
            topImageView.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor),
            topImageView.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor, constant: -80),
            topImageView.widthAnchor.constraint(equalToConstant: 200),
            topImageView.heightAnchor.constraint(equalToConstant: 200),
            
            // Bottom Image Constraints
            bottomImageView.topAnchor.constraint(equalTo: topImageView.bottomAnchor, constant: 10),
            bottomImageView.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor),
            bottomImageView.widthAnchor.constraint(equalToConstant: 150),
            bottomImageView.heightAnchor.constraint(equalToConstant: 50)
        ])
        self.view.addSubview(emptyView)
        self.view.bringSubviewToFront(emptyView)
        
        self.emptyStateView = emptyView
    }
    
    private func updateEmptyState() {
        let subscriptionStatus = Int(UserDetail.shared.getSubscriptionStatus())
        let recipeCount = BasketListArr.recipe?.count ?? 0
        
        if subscriptionStatus == 0 && recipeCount == 0 {
            emptyStateView?.isHidden = false
            self.view.bringSubviewToFront(emptyStateView!)
        } else {
            emptyStateView?.isHidden = true
        }
    }

    @objc private func emptyBottomImageTapped() {
        self.tabBarController?.selectedIndex = 3
    }
}

// MARK: - Business Logic & Network
extension BasketNewVC{
    
    enum UnitCategory {
        case weight
        case volume
        case count
        case unknown
    }
    
    func normalizeUnit(_ unit: String) -> String {
        let u = unit.lowercased()
        switch u {
            // Weight
        case "kg", "kilogram", "kilograms": return "kg"
        case "g", "gram", "grams": return "g"
        case "mg", "milligram", "milligrams": return "mg"
        case "lb", "pound", "pounds": return "lb"
        case "oz", "ounce", "ounces": return "oz"
            
            // Volume
        case "ml", "milliliter", "milliliters": return "ml"
        case "l", "liter", "liters": return "l"
        case "cup", "cups": return "cup"
        case "tbsp", "tablespoon", "tablespoons": return "tbsp"
        case "tsp", "teaspoon", "teaspoons": return "tsp"
            
        case "each": return "each"
        default: return u
        }
    }
    
    func unitCategory(for unit: String) -> UnitCategory {
        switch unit {
        case "kg", "g", "mg", "lb", "oz":
            return .weight
        case "ml", "l", "cup", "tbsp", "tsp":
            return .volume
        case "each":
            return .count
        default:
            return .unknown
        }
    }
    
    func convertToBaseUnit(quantity: Double, unit: String) -> (Double, String) {
        switch unit {
            // Weight → grams
        case "kg": return (quantity * 1000, "g")
        case "g": return (quantity, "g")
        case "mg": return (quantity / 1000, "g")
        case "lb": return (quantity * 453.592, "g")
        case "oz": return (quantity * 28.3495, "g")
            
            // Volume → ml
        case "l": return (quantity * 1000, "ml")
        case "ml": return (quantity, "ml")
        case "cup": return (quantity * 240, "ml")
        case "tbsp": return (quantity * 15, "ml")
        case "tsp": return (quantity * 5, "ml")
            
        case "each": return (quantity, "each")
        default: return (quantity, unit)
        }
    }
    
    //    func recalculateAndMergeIngredients() {
    //
    //        var mergedDict: [String: WelcomeIngredient] = [:]
    //
    //        for ingredient in originalIngredients {
    //
    //            let qty = Double(ingredient.quantity ?? 1)
    //            let servings = Double(ingredient.servings ?? "1") ?? 1.0
    //
    //            // ✅ Android logic
    //            let scaledQty = qty * servings
    //
    //            let key = (ingredient.name ?? "")
    //                .lowercased()
    //                .trimmingCharacters(in: .whitespacesAndNewlines)
    //
    //            if var existing = mergedDict[key] {
    //                existing.quantity = (existing.quantity ?? 0) + Int(scaledQty)
    //                mergedDict[key] = existing
    //            } else {
    //                var newIngredient = ingredient
    //                newIngredient.quantity = Int(scaledQty)
    //                mergedDict[key] = newIngredient
    //            }
    //        }
    //
    //        BasketListArr.ingredient = Array(mergedDict.values)
    //
    //        for i in 0..<(BasketListArr.ingredient?.count ?? 0) {
    //            BasketListArr.ingredient?[i].isSelected = true
    //        }
    //
    //        DispatchQueue.main.async {
    //            self.IngredientsTblV.reloadData()
    //        }
    //    }
    
    func recalculateAndMergeIngredients() {
        
        var mergedDict: [String: WelcomeIngredient] = [:]

        for ingredient in originalIngredients {
            
            let qty = Double(ingredient.quantity ?? 1)
            
            let baseQty = Double(ingredient.quantity ?? 1) // original from API
            let servings = Double(ingredient.servings ?? "1") ?? 1.0

            let scaledQty = baseQty * servings
            
            let key = (ingredient.name ?? "")
                .lowercased()
                .trimmingCharacters(in: .whitespacesAndNewlines)
            
            if var existing = mergedDict[key] {
                existing.quantity = (existing.quantity ?? 0) + Int(round(scaledQty))
                mergedDict[key] = existing
            } else {
                var newIngredient = ingredient
                newIngredient.quantity = Int(round(scaledQty))
                mergedDict[key] = newIngredient
            }
        }
        
        BasketListArr.ingredient = Array(mergedDict.values).sorted {
            ($0.name ?? "").lowercased() < ($1.name ?? "").lowercased()
        }
        
        for i in 0..<(BasketListArr.ingredient?.count ?? 0) {
            BasketListArr.ingredient?[i].isSelected = true
        }
        
        DispatchQueue.main.async {
            self.IngredientsTblV.reloadData()
        }
    }
    
    /// Creates JSON string from selected ingredients for API request.
    func createSelectedIngredientJSON() -> String? {
        
        guard let ingredientList = BasketListArr.ingredient else { return nil }

        var selectedIngredients: [SelectedIngredientPayload] = []

        for ingredient in ingredientList {
            if ingredient.isSelected == true {

                let qtyValue: Double = {
                    if let qty = ingredient.quantity, qty > 0 {
                        return Double(qty)
                    } else {
                        return 1.0
                    }
                }()

                let payload = SelectedIngredientPayload(
                    name: ingredient.name ?? "",
                    quantity: "\(qtyValue)",
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
            guard let dict = result.dictionaryObject,
                  let data = dict["data"] as? [String:Any],
                  let url = data["products_link_url"] as? String else {return}
            let vc = InstacartContainerVC()
            vc.urlString = url
            vc.backButtonTapped = { [weak self] in
                guard let self = self else { return }
                
                let storyboard = UIStoryboard(name: "Basket", bundle: nil)
                let missingVC = storyboard.instantiateViewController(withIdentifier: "Tesco_MissingIngredientVC") as! Tesco_MissingIngredientVC
                missingVC.missingIngredient = self.BasketListArr.ingredient ?? []
                
                if var stack = self.navigationController?.viewControllers {
                    stack.removeLast() // Remove InstacartContainerVC
                    stack.append(missingVC)
                    self.navigationController?.setViewControllers(stack, animated: false)
                }
            }
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
    
    /// Fetches basket list data and updates UI accordingly
    func getBasketListData() {
        if !isLoadingBasketContent {
            isLoadingBasketContent = true
            setBasketContentSkeletonVisible(true)
        }
        let params:JSONDictionary = [:]
         
        let loginURL = baseURL.baseURL + appEndPoints.get_basketlist
        print(params,"Params")
        print(loginURL,"loginURL")
     
        
        WebService.shared.postServiceURLEncoding(loginURL, VC: self, andParameter: params, withCompletion: { (json, statusCode) in
            
            self.isLoadingBasketContent = false
            
            let data = try! json.rawData()
            do{
                let d = try JSONDecoder().decode(basketNewModelClass.self, from: data)
                if d.success == true {
                    
                    let allData = d.data
                    
                    self.BasketListArr = allData ?? basketNewModelData()
                    self.originalIngredients = self.BasketListArr.ingredient ?? []
                    self.BasketListArr.stores = self.BasketListArr.stores?.filter { store in
                        store.total != nil && store.total != 0.0
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
                    // self.IngredientsTblV.reloadData()
                    self.recalculateAndMergeIngredients()
                    self.updateEmptyState()
                    self.setBasketContentSkeletonVisible(false)
                }else{
                    let msg = d.message ?? ""
                    self.setBasketContentSkeletonVisible(false)
                }
            }catch{
                self.setBasketContentSkeletonVisible(false)
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
    func Api_To_get_SavedAddress(hideOrNot:Bool = true){
        
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
                    self.AddressPopupView.isHidden = hideOrNot
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
                // self.getBasketListData()
                self.createSelectedIngredientDict()
            }else{
                let responseMessage = dictData["message"] as! String
                self.showToast(responseMessage)
            }
        })
    }
    
    // for Recipes
    func Api_To_Plus_Minus_ServesCount(uri:String, Quenty:String, type: String,index:Int){
        
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
                // self.getBasketListData()
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
                self.updateEmptyState()
            }else{
                let responseMessage = dictData["message"] as! String
                self.showToast(responseMessage)
            }
        })
    }
    
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
}

// MARK: - Location Handling (CLLocationManagerDelegate, GMSMapViewDelegate)
extension BasketNewVC: CLLocationManagerDelegate,GMSMapViewDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // 3
        
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
    
    // Location update handling to update map camera and app location variables
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
    
    // Reverse geocoding to update address fields based on coordinate
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
