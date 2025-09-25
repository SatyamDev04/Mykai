//
//  CreateRecipeViewModel.swift
//  My Kai
//
//  Created by YATIN  KALRA on 18/09/25.
//


import Foundation
import UIKit

final class CreateRecipeViewModel {

    // MARK: - Outputs / Bindings
    
    var didReceiveDropDownData: (([IngredientCRData], _ type:String) -> Void)?
    var didReceiveImperialUnits: (([UnitINData]) -> Void)?
    var didReceiveCookBookData: (([FavDropDownModel]) -> Void)?
    var didReceiveError: ((Error?) -> Void)?
    var viewController: UIViewController!
    
    init(viewController:UIViewController){
        self.viewController = viewController
        
    }
    // MARK: - Public API
    
    func fetchDropDown(query: String, type: String) {
        guard !query.isEmpty else { return }
        let loginURL = baseURL.baseURL + appEndPoints.ingredientAndCookware + "/\(query)/\(type)"
        // note: caller may show / hide indicator
        WebService.shared.getServiceURLEncodingwithParams(loginURL, VC: viewController, andParameter: nil, withCompletion: { [weak self] (json, statusCode) in
            guard let self = self else { return }
            let jsonString = "\(json)"
            if let data = jsonString.data(using: .utf8) {
                do {
                    let response = try JSONDecoder().decode(IngredientCRModel.self, from: data)
                    if response.success ?? false {
                        let items = response.data ?? []
                        DispatchQueue.main.async {
                            self.didReceiveDropDownData?(items, type)
                        }
                        return
                    } else {
                        DispatchQueue.main.async {
                            self.didReceiveDropDownData?([], type)
                        }
                    }
                } catch {
                    DispatchQueue.main.async {
                        self.didReceiveError?(error)
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.didReceiveError?(nil)
                }
            }
        })
    }
    /// Fetch imperial units - identical behaviour to original VC implementation
    
    func fetchImperialUnits() {
        let loginURL = baseURL.baseURL + appEndPoints.imperialUnitList
        WebService.shared.getServiceURLEncodingwithParams(loginURL, VC: viewController, andParameter: nil, withCompletion: { [weak self] (json, statusCode) in
            guard let self = self else { return }
            let jsonString = "\(json)"
            if let data = jsonString.data(using: .utf8) {
                do {
                    let response = try JSONDecoder().decode(UnitINModel.self, from: data)
                    if response.success ?? false {
                        let units = response.data ?? []
                        DispatchQueue.main.async {
                            self.didReceiveImperialUnits?(units)
                        }
                        return
                    } else {
                        DispatchQueue.main.async {
                            self.didReceiveImperialUnits?([])
                        }
                    }
                } catch {
                    DispatchQueue.main.async {
                        self.didReceiveError?(error)
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.didReceiveError?(nil)
                }
            }
        })
    }
    
    func Api_To_GetAllCookBooks(){
        let params = [String: Any]()
        guard  let vc = viewController else{return}
        vc.showIndicator(withTitle: "", and: "")
        
        let loginURL = baseURL.baseURL + appEndPoints.get_cook_book
        print(params,"Params")
        print(loginURL,"loginURL")
        
        WebService.shared.postServiceURLEncoding(loginURL, VC: vc, andParameter: params, withCompletion: { (json, statusCode) in
            
            vc.hideIndicator()
           
            let data = try! json.rawData()
            
            do{
                let d = try JSONDecoder().decode(FavDropDownModelClass.self, from: data)
                if d.success == true {
                   
                    if let list = d.data, list.count != 0 {
                        DispatchQueue.main.async {
                            self.didReceiveCookBookData?(d.data ?? [])
                        }
                    }
                   
                }else{
                    let msg = d.message ?? ""
                    vc.showToast(msg)
                }
            }catch{
               
                    DispatchQueue.main.async {
                        self.didReceiveError?(error)
                    }
                
            }
        })
    }
  
     func isValidAmount(_ text: String) -> Bool {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return false }

        // Accept: "1", "1.5", "1/2", "2 1/2", "3/4" etc.
        let pattern = #"^(\d+(\.\d+)?|\d+\s+\d+\/\d+|\d+\/\d+)$"#
        if let _ = trimmed.range(of: pattern, options: .regularExpression) {
            return true
        }
        return false
    }
}
