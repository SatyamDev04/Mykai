//
//  CreateRecipeViewModel.swift
//  My Kai
//
//  Created by YATIN  KALRA on 18/09/25.
//

import Foundation
import UIKit
import SwiftyJSON

final class CreateRecipeViewModel {

    // MARK: - Outputs / Bindings
    
    var didReceiveDropDownData: (([IngredientCRData], _ type:String) -> Void)?
    var didReceiveImperialUnits: (([UnitINData]) -> Void)?
    var didReceiveCookBookData: (([FavDropDownModel]) -> Void)?
    var didReceiveError: ((Error?) -> Void)?
    var viewController: UIViewController!
    
    // MARK: - Recipe Data
    private(set) var ingredientsSections: [RecipeDataModel] = [] {
        didSet { onIngredientsChanged?() }
    }
    private(set) var cookwareSections: [RecipeDataModel] = [] {
        didSet { onCookwareChanged?() }
    }
    private(set) var recipeStepsSections: [RecipeDataModel] = [] {
        didSet { onRecipeStepsChanged?() }
    }
   var ingredentDropDownArr = [IngredientCRData] ()
    // Callbacks
    
    var cookwareDropDownArr = [IngredientCRData]()
    var ingredentUnitArr = [UnitINData]()
    var onIngredientsChanged: (() -> Void)?
    var onCookwareChanged: (() -> Void)?
    var onRecipeStepsChanged: (() -> Void)?
    
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
    
    /// Uploads a recipe payload to the API via WebService
    func uploadRecipe(_ payload: RecipePayload, completion: @escaping (JSON, Int) -> Void) {
        let apiURL = baseURL.baseURL + appEndPoints.create_meal // Change this endpoint if needed
        guard let vc = viewController else { return }
        vc.showIndicator(withTitle: "Uploading...", and: "Please wait")
        WebService.shared.uploadModel(apiURL, VC: vc, model: payload) { json, statusCode in
            DispatchQueue.main.async {
                vc.hideIndicator()
                completion(json, statusCode)
            }
        }
    }
    
    // MARK: - Data Mutation
    
    func addIngredient(name: String, quantity: String, unit: String, img: String, header: String) {
        let ingredient = IngredientDataModel(name: name, quantity: quantity, unit: unit, img: img)
        let headerTrimmed = header.trimmingCharacters(in: .whitespacesAndNewlines)
        DispatchQueue.main.async {
            if headerTrimmed.isEmpty {
                let data = RecipeDataModel(hearder: "", ingredients: [ingredient])
                self.ingredientsSections.append(data)
            } else {
                if let idx = self.ingredientsSections.firstIndex(where: { ($0.hearder ?? "").trimmingCharacters(in: .whitespacesAndNewlines).caseInsensitiveCompare(headerTrimmed) == .orderedSame }) {
                    if self.ingredientsSections[idx].ingredients == nil {
                        self.ingredientsSections[idx].ingredients = [ingredient]
                    } else {
                        self.ingredientsSections[idx].ingredients?.append(ingredient)
                    }
                } else {
                    let data = RecipeDataModel(hearder: headerTrimmed, ingredients: [ingredient])
                    self.ingredientsSections.append(data)
                }
            }
        }
    }
    
    func removeIngredient(at indexPath: IndexPath) {
        DispatchQueue.main.async {
            guard indexPath.section < self.ingredientsSections.count else { return }
            var section = self.ingredientsSections[indexPath.section]
            guard var items = section.ingredients, indexPath.row < items.count else { return }
            items.remove(at: indexPath.row)
            section.ingredients = items
            self.ingredientsSections[indexPath.section] = section
            // Remove section if no ingredients left
            if section.ingredients?.isEmpty ?? true {
                self.ingredientsSections.remove(at: indexPath.section)
            }
        }
    }
    
    func clearIngredients() {
        DispatchQueue.main.async {
            self.ingredientsSections.removeAll()
        }
    }
    
