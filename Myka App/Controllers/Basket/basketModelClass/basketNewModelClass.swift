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
    var servings: String?
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

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        schID = try container.decodeIfPresent(Int.self, forKey: .schID)
        proPrice = try Self.decodeString(from: container, forKey: .proPrice)
        servings = try Self.decodeString(from: container, forKey: .servings)
        foodCategory = try container.decodeIfPresent(String.self, forKey: .foodCategory)
        marketID = try container.decodeIfPresent(Int.self, forKey: .marketID)
        foodID = try Self.decodeString(from: container, forKey: .foodID)
        image = try container.decodeIfPresent(String.self, forKey: .image)
        userID = try container.decodeIfPresent(Int.self, forKey: .userID)
        productID = try Self.decodeString(from: container, forKey: .productID)
        price = try Self.decodeString(from: container, forKey: .price)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        quantity = try Self.decodeInt(from: container, forKey: .quantity)
        measure = try container.decodeIfPresent(String.self, forKey: .measure)
        createdAt = try container.decodeIfPresent(String.self, forKey: .createdAt)
        isChecked = try container.decodeIfPresent(Int.self, forKey: .isChecked)
        proName = try container.decodeIfPresent(String.self, forKey: .proName)
        status = try container.decodeIfPresent(Int.self, forKey: .status)
        unitOfMeasurement = try Self.decodeString(from: container, forKey: .unitOfMeasurement)
        id = try container.decodeIfPresent(Int.self, forKey: .id)
        deletedAt = try container.decodeIfPresent(String.self, forKey: .deletedAt)
        food = try container.decodeIfPresent(String.self, forKey: .food)
        proImg = try container.decodeIfPresent(String.self, forKey: .proImg)
        updatedAt = try container.decodeIfPresent(String.self, forKey: .updatedAt)
        unitSize = try Self.decodeInt(from: container, forKey: .unitSize)
        isSelected = try container.decodeIfPresent(Bool.self, forKey: .isSelected) ?? false
        isVisible = true
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

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        reviewsCount = try container.decodeIfPresent(Int.self, forKey: .reviewsCount)
        mealType = try container.decodeIfPresent([String].self, forKey: .mealType)
        recipeMealType = try Self.decodeString(from: container, forKey: .recipeMealType)
        id = try Self.decodeString(from: container, forKey: .id)
        imageURL = try container.decodeIfPresent(String.self, forKey: .imageURL)
        createdOn = try container.decodeIfPresent(String.self, forKey: .createdOn)
        createdAt = try container.decodeIfPresent(String.self, forKey: .createdAt)
        dishType = try container.decodeIfPresent([String?].self, forKey: .dishType)
        description = try container.decodeIfPresent(String.self, forKey: .description)
        totalDaily = try container.decodeIfPresent(TotalNew.self, forKey: .totalDaily)
        fingerprint = try container.decodeIfPresent(String.self, forKey: .fingerprint)
        videoURL = try container.decodeIfPresent(String.self, forKey: .videoURL)
        preparedWeightG = try Self.decodeInt(from: container, forKey: .preparedWeightG)
        servings = try Self.decodeInt(from: container, forKey: .servings)
        macros = try container.decodeIfPresent(String.self, forKey: .macros)
        sourceType = try container.decodeIfPresent(String.self, forKey: .sourceType)
        dietLabels = try container.decodeIfPresent([String].self, forKey: .dietLabels)
        updatedAt = try container.decodeIfPresent(String.self, forKey: .updatedAt)
        estimatedPrice = try Self.decodeString(from: container, forKey: .estimatedPrice)
        popularCategory = try container.decodeIfPresent([String].self, forKey: .popularCategory)
        ingredients = try container.decodeIfPresent([RecipeIngredienNew].self, forKey: .ingredients)
        image = try container.decodeIfPresent(String.self, forKey: .image)
        yield = try Self.decodeInt(from: container, forKey: .yield)
        recipeTotalTime = try Self.decodeInt(from: container, forKey: .recipeTotalTime)
        cuisineType = try container.decodeIfPresent([String].self, forKey: .cuisineType)
        difficulty = try container.decodeIfPresent(String.self, forKey: .difficulty)
        instructionLines = try container.decodeIfPresent([String].self, forKey: .instructionLines)
        label = try container.decodeIfPresent(String.self, forKey: .label)
        keywords = try Self.decodeString(from: container, forKey: .keywords)
        totalTime = try Self.decodeInt(from: container, forKey: .totalTime)
        userID = try container.decodeIfPresent(Int.self, forKey: .userID)
        totalNutrients = try container.decodeIfPresent(Total.self, forKey: .totalNutrients)
        ratingsAvg = try Self.decodeString(from: container, forKey: .ratingsAvg)
        images = try container.decodeIfPresent(Images.self, forKey: .images)
        sourceURL = try container.decodeIfPresent(String.self, forKey: .sourceURL)
        uri = try container.decodeIfPresent(String.self, forKey: .uri)
        ingredientCostTotal = try Self.decodeString(from: container, forKey: .ingredientCostTotal)
        instructions = try container.decodeIfPresent([Instruction].self, forKey: .instructions)
        micronutrients = try Self.decodeString(from: container, forKey: .micronutrients)
        ingredientLines = try container.decodeIfPresent([String].self, forKey: .ingredientLines)
        source = try container.decodeIfPresent(String.self, forKey: .source)
        imageURLBackup = try container.decodeIfPresent(String.self, forKey: .imageURLBackup)
        url = try container.decodeIfPresent(String.self, forKey: .url)
        cookware = try container.decodeIfPresent([Cookware].self, forKey: .cookware)
        isPublic = try Self.decodeInt(from: container, forKey: .isPublic)
        cuisine = try container.decodeIfPresent(String.self, forKey: .cuisine)
        prepTime = try Self.decodeInt(from: container, forKey: .prepTime)
        calories = try Self.decodeDouble(from: container, forKey: .calories)
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

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        ingredientID = try container.decodeIfPresent(Int.self, forKey: .ingredientID)
        measurementUnitsImperialID = try Self.decodeInt(from: container, forKey: .measurementUnitsImperialID)
        category = try container.decodeIfPresent(String.self, forKey: .category)
        image = try container.decodeIfPresent(String.self, forKey: .image)
        ingredientCost = try Self.decodeString(from: container, forKey: .ingredientCost)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        unit = try Self.decodeString(from: container, forKey: .unit)
        searchKey = try container.decodeIfPresent(String.self, forKey: .searchKey)
        createdAt = try container.decodeIfPresent(String.self, forKey: .createdAt)
        createdOn = try container.decodeIfPresent(String.self, forKey: .createdOn)
        text = try container.decodeIfPresent(String.self, forKey: .text)
        quantity = try Self.decodeString(from: container, forKey: .quantity)
        imageURL = try container.decodeIfPresent(String.self, forKey: .imageURL)
        id = try Self.decodeString(from: container, forKey: .id)
        measure = try Self.decodeString(from: container, forKey: .measure)
        measureImperial = try Self.decodeString(from: container, forKey: .measureImperial)
        food = try container.decodeIfPresent(String.self, forKey: .food)
        updatedAt = try container.decodeIfPresent(String.self, forKey: .updatedAt)
        orderIndex = try container.decodeIfPresent(Int.self, forKey: .orderIndex)
        recipeID = try Self.decodeString(from: container, forKey: .recipeID)
    }
}

