//
//  FullCooking_Api's.swift
//  My Kai
//
//  Created by YES IT Labs on 13/06/25.
//

import Foundation

import UIKit
import Alamofire
import SwiftyJSON

//class FullCookingService {
//    
//    static let shared = FullCookingService()
// 
//    func Api_To_GetAllRecipe(vc: UIViewController, completion: @escaping (Result<PlanDataClass?, Error>) -> Void) {
//            var params = [String: Any]()
//         
//                params["q"] = "q"
//         
//        vc.showIndicator(withTitle: "", and: "")
//            
//            let loginURL = baseURL.baseURL + appEndPoints.all_recipe
//            print(params,"Params")
//            print(loginURL,"loginURL")
//            
//            WebService.shared.postServiceURLEncoding(loginURL, VC: vc, andParameter: params, withCompletion: { (json, statusCode) in
//                
//                vc.hideIndicator()
//            
//                let data = try! json.rawData()
//                
//                do{
//                    let d = try JSONDecoder().decode(PlanModelClass.self, from: data)
//                    if d.success == true {
//                        completion(.success(d.data))
//                    }else{
//                        completion(.failure("failed" as! Error))
//                        let msg = d.message ?? ""
//                        vc.showToast(msg)
//                    }
//                }catch{
//                    completion(.failure(error))
//                    print(error)
//                }
//            })
//        }
//  
//    func Api_To_GetAllRecipeByDate(){
//        var params = [String: Any]()
//        let dateformatter = DateFormatter()
//        dateformatter.dateFormat = "yyyy-MM-dd"
//       
//        
//        if tag == 0{
//            params["date"] = ""
//        }else{
//            let Sdate = dateformatter.string(from: seldate)
//            params["date"] = Sdate
//        }
//       
//        params["plan_type"] = "0"
//        
//        showIndicator(withTitle: "", and: "")
//        let loginURL = baseURL.baseURL + appEndPoints.get_schedule_by_random_date//get_schedule
//        
//        WebService.shared.postServiceURLEncoding(loginURL, VC: self, andParameter: params, withCompletion: { (json, statusCode) in
//            
//            self.hideIndicator()
//            
//            let data = try! json.rawData()
//            
//            do{
//                let d = try JSONDecoder().decode(YourCookedMealModelClass.self, from: data)
//                if d.success == true {
//                    let list = d.data
//                    
//                    self.AllDataList  = list ?? YourCookedMealModel()
//                     
//                    self.veryFirstLoading = 0
//                     
//                    if self.tag == 0{
//                        let date = self.AllDataList.date ?? ""
//                        
//                        let df = DateFormatter()
//                        df.dateFormat = "yyyy-MM-dd"
//                        df.locale = Locale(identifier: "en_US_POSIX")
//                        let Ndate = df.date(from: date)
//
//                        self.seldate = Ndate ?? Date()
//
//                        let today = Ndate ?? Date()
//                        self.currentWeekDates = self.calculateWeekDates(for: today)
//                        self.updateWeekLabel()
//
//                        self.updateSelection(at: today)
//                       
//                        }
//                    
//                    
//                    self.ShowNoDataFoundonCollV1()
//                    
//                }else{
//                    self.ShowNoDataFoundonCollV1()
//                    
//                    let msg = d.message ?? ""
//                    self.showToast(msg)
//                }
//            }catch{
//                self.ShowNoDataFoundonCollV1()
//                print(error)
//            }
//        })
//    }
//    
//  
//    func Api_To_RemoveMeal(){
//        var params = [String: Any]()
//         
//        params["id"] = self.selID
//        
//        showIndicator(withTitle: "", and: "")
//        
//        let loginURL = baseURL.baseURL + appEndPoints.remove_meal
//        print(params,"Params")
//        print(loginURL,"loginURL")
//        
//        WebService.shared.postServiceURLEncoding(loginURL, VC: self, andParameter: params, withCompletion: { (json, statusCode) in
//            
//            self.hideIndicator()
//            
//            guard let dictData = json.dictionaryObject else{
//                return
//            }
//            
//            if dictData["success"] as? Bool == true{
//                self.RemovePopupV.isHidden = true
//                
//                if self.Mealtypeclicked == "Breakfast"{
//                    self.AllDataList.breakfast?.remove(at: self.MealtypeSelectedIndex)
//                }else if self.Mealtypeclicked == "Lunch" {
//                    self.AllDataList.lunch?.remove(at: self.MealtypeSelectedIndex)
//                }else if self.Mealtypeclicked == "Dinner" {
//                    self.AllDataList.dinner?.remove(at: self.MealtypeSelectedIndex)
//                }else if self.Mealtypeclicked == "Snacks" {
//                    self.AllDataList.snacks?.remove(at: self.MealtypeSelectedIndex)
//                }else if self.Mealtypeclicked == "Brunch"{
//                    self.AllDataList.teatime?.remove(at: self.MealtypeSelectedIndex)
//                }
//                
//                self.ShowNoDataFoundonCollV1()
//                
//                if self.AllDataList.breakfast?.count ?? 0 == 0 && self.AllDataList.lunch?.count ?? 0 == 0 && self.AllDataList.dinner?.count ?? 0 == 0 && self.AllDataList.snacks?.count ?? 0 == 0 && self.AllDataList.teatime?.count ?? 0 == 0{
//                    self.tag = 0
//                    self.Api_To_GetAllRecipeByDate()
//                }
//                
//                let collectionViews: [UICollectionView] = [self.BreakFastCollV, self.LunchCollV, self.DinnerCollV, self.SnacksCollV, self.TeatimeCollV]
//                for collectionView in collectionViews {
//                    print(collectionView)
//                    self.longPressedEnabled = false
//                    self.stopJiggleAnimationForAllCollectionViews()
//                    return
//                }
//                
//            }else{
//                let responseMessage = dictData["message"] as! String
//                self.showToast(responseMessage)
//            }
//        })
//    }
//    
//    func Api_To_UnFAv(uri: String){
//        var params = [String: Any]()
//        
//        params["uri"] = uri
//        params["type"] = 0
//        //        params["cook_book"] = self.selID
//        
//        showIndicator(withTitle: "", and: "")
//        
//        let loginURL = baseURL.baseURL + appEndPoints.add_to_favorite
//        print(params,"Params")
//        print(loginURL,"loginURL")
//        
//        WebService.shared.postServiceURLEncoding(loginURL, VC: self, andParameter: params, withCompletion: { (json, statusCode) in
//            
//            self.hideIndicator()
//            
//            
//            guard let dictData = json.dictionaryObject else{
//                return
//            }
//            
//            if dictData["success"] as? Bool == true{
//                self.showToast("Removed from favourites successfully!")
//                self.Api_To_GetAllRecipeByDate()
//            }else{
//                let responseMessage = dictData["message"] as? String ?? ""
//                self.showToast(responseMessage)
//            }
//        })
//    }
//    
//    func Api_For_update_meal(id: String, date: Date) {
//        
//        let dateformatter = DateFormatter()
//        dateformatter.dateFormat = "yyyy-MM-dd"
//        let date1 = dateformatter.string(from: date)
//        
//        dateformatter.dateFormat = "EEEE"
//        let Day = dateformatter.string(from: date)
//        //
//        let paramsDict: [String: Any] = [
//            "type": CollVType,
//            "id": id,
//            "date": date1,
//            "day": Day
//        ]
//        
//        
//        showIndicator(withTitle: "", and: "")
//        
//        let loginURL = baseURL.baseURL + appEndPoints.update_meal
//        print(paramsDict, "Params")
//        print(loginURL, "loginURL")
//        
//        if let jsonData = JSONStringEncoder().encode(paramsDict) {
//            
//            WebService.shared.postServiceRaw(loginURL, VC: self, jsonData: jsonData) { (json, statusCode) in
//                self.hideIndicator()
//                
//                guard let dictData = json.dictionaryObject else {
//                    return
//                }
//                
//                let Msg = dictData["message"] as? String ?? ""
//                
//                if dictData["success"] as? Bool == true {
//                    self.showToast(Msg)
//                    
//                    self.Change_cooking_ScheduleBtnO .isUserInteractionEnabled = false
//                    self.Change_cooking_ScheduleBtnO.backgroundColor = UIColor.lightGray
//                }else{
//                    print("Failed to encode JSON.")
//                    self.hideIndicator()
//                    self.showToast(Msg)
//                }
//            }
//        }
//    }
//    
//    func Api_For_AddToPlan() {
//        
//        let dateformatter = DateFormatter()
//        
//        var SerArray = [[String: String]]()
//        
//        let date = self.seldate
//        dateformatter.dateFormat = "yyyy-MM-dd"
//        let Sdate = dateformatter.string(from: date)
//        
//        dateformatter.dateFormat = "EEEE" // Full day name, e.g., "Monday"
//        let dayOfWeek = dateformatter.string(from: date)
//        
//        let dictionary1: [String: String] = ["date": Sdate, "day": dayOfWeek]
//        SerArray.append(dictionary1)
//        
//        
//        print(SerArray)
//        
//        
//        let paramsDict: [String: Any] = [
//            "type": self.CollVType,
//            "uri": self.selItem,
//            "slot": SerArray
//        ]
//        
//        
//        
//        showIndicator(withTitle: "", and: "")
//        
//        let loginURL = baseURL.baseURL + appEndPoints.AddMeal
//        print(paramsDict, "Params")
//        print(loginURL, "loginURL")
//        
//        if let jsonData = JSONStringEncoder().encode(paramsDict) {
//            
//            WebService.shared.postServiceRaw(loginURL, VC: self, jsonData: jsonData) { (json, statusCode) in
//                self.hideIndicator()
//                
//                guard let dictData = json.dictionaryObject else {
//                    return
//                }
//                
//                let Msg = dictData["message"] as? String ?? ""
//                
//                if dictData["success"] as? Bool == true {
//                    self.Change_cooking_ScheduleBtnO .isUserInteractionEnabled = false
//                    self.Change_cooking_ScheduleBtnO.backgroundColor = UIColor.lightGray
//                    self.Api_To_GetAllRecipeByDate()
//                    self.showToast(Msg)
//                } else {
//                    self.showToast(Msg)
//                }
//            }
//        }else{
//            print("Failed to encode JSON.")
//            self.hideIndicator()
//            self.showToast("An error occurred while preparing the request.")
//        }
//    }
//}
