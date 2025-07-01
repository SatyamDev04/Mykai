//
//  CreateRecipeModelClass.swift
//  My-Kai
//
//  Created by YES IT Labs on 28/01/25.
//

import Foundation

struct CreateRecipeModelClass: Codable {
    var success: Bool?
    var code: Int?
    var message: String?
    var data: [CreateRecipeModel]?
}

// MARK: - Datum
struct CreateRecipeModel: Codable {
    var recipe: Recipe?
    var links: Links?
    var belongs: Int?

    enum CodingKeys: String, CodingKey {
        case recipe
        case links = "_links"
        case belongs
    }
}
