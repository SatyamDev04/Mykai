//
//  FavDropDownModelClass.swift
//  Myka App
//
//  Created by YES IT Labs on 22/01/25.
//

import Foundation

struct FavDropDownModelClass: Codable {
    var success: Bool?
    var code: Int?
    var message: String?
    var data: [FavDropDownModel]?
}

// MARK: - Datum
struct FavDropDownModel: Codable {
    var id, userID: Int?
    var name, image: String?
    var status: Int?
    var updatedAt, createdAt: String?
    var deletedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case name, image, status
        case updatedAt = "updated_at"
        case createdAt = "created_at"
        case deletedAt = "deleted_at"
    }
}
