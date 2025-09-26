//
//  RecipeDataModel.swift
//  My Kai
//
//  Created by YATIN  KALRA on 16/09/25.
//


struct RecipeDataModel:Encodable{
    var hearder:String? = ""
    var ingredients:[IngredientDataModel]?
    var cookware:[IngredientDataModel]?
    var recipe:[StepsDataModel]?
}
struct IngredientDataModel:Encodable{
    var name:String?
    var quantity:String?
    var unit:String?
    var img:String? = ""
    var isSelected:Bool?
    var text: String?
    var image: String?
    var food: String?
    var ingredient_cost: String?
    var foodCategory: String?
    var measure: String?
    var id: String?
    var status: Bool?
    var header: String?
}
struct CookwareDataModel:Encodable{
    var name:String?
    var img:String?
}
struct StepsDataModel:Encodable{
    var instruction:String?
}


struct IngredientCRModel: Codable {
    let data: [IngredientCRData]?
    let code: Int?
    let message: String?
    let success: Bool?
}

// MARK: - Datum
struct IngredientCRData: Codable {
    let imageURL: String?
    let id: Int?
    let unitName: String?
    let name: String?

    enum CodingKeys: String, CodingKey {
        case imageURL = "image_url"
        case id
        case unitName = "unit_name"
        case name
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        imageURL = try? container.decode(String.self, forKey: .imageURL)
        unitName = try? container.decode(String.self, forKey: .unitName)
        name = try? container.decode(String.self, forKey: .name)

        // Try Int first
        if let intValue = try? container.decode(Int.self, forKey: .id) {
            id = intValue
        }
        // Then try String
        else if let stringValue = try? container.decode(String.self, forKey: .id),
                let intFromString = Int(stringValue) {
            id = intFromString
        } else {
            id = nil
        }
    }
}
struct UnitINModel: Codable {
    let success: Bool?
    let code: Int?
    let message: String?
    let data: [UnitINData]?
}

// MARK: - Datum
struct UnitINData: Codable {
    let unitType: String?
    let id: Int?
    let toMetricFactor, unitName: String?

    enum CodingKeys: String, CodingKey {
        case unitType = "unit_type"
        case id
        case toMetricFactor = "to_metric_factor"
        case unitName = "unit_name"
    }
}

struct RecipePayload: Codable {
    let summary: String
    let recipe_key: String
    let cook_book: String
    let title: String
    let yield: String
    let prep_time: String
    let cook_time: String
    let is_public: String
    let img: String
    let createdType: String
    let source_url: String
    let ingr: [String]
    let headers: [String]
    let prep: [String]
    let steps_headers: [String]
    let cookware: [String]
}
