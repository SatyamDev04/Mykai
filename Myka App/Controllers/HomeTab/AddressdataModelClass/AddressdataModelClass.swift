//
//  AddressdataModelClass.swift
//  My Kai
//
//  Created by YES IT Labs on 05/06/25.
//

import Foundation

/* Structure for Address data*/
struct AddressdataModelClass: Codable {
    var code: Int?
    var data: [AddressdataModel]?
    var success: Bool?
    var message: String?
}

struct AddressdataModel: Codable {
    var city: String?
    var userID: Int?
    var longitude, latitude: String?
    var id, primary: Int?
    var state, updatedAt, apartNum, country: String?
    var streetNum: String?
    var deletedAt: String?
    var type, zipcode, createdAt, streetName: String?

    enum CodingKeys: String, CodingKey {
        case city
        case userID = "user_id"
        case longitude, latitude, id, primary, state
        case updatedAt = "updated_at"
        case apartNum = "apart_num"
        case country
        case streetNum = "street_num"
        case deletedAt = "deleted_at"
        case type, zipcode
        case createdAt = "created_at"
        case streetName = "street_name"
    }
}
