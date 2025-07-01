//
//  BasketDetailsModelClass.swift
//  My Kai
//
//  Created by YES IT Labs on 16/04/25.
//

import Foundation

struct BasketDetailsModelClass: Codable {
    let code: Int?
    let data: BasketDetailsModelData?
    let message: String?
    let success: Bool?
}

struct BasketDetailsModelData: Codable {
    var product: [Product]?
    var store: Store?
    var total: String?
}

struct Product: Codable {
    let created_at: String?
       let deleted_at: String?
       let food_id: String?
       let id: Int?
       let market_id: String?
       let name: String?
       let price: Double?
       let pro_id: String?
       let pro_img: String?
       let pro_name: String?
       let pro_price: String?
       let product_id: String?
       var quantity: Double?
       var sch_id: Int?
       let status: Int?
       let updated_at: String?
       let user_id: Int?
}

//struct Store: Codable {
//    let address: Address?
//    let distance: String?
//    let image: String?
//    let operationalHours: String?
//    let storeName: String?
//    let storeUuid: String?
//}
 
