//
//  EnterYourAddressVC.swift
//  My Kai
//
//  Created by YES IT Labs on 25/03/25.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation
import DropDown

class EnterYourAddressVC: UIViewController,CLLocationManagerDelegate, UITextFieldDelegate {

    @IBOutlet weak var SearchBgV: UIView!
    @IBOutlet weak var SearchAddTxtF: UITextField!
    
  //  @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var HomeIMg: UIImageView!
    @IBOutlet weak var SetHomeBgV: UIView!
    
    @IBOutlet weak var WorkImg: UIImageView!
    @IBOutlet weak var SetWorkBgV: UIView!
    
    @IBOutlet weak var SetHomeBtnO: UIButton!
    @IBOutlet weak var SetWorkBtnO: UIButton!
    
    @IBOutlet weak var MapView: GMSMapView!
   
    var  moveTime = 0
    
    var comesFrom = ""
 
    var gmsAddress: GMSAddress?
    var zoomCamera : GMSCameraPosition?
    let marker = GMSMarker()
    var locationManager = CLLocationManager()
    let geoCoder = CLGeocoder()
 
  //  var btnLocation : UIButton?
     
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GMSPlacesClient.provideAPIKey("AIzaSyA7f3YXlTD-foNwy7phnJJHCsYDiWgURkQ") // Ensure API Key is provided
        placesClient = GMSPlacesClient.shared() // ✅ Initialize it here
        
        SetHomeBtnO.isSelected = true
        SetHomeBgV.borderColor = #colorLiteral(red: 0.02352941176, green: 0.7568627451, blue: 0.4117647059, alpha: 1)
        SetWorkBtnO.isSelected = false
        SetWorkBgV.borderColor = #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9529411765, alpha: 1)
        WorkImg.tintColor = #colorLiteral(red: 0.9960784314, green: 0.6235294118, blue: 0.2705882353, alpha: 1)
        HomeIMg.image = UIImage(named: "Home1")
        
        
        SearchAddTxtF.delegate = self
        SearchAddTxtF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
      //  searchBtn.addTarget(self, action: #selector(editingChanged(sender:)), for: .touchUpInside)
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
                        
