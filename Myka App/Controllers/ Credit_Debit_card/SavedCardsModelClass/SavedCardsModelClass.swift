//
//  SavedCardsModelClass.swift
//  My Kai
//
//  Created by YES IT Labs on 24/04/25.
//

import Foundation

struct SavedCardsModelClass: Codable {
    var code: Int?
    var message: String?
    var success: Bool?
    var data: [SavedCardsModelData]?
}

// MARK: - Datum
struct SavedCardsModelData: Codable {
    var id, cardNum, status: Int?
    var paymentID: String?
    var deletedAt: String?
    var createdAt, updatedAt: String?
    var userID: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case cardNum = "card_num"
        case status
        case paymentID = "payment_id"
        case deletedAt = "deleted_at"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case userID = "user_id"
    }
}
