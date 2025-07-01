//
//  TurnonLocationVC.swift
//  Myka App
//
//  Created by YES IT Labs on 03/12/24.
//

import UIKit
import CoreLocation
import Alamofire
import GoogleMaps

class TurnonLocationVC: UIViewController,CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager!
    var moveTime = 0
    
    var comesFrom = ""
    
    var isShareLocBtnTapped = false
    
    var StreetName = ""
    var StreetNo = ""
    var ApartmentNo = ""
    var City = ""
    var State = ""
    var Address = ""
    var PostCode = ""
    var country = ""
    var ID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if comesFrom == "Signup" {
            UserDetail.shared.setiSfromSignup(true)
        }
    }
    
    @IBAction func ShareLocBtn(_ sender: UIButton) {
        isShareLocBtnTapped = true
            getUserLocation()
    }

//    @IBAction func NotNowBtn(_ sender: UIButton) {
//        UserDetail.shared.setLocationStatus("no")
//        let storyboard = UIStoryboard(name: "Login", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "TurnonNotificationVC") as! TurnonNotificationVC
//        vc.comesfrom = comesFrom
//        self.navigationController?.pushViewController(vc, animated: true)
//    }

    
    func getUserLocation() {
        requestLocationPermission()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        locationManager.stopUpdatingLocation()
        
        let location = locations.last! as CLLocation
        let loca = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        
        reverseGeocodeCoordinate(latitude: loca.latitude, longitude: loca.longitude)
         
        if moveTime == 0 {
            moveTime = 1
           // UserDefaults.standard.setValue(5, forKey: "Skip")
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5){
                print(loca.latitude,loca.longitude)
                self.hideIndicator()
                
                UserDetail.shared.setLocationStatus("yes")
                AppLocation.lat = "\(loca.latitude)"
                AppLocation.long = "\(loca.longitude)"
                
                let storyboard = UIStoryboard(name: "Login", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "ConfirmYourAddressVC") as! ConfirmYourAddressVC
                vc.AddressType = "Home"
                vc.StreetName = self.StreetName
                vc.StreetNo = self.StreetNo
                vc.ApartmentNo = self.ApartmentNo
                vc.City = self.City
                vc.State = self.State
                vc.Address = self.Address
                vc.PostCode = self.PostCode
                vc.country = self.country
                vc.comesfrom = self.comesFrom
                vc.moveTime = self.moveTime
                vc.BackAction = { moveTime in
                    self.moveTime = moveTime
                }
                
                self.navigationController?.pushViewController(vc, animated: true)
            }
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
        }else if status == .denied || status == .restricted{
            if isShareLocBtnTapped == true{
                let storyboard = UIStoryboard(name: "Login", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "EnterYourAddressVC") as! EnterYourAddressVC
                vc.comesFrom = comesFrom
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }else{
            
        }
    }

    // Check if location services are enabled before requesting location
    func requestLocationPermission() {
      //  DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                self.locationManager = CLLocationManager()
                self.locationManager.delegate = self
                self.locationManager.requestWhenInUseAuthorization() // or requestAlwaysAuthorization depending on your needs
               
            }else{
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
                        }
                    }
                }
            }
        }
     
    
    private func reverseGeocodeCoordinate(latitude: Double, longitude: Double) {
        print(latitude, "lat")
        print(longitude, "long")
        
        self.showIndicator(withTitle: "", and: "")
        
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let geocoder = GMSGeocoder()
        
        geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
            guard let address = response?.firstResult(), let lines = address.lines else {
                print("No address found or error occurred: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
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
            
//            self.hideIndicator()
           // self.Api_To_SaveAddress()
            
            UIView.animate(withDuration: 0.25) {
                self.view.layoutIfNeeded()
            }
        }
    }
    }



//extension TurnonLocationVC{
//    func Api_To_SaveAddress(){
//        var params = [String: Any]()
//        
//        params["latitude"] = "\(AppLocation.lat)"
//        params["longitude"] = "\(AppLocation.long)"
//        params["street_name"] = self.StreetName
//        params["street_num"] = self.StreetNo
//        params["apart_num"] = self.ApartmentNo
//        params["city"] = self.City
//        params["state"] = self.State
//        params["country"] = self.country
//        params["zipcode"] = self.PostCode
//        params["primary"] = "1"
//        params["id"] = self.ID
//        
//        params["type"] = "Home"
//        
//        
//        let token  = UserDetail.shared.getTokenWith()
//        
//        let headers: HTTPHeaders = [
//            "Authorization": "Bearer \(token)"
//        ]
//        
//        showIndicator(withTitle: "", and: "")
//        
//        let loginURL = baseURL.baseURL + appEndPoints.add_address
//        print(params,"Params")
//        print(loginURL,"loginURL")
//        
//        WebService.shared.postServiceURLEncoding(loginURL, VC: self, andParameter: params, headers: headers, withCompletion: { (json, statusCode) in
//            
//            self.hideIndicator()
//            
//            guard let dictData = json.dictionaryObject else{
//                return
//            }
//            
//            if dictData["success"] as? Bool == true{
//                let storyboard = UIStoryboard(name: "Login", bundle: nil)
//                let vc = storyboard.instantiateViewController(withIdentifier: "TurnonNotificationVC") as! TurnonNotificationVC
//                vc.comesfrom = self.comesFrom
//                self.navigationController?.pushViewController(vc, animated: true)
//            }else{
//               
//            }
//        })
//    }
//}
