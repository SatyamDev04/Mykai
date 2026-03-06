//
//  Welcome.swift
//  My Kai
//
//  Created by YATIN  KALRA on 09/09/25.
//


struct basketNewModelClass: Codable {
    var success: Bool?
    var code: Int?
    var message: String?
    var data: basketNewModelData?
}


struct basketNewModelData: Codable {
    var recipe: [RecipeNewElement]?
    var billing: BillingNew?
    var stores: [Store]?
    var ingredient: [WelcomeIngredient]?
    
}

// MARK: - Billing
struct BillingNew: Codable {
    let netTotal, recipes, total: Int?

    enum CodingKeys: String, CodingKey {
        case netTotal = "net_total"
        case recipes, total
    }
}

// MARK: - WelcomeIngredient
struct WelcomeIngredient: Codable {
    let schID: Int?
    let proPrice: String?
    let servings: String?
    let foodCategory: String?
    let marketID: Int?
    let foodID: String?
    let image: String?
    let userID: Int?
    let productID, price: String?
    let name: String?
    var quantity: Int?
    let measure: String?
    let createdAt: String?
    let isChecked: Int?
    let proName: String?
    let status: Int?
    var unitOfMeasurement: String?
    let id: Int?
    let deletedAt: String?
    let food: String?
    let proImg: String?
    let updatedAt: String?
    let unitSize: Int?
    var isSelected: Bool? = false
    var isVisible: Bool? = true
    
    enum CodingKeys: String, CodingKey {
        case schID = "sch_id"
        case proPrice = "pro_price"
        case foodCategory
        case marketID = "market_id"
        case foodID = "food_id"
        case image,servings
        case userID = "user_id"
        case productID = "product_id"
        case price, name, quantity, measure
        case createdAt = "created_at"
        case isChecked = "is_checked"
        case proName = "pro_name"
        case status
        case unitOfMeasurement = "unit_of_measurement"
        case id
        case deletedAt = "deleted_at"
        case food
        case proImg = "pro_img"
        case updatedAt = "updated_at"
        case unitSize = "unit_size"
        case isSelected
    }
}

// MARK: - RecipeElement
struct RecipeNewElement: Codable {
    let updatedAt: String?
    let userID: Int?
    let data: DataNewClass?
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

// MARK: - DataClass
struct DataNewClass: Codable {
    let links: Links?
    let recipe: DataRecipe?

    enum CodingKeys: String, CodingKey {
        case links = "_links"
        case recipe
    }
}


// MARK: - DataRecipe
struct DataRecipe: Codable {
    let reviewsCount: Int?
    let mealType: [String]?
    let recipeMealType, id: String?
    let imageURL: String?
    let createdOn, createdAt: String?
    let dishType: [String?]?
    let description: String?
    let totalDaily: TotalNew?
    let fingerprint: String?
    let videoURL: String?
    let preparedWeightG, servings: Int?
    let macros, sourceType: String?
    let dietLabels: [String]?
    let updatedAt, estimatedPrice: String?
    let popularCategory: [String]?
    let ingredients: [RecipeIngredienNew]?
    let image: String?
    let yield, recipeTotalTime: Int?
    let cuisineType: [String]?
    let difficulty: String?
//    let healthLabels: [JSONAny]?
    let instructionLines: [String]?
    let label, keywords: String?
    let totalTime: Int?
    let userID: Int?
    let totalNutrients: Total?
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
    let prepTime: Int?
    let calories: Double?

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

// MARK: - Cookware
//struct Cookware: Codable {
//    let name: String?
//    let imageURL: String?
//    let createdOn, id: String?
//
//    enum CodingKeys: String, CodingKey {
//        case name
//        case imageURL = "image_url"
//        case createdOn = "created_on"
//        case id
//    }
//}

// MARK: - Images
//struct Images: Codable {
//    let thumbnail, small, large, regular: Large?
//
//    enum CodingKeys: String, CodingKey {
//        case thumbnail = "THUMBNAIL"
//        case small = "SMALL"
//        case large = "LARGE"
//        case regular = "REGULAR"
//    }
//}

// MARK: - Large
//struct Large: Codable {
//    let url: String?
//}

// MARK: - RecipeIngredient
struct RecipeIngredienNew: Codable {
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

// MARK: - Instruction
//struct Instruction: Codable {
//    let timerMin: Int?
//    let id, sectionID: String?
//    let createdAt: InstructionCreatedAt?
//    let text: String?
//    let stepOrder: Int?
//    let updatedAt: InstructionUpdatedAt?
//    let createdOn: String?
//
//    enum CodingKeys: String, CodingKey {
//        case timerMin = "timer_min"
//        case id
//        case sectionID = "section_id"
//        case createdAt = "created_at"
//        case text
//        case stepOrder = "step_order"
//        case updatedAt = "updated_at"n m
//        case createdOn = "created_on"
//    }
//}
//
//enum InstructionCreatedAt: String, Codable {
//    case the20250617234005 = "2025-06-17 23:40:05"
//}

enum InstructionUpdatedAt: String, Codable {
    case the20250831190211 = "2025-08-31 19:02:11"
}

// MARK: - Total
struct TotalNew: Codable {
    let procnt, chocdf, enercKcal, fat: Chocdf?

    enum CodingKeys: String, CodingKey {
        case procnt = "PROCNT"
        case chocdf = "CHOCDF"
        case enercKcal = "ENERC_KCAL"
        case fat = "FAT"
    }
}

// MARK: - Chocdf
struct Chocdf: Codable {
    let quantity: Double?
}