    func addCookware(name: String, img: String, header: String){
        let cookware = IngredientDataModel(name: name, unit: "", img: img)
        let headerTrimmed = header.trimmingCharacters(in: .whitespacesAndNewlines)
        DispatchQueue.main.async {
            if headerTrimmed.isEmpty {
                let data = RecipeDataModel(hearder: "", cookware: [cookware])
                self.cookwareSections.append(data)
            } else {
                if let idx = self.cookwareSections.firstIndex(where: { ($0.hearder ?? "").trimmingCharacters(in: .whitespacesAndNewlines).caseInsensitiveCompare(headerTrimmed) == .orderedSame }) {
                    if self.cookwareSections[idx].cookware == nil {
                        self.cookwareSections[idx].cookware = [cookware]
                    } else {
                        self.cookwareSections[idx].cookware?.append(cookware)
                    }
                } else {
                    let data = RecipeDataModel(hearder: headerTrimmed, cookware: [cookware])
                    self.cookwareSections.append(data)
                }
            }
        }
    }
    
    func removeCookware(at indexPath: IndexPath) {
        DispatchQueue.main.async {
            guard indexPath.section < self.cookwareSections.count else { return }
            var section = self.cookwareSections[indexPath.section]
            guard var items = section.cookware, indexPath.row < items.count else { return }
            items.remove(at: indexPath.row)
            section.cookware = items
            self.cookwareSections[indexPath.section] = section
            // Remove section if no cookware left
            if section.cookware?.isEmpty ?? true {
                self.cookwareSections.remove(at: indexPath.section)
            }
        }
    }
    
    func clearCookware() {
        DispatchQueue.main.async {
            self.cookwareSections.removeAll()
        }
    }
    
    func addRecipeStep(instruction: String, header: String) {
        let step = StepsDataModel(instruction: instruction)
        let headerTrimmed = header.trimmingCharacters(in: .whitespacesAndNewlines)
        DispatchQueue.main.async {
            if headerTrimmed.isEmpty {
                let data = RecipeDataModel(hearder: "", recipe: [step])
                self.recipeStepsSections.append(data)
            } else {
                if let idx = self.recipeStepsSections.firstIndex(where: { ($0.hearder ?? "").trimmingCharacters(in: .whitespacesAndNewlines).caseInsensitiveCompare(headerTrimmed) == .orderedSame }) {
                    if self.recipeStepsSections[idx].recipe == nil {
                        self.recipeStepsSections[idx].recipe = [step]
                    } else {
                        self.recipeStepsSections[idx].recipe?.append(step)
                    }
                } else {
                    let data = RecipeDataModel(hearder: headerTrimmed, recipe: [step])
                    self.recipeStepsSections.append(data)
                }
            }
        }
    }
    
    func removeRecipeStep(at indexPath: IndexPath) {
        DispatchQueue.main.async {
            guard indexPath.section < self.recipeStepsSections.count else { return }
            var section = self.recipeStepsSections[indexPath.section]
            guard var steps = section.recipe, indexPath.row < steps.count else { return }
            steps.remove(at: indexPath.row)
            section.recipe = steps
            self.recipeStepsSections[indexPath.section] = section
            // Remove section if no steps left
            if section.recipe?.isEmpty ?? true {
                self.recipeStepsSections.remove(at: indexPath.section)
            }
        }
    }
    
    func clearRecipeSteps() {
        DispatchQueue.main.async {
            self.recipeStepsSections.removeAll()
        }
    }
    
    // MARK: - TableView Helpers

    
    func numberOfSections(for type: RecipeSectionType) -> Int {
        switch type {
        case .ingredient: return ingredientsSections.count
        case .cookware: return cookwareSections.count
        case .recipe: return recipeStepsSections.count
        }
    }
    func numberOfRows(in section: Int, for type: RecipeSectionType) -> Int {
        switch type {
        case .ingredient:
            guard section < ingredientsSections.count else { return 0 }
            return ingredientsSections[section].ingredients?.count ?? 0
        case .cookware:
            guard section < cookwareSections.count else { return 0 }
            return cookwareSections[section].cookware?.count ?? 0
        case .recipe:
            guard section < recipeStepsSections.count else { return 0 }
            return recipeStepsSections[section].recipe?.count ?? 0
        }
    }
    func modelForRow(at indexPath: IndexPath, for type: RecipeSectionType) -> Any? {
        switch type {
        case .ingredient:
            let section = indexPath.section
            let row = indexPath.row
            guard section < ingredientsSections.count, let arr = ingredientsSections[section].ingredients, row < arr.count else { return nil }
            return arr[row]
        case .cookware:
            let section = indexPath.section
            let row = indexPath.row
            guard section < cookwareSections.count, let arr = cookwareSections[section].cookware, row < arr.count else { return nil }
            return arr[row]
        case .recipe:
            let section = indexPath.section
            let row = indexPath.row
            guard section < recipeStepsSections.count, let arr = recipeStepsSections[section].recipe, row < arr.count else { return nil }
            return arr[row]
        }
    }
    
