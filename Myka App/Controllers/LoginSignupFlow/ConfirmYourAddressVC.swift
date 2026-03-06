//
//  ConfirmYourAddressVC.swift
//  My Kai
//
//  Created by YES IT Labs on 04/04/25.
//

import UIKit
import Alamofire
import CoreLocation

class ConfirmYourAddressVC: UIViewController {
    
    @IBOutlet weak var StreetNameTxtF: UITextField!
    @IBOutlet weak var StreetNoTxtF: UITextField!
    @IBOutlet weak var ApartmentNumTxtF: UITextField!
    @IBOutlet weak var CityTxtF: UITextField!
    @IBOutlet weak var StateTxtF: UITextField!
    @IBOutlet weak var AddressTxtF: UITextField!
    @IBOutlet weak var PostalCodeTxtF: UITextField!
    
    var comesfrom = ""
    
    var StreetName = ""
    var StreetNo = ""
    var ApartmentNo = ""
    var City = ""
    var State = ""
    var Address = ""
    var PostCode = ""
    var AddressType = ""
    var country = ""
    
    var ID = ""
    var moveTime = 0

    var BackAction:(Int)->() = {_ in}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.StreetNameTxtF.text = self.StreetName
        self.StreetNoTxtF.text = self.StreetNo
        self.ApartmentNumTxtF.text = self.ApartmentNo
        self.CityTxtF.text = self.City
        self.StateTxtF.text = self.State
        self.AddressTxtF.text = self.Address
        self.PostalCodeTxtF.text = self.PostCode
        fetchCityFromCoordinates()
    }
    
    @IBAction func CrossBtn(_ sender: UIButton) {
        moveTime = 0
        self.BackAction(moveTime)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func ConfirmBtn(_ sender: UIButton) {
        guard validation() else { return }
        
        self.Api_To_SaveAddress()
    }
    
    func validation() -> Bool {
        if StreetNameTxtF.text == ""{
            AlertControllerOnr(title: "", message: "Enter street name first.")
            return false
        }else if StreetNoTxtF.text == ""{
            AlertControllerOnr(title: "", message: "Enter street number first.")
            return false
        }else if CityTxtF.text == ""{
            AlertControllerOnr(title: "", message: "Enter city first.")
            return false
        }else if StateTxtF.text == ""{
            AlertControllerOnr(title: "", message: "Enter state first.")
            return false
        }else if AddressTxtF.text == ""{
            AlertControllerOnr(title: "", message: "Enter address first.")
            return false
        }else if PostalCodeTxtF.text == ""{
            AlertControllerOnr(title: "", message: "Enter postal code first.")
            return false
        }
       
        return true
    }
    
    func fetchCityFromCoordinates() {
        let latitude = Double(AppLocation.lat) ?? 0.0
        let longitude = Double(AppLocation.long) ?? 0.0
        
        guard latitude != 0.0 && longitude != 0.0 else { return }
        
        let location = CLLocation(latitude: latitude, longitude: longitude)
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            guard let self = self else { return }
            
            if let place = placemarks?.first {
                DispatchQueue.main.async {
                    if self.CityTxtF.text?.isEmpty ?? true {
                        self.CityTxtF.text = place.locality
                    }
                    if self.StateTxtF.text?.isEmpty ?? true {
                        self.StateTxtF.text = place.administrativeArea
                    }
                }
            }
        }
    }
}

extension ConfirmYourAddressVC {
    
    func Api_To_SaveAddress(){
        var params = [String: Any]()
        
        params["latitude"] = "\(AppLocation.lat)"
        params["longitude"] = "\(AppLocation.long)"
        params["street_name"] = self.StreetNameTxtF.text ?? ""
        params["street_num"] = self.StreetNoTxtF.text ?? ""
        params["apart_num"] = self.ApartmentNumTxtF.text ?? ""
        params["city"] = self.CityTxtF.text ?? ""
        params["state"] = self.StateTxtF.text ?? ""
        params["country"] = self.country
        params["zipcode"] = self.PostalCodeTxtF.text ?? ""
        params["primary"] = "1"
        params["id"] = self.ID
        
        params["type"] = self.AddressType
        
        
        showIndicator(withTitle: "", and: "")
        
        let loginURL = baseURL.baseURL + appEndPoints.add_address
        print(params,"Params")
        print(loginURL,"loginURL")
        
        WebService.shared.postServiceURLEncoding(loginURL, VC: self, andParameter: params, withCompletion: { (json, statusCode) in
            
            self.hideIndicator()
            
            guard let dictData = json.dictionaryObject else{
                return
            }
            
            if dictData["success"] as? Bool == true{
                if self.comesfrom == "Basket"{
                    self.navigationController?.popToViewController(ofClass: BasketNewVC.self)
                }else if self.comesfrom == "CheckOutVC"{
                    let data:[String: String] = ["data": "Reload"]
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "notificationName"), object: nil, userInfo: data)

                    self.navigationController?.popToViewController(ofClass: CheckOutVC.self)
                }else{
                    let storyboard = UIStoryboard(name: "Login", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "TurnonNotificationVC") as! TurnonNotificationVC
                    vc.comesfrom = self.comesfrom
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }else{
                let responseMessage = dictData["message"] as! String
                 
                    // self.showToast(responseMessage)
//                if self.comesfrom == "Basket"{
//                 //  se
//                    self.navigationController?.popToViewController(ofClass: BasketVC.self)
//                }else if self.comesfrom == "CheckOutVC"{
//                    self.navigationController?.popToViewController(ofClass: CheckOutVC.self)
//                }else{
//                    let storyboard = UIStoryboard(name: "Login", bundle: nil)
//                    let vc = storyboard.instantiateViewController(withIdentifier: "TurnonNotificationVC") as! TurnonNotificationVC
//                    vc.comesfrom = self.comesfrom
//                    self.navigationController?.pushViewController(vc, animated: true)
//                }
                
                self.navigationController?.AlertControllerOnr(title: "", message: responseMessage)
            }
        })
    }
}
