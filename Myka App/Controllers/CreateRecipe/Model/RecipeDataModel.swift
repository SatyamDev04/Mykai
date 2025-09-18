//
//  RecipeDataModel.swift
//  My Kai
//
//  Created by YATIN  KALRA on 16/09/25.
//


struct RecipeDataModel{
    var hearder:String?
    var ingredients:[IngredientDataModel]?
    var cookware:[CookwareDataModel]?
    var recipe:[StepsDataModel]?
}
struct IngredientDataModel{
    var name:String?
    var quantity:String?
    var unit:String?
}
struct CookwareDataModel{
    var name:String?
}
struct StepsDataModel{
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
    let unitName, name: String?

    enum CodingKeys: String, CodingKey {
        case imageURL = "image_url"
        case id
        case unitName = "unit_name"
        case name
    }
}
