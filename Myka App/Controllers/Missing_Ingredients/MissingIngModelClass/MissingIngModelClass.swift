//
//  MissingIngModelClass.swift
//  My-Kai
//
//  Created by YES IT Labs on 31/01/25.
//

import Foundation

struct MissingIngModelClass: Codable {
    var success: Bool?
    var code: Int?
    var message: String?
    var data: [MissingIngModel]?
}

// MARK: - Datum
struct MissingIngModel: Codable {
    var text: String?
    var quantity: Double?
    var measure, food: String?
    var weight: Double?
    var foodCategory, foodID: String?
    var image: String?
    var isMissing: Int?

    enum CodingKeys: String, CodingKey {
        case text, quantity, measure, food, weight, foodCategory
        case foodID = "foodId"
        case image
        case isMissing = "is_missing"
    }
}
