//
//  FilterModelClass.swift
//  My-Kai
//
//  Created by YES IT Labs on 06/02/25.
//

import Foundation


struct FilterModelClass: Codable {
    var success: Bool?
    var code: Int?
    var message: String?
    var data: FilterModel?
}

// MARK: - DataClass
struct FilterModel: Codable {
    var mealType: [MealType]?
    var diet: [Diet]?
    var cookTime: [CookTime]?
    var dishType: [DishType]?
    var protein: [Diet]?
     

    enum CodingKeys: String, CodingKey {
        case mealType
        case diet = "Diet"
        case cookTime = "cook_time"
        case dishType
        case protein
    }
}

// MARK: - CookTime
struct CookTime: Codable {
    var name, value: String?
}

// MARK: - Diet
struct Diet: Codable {
    var name: String?
    var value: String?
}

// MARK: - MealType
struct MealType: Codable {
    var id: Int?
    var name: String?
    var image: String?
}

struct DishType: Codable {
    var updatedAt: String?
    var id: Int?
    var deletedAt: String?
    var createdAt: String?
    var name: String?

    enum CodingKeys: String, CodingKey {
        case updatedAt = "updated_at"
        case id
        case deletedAt = "deleted_at"
        case createdAt = "created_at"
        case name
    }
}
