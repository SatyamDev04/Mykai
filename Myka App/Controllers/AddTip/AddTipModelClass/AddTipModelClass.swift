//
//  AddTipModelClass.swift
//  My Kai
//
//  Created by YES IT Labs on 25/04/25.
//

import Foundation

struct AddTipModelClass: Codable {
    var message: String?
    var success: Bool?
    var response: ResponseData?
    var code: Int?
}

// MARK: - Response
struct ResponseData: Codable {
    var isSandbox: Bool?
    var trackingLink: String?
    var orderID: String?
    var orderPlaced: Bool?
    var finalQuote: FinalQuote?

    enum CodingKeys: String, CodingKey {
        case isSandbox = "is_sandbox"
        case trackingLink = "tracking_link"
        case orderID = "order_id"
        case orderPlaced = "order_placed"
        case finalQuote = "final_quote"
    }
}

// MARK: - FinalQuote
struct FinalQuote: Codable {
    var storeAddress: String?
    var addedFees: AddedFees?
    var quote: Quote?
    var items: [Item]?
    var tip: Int?
    var store: String?
    var totalWithTip: Double?
    var quoteID, storeID: String?
   // var miscFees: [Any]?

    enum CodingKeys: String, CodingKey {
        case storeAddress = "store_address"
        case addedFees = "added_fees"
        case quote, items, tip, store
        case totalWithTip = "total_with_tip"  
        case quoteID = "quote_id"
        case storeID = "store_id"
       // case miscFees = "misc_fees"
    }
}

// MARK: - AddedFees
struct AddedFees: Codable {
    var isFeeTaxable: Bool?
    var salesTaxCents, flatFeeCents, percentFee, totalFeeCents: Int?

    enum CodingKeys: String, CodingKey {
        case isFeeTaxable = "is_fee_taxable"
        case salesTaxCents = "sales_tax_cents"
        case flatFeeCents = "flat_fee_cents"
        case percentFee = "percent_fee"
        case totalFeeCents = "total_fee_cents"
    }
}

// MARK: - Item
struct Item: Codable {
    var image: String?
    var productID: String?
    var basePrice: Double
    var quantity: Double?
 //   var customizations: [Any]?
    var notes, name: String?

    enum CodingKeys: String, CodingKey {
        case image
        case productID = "product_id"
        case basePrice = "base_price"
        case quantity, notes, name//, customizations
    }
}

// MARK: - Quote
struct Quote: Codable {
    var deliveryTimeMax, deliveryTimeMin: Int?
    var serviceFeeCents, salesTaxCents: Double?
    var deliveryFeeCents: Double?
    var expectedTimeOfArrival: String?
    var subtotal: Double?
    //var scheduled: [Any]?
    var totalWithoutTips, smallOrderFeeCents: Double?

    enum CodingKeys: String, CodingKey {
        case deliveryTimeMax = "delivery_time_max"
        case deliveryTimeMin = "delivery_time_min"
        case serviceFeeCents = "service_fee_cents"
        case salesTaxCents = "sales_tax_cents"
        case deliveryFeeCents = "delivery_fee_cents"
        case expectedTimeOfArrival = "expected_time_of_arrival"
        case subtotal//, scheduled
        case totalWithoutTips = "total_without_tips"
        case smallOrderFeeCents = "small_order_fee_cents"
    }
}
