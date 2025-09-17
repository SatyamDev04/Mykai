//
//  ShoppingListViewModel.swift
//  Myka App
//
//  Created by Assistant on 16/09/25.
//

import Foundation
import UIKit

final class ShoppingListViewModel {

    // MARK: - Data
    private(set) var shoppingList: basketModelData? {
        didSet { onUpdate?() }
    }

    // MARK: - Bindings
    var onUpdate: (() -> Void)?
    var onLoading: ((_ loading: Bool) -> Void)?
    var onError: ((_ message: String) -> Void)?
    var onToast: ((_ message: String) -> Void)?

    // MARK: - Public helpers
    var recipesCount: Int { shoppingList?.recipe?.count ?? 0 }
    var ingredientsCount: Int { shoppingList?.ingredient?.count ?? 0 }
    var vc = UIViewController()
    func recipe(at index: Int) -> RecipeElementt? {
        return shoppingList?.recipe?[index]
    }

    func ingredient(at index: Int) -> Product? {
        return shoppingList?.ingredient?[index]
    }
    init(vc:UIViewController){
        self.vc = vc
    }
    // MARK: - Load
    func loadShoppingList() {
        let params: JSONDictionary = [:]
        onLoading?(true)

        let loginURL = baseURL.baseURL + appEndPoints.shopping_list

        WebService.shared.postServiceURLEncoding(loginURL, VC: vc, andParameter: params, withCompletion: { [weak self] (json, statusCode) in
            guard let self = self else { return }
            self.onLoading?(false)

            do {
                let data = try json.rawData()
                let d = try JSONDecoder().decode(basketModelClass.self, from: data)
                if d.success == true {
                    var allData = d.data ?? basketModelData()
                    // stable sort ingredients so unchecked come first
                    if !(allData.ingredient?.isEmpty ?? true) {
                        allData.ingredient = allData.ingredient?.stableSorted { $0.is_checked < $1.is_checked }
                    }
                    
                    
                    
                    
                    
                    
                    
                    self.shoppingList = allData
                } else {
                    let msg = d.message ?? "Something went wrong"
                    self.onToast?(msg)
                }
            } catch {
                self.onError?(error.localizedDescription)
            }
        })
    }

    // MARK: - Recipe plus/minus serves
    func updateRecipeServes(uri: String, quantity: String) {
        var params: JSONDictionary = [:]
        params["uri"] = uri
        params["quantity"] = quantity

        onLoading?(true)
        let loginURL = baseURL.baseURL + appEndPoints.add_to_basket

        WebService.shared.postServiceURLEncoding(loginURL, VC: vc, andParameter: params, withCompletion: { [weak self] (json, statusCode) in
            guard let self = self else { return }
            self.onLoading?(false)
            guard let dictData = json.dictionaryObject else { return }
            if dictData["success"] as? Bool == true {
                // optionally refresh, but original didn't call refresh here
            } else {
                let responseMessage = dictData["message"] as? String ?? "Something went wrong"
                self.onToast?(responseMessage)
            }
        })
    }

    // MARK: - Remove recipe
    func removeRecipe(id: String) {
        var params: JSONDictionary = [:]
        params["id"] = id

        onLoading?(true)
        let loginURL = baseURL.baseURL + appEndPoints.remove_basket

        WebService.shared.postServiceURLEncoding(loginURL, VC: vc, andParameter: params, withCompletion: { [weak self] (json, statusCode) in
            guard let self = self else { return }
            self.onLoading?(false)
            guard let dictData = json.dictionaryObject else { return }
            if dictData["success"] as? Bool == true {
                // no auto refresh — mirror your old behavior
            } else {
                let responseMessage = dictData["message"] as? String ?? "Something went wrong"
                self.onToast?(responseMessage)
            }
        })
    }

    // MARK: - Ingredient count change / remove
    func changeIngredientCount(foodID: String, quantity: String) {
        var params: JSONDictionary = [:]
        params["food_id"] = foodID
        params["quantity"] = quantity

        onLoading?(true)
        let loginURL = baseURL.baseURL + appEndPoints.change_cart

        WebService.shared.postServiceURLEncoding(loginURL, VC: vc, andParameter: params, withCompletion: { [weak self] (json, statusCode) in
            guard let self = self else { return }
            self.onLoading?(false)
            guard let dictData = json.dictionaryObject else { return }
            if dictData["success"] as? Bool == true {
                // no auto refresh per original
            } else {
                let responseMessage = dictData["message"] as? String ?? "Something went wrong"
                self.onToast?(responseMessage)
            }
        })
    }

    // MARK: - Local mutations (update model & notify VC)
    func toggleIngredientChecked(at index: Int) {
        guard index >= 0, index < (shoppingList?.ingredient?.count ?? 0) else { return }
        if shoppingList?.ingredient?[index].is_checked == 0 {
            shoppingList?.ingredient?[index].is_checked = 1
        } else {
            shoppingList?.ingredient?[index].is_checked = 0
        }
        // trigger onUpdate via didSet
    }

    func setIngredientSchID(at index: Int, schID: Int) {
        guard index >= 0, index < (shoppingList?.ingredient?.count ?? 0) else { return }
        shoppingList?.ingredient?[index].sch_id = schID
    }

    func removeIngredient(at index: Int) {
        guard index >= 0, index < (shoppingList?.ingredient?.count ?? 0) else { return }
        shoppingList?.ingredient?.remove(at: index)
    }

    func appendManualItem(name: String, count: Int) {
        // Append a new Product (mirrors original code)
        let newProduct = Product(created_at: "",
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
                                 sch_id: count,
                                 status: nil,
                                 unit_size: 0,
                                 updated_at: "",
                                 user_id: nil,
                                 unit_of_measurement: "",
                                 is_checked: 0)
        if shoppingList?.ingredient == nil {
            shoppingList?.ingredient = [Product]()
        }
        shoppingList?.ingredient?.append(newProduct)
    }
}
