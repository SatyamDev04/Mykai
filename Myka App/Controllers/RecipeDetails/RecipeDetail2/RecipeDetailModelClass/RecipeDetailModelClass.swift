//
//  RecipeDetailModelClass.swift
//  Myka App
//  Created by YES IT Labs on 16/01/25.

import Foundation

// MARK:
struct RecipeDetailModelClass: Codable {
    var success: Bool?
    var code: Int?
    var message: String?
    var data: [RecipeDetailModel]?
}

// MARK: - Datum
struct RecipeDetailModel: Codable {
    var recipe: RecipeDetail?
    var links: Links?
    var isLike: Int?
    var review: Double?
    var review_number: Int?
    var servings:StringOrNumber?
    
    enum CodingKeys: String, CodingKey {
        case recipe,servings
        case links = "_links"
        case isLike = "is_like"
        case review = "review"
        case review_number = "review_number"
    }
}
  
// MARK: - Recipe
struct RecipeDetail: Codable {
    var uri: String?
    var label: String?
    var image: String?
    var images: Images?
    var source: String?
    var description: String?
    var url, shareAs: String?
    var yield: Double?
    var dietLabels, healthLabels, cautions, ingredientLines: [String]? 
    var ingredients: [Ingredient]?
    var cookware: [Cookware]?
    let instructions: [Instruction]?
    var calories, totalWeight: Double?
    var totalTime: Int?
    var prep_time: Int?
    var cuisineType, mealType: [String]?
    var dishType: [String?]?
    var totalNutrients, totalDaily: [String: Total]?
    var digest: [Digest]?
//  var instructionLines: [String?]?
    var createdType: String?
    var source_url: String?
    var servings:StringOrNumber?
}

// MARK: - Cookware
struct Cookware: Codable {
    let id: String?
    let imageURL: String?
    let name, createdOn: String?

    enum CodingKeys: String, CodingKey {
        case id
        case imageURL = "image_url"
        case name
        case createdOn = "created_on"
    }
}

// MARK: - Regular
struct Regular: Codable {
    var url: String?
    var width, height: Int?
}
