//
//  InvitationsModelClass.swift
//  My Kai
//
//  Created by YES IT Labs on 01/05/25.
//

import Foundation

struct InvitationModelClass: Codable {
    var success: Bool?
    var code: Int?
    var message: String?
    var data: [InvitationModel]?
}

// MARK: - Datum
struct InvitationModel: Codable {
    var stage, name, createdAt, email: String?
    var status: String?
    var id: Int?

    enum CodingKeys: String, CodingKey {
        case name
        case createdAt = "created_at"
        case email, status, id
    }
}
