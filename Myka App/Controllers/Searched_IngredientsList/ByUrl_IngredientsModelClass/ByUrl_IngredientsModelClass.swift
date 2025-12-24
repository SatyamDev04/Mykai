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

 
struct URLReciepeModel: Codable {
    let success: Bool?
    let code: Int?
    let data: [RecipeDataModelURL]?
    let message: String?
}

// MARK: - Datum
struct RecipeDataModelURL: Codable {
    let recipe: RecipeURL?
}

// MARK: - Recipe
struct RecipeURL: Codable {
    let mealType, sourceType: String?
    let ingredients: [URLIngredient]?
    let totalTime, recipeTotalTime: StringOrNumber?
    let url: String?
    let userID: StringOrNumber?
    let yield: StringOrNumber?
    let image: String?
    let prepTime: Int?
    let source, uri, origin, description: String?
    let videoURL: String?
    let cookware: [URLCookware]?
    let sourceURL: String?
    let instructions: [URLInstruction]?
    let isPublic: Int?
    let label:String
    let servings: StringOrNumber?
    let ratingsAvg: StringOrNumber?
    let createdType:String?
    enum CodingKeys: String, CodingKey {
        case mealType = "meal_type"
        case sourceType = "source_type"
        case ingredients, totalTime
        case recipeTotalTime = "total_time"
        case url,createdType
        case userID = "user_id"
        case yield, image
        case prepTime = "prep_time"
        case source, uri, origin, description
        case videoURL = "video_url"
        case cookware
        case sourceURL = "source_url"
        case instructions
        case isPublic = "is_public"
        case label, servings
        case ratingsAvg = "ratings_avg"
    }
}

// MARK: - Cookware
struct URLCookware: Codable {
    let name: String?
    let image: String?
    let id: String?
}

// MARK: - Ingredient
struct URLIngredient: Codable {
    let name, quantity, measure: String?
    let image: String?
    let orderIndex: Int?
    let measureImperial, id, searchKey, header: String?
    let updatedAt: String?
    let category: String?
    let measurementUnitsImperialID: StringOrNumber?
    let createdOn: String?
    let ingredientCost: String?
    let ingredientID: Int?
    let recipeID, food, text, createdAt: String?
    let imageURL: String?
    let unit: String?

    enum CodingKeys: String, CodingKey {
        case name, quantity, measure, image
        case orderIndex = "order_index"
        case measureImperial = "measure_imperial"
        case id
        case searchKey = "search_key"
        case header
        case updatedAt = "updated_at"
        case category
        case measurementUnitsImperialID = "measurement_units_imperial_id"
        case createdOn = "created_on"
        case ingredientCost = "ingredient_cost"
        case ingredientID = "ingredient_id"
        case recipeID = "recipe_id"
        case food, text
        case createdAt = "created_at"
        case imageURL = "image_url"
        case unit
    }
}

// MARK: - Instruction
struct URLInstruction: Codable {
    let createdAt, sectionID, text, createdOn: String?
    let updatedAt, id, header: String?
    let stepOrder: Int?
    let timerMin: StringOrNumber?

    enum CodingKeys: String, CodingKey {
        case createdAt = "created_at"
        case sectionID = "section_id"
        case text
        case createdOn = "created_on"
        case updatedAt = "updated_at"
        case id, header
        case stepOrder = "step_order"
        case timerMin = "timer_min"
    }
}
