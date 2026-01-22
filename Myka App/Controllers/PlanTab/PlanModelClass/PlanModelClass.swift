//
//  PlanModelClass.swift
//  Myka App
//
//  Created by YES IT Labs on 07/01/25.
//

import Foundation

struct PlanModelClass: Codable {
    var success: Bool?
    var code: Int?
    var message: String?
    var data: PlanDataClass?
    
    enum CodingKeys: String, CodingKey {
        case data = "data"
        case success = "success"
        case code = "code"
        case message = "message"
    }
}

// MARK: - DataClass
struct PlanDataClass: Codable {
    var recipes: Recipes?
    var url: String?
}

// MARK: - Recipes
struct Recipes: Codable {
    var breakfast,Dessert, Teatime, Snack: [Breakfast]?
    var dinner, lunch: [Breakfast]?

    enum CodingKeys: String, CodingKey {
        case breakfast = "Breakfast"
        case dinner = "Dinner"
        case lunch = "Lunch"
        case Teatime = "Brunch"
        case Snack = "Snacks"
        case Dessert = "Dessert"
    }
}

// MARK: - Breakfast
struct Breakfast: Codable {
    var recipe: BreakfastRecipe?
    var links: Links?
    var isLike: Int?
    var review_number : Int?
    var review : Double?

    enum CodingKeys: String, CodingKey {
        case recipe
        case links = "_links"
        case isLike = "is_like"
        case review_number
        case review
    }
}


// MARK: - BreakfastRecipe
struct BreakfastRecipe: Codable {
    var uri: String?
    var label: String?
    var image: String?
    var images: Images?
    var source: String?
    var url: String?
    var shareAs: String?
   // var yield: Int?
    var dietLabels: [String]?
    var healthLabels: [String]?
    var cautions: [String]?
    var ingredientLines: [String]?
    var ingredients: [Ingredient]?
    var calories, glycemicIndex: Double?
    var co2EmissionsClass: String?
    var totalWeight: Double?
    var totalTime: Int?
    var cuisineType, mealType, dishType: [String?]?
    var totalNutrients, totalDaily: [String: Total]?
    var digest: [Digest]?
    var tags: [String]?
}



// MARK: - Dinner
struct Dinner: Codable {
    var recipe: DinnerRecipe?
    var links: Links?
    var isLike: Int?
    var review_number : Int?
    var review : Double?


    enum CodingKeys: String, CodingKey {
        case recipe
        case links = "_links"
        case isLike = "is_like"
        case review_number
        case review
    }
}

// MARK: - DinnerRecipe
struct DinnerRecipe: Codable {
    var uri: String?
    var label: String?
    var image: String?
    var images: Images?
    var source: String?
    var url: String?
    var shareAs: String?
    var yield: Double?
    var dietLabels: [String]?
    var healthLabels: [String]?
    var cautions: [String]?
    var ingredientLines: [String]?
    var ingredients: [Ingredient]?
    var calories, glycemicIndex: Double?
    var co2EmissionsClass: String?
    var totalWeight: Double?
    var totalTime: Int?
    var cuisineType: [String]?
    var mealType: [String]?
    var dishType: [String?]?
    var totalNutrients, totalDaily: [String: Total]?
    var digest: [Digest]?
}

//enum CuisineType: String, Codable {
//    case american = "american"
//    case british = "british"
//    case french = "french"
//    case korean = "korean"
//    case southEastAsian = "south east asian"
//    case world = "world"
//}
//
//enum DishType: String, Codable {
//    case alcoholCocktail = "alcohol cocktail"
//    case drinks = "drinks"
//    case mainCourse = "main course"
//    case sandwiches = "sandwiches"
//    case soup = "soup"
//}
//
//enum MealType: String, Codable {
//    case lunchDinner = "lunch/dinner"
//}

