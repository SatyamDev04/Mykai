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
    var netTotal, recipes, total: Int

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
    let updatedAt: String?
        let userID: Int?
        let data: RecipeData?
        let id: Int?
        let type, uri: String?
        let createdAt: String?
        var serving: String?
        let deletedAt: String?

        enum CodingKeys: String, CodingKey {
            case updatedAt = "updated_at"
            case userID = "user_id"
            case data, id, type, uri
            case createdAt = "created_at"
            case serving
            case deletedAt = "deleted_at"
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
    let reviewsCount: Int?
        let mealType: [String]?
        let recipeMealType, id: String?
        let imageURL: String?
        let createdOn, createdAt: String?
        let dishType: [String?]?
        let description: String?
        let totalDaily: Total?
        let fingerprint: String?
        let videoURL: String?
        let preparedWeightG, servings: Int?
        let macros, sourceType: String?
        let dietLabels: [String]?
        let updatedAt, estimatedPrice: String?
        let popularCategory: [String]?
        let ingredients: [RecipeIngredient]?
        let image: String?
        let yield, recipeTotalTime: Int?
        let cuisineType: [String]?
        let difficulty: String?
//        let healthLabels: [JSONAny]?
        let instructionLines: [String]?
        let label, keywords: String?
        let totalTime: Int?
        let userID: Int?
        let totalNutrients: Total
        let ratingsAvg: String?
        let images: Images?
        let sourceURL, uri, ingredientCostTotal: String?
        let instructions: [Instruction]?
        let micronutrients: String?
        let ingredientLines: [String]?
        let source: String?
        let imageURLBackup: String?
        let url: String?
        let cookware: [Cookware]?
        let isPublic: Int?
        let cuisine: String?
        let calories, prepTime: Int?

        enum CodingKeys: String, CodingKey {
            case reviewsCount = "reviews_count"
            case mealType
            case recipeMealType = "meal_type"
            case id
            case imageURL = "image_url"
            case createdOn = "created_on"
            case createdAt = "created_at"
            case dishType, description, totalDaily, fingerprint
            case videoURL = "video_url"
            case preparedWeightG = "prepared_weight_g"
            case servings, macros
            case sourceType = "source_type"
            case dietLabels
            case updatedAt = "updated_at"
            case estimatedPrice = "estimated_price"
            case popularCategory, ingredients, image, yield
            case recipeTotalTime = "total_time"
            case cuisineType, difficulty, instructionLines, label, keywords, totalTime
            case userID = "user_id"
            case totalNutrients
            case ratingsAvg = "ratings_avg"
            case images
            case sourceURL = "source_url"
            case uri
            case ingredientCostTotal = "ingredient_cost_total"
            case instructions, micronutrients, ingredientLines, source
            case imageURLBackup = "image_url_backup"
            case url, cookware
            case isPublic = "is_public"
            case cuisine, calories
            case prepTime = "prep_time"
        }
}

// MARK: - Instruction
struct Instruction: Codable {
    let stepsHeaders: String?
    let createdOn, id: String?
    let updatedAt: String?
    let timerMin: Int?
    let text: String?
    let stepOrder: Int?
    let createdAt: String?
    let sectionID: String?

    enum CodingKeys: String, CodingKey {
        case stepsHeaders = "steps_headers"
        case createdOn = "created_on"
        case id
        case updatedAt = "updated_at"
        case timerMin = "timer_min"
        case text
        case stepOrder = "step_order"
        case createdAt = "created_at"
        case sectionID = "section_id"
    }
}

 
// MARK: - RecipeIngredient
struct RecipeIngredient: Codable {
    let ingredientID, measurementUnitsImperialID: Int?
    let category: String?
    let image: String?
    let ingredientCost, name: String?
    let unit: String?
    let searchKey: String?
    let createdAt: String?
    let createdOn, text, quantity: String?
    let imageURL: String?
    let id: String?
    let measure: String?
    let measureImperial, food: String?
    let updatedAt: String?
    let orderIndex: Int?
    let recipeID: String?

    enum CodingKeys: String, CodingKey {
        case ingredientID = "ingredient_id"
        case measurementUnitsImperialID = "measurement_units_imperial_id"
        case category, image
        case ingredientCost = "ingredient_cost"
        case name, unit
        case searchKey = "search_key"
        case createdAt = "created_at"
        case createdOn = "created_on"
        case text, quantity
        case imageURL = "image_url"
        case id, measure
        case measureImperial = "measure_imperial"
        case food
        case updatedAt = "updated_at"
        case orderIndex = "order_index"
        case recipeID = "recipe_id"
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
