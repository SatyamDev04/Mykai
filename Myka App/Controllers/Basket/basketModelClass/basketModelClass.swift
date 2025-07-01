//
//  basketModelClass.swift
//  My Kai
//
//  Created by YES IT Labs on 15/04/25.
//

import Foundation

struct basketModelClass: Codable {
    var success: Bool?
    var code: Int?
    var message: String?
    var data: basketModelData?
}

// MARK: - WelcomeData
struct basketModelData: Codable {
    var recipe: [RecipeElementt]?
    var ingredient: [Product]?//[DataIngredient]?
    var billing: Billing?
    var stores: [Store]?
}

// MARK: - Billing
struct Billing: Codable {
    var recipes: Int?
    var netTotal, total: Double?

    enum CodingKeys: String, CodingKey {
        case recipes
        case netTotal = "net_total"
        case total
    }
}

// MARK: - DataIngredient
struct DataIngredient: Codable {
    var id, userID: Int?
    var foodID: String?
    var schID: Int?
    var name: String?
    var productID: String?
    var price: Int?
    var status: Int?
    var marketID: Int?
    var createdAt: String?
    var updatedAt: String?
    var deletedAt: String?
    var proPrice, proName, proID, proImg: String?

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case foodID = "food_id"
        case schID = "sch_id"
        case name
        case productID = "product_id"
        case price, status
        case marketID = "market_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case deletedAt = "deleted_at"
        case proPrice = "pro_price"
        case proName = "pro_name"
        case proID = "pro_id"
        case proImg = "pro_img"
    }
}
 
 

// MARK: - RecipeElement
struct RecipeElementt: Codable {
    var id, userID: Int?
    var uri: String?
    var serving, type, updatedAt, createdAt: String?
    var deletedAt: String?
    var data: RecipeData?

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case uri, serving, type
        case updatedAt = "updated_at"
        case createdAt = "created_at"
        case deletedAt = "deleted_at"
        case data
    }
}

// MARK: - RecipeData
struct RecipeData: Codable {
    var recipe: PurpleRecipe?
    var links: Links?

    enum CodingKeys: String, CodingKey {
        case recipe
        case links = "_links"
    }
}

 

// MARK: - PurpleRecipe
struct PurpleRecipe: Codable {
    var uri: String?
    var label: String?
    var image: String?
    var images: Images?
    var source: String?
    var url: String?
    var shareAs: String?
    var yield: Double?
    var dietLabels, healthLabels, cautions, ingredientLines: [String]?
    var ingredients: [RecipeIngredient]?
    var calories, totalWeight: Double?
    var totalTime: Int?
    var cuisineType, mealType, dishType: [String]?
    var totalNutrients, totalDaily: [String: Total]?
    var digest: [Digest]?
    var instructionLines: [String]?
}

 

 
// MARK: - RecipeIngredient
struct RecipeIngredient: Codable {
    var text: String?
    var quantity: Double?
    var measure, food: String?
    var weight: Double?
    var foodCategory, foodID: String?
    var image: String?

    enum CodingKeys: String, CodingKey {
        case text, quantity, measure, food, weight, foodCategory
        case foodID = "foodId"
        case image
    }
}

 

// MARK: - Store
struct Store: Codable {
    var storeUUID, storeName: String?
    var address: Address?
    var distance: String?
    var operationalHours: OperationalHours?
    var image: String?
    var allItems, missing: Int?
    var total: Double?
    var isSlected: Int?
    var price: Double?
    var isOpen: Bool?

    enum CodingKeys: String, CodingKey {
        case storeUUID = "store_uuid"
        case storeName = "store_name"
        case address
        case isOpen = "is_open"
        case operationalHours = "operational_hours"
        case distance, image
        case allItems = "all_items"
        case missing, total
        case isSlected = "is_slected"
        case price
    }
}
 
struct OperationalHours: Codable {
    let sunday, saturday, thursday, monday: String?
    let tuesday, friday, wednesday: String?

    enum CodingKeys: String, CodingKey {
        case sunday = "Sunday"
        case saturday = "Saturday"
        case thursday = "Thursday"
        case monday = "Monday"
        case tuesday = "Tuesday"
        case friday = "Friday"
        case wednesday = "Wednesday"
    }
}

enum IntOrDouble: Codable {
    case int(Int)
    case double(Double)
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let intValue = try? container.decode(Int.self) {
            self = .int(intValue)
        } else if let doubleValue = try? container.decode(Double.self) {
            self = .double(doubleValue)
        } else {
            throw DecodingError.typeMismatch(IntOrDouble.self, DecodingError.Context(
                codingPath: decoder.codingPath,
                debugDescription: "Value is not an Int or Double"
            ))
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .int(let value):
            try container.encode(value)
        case .double(let value):
            try container.encode(value)
        }
    }
    
    var asDouble: Double {
        switch self {
        case .int(let value):
            return Double(value)
        case .double(let value):
            return value
        }
    }
}
