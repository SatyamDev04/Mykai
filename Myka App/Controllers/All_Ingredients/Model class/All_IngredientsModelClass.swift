//
//  All_IngredientsModelClass.swift
//  My Kai
//
//  Created by YES IT Labs on 31/03/25.
//

import Foundation

struct All_IngredientsModelClass: Codable {
    var success: Bool?
    var code: Int?
    var message: String?
    var data: All_IngredientsModel?
}

// MARK: - DataClass
struct All_IngredientsModel: Codable {
    var ingredients: [Ingredientt]?
    var categories: [String]?
}

// MARK: - Ingredient
struct Ingredientt: Codable {
    var id: Int?
    var name, food_id, image, category: String?
    var deletedAt, createdAt, updatedAt: String?
    var isselected:Bool? = false
     
    enum CodingKeys: String, CodingKey {
        case id, name, category, image, food_id
        case deletedAt = "deleted_at"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
 
}
