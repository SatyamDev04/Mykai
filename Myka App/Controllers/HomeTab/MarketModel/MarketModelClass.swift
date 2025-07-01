//
//  MarketModelClass.swift
//  My-Kai
//
//  Created by YES IT Labs on 17/02/25.
//

import Foundation

struct MarketModelClass: Codable {
    var message: String?
    var success: Bool?
    var data: [MarketModel]?
    var code: Int?
}

// MARK: - Datum
struct MarketModel: Codable {
    var distance: String?
    var storeName: String?
    var isSlected, missing: Int?
    var image: String?
    var storeUUID: String?
    var operationalHours: OperationalHours?
    var isOpen: Bool?
    var address: Address?
    var total: Double?

    enum CodingKeys: String, CodingKey {
        case distance
        case storeName = "store_name"
        case isSlected = "is_slected"
        case missing, image
        case operationalHours = "operational_hours"
        case storeUUID = "store_uuid"
        case isOpen = "is_open"
        case address, total
    }
}
 

// MARK: - Address
struct Address: Codable {
    var longitude: Double?
    var state: String?
    var latitude: Double?
    var city, zipcode, streetAddr, streetAddr2: String?
    var country: String?

    enum CodingKeys: String, CodingKey {
        case longitude, state, latitude, city, zipcode
        case streetAddr = "street_addr"
        case streetAddr2 = "street_addr_2"
        case country
    }
}