    // MARK: - Image Encoding
    func encodeImageToBase64(_ image: UIImage) -> String? {
        if let imageData = image.jpegData(compressionQuality: 0.8) {
            return imageData.base64EncodedString()
        } else if let imageData = image.pngData() {
            return imageData.base64EncodedString()
        }
        return nil
    }
    
    // MARK: - Added Computed Properties and Methods
    
    // Returns a flat array of ingredient display strings
    func flatIngredients() -> [String] {
        var ingr: [String] = []
        for section in ingredientsSections {
            let headerTrimmed = section.hearder?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            if let ingredients = section.ingredients {
                for ingredient in ingredients {
                    let quantity = ingredient.quantity?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
                    var unit = ingredient.unit?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
                    if unit.isEmpty || unit == "<unit>" { unit = "" }
                    let name = ingredient.name?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
                    var ingredientStr = ""
                    if !quantity.isEmpty { ingredientStr += quantity }
                    if !unit.isEmpty { ingredientStr += (ingredientStr.isEmpty ? "" : " ") + unit }
                    if !name.isEmpty { ingredientStr += (ingredientStr.isEmpty ? "" : " ") + name }
                    if !ingredientStr.isEmpty { ingr.append(ingredientStr) }
                }
            }
        }
        return ingr
    }
    
    // Returns array of ingredient section headers for each ingredient
    func ingredientHeaders() -> [String] {
        var headers: [String] = []
        for section in ingredientsSections {
            let headerTrimmed = section.hearder?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            if let ingredients = section.ingredients {
                for _ in ingredients {
                    if !headerTrimmed.isEmpty {
                        headers.append(headerTrimmed)
                    } else {
                        headers.append("Ingredients")
                    }
                }
            }
        }
        return headers
    }
    
    // Returns a flat array of step instructions
    func flatRecipeSteps() -> [String] {
        var steps: [String] = []
        for section in recipeStepsSections {
            if let arr = section.recipe {
                for recipe in arr {
                    let instruction = recipe.instruction?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
                    if !instruction.isEmpty { steps.append(instruction) }
                }
            }
        }
        return steps
    }
    
    // Returns array of step headers for each step
    func recipeHeaders() -> [String] {
        var headers: [String] = []
        for section in recipeStepsSections {
            let headerTrimmed = section.hearder?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            if let recipes = section.recipe {
                for _ in recipes {
                    if !headerTrimmed.isEmpty {
                        headers.append(headerTrimmed)
                    } else {
                        headers.append("Recipe")
                    }
                }
            }
        }
        return headers
    }
    
    // Returns flat array of cookware names
    func flatCookware() -> [String] {
        var cookware: [String] = []
        for section in cookwareSections {
            if let items = section.cookware {
                for item in items {
                    let name = item.name?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
                    if !name.isEmpty { cookware.append(name) }
                }
            }
        }
        return cookware
    }
    
    // Returns header title for a given section and type
    enum RecipeSectionType { case ingredient, cookware, recipe }
    func headerTitle(for section: Int, in type: RecipeSectionType) -> String? {
        switch type {
        case .ingredient:
            guard section < ingredientsSections.count else { return nil }
            return ingredientsSections[section].hearder?.trimmingCharacters(in: .whitespacesAndNewlines)
        case .cookware:
            guard section < cookwareSections.count else { return nil }
            return cookwareSections[section].hearder?.trimmingCharacters(in: .whitespacesAndNewlines)
        case .recipe:
            guard section < recipeStepsSections.count else { return nil }
            return recipeStepsSections[section].hearder?.trimmingCharacters(in: .whitespacesAndNewlines)
        }
    }
}
