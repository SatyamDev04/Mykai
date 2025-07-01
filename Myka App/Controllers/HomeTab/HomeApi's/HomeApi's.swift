//
//  HomeApi's.swift
//  My Kai
//
//  Created by YES IT Labs on 05/06/25.
//

import Foundation
import UIKit
// Api For HomeData
class HomeService {
    static let shared = HomeService()
    
    func getHomeData(vc: UIViewController, completion: @escaping (Result<DataClass?, Error>) -> Void) {
        
        vc.showIndicator(withTitle: "", and: "")
        
        var params:JSONDictionary = [:]
        
        let loginURL = baseURL.baseURL + appEndPoints.home_data
        print(params,"Params")
        print(loginURL,"loginURL")
       
        
        WebService.shared.postServiceURLEncoding(loginURL, VC: vc, andParameter: params, withCompletion: { (json, statusCode) in
            //if UserDetail.shared.getiSfromSignup() == false{
                vc.hideIndicator()
           // }
            
            let data = try! json.rawData()
            do{
                
                let d = try JSONDecoder().decode(HomeDataModel.self, from: data)
                if d.success == true {
                     
                    let allData = d.data
                    
                    completion(.success(allData))
                     
                }else{
                    let msg = d.message ?? ""
                    vc.showToast(msg)
                }
            }catch{
                
                print(error)
            }
        })
    }
    
    func Api_To_Get_ProfileData(vc: UIViewController, completion: @escaping (Result<NSDictionary, Error>) -> Void) {
        var params = [String: Any]()
       
       
       // showIndicator(withTitle: "", and: "")
        
        let loginURL = baseURL.baseURL + appEndPoints.getUserProfile
        print(params,"Params")
        print(loginURL,"loginURL")
        
        WebService.shared.postServiceURLEncoding(loginURL, VC: vc, andParameter: params, withCompletion: { (json, statusCode) in
            
          //  self.hideIndicator()
            
            guard let dictData = json.dictionaryObject else{
                return
            }
            
            if dictData["success"] as? Bool == true{
                let response = dictData["data"] as? NSDictionary ?? NSDictionary()
                
                completion(.success(response))
            }else{
                let responseMessage = dictData["message"] as? String ?? ""
                vc.showToast(responseMessage)
            }
        })
    }
    
    func Api_To_UnFAv(uri: String, vc: UIViewController, completion: @escaping (Result<NSDictionary, Error>) -> Void) {
        var params = [String: Any]()
        
        params["uri"] = uri
        params["type"] = 0
//        params["cook_book"] = self.selID
      
        
        vc.showIndicator(withTitle: "", and: "")
        
        let loginURL = baseURL.baseURL + appEndPoints.add_to_favorite
        print(params,"Params")
        print(loginURL,"loginURL")
        
        WebService.shared.postServiceURLEncoding(loginURL, VC: vc, andParameter: params, withCompletion: { (json, statusCode) in
            
            vc.hideIndicator()
            
            guard let dictData = json.dictionaryObject else{
                return
            }
        
            if dictData["success"] as? Bool == true{
                vc.showToast("Removed from favourites successfully!")
                completion(.success(dictData as NSDictionary))
               }else{
                   let responseMessage = dictData["message"] as? String ?? ""
                   vc.showToast(responseMessage)
               }
          })
         }
  
   // MarketModelClass
    func getSuperMarketData(vc: UIViewController, currentPage:Int, completion: @escaping (Result<[MarketModel]?, Error>) -> Void) {
        var params:JSONDictionary = [:]
        
        params["latitude"] = AppLocation.lat
        params["longitude"] = AppLocation.long
        params["page"] = currentPage
        
        vc.showIndicator(withTitle: "", and: "")
        
        let loginURL = baseURL.baseURL + appEndPoints.super_markets
        print(params,"Params")
        print(loginURL,"loginURL")
        
       
        
        WebService.shared.postServiceURLEncoding(loginURL, VC: vc, andParameter: params, withCompletion: { (json, statusCode) in
            
            vc.hideIndicator()
            
            let data = try! json.rawData()
            do{
                
                let d = try JSONDecoder().decode(MarketModelClass.self, from: data)
                if d.success == true {
                    
                    let allData = d.data
          
                    completion(.success(allData))
                    
                }else{
                    
                    let msg = d.message ?? ""
                    vc.showToast(msg)
                }
            }catch{
                
                print(error)
            }
        })
    }
    
    func Api_To_UpdateSuperMarket(vc: UIViewController, selectedStoreID: String, StoreName: String, completion: @escaping (Result<NSDictionary, Error>) -> Void) {
        var params = [String: Any]()
         
        params["store"] = selectedStoreID
        params["store_name"] = StoreName
        
       
        vc.showIndicator(withTitle: "", and: "")
        
        let loginURL = baseURL.baseURL + appEndPoints.Updateprefrence
        print(params,"Params")
        print(loginURL,"loginURL")
        
        WebService.shared.postServiceURLEncoding(loginURL, VC: vc, andParameter: params, withCompletion: { (json, statusCode) in
            
            vc.hideIndicator()
            
            guard let dictData = json.dictionaryObject else{
                return
            }
            
            if dictData["success"] as? Bool == true{
                completion(.success(dictData as NSDictionary))
            }else{
                let responseMessage = dictData["message"] as? String ?? ""
                vc.showToast(responseMessage)
            }
        })
    }
    
    //get-address
    func Api_To_get_SavedAddress(vc: UIViewController, completion: @escaping (Result<[AddressdataModel]?, Error>) -> Void) {
        
       
        vc.showIndicator(withTitle: "", and: "")
        
        let loginURL = baseURL.baseURL + appEndPoints.get_address
        
        print(loginURL,"loginURL")
        
        WebService.shared.postServiceURLEncoding(loginURL, VC: vc, andParameter: [:], withCompletion: { (json, statusCode) in
            
            vc.hideIndicator()
            
            let data = try! json.rawData()
            do{
                
                let d = try JSONDecoder().decode(AddressdataModelClass.self, from: data)
                if d.success == true {
                    
                    let allData = d.data
                    
                    completion(.success(allData))
                }else{
                    let msg = d.message ?? ""
                    vc.showToast(msg)
                }
            }catch{
                
                print(error)
            }
        })
    }
    
    //getSubscriptionDeltails
    
    func Api_To_getSubscriptionDeltails(vc: UIViewController, completion: @escaping (Result<NSDictionary, Error>) -> Void) {
        var params = [String: Any]()
        
  
      //  showIndicator(withTitle: "", and: "")
        
        let loginURL = baseURL.baseURL + appEndPoints.getSubscriptionDeltails
        print(params,"Params")
        print(loginURL,"loginURL")
        
        WebService.shared.postServiceURLEncodingSubscription(loginURL, VC: vc, andParameter: params, withCompletion: { (json, statusCode) in
            
          //  self.hideIndicator()
            
            guard let dictData = json.dictionaryObject else{
                return
            }
            
            if dictData["success"] as? Bool == true{
                let val = dictData["data"] as? NSDictionary ?? NSDictionary()
                
                completion(.success(val))
            }else{
                //let responseMessage = dictData["message"] as? String ?? ""
              //  self.showToast(responseMessage)
            }
        })
    }
}