                        getPlaceDetails(placeID: PlaceID)
                    }
                 
                    self.dropDown.show()
                }
            }
        }
    }
    
    
    private func getPlaceDetails(placeID: String) {
//        let request = GMSFetchPlaceRequest(
//            placeID: placeID,
//            placeProperties: ["name", "formatted_address", "coordinate"], // Fetching name & address
//            sessionToken: nil
//        )
        
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
                    
                    self.marker.icon = GMSMarker.markerImage(with: UIColor.clear)
                    self.MapView.clear()
                    UserDetail.shared.setLocationStatus("yes")
                    AppLocation.lat = "\(place.coordinate.latitude)"
                    AppLocation.long = "\(place.coordinate.longitude)"
                    
                    self.reverseGeocodeCoordinate(place.coordinate, placeName: "")
                    
//                    let AddComp = place.addressComponents
//                    
//                    if let addressComponents = AddComp {
//                        self.StreetNo = self.getAddressComponent(for: "street_number", from: addressComponents) ?? ""
//                        self.StreetName = self.getAddressComponent(for: "route", from: addressComponents) ?? ""
//                        self.ApartmentNo = self.getAddressComponent(for: "subpremise", from: addressComponents) ?? ""
//                        self.City = self.getAddressComponent(for: "locality", from: addressComponents) ?? ""
//                        self.State = self.getAddressComponent(for: "administrative_area_level_1", from: addressComponents) ?? ""
//                        self.PostCode = self.getAddressComponent(for: "postal_code", from: addressComponents) ?? ""
//                        self.Address = "\(self.StreetNo) \(self.StreetName), \(self.City), \(self.State), \(self.PostCode)"
//                        
//                        self.country = self.getAddressComponent(for: "country", from: addressComponents) ?? ""
//                        
//                    } else {
//                        self.StreetNo = ""
//                        self.StreetName = ""
//                        self.ApartmentNo = ""
//                        self.City = ""
//                        self.State = ""
//                        self.PostCode = ""
//                        self.Address = ""
//                        self.country = ""
//                    }
                    
                    let center = CLLocationCoordinate2D(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
                    let marker = GMSMarker()
                    marker.position = center
                    marker.title = "current location"
                    marker.map = self.MapView
                    let customImage = UIImage(named: "MarkerIcon")
                    marker.icon = customImage
                    let camera: GMSCameraPosition = GMSCameraPosition.camera(withLatitude: place.coordinate.latitude, longitude: place.coordinate.longitude, zoom: Float(14.0))
                    self.MapView.animate(to: camera)
                    
                } else {
                    print("No address found for this place.")
                }
            }
        })
    }
    
    func getAddressComponent(for type: String, from components: [GMSAddressComponent]) -> String? {
        return components.first(where: { $0.types.contains(type) })?.name
    }

    
    @IBAction func SetHomeBtn(_ sender: UIButton) {
        SetHomeBtnO.isSelected = true
        SetHomeBgV.borderColor = #colorLiteral(red: 0.02352941176, green: 0.7568627451, blue: 0.4117647059, alpha: 1)
        SetWorkBtnO.isSelected = false
        SetWorkBgV.borderColor = #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9529411765, alpha: 1)
        HomeIMg.image = UIImage(named: "HomeIcon")
        WorkImg.tintColor = #colorLiteral(red: 0.5882352941, green: 0.6666666667, blue: 0.631372549, alpha: 1)
    }
     
    
    @IBAction func SetWorkBtn(_ sender: UIButton) {
        SetWorkBtnO.isSelected = true
        SetWorkBgV.borderColor = #colorLiteral(red: 0.02352941176, green: 0.7568627451, blue: 0.4117647059, alpha: 1)
        SetHomeBtnO.isSelected = false
        SetHomeBgV.borderColor = #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9529411765, alpha: 1)
        WorkImg.tintColor = #colorLiteral(red: 0.9960784314, green: 0.6235294118, blue: 0.2705882353, alpha: 1)
        HomeIMg.image = UIImage(named: "Home1")
    }
    
    @IBAction func TurnOnLocationBtn(_ sender: UIButton) {
        getUserLocation()
    }
    
    @IBAction func EditPinBtn(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AddressOnMapVC") as! AddressOnMapVC
        if SetHomeBtnO.isSelected == true{
            vc.AddressType = "Home"
        }else{
            vc.AddressType = "Work"
        }
        
        vc.StreetName = self.StreetName
        vc.StreetNo = self.StreetNo
        vc.ApartmentNo = self.ApartmentNo
        vc.City = self.City
        vc.State = self.State
        vc.Address = self.Address
        vc.PostCode = self.PostCode
        vc.country = self.country
         
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    @IBAction func ConfirmLocationBtn(_ sender: UIButton) {
        
        if SearchAddTxtF.text! == ""{
            AlertControllerOnr(title: "", message: "Enter Your Address")
        }else{
            let storyboard = UIStoryboard(name: "Login", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "ConfirmYourAddressVC") as! ConfirmYourAddressVC
            if SetHomeBtnO.isSelected == true{
                vc.AddressType = "Home"
            }else{
                vc.AddressType = "Work"
            }
            vc.StreetName = self.StreetName
            vc.StreetNo = self.StreetNo
            vc.ApartmentNo = self.ApartmentNo
            vc.City = self.City
            vc.State = self.State
            vc.Address = self.Address
            vc.PostCode = self.PostCode
            vc.country = self.country
            vc.comesfrom = comesFrom
            self.navigationController?.pushViewController(vc, animated: true)
        }
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
    
    func showCurrentLocation() {
        MapView.settings.myLocationButton = true
        marker.icon = GMSMarker.markerImage(with: UIColor.clear)
        MapView.clear()
        let locationObj = locationManager.location!
        let coord = locationObj.coordinate
        let lattitude = coord.latitude
        let longitude = coord.longitude
        print(" lat in  updating \(lattitude) ")
        print(" long in  updating \(longitude)")
        AppLocation.lat = "\(lattitude)"
        AppLocation.long = "\(longitude)"

        let center = CLLocationCoordinate2D(latitude: locationObj.coordinate.latitude, longitude: locationObj.coordinate.longitude)
        let marker = GMSMarker()
        marker.position = center
        marker.title = "current location"
        marker.map = MapView
        let customImage = UIImage(named: "MarkerIcon")
        marker.icon = customImage
       // marker.icon = GMSMarker.markerImage(with: UIColor.orange)
        
        let camera: GMSCameraPosition = GMSCameraPosition.camera(withLatitude: lattitude, longitude: longitude, zoom: Float(14.0))
        self.MapView.animate(to: camera)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        locationManager.stopUpdatingLocation()
        let location = locations.last! as CLLocation
        let loca = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        if moveTime == 0 {
            moveTime = 1
           // UserDefaults.standard.setValue(5, forKey: "Skip")
            
            print(loca.latitude,loca.longitude)
            UserDetail.shared.setLocationStatus("yes")
            AppLocation.lat = "\(loca.latitude)"
            AppLocation.long = "\(loca.longitude)"
            
            MapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // Check the authorization status first
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            // Safe to start location updates
            DispatchQueue.main.async {
                self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
                self.locationManager.startUpdatingLocation()
            }
        }
        
        MapView.isMyLocationEnabled = true
        MapView.settings.myLocationButton = true
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
           
            // 4
            UIView.animate(withDuration: 0.25) {
                self.view.layoutIfNeeded()
                
            }
        }
    }
}

