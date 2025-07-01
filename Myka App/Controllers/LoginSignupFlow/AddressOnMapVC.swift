//
//  AddressOnMapVC.swift
//  My Kai
//
//  Created by YES IT Labs on 04/04/25.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation

class AddressOnMapVC: UIViewController {
    
    @IBOutlet weak var SetHomeBgV: UIView!
    @IBOutlet weak var SetWorkBgV: UIView!
    
    @IBOutlet weak var SetHomeBtnO: UIButton!
    @IBOutlet weak var SetWorkBtnO: UIButton!
    @IBOutlet weak var HomeIMg: UIImageView!
    
    
    @IBOutlet weak var WorkImg: UIImageView!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var completeAddLbl: UILabel!
    
    @IBOutlet weak var AddressBgV: UIView!
    
    var comesFrom = ""
 
    var gmsAddress: GMSAddress?
    var zoomCamera : GMSCameraPosition?
    //let marker = GMSMarker()
    var locationManager = CLLocationManager()
    let geoCoder = CLGeocoder()
    
    var AddressType = ""
   // var isMapScrollAddress = true
    var OldAddress = "" // passed from another screen
    var tag = 0 // to check if we pass address from another screen. tag = 1
    //
    
    var StreetName = ""
    var StreetNo = ""
    var ApartmentNo = ""
    var City = ""
    var State = ""
    var Address = ""
    var PostCode = ""
    var country = ""
    var lat = ""
    var long = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mapView.delegate = self
      
            self.locationManager.requestAlwaysAuthorization()
            self.locationManager.requestWhenInUseAuthorization()
            self.locationManager.delegate = self
            //locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            //self.locationManager.distanceFilter = 5
            self.locationManager.distanceFilter = kCLDistanceFilterNone
            self.locationManager.startUpdatingLocation()

