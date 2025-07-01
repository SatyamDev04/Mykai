//
//  planApi's.swift
//  My Kai
//
//  Created by YES IT Labs on 05/06/25.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

class planService {
    
    static let shared = planService()
 
    func Api_To_GetAllRecipe(vc: UIViewController, completion: @escaping (Result<PlanDataClass?, Error>) -> Void) {
            var params = [String: Any]()
         
                params["q"] = "q"
         
        vc.showIndicator(withTitle: "", and: "")
            
            let loginURL = baseURL.baseURL + appEndPoints.all_recipe
            print(params,"Params")
            print(loginURL,"loginURL")
            
            WebService.shared.postServiceURLEncoding(loginURL, VC: vc, andParameter: params, withCompletion: { (json, statusCode) in
                
                vc.hideIndicator()
            
                let data = try! json.rawData()
                
                do{
                    let d = try JSONDecoder().decode(PlanModelClass.self, from: data)
                    if d.success == true {
                        completion(.success(d.data))
                    }else{
                        completion(.failure("failed" as! Error))
                        let msg = d.message ?? ""
                        vc.showToast(msg)
                    }
                }catch{
                    completion(.failure(error))
                    print(error)
                }
            })
        }
  
    func Api_To_Like_UnlikeRecipe(uri: String, type: String, vc: UIViewController, completion: @escaping (Result<NSDictionary?, Error>) -> Void) {
            var params = [String: Any]()
                params["uri"] = uri
                params["type"] = type
            
        
            
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
                    completion(.success(dictData as NSDictionary))
                   }else{
                       let responseMessage = dictData["message"] as? String ?? ""
                       vc.showToast(responseMessage)
                   }
              })
             }
        
    func Api_To_AddToBasket_Recipe(uri: String, type: String, vc: UIViewController, completion: @escaping (Result<NSDictionary?, Error>) -> Void) {
            var params = [String: Any]()
                params["uri"] = uri
                params["quantity"] = ""
                params["type"] = type
            
            
        vc.showIndicator(withTitle: "", and: "")
            
            let loginURL = baseURL.baseURL + appEndPoints.add_to_basket
            print(params,"Params")
            print(loginURL,"loginURL")
            
            WebService.shared.postServiceURLEncoding(loginURL, VC: vc, andParameter: params, withCompletion: { (json, statusCode) in
                
                vc.hideIndicator()
                
                
                guard let dictData = json.dictionaryObject else{
                    return
                }
            
                if dictData["success"] as? Bool == true{
                    completion(.success(dictData as NSDictionary))
                    vc.showToast("Added to basket.")
                   }else{
                       let responseMessage = dictData["message"] as? String ?? ""
                       vc.showToast(responseMessage)
                   }
              })
             }
 
    func Api_For_AddToPlan(uri: String, type: String, SerArray: [[String: String]], vc: UIViewController, completion: @escaping (Result<NSDictionary?, Error>) -> Void) {
            
                let paramsDict: [String: Any] = [
                    "type": type,
                    "uri": uri,
                    "slot": SerArray
                ]
          
            
        vc.showIndicator(withTitle: "", and: "")
            
            let loginURL = baseURL.baseURL + appEndPoints.AddMeal
            print(paramsDict, "Params")
            print(loginURL, "loginURL")
            
            if let jsonData = JSONStringEncoder().encode(paramsDict) {
                
                WebService.shared.postServiceRaw(loginURL, VC: vc, jsonData: jsonData) { (json, statusCode) in
                    vc.hideIndicator()
                    
                    guard let dictData = json.dictionaryObject else {
                        return
                    }
                    
                    let Msg = dictData["message"] as? String ?? ""
                    
                    if dictData["success"] as? Bool == true {
                        completion(.success(dictData as NSDictionary))
                        vc.showToast(Msg)
                    } else {
                        vc.showToast(Msg)
                    }
                }
            }else{
                print("Failed to encode JSON.")
                vc.hideIndicator()
                vc.showToast("An error occurred while preparing the request.")
            }
        }
 
    func Api_To_GetAllRecipeByDate(Sdate: String, vc: UIViewController, completion: @escaping (Result<YourCookedMealModel?, Error>) -> Void) {
            var params = [String: Any]()
           
            params["date"] = Sdate
            params["plan_type"] = "0"
           
            
        vc.showIndicator(withTitle: "", and: "")
            
            let loginURL = baseURL.baseURL + appEndPoints.get_meals
            print(params,"Params")
            print(loginURL,"loginURL")
            
            WebService.shared.postServiceURLEncoding(loginURL, VC: vc, andParameter: params, withCompletion: { (json, statusCode) in
                
                vc.hideIndicator()
                
                let data = try! json.rawData()
                
                do{
                    let d = try JSONDecoder().decode(YourCookedMealModelClass.self, from: data)
                    if d.success == true {
                    let list = d.data
                        completion(.success(d.data))
                    }else{
                    
                        let msg = d.message ?? ""
                        vc.showToast(msg)
                    }
                }catch{
                    completion(.failure(error))
                    print(error)
                }
            })
        }
        
       
    func Api_For_AddServingcount(uri: String, type: String, servingCount: Int, seldate: Date, vc: UIViewController, completion: @escaping (Result<NSDictionary?, Error>) -> Void) {
           
            let dateformatter = DateFormatter()
            
            var SerArray = [[String: String]]()
            
                let date = seldate
                dateformatter.dateFormat = "yyyy-MM-dd"
                let Sdate = dateformatter.string(from: date)
                
                dateformatter.dateFormat = "EEEE" // Full day name, e.g., "Monday"
                let dayOfWeek = dateformatter.string(from: date)
             
                    print("\(dayOfWeek), \(Sdate) is selected!")
                    
                let dictionary1: [String: String] = ["date": Sdate, "day": dayOfWeek]
                    SerArray.append(dictionary1)
            
            
            print(SerArray)
            
            
                let paramsDict: [String: Any] = [
                    "type": type,
                    "uri": uri,
                    "slot": SerArray,
                    "servings": servingCount
                ]
          
            
            let token = UserDetail.shared.getTokenWith()
          
            
        vc.showIndicator(withTitle: "", and: "")
            
            let loginURL = baseURL.baseURL + appEndPoints.AddMeal
            print(paramsDict, "Params")
            print(loginURL, "loginURL")
            
            if let jsonData = JSONStringEncoder().encode(paramsDict) {
                
                WebService.shared.postServiceRaw(loginURL, VC: vc, jsonData: jsonData) { (json, statusCode) in
                    vc.hideIndicator()
                    
                    guard let dictData = json.dictionaryObject else {
                        return
                    }
                    
                    let Msg = dictData["message"] as? String ?? ""
                    
                    if dictData["success"] as? Bool == true {
                        completion(.success(dictData as NSDictionary))
                        vc.showToast(Msg)
                    } else {
                        vc.showToast(Msg)
                    }
                }
            }else{
                print("Failed to encode JSON.")
                vc.hideIndicator()
                vc.showToast("An error occurred while preparing the request.")
            }
        }
  
 
    func Api_To_GetPrefrenceBodyGoals(vc: UIViewController, completion: @escaping (Result<[[String : Any]], Error>) -> Void) {
            var params = [String: Any]()

             
         //   showIndicator(withTitle: "", and: "")
            
            let loginURL = baseURL.baseURL + appEndPoints.Getprefrence
            print(params,"Params")
            print(loginURL,"loginURL")
            
            WebService.shared.postServiceURLEncoding(loginURL, VC: vc, andParameter: params, withCompletion: { (json, statusCode) in
                
              //  self.hideIndicator()
                
                guard let dictData = json.dictionaryObject else{
                    return
                }
                
                if dictData["success"] as? Bool == true{
                    let result = dictData["data"] as? NSDictionary ?? NSDictionary()
                    
                    let responseArray = result["mealroutine"] as? [[String : Any]] ?? [[String: Any]]()
                    
                    completion(.success(responseArray))
                }else{
                    let responseMessage = dictData["message"] as! String
                    vc.showToast(responseMessage)
                }
            })
        }
        
    func Api_To_UpdatePrefrence(SelMealRoutineArr: [String], vc: UIViewController, completion: @escaping (Result<NSDictionary?, Error>) -> Void) {
            var params : [String:Any] = [:]
             
            params["meal_routine_id"] = SelMealRoutineArr
     
            let token  = UserDetail.shared.getTokenWith()
            let headers: HTTPHeaders = [
                "Authorization": "Bearer \(token)"
            ]
            
            
            
            let loginURL = baseURL.baseURL + appEndPoints.Updateprefrence
            
        vc.showIndicator(withTitle: "", and: "")
            
            AF.upload(multipartFormData: { multipartFormData in
                for (key, value) in params {
                    if let temp = value as? String {
                        multipartFormData.append(temp.data(using: .utf8)!, withName: key)
                    }
                    if let temp = value as? Int {
                        multipartFormData.append("\(temp)".data(using: .utf8)!, withName: key)
                    }
                    if let temp = value as? NSArray {
                        temp.forEach({ element in
                            let keyObj = key + "[]"
                            if let string = element as? String {
                                multipartFormData.append(string.data(using: .utf8)!, withName: keyObj)
                            } else
                            if let num = element as? Int {
                                let value = "\(num)"
                                multipartFormData.append(value.data(using: .utf8)!, withName: keyObj)
                            }
                        })
                    }
                }
            },to: loginURL, method: .post , headers: headers)
            .responseJSON(completionHandler: { (encodingResult) in
                vc.hideIndicator()
                
                do {
                    if let err = encodingResult.error{
                        //                    if loader { CommonFunctions.hideActivityLoader() }
                        
                        if (err as NSError).code == NSURLErrorNotConnectedToInternet {
                            
                        }
                        print(err as NSError)
                        if let f = encodingResult.data {
                            print("Print Server Error: " + String(data: f, encoding: String.Encoding.utf8)!)
                        }
                        
                        return
                    }
               
                    print(encodingResult.data!)
                    let value = try JSON(data: encodingResult.data!)
                    print(JSON(value))
                    
                    guard  let dict = value.dictionaryObject else {
                        return
                    }
                    if (dict["success"] as? Bool) == true {
                        completion(.success(dict as NSDictionary))
                    }else{
                       let msg = dict["msg"] as? String ?? ""
                        vc.showToast(msg)
                    }
                }catch {
                    vc.hideIndicator()
                    print("===================== FAILURE =======================")
                    print(error.localizedDescription)
                    
                }
            })
        }
        
        func Api_To_Get_ProfileData(vc: UIViewController, completion: @escaping (Result<NSDictionary?, Error>) -> Void) {

            var params = [String: Any]()
           
           
            let token  = UserDetail.shared.getTokenWith()
       
            
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
         
    func Api_To_Swap(uri: String, swipeID: String, vc: UIViewController, completion: @escaping (Result<NSDictionary?, Error>) -> Void) {
            var params = [String: Any]()
            
            params["uri"] = uri
            params["id"] = swipeID
    //        params["cook_book"] = self.selID
      
            
        vc.showIndicator(withTitle: "", and: "")
            
            let loginURL = baseURL.baseURL + appEndPoints.swap
            print(params,"Params")
            print(loginURL,"loginURL")
            
            WebService.shared.postServiceURLEncoding(loginURL, VC: vc, andParameter: params, withCompletion: { (json, statusCode) in
                
                vc.hideIndicator()
           
                
                guard let dictData = json.dictionaryObject else{
                    return
                }
            
                if dictData["success"] as? Bool == true{
                    completion(.success(dictData as NSDictionary))
                    let responseMessage = dictData["message"] as? String ?? ""
                    vc.showToast(responseMessage)
                     
                   }else{
                       let responseMessage = dictData["message"] as? String ?? ""
                       vc.showToast(responseMessage)
                   }
              })
             }
   

    //add-to-basket-all
 
    func Api_To_AddAllRecipeToBasket(seldate: Date, vc: UIViewController, completion: @escaping (Result<NSDictionary?, Error>) -> Void) {
            var params = [String: Any]()
            
            let df = DateFormatter()
            df.dateFormat = "yyyy-MM-dd"
            let Date = df.string(from: seldate)
            
            
            params["date"] = Date
      
            
        vc.showIndicator(withTitle: "", and: "")
            
            let loginURL = baseURL.baseURL + appEndPoints.add_to_basket_all
            print(params,"Params")
            print(loginURL,"loginURL")
            
            WebService.shared.postServiceURLEncoding(loginURL, VC: vc, andParameter: params, withCompletion: { (json, statusCode) in
                
                vc.hideIndicator()
           
                
                guard let dictData = json.dictionaryObject else{
                    return
                }
            
                if dictData["success"] as? Bool == true{
                    let responseMessage = dictData["message"] as? String ?? ""
                    vc.showToast("Added To Basket successfully")
                  //  self.Api_To_GetAllRecipeByDate()
                    completion(.success(dictData as NSDictionary))
                    
                   }else{
                       let responseMessage = dictData["message"] as? String ?? ""
                       vc.showToast(responseMessage)
                   }
              })
        }

}