//extension EnterYourAddressVC {
//    @objc private func editingChanged(sender: UIButton) {
//        if sender == searchBtn{
//            btnLocation = sender
//            //    }
//            //    // Present the Autocomplete view controller when the button is pressed.
//            let autocompleteController = GMSAutocompleteViewController()
//            autocompleteController.delegate = self
//            // Specify the place data types to return.
//            let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt64(GMSPlaceField.name.rawValue) | UInt64(GMSPlaceField.placeID.rawValue) | UInt64(GMSPlaceField.all.rawValue) | UInt64(GMSPlaceField.coordinate.rawValue))
//            autocompleteController.placeFields = fields
//            
//            // Specify a filter.
//            let filter = GMSAutocompleteFilter()
//            filter.types = .none
//            autocompleteController.autocompleteFilter = filter
//            //filter.types = ["address"]
//            autocompleteController.autocompleteFilter = filter
//            // Display the autocomplete view controller.
//            present(autocompleteController, animated: true, completion: nil)
//        }
//    }
//}

//extension EnterYourAddressVC : GMSAutocompleteViewControllerDelegate {
//    // Handle the user's selection.
//    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
//        
//        print("Place name: \(String(describing: place.name))")
//        print("Place ID: \(String(describing: place.placeID))")
//        print("Place attributions: \(String(describing: place))")
//        print("Place coordinate: \(String(describing: place.coordinate))")
//        var locality = ""
//        var sublocality_level_2 = ""
//        var sublocality_level_1 = ""
//        var administrative_area_level_2 = ""
//        var administrative_area_level_1 = ""
//        var country = ""
//        var postal_code = ""
//        
//        if let address_components = place.addressComponents {
//            print(address_components, "Addr")
//            //  Place coordinate: CLLocationCoordinate2D(latitude: 28.5729847, longitude: 77.32490430000001)
//            for item in address_components {
//                if item.types.contains("locality") {
//                    locality = item.name
//                }else if item.types.contains("sublocality_level_1") {
//                    sublocality_level_1 = item.name
//                }else if item.types.contains("sublocality_level_2") {
//                    sublocality_level_2 = item.name
//                }else if item.types.contains("administrative_area_level_1") {
//                    administrative_area_level_1 = item.name
//                }else if item.types.contains("administrative_area_level_2") {
//                    administrative_area_level_2 = item.name
//                }else if item.types.contains("country") {
//                    country = item.name
//                }else if item.types.contains("postal_code") {
//                    postal_code = item.name
//                }
//            }
//        }
//        let f = place.name! + " " + locality + " " + administrative_area_level_1 + "," + country
//        // self.addressLabel.text = f
//        if self.searchBtn == self.btnLocation {
//            let newadd =  place.formattedAddress ?? ""
//            marker.icon = GMSMarker.markerImage(with: UIColor.clear)
//            MapView.clear()
//            self.SearchAddTxtF.text = newadd
//            //self.txt_Location.textColor = UIColor.white
//            DispatchQueue.main.async {
//                print(place.coordinate.latitude, place.coordinate.longitude)
//            }
//            
//            UserDetail.shared.setLocationStatus("yes")
//            AppLocation.lat = "\(place.coordinate.latitude)"
//            AppLocation.long = "\(place.coordinate.longitude)"
//            
//            let center = CLLocationCoordinate2D(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
//            let marker = GMSMarker()
//            marker.position = center
//            marker.title = "current location"
//            marker.map = MapView
//            let customImage = UIImage(named: "MarkerIcon")
//            marker.icon = customImage
//            let camera: GMSCameraPosition = GMSCameraPosition.camera(withLatitude: place.coordinate.latitude, longitude: place.coordinate.longitude, zoom: Float(14.0))
//            self.MapView.animate(to: camera)
//            
//        }
//        dismiss(animated: true)
//    }
//    
//    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
//        // TODO: handle the error.
//        print("Error: ", error.localizedDescription)
//    }
//    // User canceled the operation.
//    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
//        dismiss(animated: true, completion: nil)
//    }
//    
//    
//}
