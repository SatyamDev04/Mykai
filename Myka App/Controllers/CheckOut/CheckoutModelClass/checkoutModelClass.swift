//
//  checkoutModelClass.swift
//  My Kai
//
//  Created by YES IT Labs on 23/04/25.
//

import Foundation

struct checkoutModelClass: Codable {
    var success: Bool?
    var code: Int?
    var message: String?
    var data: checkoutModelData?
}

// MARK: - DataClass
struct checkoutModelData: Codable {
    var address: Addresss?
    var note: Note?
    var phone: String?
    var countryCode: String?
    var card: [Card]?
    var estimatedTime, store: String?
    var storeImage: String?
    var ingredient: [IngredientPro]?
    var ingredientCount, recipes: Int?
    var netTotal, tax: Double?
    var delivery: Double?
    var processing, total: Double?
    var offer : String?

    enum CodingKeys: String, CodingKey {
        case address, note, phone, offer
        case countryCode = "country_code"
        case card
        case estimatedTime = "estimated_time"
        case store = "Store"
        case storeImage = "store_image"
        case ingredient
        case ingredientCount = "ingredient_count"
        case recipes
        case netTotal = "net_total"
        case tax, delivery, processing, total
    }
    
    // MARK: - Ingredient
    struct IngredientPro: Codable {
        var createdAt, name, proPrice: String?
        var quantity: Double?
        var id, userID: Int?
        var productID: String?
        var marketID: Int?
        var proID, foodID: String?
        var proImg: String?
        var schID: Int?
        var proName: String?
        var updatedAt: String?
        var deletedAt: String?
        var price: Double?
        var status: Int?

        enum CodingKeys: String, CodingKey {
            case createdAt = "created_at"
            case name
            case proPrice = "pro_price"
            case quantity, id
            case userID = "user_id"
            case productID = "product_id"
            case marketID = "market_id"
            case proID = "pro_id"
            case foodID = "food_id"
            case proImg = "pro_img"
            case schID = "sch_id"
            case proName = "pro_name"
            case updatedAt = "updated_at"
            case deletedAt = "deleted_at"
            case status, price
        }
    }
    
    struct Addresss: Codable {
        var id, userID: Int?
        var latitude, longitude, streetName, streetNum: String?
        var apartNum, city, state, country: String?
        var zipcode, type: String?
        var primary: Int?
        var createdAt, updatedAt: String?
        var deletedAt: String?

        enum CodingKeys: String, CodingKey {
            case id
            case userID = "user_id"
            case latitude, longitude
            case streetName = "street_name"
            case streetNum = "street_num"
            case apartNum = "apart_num"
            case city, state, country, zipcode, type, primary
            case createdAt = "created_at"
            case updatedAt = "updated_at"
            case deletedAt = "deleted_at"
        }
    }
    
    // MARK: - Card
    struct Card: Codable {
        var paymentID, createdAt: String?
        var userID: Int?
        var updatedAt: String?
        var deletedAt: String?
        var type: String?
        var id, cardNum, status: Int?
        var SelCrad: Int?

        enum CodingKeys: String, CodingKey {
            case paymentID = "payment_id"
            case createdAt = "created_at"
            case userID = "user_id"
            case updatedAt = "updated_at"
            case deletedAt = "deleted_at"
            case id
            case cardNum = "card_num"
            case status
            case type
            case SelCrad
        }
    }
    
    struct Note: Codable {
        var pickup, description: String?
        var userID, id: Int?

        enum CodingKeys: String, CodingKey {
            case pickup, description
            case userID = "user_id"
            case id
        }
    }
}
 
 
