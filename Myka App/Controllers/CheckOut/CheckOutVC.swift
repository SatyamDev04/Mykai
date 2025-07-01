//
//  CheckOutVC.swift
//  My-Kai
//
//  Created by YES IT Labs on 05/03/25.
//

import UIKit
import GoogleMaps
import Alamofire
import SDWebImage
import GooglePlaces
import DropDown
import Stripe

class CheckOutVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var MapView: GMSMapView!
    
    @IBOutlet weak var SethomeAddressLbl: UILabel!
    @IBOutlet weak var ContactTxtF: UITextField!
    @IBOutlet weak var DeliveryTimeLbl: UILabel!
    @IBOutlet weak var StandardTimeLbl: UILabel!
    @IBOutlet weak var MarketNameLbl: UITextField!
    @IBOutlet weak var marketTotalItemLbl: UILabel!
    @IBOutlet weak var MarketImg: UIImageView!
    @IBOutlet weak var ItemDropBtnO: UIButton!
    @IBOutlet weak var DropIconImgV: UIImageView!
    @IBOutlet weak var DropOffLbl: UITextField!
    
    @IBOutlet weak var SubTotalPriceLbl: UILabel!
    @IBOutlet weak var SubtotalDiscountPriceLbl: UILabel!
    @IBOutlet weak var TaxLbl: UILabel!
    @IBOutlet weak var FeeLbl: UILabel!
    @IBOutlet weak var ServicePriceLbl: UILabel!
    @IBOutlet weak var ProcessingLbl: UILabel!
    @IBOutlet weak var DeliveryPriceLbl: UILabel!
    @IBOutlet weak var ScheduleSavingPriceLbl: UILabel!
    @IBOutlet weak var TotalPriceLbl: UILabel!
    
    @IBOutlet weak var itemsTblV: UITableView!
    @IBOutlet weak var itemsTblVH: NSLayoutConstraint!
     
    @IBOutlet weak var CardsTblV: UITableView!
    @IBOutlet weak var CardsTblVH: NSLayoutConstraint!
    // Replaced by this, using this.
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
    @IBOutlet weak var AddressTypeLbl: UITextField!
    
    
    @IBOutlet weak var ApplePayBtnO: UIButton!
    @IBOutlet weak var GooglePayBtnO: UIButton!
    
    //for google search
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
    //
    var SavedAddTag = 0
    var addressID = ""
    
    var mapView = GMSMapView()
    var gmsAddress: GMSAddress?
    var zoomCamera : GMSCameraPosition?
    let marker = GMSMarker()
    var locationManager = CLLocationManager()
    let geoCoder = CLGeocoder()
     
    //
    
    var SavedAddressList = [AddressdataModel]()
    
    var PrimaryAddressID = "" //from api
    
    var CheckoutData : checkoutModelData?
    
    var ScheduleDiscount : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GMSPlacesClient.provideAPIKey("AIzaSyA7f3YXlTD-foNwy7phnJJHCsYDiWgURkQ") // Ensure API Key is provided
        placesClient = GMSPlacesClient.shared() // ✅ Initialize it here
        
        self.AddressPopupView.frame = self.view.bounds
        self.view.addSubview(self.AddressPopupView)
        self.AddressPopupView.isHidden = true
        
        self.SetHomeBgV.borderColor = #colorLiteral(red: 0.02352941176, green: 0.7568627451, blue: 0.4117647059, alpha: 1)
        self.SetWorkBgV.borderColor = #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9529411765, alpha: 1)
        self.SethomeBtnO.isSelected = true
        self.SetWorkBtnO.isSelected = false
        self.HomeIMg.image = UIImage(named: "HomeIcon")
        self.WorkImg.tintColor = #colorLiteral(red: 0.5882352941, green: 0.6666666667, blue: 0.631372549, alpha: 1)
        
        self.itemsTblV.register(UINib(nibName: "ItemsTblVCell", bundle: nil), forCellReuseIdentifier: "ItemsTblVCell")
        self.itemsTblV.delegate = self
        self.itemsTblV.dataSource = self
        self.itemsTblV.isHidden = true
        
        self.AddressTblV.register(UINib(nibName: "AddressTblVCell", bundle: nil), forCellReuseIdentifier: "AddressTblVCell")
        self.AddressTblV.delegate = self
        self.AddressTblV.dataSource = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        AddressBgV.addGestureRecognizer(tapGesture)
        
        SearchAddTxtF.delegate = self
        SearchAddTxtF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        //
        
        
        self.CardsTblV.register(UINib(nibName: "CardCell", bundle: nil), forCellReuseIdentifier: "CardCell")
        self.CardsTblV.dataSource = self
        self.CardsTblV.delegate = self

        // Do any additional setup after loading the view.
        self.getCheckoutListData()
        
        self.Api_To_get_SavedAddress()
        
        setupTableView(CardsTblV, tag: 1)
        setupTableView(AddressTblV, tag: 2)
        setupTableView(itemsTblV, tag: 3)
        
        NotificationCenter.default.addObserver(self, selector: #selector(listnerFunction(_:)), name: NSNotification.Name(rawValue: "notificationName"), object: nil)
       //
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
                CardsTblVH.constant = tableView.contentSize.height
            } else if tableView.tag == 2 {
                AddressTblVH.constant = tableView.contentSize.height
            } else if tableView.tag == 3 {
                itemsTblVH.constant = tableView.contentSize.height
            }
        }
    }
    
    deinit {
        // Remove observers
        CardsTblV.removeObserver(self, forKeyPath: "contentSize")
        AddressTblV.removeObserver(self, forKeyPath: "contentSize")
        itemsTblV.removeObserver(self, forKeyPath: "contentSize")
    }
    
    @objc func listnerFunction(_ notification: NSNotification) {
        if let data = notification.userInfo?["data"] as? String {
            if data == "Reload"{
                self.getCheckoutListData()
            }
          }
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
                    
                    let AddComp = place.addressComponents
                    
                    if let addressComponents = AddComp {
                        self.StreetNo = self.getAddressComponent(for: "street_number", from: addressComponents) ?? ""
                        self.StreetName = self.getAddressComponent(for: "route", from: addressComponents) ?? ""
                        self.ApartmentNo = self.getAddressComponent(for: "subpremise", from: addressComponents) ?? ""
                        self.City = self.getAddressComponent(for: "locality", from: addressComponents) ?? ""
                        self.State = self.getAddressComponent(for: "administrative_area_level_1", from: addressComponents) ?? ""
                        self.PostCode = self.getAddressComponent(for: "postal_code", from: addressComponents) ?? ""
                        self.Address = "\(self.StreetNo) \(self.StreetName), \(self.City), \(self.State), \(self.PostCode)"
                        
                        self.country = self.getAddressComponent(for: "country", from: addressComponents) ?? ""
                        
                    } else {
                        self.StreetNo = ""
                        self.StreetName = ""
                        self.ApartmentNo = ""
                        self.City = ""
                        self.State = ""
                        self.PostCode = ""
                        self.Address = ""
                        self.country = ""
                    }
                    
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
        for i in 0..<SavedAddressList.count{
            if "\(self.SavedAddressList[i].id ?? 0)" == self.PrimaryAddressID{
                self.SavedAddressList[i].primary = 1
                self.addressID = "\(self.SavedAddressList[i].id ?? 0)"
            }else{
                self.SavedAddressList[i].primary = 0
            }
        }
        self.AddressTblV.reloadData()
        SavedAddTag = 0
        
        AddressPopupView.isHidden = true
    }
    
    
    @IBAction func BackBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func EditPinBtn(_ sender: UIButton) {
        let fullAddress = self.SethomeAddressLbl.text ?? ""
 
            let ApptNo = self.CheckoutData?.address?.apartNum ?? ""
            let StreetName = self.CheckoutData?.address?.streetName ?? ""
            let City = self.CheckoutData?.address?.city ?? ""
            let state = self.CheckoutData?.address?.state ?? ""
            let country = self.CheckoutData?.address?.country ?? ""
            let ZipCode = self.CheckoutData?.address?.zipcode ?? ""
            let AddType = self.CheckoutData?.address?.type ?? ""
            let lat = self.CheckoutData?.address?.latitude ?? ""
            let long = self.CheckoutData?.address?.longitude ?? ""
            
            let storyboard = UIStoryboard(name: "Login", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "AddressOnMapVC") as! AddressOnMapVC
            vc.AddressType = AddType
            vc.StreetName = StreetName
            vc.StreetNo = ""
            vc.ApartmentNo = ApptNo
            vc.City = City
            vc.State = state
            vc.Address = fullAddress
            vc.OldAddress = fullAddress
            vc.tag = 1
            vc.PostCode = ZipCode
            vc.country = country
            vc.lat = lat
            vc.long = long
            vc.comesFrom = "CheckOutVC"
            self.navigationController?.pushViewController(vc, animated: false)
        }
    
    @IBAction func SetHomeBtn(_ sender: UIButton) {
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
    }
    
    @IBAction func MeetAtDoorBtn(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Basket", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "DropOffOptionsVC") as! DropOffOptionsVC
        vc.backAction = { str in
            self.DropOffLbl.text = str
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func ContactNumBtn(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Basket", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AddNumberVC") as! AddNumberVC
        vc.backAction = { str in
            self.ContactTxtF.text = str
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func ItemDropBtn(_ sender: UIButton) {
        if self.ItemDropBtnO.isSelected == true{
            self.ItemDropBtnO.isSelected = false
            self.DropIconImgV.image = UIImage(named: "DropIcon")
            self.itemsTblV.isHidden = true
        }else{
            self.ItemDropBtnO.isSelected = true
            self.DropIconImgV.image = UIImage(named: "DropUpIcon")
            self.itemsTblV.isHidden = false
        }
    }
    
    @IBAction func ScheduleBtn(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Basket", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ScheduleDeliveryVC") as! ScheduleDeliveryVC
        vc.discStr = self.ScheduleDiscount
        vc.BackAction = { disc in
            self.ScheduleDiscount = disc
            self.ScheduleSavingPriceLbl.text = "$\(disc)"
            
            let TotalPrice = self.CheckoutData?.total ?? 0
            let discPrc = Double(disc)
            let Ftotal = TotalPrice - (discPrc ?? 0)
            let FTotalPrice = self.formatPrice(Ftotal)
            self.TotalPriceLbl.text = "$\(FTotalPrice)"
        }
        self.present(vc, animated: true)
    }
    
    
    @IBAction func AddCardBtn(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Basket", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "Credit_Debit_cardVC") as! Credit_Debit_cardVC
        vc.backAction = {
            self.getCheckoutListData()
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func ProceedBtn(_ sender: UIButton) {
        guard self.ContactTxtF.text != "Please Add Phone Number" else {
            AlertControllerOnr(title: "", message: "")
            return
        }
        
//        guard self.CheckoutData?.card?.count ?? 0 > 0 else {
//            AlertControllerOnr(title: "Please Add Card", message: "")
//            return
//        }
        guard self.ApplePayBtnO.isSelected != false || self.GooglePayBtnO.isSelected != false || self.CheckoutData?.card?.count ?? 0 > 0 else{
            AlertControllerOnr(title: "Please select payment method", message: "")
            return
        }
              
        self.Api_To_CheckOredrAvailablity()
    }
    
    
    //Address popup Btns.
    @IBAction func SetHomePopupBtn(_ sender: UIButton) {
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
            vc.comesfrom = "CheckOutVC"
            vc.AddressType = self.AddressType
            vc.country = self.country
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            self.Api_To_make_PrimaryAddress()
        }
    }
    //
    //
    
    @IBAction func ApplePayBtn(_ sender: UIButton) {
        self.ApplePayBtnO.isSelected = true
        self.GooglePayBtnO.isSelected = false
        
        for i in 0..<(self.CheckoutData?.card?.count ?? 0) {
            self.CheckoutData?.card?[i].SelCrad = 0
        }

        self.CardsTblV.reloadData()
    }
    
    
    @IBAction func GooglePayBtn(_ sender: UIButton) {
        self.ApplePayBtnO.isSelected = false
        self.GooglePayBtnO.isSelected = true
        
        for i in 0..<(self.CheckoutData?.card?.count ?? 0) {
            self.CheckoutData?.card?[i].SelCrad = 0
        }

        self.CardsTblV.reloadData()
    }
    
}

extension CheckOutVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == AddressTblV{
            return self.SavedAddressList.count
        }else if tableView == CardsTblV{
            return self.CheckoutData?.card?.count ?? 0
        }else{
            return self.CheckoutData?.ingredient?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == AddressTblV{
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddressTblVCell", for: indexPath) as! AddressTblVCell
            
            cell.AddTypeLbl.text = self.SavedAddressList[indexPath.row].type
            
            let apartNo = self.SavedAddressList[indexPath.row].apartNum ?? ""
            let streetNo = self.SavedAddressList[indexPath.row].streetNum ?? ""
            let streetName = self.SavedAddressList[indexPath.row].streetName ?? ""
            let city = self.SavedAddressList[indexPath.row].city ?? ""
            let state = self.SavedAddressList[indexPath.row].state ?? ""
            let country = self.SavedAddressList[indexPath.row].country ?? ""
            let zipcode = self.SavedAddressList[indexPath.row].zipcode ?? ""
            
            if self.SavedAddressList[indexPath.row].type == "Work"{
                cell.ImgV.image = UIImage(named: "work")
                cell.ImgV.tintColor = #colorLiteral(red: 0.9960784314, green: 0.6235294118, blue: 0.2705882353, alpha: 1)
            }else{
                cell.ImgV.image = UIImage(named: "HomeIcon")
            }
  
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
            
            cell.EditBtn.tag = indexPath.row
            cell.EditBtn.addTarget(self, action: #selector(EditAddressBtnTapped(sender:)), for: .touchUpInside)
            
            return cell
        }else if tableView == CardsTblV{
            let cell = tableView.dequeueReusableCell(withIdentifier: "CardCell", for: indexPath) as! CardCell
            
            cell.CardNumber.text = "**** **** **** \(self.CheckoutData?.card?[indexPath.row].cardNum ?? 0)"
            
            cell.CArdImg.image = UIImage(named: "Card")
            
            // pick image from stripe.
            let card = self.CheckoutData?.card?[indexPath.row].type ?? ""
            let crdbrnd = STPCard.brand(from: card)
            
            let cardImage = STPImageLibrary.cardBrandImage(for: crdbrnd)
            cell.CArdImg.image = cardImage
            
            cell.CardName.text = self.CheckoutData?.card?[indexPath.row].type ?? ""
            
            if self.CheckoutData?.card?[indexPath.row].status == 1{
                cell.PrefferedLbl.text = "Preffered"
            }else{
                cell.PrefferedLbl.text = ""
            }
            
         
            let selCard = self.CheckoutData?.card?[indexPath.row].SelCrad ?? 0
             
          //  cell.RadioBtn.isSelected = false
            
                if selCard == 0 {
                    cell.RadioBtn.isSelected = false
                } else if selCard == 1 {
                    cell.RadioBtn.isSelected = true
                } else {
                    cell.RadioBtn.isSelected = false
                }
          
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ItemsTblVCell", for: indexPath) as! ItemsTblVCell
            let val = self.CheckoutData?.ingredient?[indexPath.row]
            
            cell.ItemNameLbl.text = val?.proName ?? ""
            
            cell.itemCountLbl.text = "\(val?.schID ?? 1)"
            
            cell.PriceLbl.text = val?.proPrice ?? ""
            
            return cell
        }
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
        }else if tableView == CardsTblV{
            self.ApplePayBtnO.isSelected = false
            self.GooglePayBtnO.isSelected = false
            
            for i in 0..<(self.CheckoutData?.card?.count ?? 0) {
                self.CheckoutData?.card?[i].SelCrad = 0
            }
            
           // self.CheckoutData?.card?[indexPath.row].status = 1
            self.CheckoutData?.card?[indexPath.row].SelCrad = 1
             
            self.CardsTblV.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == AddressTblV{
            return 55
        }else{
            return 50
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return UITableView.automaticDimension
    }
}

extension CheckOutVC{
    
    func getCheckoutListData() {
        var params:JSONDictionary = [:]
        
//        params["latitude"] = AppLocation.lat
//        params["longitude"] = AppLocation.long
        
        showIndicator(withTitle: "", and: "")
         
        let loginURL = baseURL.baseURL + appEndPoints.checkout
        print(params,"Params")
        print(loginURL,"loginURL")
        
        
        WebService.shared.postServiceURLEncoding(loginURL, VC: self, andParameter: params, withCompletion: { (json, statusCode) in
            
            self.hideIndicator()
            
            let data = try! json.rawData()
            do{
                
                let d = try JSONDecoder().decode(checkoutModelClass.self, from: data)
                if d.success == true {
                    
                    let allData = d.data
                      
                    self.CheckoutData = allData ?? checkoutModelData()
                    
                    for i in 0..<(self.CheckoutData?.card?.count ?? 0){
                        let status = self.CheckoutData?.card?[i].status ?? 0
                        if status == 1{
                            self.CheckoutData?.card?[i].SelCrad = 1
                        }
                    }
                     
                    
                    let DropOff = self.CheckoutData?.note?.pickup ?? ""
                    self.DropOffLbl.text = DropOff
                    
                    let phone = "\(self.CheckoutData?.countryCode ?? "")\(self.CheckoutData?.phone ?? "")"
                
                    let fPhone = phone.replace(string: "+", withString: "")
             
                    let phonenumber = self.formatNewPhoneNumber(fPhone, with: "+X-XXX-XXX-XXXX")
                    self.ContactTxtF.text = phonenumber
                     
                    self.DeliveryTimeLbl.text = self.CheckoutData?.estimatedTime ?? ""
                    
                    self.StandardTimeLbl.text = self.CheckoutData?.estimatedTime ?? ""
                    
                    self.AddressTypeLbl.text = "Set \(self.CheckoutData?.address?.type ?? "")"
                    
                    let ApprtNum = self.CheckoutData?.address?.apartNum ?? ""
                     
                    
                    if ApprtNum != "" {
                        let fullAddress = "\(self.CheckoutData?.address?.apartNum ?? ""),\(self.CheckoutData?.address?.streetNum ?? "") \(self.CheckoutData?.address?.streetName ?? "")\(self.CheckoutData?.address?.city ?? "")\(self.CheckoutData?.address?.state ?? ""),\(self.CheckoutData?.address?.country ?? ""),\(self.CheckoutData?.address?.zipcode ?? "")"
                         
                        self.SethomeAddressLbl.text = fullAddress
                    }else{
                        let fullAddress = "\(self.CheckoutData?.address?.apartNum ?? "")\(self.CheckoutData?.address?.streetNum ?? "") \(self.CheckoutData?.address?.streetName ?? "")\(self.CheckoutData?.address?.city ?? "")\(self.CheckoutData?.address?.state ?? ""),\(self.CheckoutData?.address?.country ?? ""),\(self.CheckoutData?.address?.zipcode ?? "")"
                         
                        self.SethomeAddressLbl.text = fullAddress
                    }
                    
                    
                    
                    self.MarketNameLbl.text = self.CheckoutData?.store ?? ""
                    self.marketTotalItemLbl.text = "\(self.CheckoutData?.ingredientCount ?? 0) items"
                    
                    let img = self.CheckoutData?.storeImage ?? ""
                    let imgUrl = URL(string: img)
                    
                    self.MarketImg.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
                    self.MarketImg.sd_setImage(with: imgUrl, placeholderImage: UIImage(named: "No_Image"))
                    
                    let netTotal = self.CheckoutData?.netTotal ?? 0
                    let FnetTotal = self.formatPrice(netTotal)
                    self.SubtotalDiscountPriceLbl.text = "$\(FnetTotal)"
                    
                    let TaxFee = self.CheckoutData?.tax ?? 0
                    let FTaxFee = self.formatPrice(TaxFee)
                    self.TaxLbl.text = "$\(FTaxFee)"
                    
                    //self.FeeLbl.text = "$\(FFee)"
                    
                    let Fee = self.CheckoutData?.processing ?? 0
                    let FFee = self.formatPrice(Fee)
                    self.ProcessingLbl.text = "$\(FFee)"
                     
                    
                    let DeliveryFee = self.CheckoutData?.delivery ?? 0
                    let FDeliveryFee = self.formatPrice(DeliveryFee)
                    self.DeliveryPriceLbl.text = "$\(FDeliveryFee)"
                    
                    let ScheduleDisc = self.CheckoutData?.offer ?? ""
                    self.ScheduleDiscount = ScheduleDisc
                    self.ScheduleSavingPriceLbl.text = "$\(ScheduleDisc)"
                    
                    let TotalPrice = self.CheckoutData?.total ?? 0
                    
                    let FScheduleDisc = Double(ScheduleDisc) ?? 0
                    
                    let FinalTopatPric = TotalPrice - FScheduleDisc
                    
                    let FTotalPrice = self.formatPrice(FinalTopatPric)
                    self.TotalPriceLbl.text = "$\(FTotalPrice)"
                    
                 
                    self.CardsTblV.reloadData()
                    
                    self.itemsTblV.reloadData()
                    
                    
                    let lat = Double(self.CheckoutData?.address?.latitude ?? "") ?? 0.0
                    let long = Double(self.CheckoutData?.address?.longitude ?? "") ?? 0.0
                    
                    let center = CLLocationCoordinate2D(latitude: lat, longitude: long)
                    let marker = GMSMarker()
                    marker.position = center
                    marker.title = "current location"
                    marker.map = self.MapView
                    let customImage = UIImage(named: "MarkerIcon")
                    marker.icon = customImage
                    
                    let camera: GMSCameraPosition = GMSCameraPosition.camera(withLatitude: lat, longitude: long, zoom: Float(14.0))
                    self.MapView.animate(to: camera)
                     
                }else{
                    
                    let msg = d.message ?? ""
                    self.showToast(msg)
                }
            }catch{
                
                print(error)
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
                        
                        self.PrimaryAddressID = "\(self.SavedAddressList[indx].id ?? 0)"
                        
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
                self.Api_To_get_SavedAddress()
                self.getCheckoutListData()
            }else{
                let responseMessage = dictData["message"] as! String
                self.showToast(responseMessage)
            }
        })
    }
    
    func Api_To_CheckOredrAvailablity(){
        
        var params:JSONDictionary = [:]
        
        
        showIndicator(withTitle: "", and: "")
        
        let loginURL = baseURL.baseURL + appEndPoints.checkavailablity
        
        print(loginURL,"loginURL")
        
        WebService.shared.postServiceURLEncoding(loginURL, VC: self, andParameter: params, withCompletion: { (json, statusCode) in
            
            self.hideIndicator()
            
            guard let dictData = json.dictionaryObject else{
                
                return
            }
            
            if dictData["success"] as? Bool == true{
                var CardOID = ""
                 
                if self.ApplePayBtnO.isSelected == true {
                    CardOID = "ApplePay"
                }else if self.ApplePayBtnO.isSelected == true {
                    CardOID = "GPay"
                }else{
                    if let index = self.CheckoutData?.card?.firstIndex(where: {$0.status == 1}){
                        let cardID = self.CheckoutData?.card?[index].id ?? 0
                        CardOID = "\(cardID)"
                    }
                }
                
                let TotalPrice = self.CheckoutData?.total ?? 0
                let ScheduleDisc = self.CheckoutData?.offer ?? ""
                let FScheduleDisc = Double(ScheduleDisc) ?? 0
                
                let FinalTopatPric = TotalPrice - FScheduleDisc
                
                let storyboard = UIStoryboard(name: "Basket", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "AddTipVC") as! AddTipVC
                vc.totalPrice = FinalTopatPric
                vc.cardID = CardOID
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                let responseMessage = dictData["message"] as! String
                self.AlertControllerOnr(title: responseMessage, message: "")
               // self.showToast(responseMessage)
            }
        })
    }
}

extension CheckOutVC: CLLocationManagerDelegate,GMSMapViewDelegate {
    
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