        //
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
            AppLocation.lat = self.lat
            AppLocation.long = self.long
            self.showCurrentLocation()
      
        }
        
        if AddressType == "Home"{
            SetHomeBtnO.isSelected = true
            SetHomeBgV.borderColor = #colorLiteral(red: 0.02352941176, green: 0.7568627451, blue: 0.4117647059, alpha: 1)
            SetWorkBtnO.isSelected = false
            SetWorkBgV.borderColor = #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9529411765, alpha: 1)
            HomeIMg.image = UIImage(named: "HomeIcon")
            WorkImg.tintColor = #colorLiteral(red: 0.5882352941, green: 0.6666666667, blue: 0.631372549, alpha: 1)
        }else{
            SetWorkBtnO.isSelected = true
            SetWorkBgV.borderColor = #colorLiteral(red: 0.02352941176, green: 0.7568627451, blue: 0.4117647059, alpha: 1)
            SetHomeBtnO.isSelected = false
            SetHomeBgV.borderColor = #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9529411765, alpha: 1)
            WorkImg.tintColor = #colorLiteral(red: 0.9960784314, green: 0.6235294118, blue: 0.2705882353, alpha: 1)
            HomeIMg.image = UIImage(named: "Home1")
        }
    }
    
    @IBAction func BackActionBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func SetHomeBtn(_ sender: UIButton) {
        SetHomeBtnO.isSelected = true
        SetHomeBgV.borderColor = #colorLiteral(red: 0.02352941176, green: 0.7568627451, blue: 0.4117647059, alpha: 1)
        SetWorkBtnO.isSelected = false
        SetWorkBgV.borderColor = #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9529411765, alpha: 1)
        self.AddressType = "Home"
        HomeIMg.image = UIImage(named: "HomeIcon")
        WorkImg.tintColor = #colorLiteral(red: 0.5882352941, green: 0.6666666667, blue: 0.631372549, alpha: 1)
    }
    
    @IBAction func SetWorkBtn(_ sender: UIButton) {
        SetWorkBtnO.isSelected = true
        SetWorkBgV.borderColor = #colorLiteral(red: 0.02352941176, green: 0.7568627451, blue: 0.4117647059, alpha: 1)
        SetHomeBtnO.isSelected = false
        SetHomeBgV.borderColor = #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9529411765, alpha: 1)
        self.AddressType = "Work"
        WorkImg.tintColor = #colorLiteral(red: 0.9960784314, green: 0.6235294118, blue: 0.2705882353, alpha: 1)
        HomeIMg.image = UIImage(named: "Home1")
    }
    
    @IBAction func ConfirmLocationBtn(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ConfirmYourAddressVC") as! ConfirmYourAddressVC
        vc.StreetName = self.StreetName
        vc.StreetNo = self.StreetNo
        vc.ApartmentNo = self.ApartmentNo
        vc.City = self.City
        vc.State = self.State
        vc.Address = self.Address
        vc.PostCode = self.PostCode
        vc.comesfrom = comesFrom
        vc.AddressType = self.AddressType
        vc.country = self.country
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension AddressOnMapVC: CLLocationManagerDelegate,GMSMapViewDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // 3
        guard status == .authorizedWhenInUse else {
            CLLocationManager.authorizationStatus()
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
                locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                self.locationManager.distanceFilter = 10
                //self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
                self.locationManager.startUpdatingLocation()
                guard let location: CLLocationCoordinate2D = locationManager.location?.coordinate else { return }
          
                AppLocation.lat = "\(location.latitude)"
                AppLocation.long = "\(location.longitude)"

                
                break
            case .authorizedAlways:
                // If always authorized
                manager.startUpdatingLocation()
                //stopTimer()
                self.mapView.delegate = self
                self.locationManager.requestAlwaysAuthorization()
                self.locationManager.requestWhenInUseAuthorization()
                self.locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                self.locationManager.distanceFilter = 10
                //self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
                self.locationManager.startUpdatingLocation()
                guard let location: CLLocationCoordinate2D = locationManager.location?.coordinate else { return }
                AppLocation.lat = "\(location.latitude)"
                AppLocation.long = "\(location.longitude)"
                
                break
            case .restricted, .denied:
                // If restricted by e.g. parental controls. User can't enable Location Services
                // If user denied your app access to Location Services, but can grant access from Settings.app
                // Disable location features
                
                let alert = UIAlertController(title: "Allow Location Access", message: "Roam App needs to access your current location to show data according to your locaton. Turn on Location Services in your device settings.", preferredStyle: UIAlertController.Style.alert)
                
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
        mapView.settings.myLocationButton = true
        // 7
        mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 19, bearing: 0, viewingAngle: 0)
    
        AppLocation.lat = "\(lattitude)"
        AppLocation.long = "\(longitude)"
        // 8
        locationManager.stopUpdatingLocation()
        
//        self.marker.icon = GMSMarker.markerImage(with: UIColor.clear)
//        self.mapView.clear()
        
 //       let center = CLLocationCoordinate2D(latitude: lattitude, longitude: longitude)//CLLocationCoordinate2D(latitude: locationObj.coordinate.latitude, longitude: locationObj.coordinate.longitude)
//        let marker = GMSMarker()
//        marker.position = center
//        marker.title = ""//"current location"
//        marker.map = self.mapView
        //marker.icon = GMSMarker.markerImage(with: UIColor.clear)
        //marker.icon = GMSMarker.markerImage(with: UIColor.red)
    }
    
    func showCurrentLocation() {
        mapView.settings.myLocationButton = true
        let lattitude = Double(AppLocation.lat)
        let longitude = Double(AppLocation.long)
         
        let center = CLLocationCoordinate2D(latitude: lattitude ?? 0.0, longitude: longitude ?? 0.0)

        let camera: GMSCameraPosition = GMSCameraPosition.camera(withLatitude: lattitude ?? 0.0, longitude: longitude ?? 0.0, zoom: Float(19.0))
        self.mapView.animate(to: camera)
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
            self.completeAddLbl.text = lines.joined(separator: "\n")
         
             
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
            
            if self.tag != 0{
                self.completeAddLbl.text = self.OldAddress
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.2){
                        self.tag = 0
                }
            }else{
                self.completeAddLbl.text = lines.joined(separator: "\n")
            }
            
            
            // 4
            UIView.animate(withDuration: 0.25) {
                self.view.layoutIfNeeded()
                
            }
        }
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
//        self.isMapScrollAddress = true
//        let marker = GMSMarker()
//        mapView.clear()
//        marker.position = coordinate
//       // marker.title = self.addressLabel.text!
//       // marker.snippet = ""
//        marker.map = mapView
//       // marker.isTappable = true
//       
//        marker.icon = GMSMarker.markerImage(with: UIColor.red)
//       // self.Loctn = self.addressLabel.text!
//        let lati = coordinate.latitude
//        let longi = coordinate.longitude
//      
//        AppLocation.lat = String(format: "%f", lati)
//        AppLocation.long = String(format: "%f", longi)
//        
//        let center = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
//       
//        marker.position = center
//       // marker.title = "current location"
//        marker.map = mapView
//        marker.icon = GMSMarker.markerImage(with: UIColor.red)
//        let camera: GMSCameraPosition = GMSCameraPosition.camera(withLatitude: coordinate.latitude, longitude: coordinate.longitude, zoom: Float(14.0))
//        self.mapView.animate(to: camera)
    }

    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
//        let marker = GMSMarker()
//        marker.position = position.target
      //  marker.title = self.completeAddLbl.text!
       // self.Loctn = self.addressLabel.text!
    }


    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
     //   if isMapScrollAddress == true {
            reverseGeocodeCoordinate(position.target, placeName: "")
            //reverseGeocodeCoordinate(locationManager.location!.coordinate, placeName: "")
        //    isMapScrollAddress = false
     //   }
    }

    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
      //  addressLabel.lock()
    }
    
    // tap map marker
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        print("didTap marker \(marker.title)")
        // remove color from currently selected marker
//        if let selectedMarker = mapView.selectedMarker {
//            selectedMarker.icon = GMSMarker.markerImage(with: nil)
//        }
        // select new marker and make green
//        mapView.selectedMarker = marker
//        marker.icon = GMSMarker.markerImage(with: UIColor.red)
        // tap event handled by delegate
        return true
    }
}
