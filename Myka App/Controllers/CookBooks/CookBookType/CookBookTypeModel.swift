//
//  CookBookTypeModel.swift
//  Myka
//
//  Created by YATIN  KALRA on 23/01/25.
//

import Foundation

// MARK: - TopLevel
struct CookBookTypeModel: Codable {
    let success: Bool?
    let code: Int?
    let message: String?
    let data: [Datum]?
}

// MARK: - Datum
struct Datum: Codable {
    let id, userID: Int?
    let uri: String?
    let cookBook: Int?
    let updatedAt, createdAt: String?
    let deletedAt: String?
    let data: CookBookTypeData?

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case uri
        case cookBook = "cook_book"
        case updatedAt = "updated_at"
        case createdAt = "created_at"
        case deletedAt = "deleted_at"
        case data
    }
}

// MARK: - DataClass
struct CookBookTypeData: Codable {
    let recipe: Recipe?
    let links: Links?

    enum CodingKeys: String, CodingKey {
        case recipe
        case links = "_links"
    }
}
