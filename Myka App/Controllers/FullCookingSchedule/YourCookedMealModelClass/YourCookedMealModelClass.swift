//
//  YourCookedMealModelClass.swift
//  Myka App
//
//  Created by YES IT Labs on 17/01/25.
//

import Foundation

struct YourCookedMealModelClass: Codable {
    var success: Bool?
    var code: Int?
    var message: String?
    var data: YourCookedMealModel?
}

// MARK: - DataClass
struct YourCookedMealModel: Codable {
    var breakfast: [Lunch]?
    var lunch: [Lunch]?
    var snacks, teatime, dinner: [Lunch]?
    var fridge, freezer: Int?
    var fat, protein, kcal, carbs : Double?
    var is_add: Int?
    var show: Int?
    var date: String?

    enum CodingKeys: String, CodingKey {
        case breakfast = "Breakfast"
        case lunch = "Lunch"
        case snacks = "Snacks"//"Snacks"
        case teatime = "Brunch"
        case dinner = "Dinner"
        case fridge, freezer, fat, protein, kcal, carbs
        case is_add
        case show
        case date
    }
}

// MARK: - Lunch
    struct Lunch: Codable {
        var id, userID: Int?
        var day: String?
        var date: String?
        var uri: String?
        var type: String?
        var planType, servings, status: Int?
        var createdAt, updatedAt: String?
        var deletedAt: String?
        var recipe: Recipe?
        var isLike: Int?
        var createdDate: String?
        var is_missing: Int?
        

        enum CodingKeys: String, CodingKey {
            case id
            case userID = "user_id"
            case day, date, uri, type
            case planType = "plan_type"
            case servings, status
            case createdAt = "created_at"
            case updatedAt = "updated_at"
            case deletedAt = "deleted_at"
            case recipe
            case isLike = "is_like"
            case createdDate = "created_date"
            case is_missing
        }
    }

// MARK: - Recipe
struct Recipe: Codable {
    var uri: String?
    var label: String?
    var image: String?
    var images: Images?
    var source: String?
    var url: String?
    var shareAs: String?
    var yield: Double?
    var dietLabels, healthLabels: [String]?
    var cautions: [String]?
    var ingredientLines: [String]?
    var ingredients: [Ingredient]?
    var calories, totalWeight: Double?
    var totalTime: Int?
    var cuisineType, mealType, dishType: [String]?
    var totalNutrients, totalDaily: [String: Total]?
    var digest: [Digest]?
    var instructionLines: [String]?
}

 
