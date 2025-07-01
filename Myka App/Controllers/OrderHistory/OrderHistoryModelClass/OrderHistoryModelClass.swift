//
//  OrderHistoryModelClass.swift
//  My Kai
//
//  Created by YES IT Labs on 29/04/25.
//

import Foundation

struct OrderHistoryModelClass: Codable {
    var success: Bool?
    var code: Int?
    var message: String?
    var data: [OrderHistoryModelData]?
    var history_status: Int?
}

// MARK: - Datum
struct OrderHistoryModelData: Codable {
    var order: Order?
    var storeLogo: String?
    var date: String?
    var card: Card?
    var address: String?
    var status: Int?

    enum CodingKeys: String, CodingKey {
        case order
        case storeLogo = "store_logo"
        case card, date, address, status
    }
}

// MARK: - Card
struct Card: Codable {
    let cardType, cardBrand, cardNo, name: String?

    enum CodingKeys: String, CodingKey {
        case cardType = "card_type"
        case cardBrand = "card_brand"
        case cardNo = "card_no"
        case name
    }
}

// MARK: - Order
struct Order: Codable {
    var orderPlaced: Bool?
    var trackingLink: String?
    var finalQuote: FinalQuote?
    var orderID: String?
    var isSandbox: Bool?

    enum CodingKeys: String, CodingKey {
        case orderPlaced = "order_placed"
        case trackingLink = "tracking_link"
        case finalQuote = "final_quote"
        case orderID = "order_id"
        case isSandbox = "is_sandbox"
    }
}
 
