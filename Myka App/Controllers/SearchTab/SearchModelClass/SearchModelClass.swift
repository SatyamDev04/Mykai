//
//  SearchModelClass.swift
//  Myka App
//
//  Created by YES IT Labs on 27/12/24.
//

import Foundation

struct SearchModelClass: Codable {
    var success: Bool?
    var code: Int?
    var message: String?
    var data: SearchDataClass?
    
    enum CodingKeys: String, CodingKey {
        case data = "data"
        case success = "success"
        case code = "code"
        case message = "message"
    }
}


// MARK: - DataClass
struct SearchDataClass: Codable {
    var recipes: [RecipeElement]?
    var url: String?
}

// MARK: - RecipeElement
struct RecipeElement: Codable {
    var recipe: RecipeRecipe?
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

struct RecipeElement1: Codable {
    let belongs, reviewNumber: Int?
    let review: Double?
    let isLike: Int?
    let links: Links?
    let recipe: RecipeRecipe?

    enum CodingKeys: String, CodingKey {
        case belongs
        case reviewNumber = "review_number"
        case review
        case isLike = "is_like"
        case links = "_links"
        case recipe
    }
}

// MARK: - Links
struct Links: Codable {
    var linksSelf: SelfClass?

    enum CodingKeys: String, CodingKey {
        case linksSelf = "self"
    }
}

// MARK: - SelfClass
struct SelfClass: Codable {
    var href: String?
    var title: Title?
}

enum Title: String, Codable {
    case titleSelf = "Self"
}

// MARK: - RecipeRecipe
struct RecipeRecipe: Codable {
    var uri: String?
    var label: String?
    var image: String?
    var images: Images?
    var source: String?
    var url: String?
    var shareAs: String?
//    var yield: Int?
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
    var dishType: [String]?
    var totalNutrients, totalDaily: [String: Total]?
    var digest: [Digest]?
    var tags: [String]?
    
//    private enum CodingKeys: String, CodingKey {
//        case yield
//    }
// 
//    init(from decoder: Decoder) throws {
//         let container = try decoder.container(keyedBy: CodingKeys.self)
//
//         if let intValue = try? container.decode(Int.self, forKey: .yield) {
//             yield = intValue
//         } else if let doubleValue = try? container.decode(Double.self, forKey: .yield) {
//             yield = Int(doubleValue) // You can also round if needed
//         } else {
//             yield = nil
//         }
//     }
}
 
// MARK: - Digest
struct Digest: Codable {
    var label: String?
    var tag: String?
    var schemaOrgTag: String?
    var total: Double?
    var hasRDI: Bool?
    var daily: Double?
    var unit: String?
    var sub: [Digest]?
}

 

// MARK: - Images
struct Images: Codable {
    var thumbnail, small, regular, large: Large?

    enum CodingKeys: String, CodingKey {
        case thumbnail = "THUMBNAIL"
        case small = "SMALL"
        case regular = "REGULAR"
        case large = "LARGE"
    }
    
    init(from decoder: Decoder) throws {
         let container = try decoder.singleValueContainer()
         if let imageObject = try? container.decode([String: Large].self) {
             thumbnail = imageObject["THUMBNAIL"]
             small = imageObject["SMALL"]
             regular = imageObject["REGULAR"]
             large = imageObject["LARGE"]
         } else {
             thumbnail = nil
             small = nil
             regular = nil
             large = nil
         }
     }
}


// MARK: - Large
struct Large: Codable {
    var url: String?
    var width, height: Int?
}

// MARK: - Ingredient
struct Ingredient: Codable {
    let image: String?
    let unit, createdAt, text, createdOn: String?
    let imageURL: String?
    let header: String?
    let ingredientID: Int?
    let updatedAt, name, quantity: String?
    let orderIndex: Int?
    let ingredientCost, searchKey, id, measureImperial: String?
    let food, recipeID: String?
    let measurementUnitsImperialID: Int?
    let measure, category: String?

    enum CodingKeys: String, CodingKey {
        case image, unit
        case createdAt = "created_at"
        case text
        case createdOn = "created_on"
        case imageURL = "image_url"
        case header
        case ingredientID = "ingredient_id"
        case updatedAt = "updated_at"
        case name, quantity
        case orderIndex = "order_index"
        case ingredientCost = "ingredient_cost"
        case searchKey = "search_key"
        case id
        case measureImperial = "measure_imperial"
        case food
        case recipeID = "recipe_id"
        case measurementUnitsImperialID = "measurement_units_imperial_id"
        case measure, category
    }
}
// MARK: - Total
struct Total: Codable {
    var label: String?
    var quantity: Double?
    var unit: String?
}


// For Search TAb.
struct SearchListModelClass: Codable {
    var success: Bool?
    var code: Int?
    var message: String?
    var data: SearchListModel?
}

// MARK: - DataClass
struct SearchListModel: Codable {
    var ingredient, mealType, category: [Category]?, recipes: [RecipeElement1]?
    var preferenceStatus: Int?

    enum CodingKeys: String, CodingKey {
        case ingredient, mealType, category, recipes
        case preferenceStatus = "preference_status"
    }
}

// MARK: - Category
struct Category: Codable {
    var id: Int?
    var name: String?
    var image: String?
}
