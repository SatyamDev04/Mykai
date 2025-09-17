//
//  AddMoreViewModel.swift
//  My Kai
//
//  Created by YATIN  KALRA on 15/09/25.
//


import Foundation
import UIKit

final class AddMoreViewModel {
    // MARK: - Public bindings / callbacks
    var onIngredientsChanged: (() -> Void)?
    var onDislikesChanged: (() -> Void)?
    var onShowLoading: ((_ show: Bool) -> Void)?
    var onShowToast: ((_ message: String) -> Void)?
    var onShowAlert: ((_ title: String?, _ message: String?) -> Void)?
    var vc = UIViewController()
    // For DropDown selection
    var onSelectDislike: ((_ name: String) -> Void)?
    
    // MARK: - Data
    private(set) var ingredient: [Product] = []
    private(set) var dislikesIngredientArr: [ModelClass] = []
    
    // debounce
    private var textChangedWorkItem: DispatchWorkItem?
    private var moreCount: Int = 100
    
    // MARK: - Public helpers
    func numberOfIngredients() -> Int { ingredient.count }
    func ingredientAt(_ index: Int) -> Product { ingredient[index] }
    
    init( vc: UIViewController = UIViewController()) {
        self.vc = vc
      
    }
    
    
    func addCustomIngredient(name: String, schID: Int) {
        let product = Product(
            created_at: "",
            deleted_at: "",
            food_id: "",
            id: nil,
            market_id: "",
            name: "",
            price: nil,
            pro_id: "",
            pro_img: "",
            pro_name: name,
            pro_price: "",
            product_id: "",
            sch_id: schID,
            status: nil,
            unit_size: 0,
            updated_at: "",
            user_id: nil,
            unit_of_measurement: "",
            is_checked: 0
        )
        ingredient.append(product)
        onIngredientsChanged?()
    }
    
    func removeIngredient(at index: Int) {
        guard index >= 0 && index < ingredient.count else { return }
        ingredient.remove(at: index)
        onIngredientsChanged?()
    }
    
    func increaseServCount(at index: Int) {
        guard index >= 0 && index < ingredient.count else { return }
        var servCount = ingredient[index].sch_id ?? 1
        servCount += 1
        ingredient[index].sch_id = servCount
        onIngredientsChanged?()
        
        let foodID = ingredient[index].food_id ?? ""
        if !foodID.isEmpty {
            // If you have API for plus/minus, put call here.
            // Api_To_Plus_Minus_ingredientsCount(FoodID: foodID, Quenty: "\(servCount)")
        }
    }
    
    func decreaseServCount(at index: Int) {
        guard index >= 0 && index < ingredient.count else { return }
        var servCount = ingredient[index].sch_id ?? 1
        guard servCount > 1 else { return }
        servCount -= 1
        ingredient[index].sch_id = servCount
        onIngredientsChanged?()
        
        let foodID = ingredient[index].food_id ?? ""
        if !foodID.isEmpty {
            // If you have API for plus/minus, put call here.
            // Api_To_Plus_Minus_ingredientsCount(FoodID: foodID, Quenty: "\(servCount)")
        }
    }
    
    // MARK: - Debounced search for dislike ingredients
    func debouncedSearchIngredients(query: String) {
        // cancel previous
        textChangedWorkItem?.cancel()
        
        guard !query.isEmpty else {
            dislikesIngredientArr.removeAll()
            onDislikesChanged?()
            return
        }
        
        let workItem = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            self.apiToGetIngredientDislikes(query: query)
        }
        textChangedWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: workItem)
    }
    
    // MARK: - APIs
    private func apiToGetIngredientDislikes(query: String) {
        var params = [String: Any]()
        let type = UserDetail.shared.getUserType()
        if type == "MySelf" {
            params["type"] = "1"
        } else if type == "Partner" {
            params["type"] = "2"
        } else {
            params["type"] = "3"
        }
        
        onShowLoading?(true)
        let loginURL = baseURL.baseURL + appEndPoints.dislikeIngredients + "/\(moreCount)/\(query)"
        
        WebService.shared.getServiceURLEncodingwithParams(loginURL, VC: vc, andParameter: params, withCompletion: { [weak self] (json, statusCode) in
            guard let self = self else { return }
            self.onShowLoading?(false)
            guard let dictData = json.dictionaryObject else { return }
            
            if dictData["success"] as? Bool == true {
                let responseArray = dictData["data"] as? [[String: Any]] ?? [[String: Any]]()
                self.dislikesIngredientArr = ModelClass.getBodyGoalsDetails(responseArray: responseArray)
                self.onDislikesChanged?()
            } else {
                let responseMessage = dictData["message"] as? String ?? "Something went wrong"
                self.onShowToast?(responseMessage)
            }
        })
    }
    
    func apiToSaveIngredients(completion: (() -> Void)? = nil) {
        var params = [String: Any]()
        var foodIds: [String] = []
        var names: [String] = []
        var Status: [String] = []
        var schID: [String] = []
        
        for idx in 0..<self.ingredient.count {
            let ServCount = self.ingredient[idx].sch_id ?? 1
            let name = self.ingredient[idx].pro_name ?? ""
            let foodid = self.ingredient[idx].food_id ?? ""
            
            if foodid.isEmpty {
                let uniqueNumber = generateUniqueFiveDigitNumber()
                foodIds.append("\(uniqueNumber)")
                names.append(name)
                schID.append("\(ServCount)")
                Status.append("3")
            }
        }
        
        params["food_ids"] = foodIds
        params["sch_id"] = schID
        params["names"] = names
        params["status"] = Status
        
        onShowLoading?(true)
        let loginURL = baseURL.baseURL + appEndPoints.add_to_cart
        
        WebService.shared.postServiceURLEncoding(loginURL, VC: vc, andParameter: params, withCompletion: { [weak self] (json, statusCode) in
            guard let self = self else { return }
            self.onShowLoading?(false)
            guard let dictData = json.dictionaryObject else { return }
            
            if dictData["success"] as? Bool == true {
                self.onShowToast?("Saved successfully.")
                completion?()
            } else {
                let responseMessage = dictData["message"] as? String ?? "Something went wrong"
                self.onShowToast?(responseMessage)
            }
        })
    }
    
    // MARK: - Utilities
    func generateUniqueFiveDigitNumber() -> Int {
        return Int.random(in: 10000...99999)
    }
    
    // Expose dislikes names for DropDown
    func dislikesNames() -> [String] {
        dislikesIngredientArr.map { $0.name ?? "" }
    }
    
    func dislikeAt(_ index: Int) -> ModelClass? {
        guard index >= 0 && index < dislikesIngredientArr.count else { return nil }
        return dislikesIngredientArr[index]
    }
}