private extension Decodable {
    static func decodeString<K: CodingKey>(from container: KeyedDecodingContainer<K>, forKey key: K) throws -> String? {
        if let stringValue = try? container.decodeIfPresent(String.self, forKey: key) {
            return stringValue
        }
        if let mixedValue = try? container.decodeIfPresent(StringOrNumber.self, forKey: key) {
            return mixedValue.stringValue()
        }
        return nil
    }

    static func decodeInt<K: CodingKey>(from container: KeyedDecodingContainer<K>, forKey key: K) throws -> Int? {
        if let intValue = try? container.decodeIfPresent(Int.self, forKey: key) {
            return intValue
        }
        if let mixedValue = try? container.decodeIfPresent(StringOrNumber.self, forKey: key) {
            return Int(mixedValue.stringValue() ?? "")
        }
        return nil
    }

    static func decodeDouble<K: CodingKey>(from container: KeyedDecodingContainer<K>, forKey key: K) throws -> Double? {
        if let doubleValue = try? container.decodeIfPresent(Double.self, forKey: key) {
            return doubleValue
        }
        if let intValue = try? container.decodeIfPresent(Int.self, forKey: key) {
            return Double(intValue ?? 0)
        }
        if let mixedValue = try? container.decodeIfPresent(StringOrNumber.self, forKey: key) {
            return Double(mixedValue.stringValue() ?? "")
        }
        return nil
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
