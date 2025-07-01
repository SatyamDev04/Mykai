//
//  ByUrl_IngredientsModelClass.swift
//  My-Kai
//
//  Created by YES IT Labs on 03/02/25.
//

import Foundation

// MARK: - Welcome
struct ByUrl_IngredientsModelClass: Codable {
    var code: Int?
    var data: ByUrl_IngredientsModel?
    var success: Bool?
    var message: String?
}

// MARK: - DataClass
struct ByUrl_IngredientsModel: Codable {
    var url: String?
    var images: Images?
    var cuisineType: [String]?
    var ingredients: [Ingredient]?
    var totalTime: Int?
    var label: String?
    var totalWeight, calories: Double?
    var yield: Double?
    var totalDaily: [String: Total]?
    var healthLabels, ingredientLines: [String]?
    var dietLabels: [String]?
    var digest: [Digest]?
    var image: String?
    var dishType, cautions: [String]?
    var uri: String?
    var instructionLines: [String]?
    var totalNutrients: [String: Total]?
    var mealType: [String]?
    var shareAs: String?
    var source: String?
}

 
