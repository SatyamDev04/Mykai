//
//  SwapModelClass.swift
//  My Kai
//
//  Created by YES IT Labs on 24/04/25.
//

import Foundation

struct SwapModelClass: Codable {
    let code: Int
    let data: SwapModelClassData?
    let message: String?
    let success: Bool?
}

struct SwapModelClassData: Codable {
    let formattedPrice: String?
    let image: String?
    let name: String?
    let productId: String?
    let schId: Int?
    let unitSize: Int?
    let foodId: String?
    
    enum CodingKeys: String, CodingKey {
        case formattedPrice = "formatted_price"
        case image
        case name
        case productId = "product_id"
        case schId = "sch_id"
        case unitSize = "unit_size"
        case foodId = "food_id"
    }
}


//
struct SelIngredientsModelClass: Codable {
    var message: String?
    var code: Int?
    var success: Bool?
    var data: [SelIngredientsModelData]?
}

// MARK: - Datum
struct SelIngredientsModelData: Codable {
    var name, productID: String?
    var schID: Int?
    var foodID: String?
    var image: String?
    var formattedPrice: String?

    enum CodingKeys: String, CodingKey {
        case name
        case productID = "product_id"
        case schID = "sch_id"
        case foodID = "food_id"
        case image
        case formattedPrice = "formatted_price"
    }
}
