//
//  YourRecipeModelClass.swift
//  My Kai
//
//  Created by YES IT Labs on 16/04/25.
//

import Foundation

// MARK: - Welcome
struct YourRecipeModelClass: Codable {
    var success: Bool?
    var code: Int?
    var message: String?
    var data: YourRecipeModel?
}

// MARK: - WelcomeData
struct YourRecipeModel: Codable {
    var breakfast: [DinnerList]?
    var dinner, lunch: [DinnerList]?
    var Teatime: [DinnerList]?
    var snacks: [DinnerList]?

    enum CodingKeys: String, CodingKey {
        case breakfast = "Breakfast"
        case dinner = "Dinner"
        case lunch = "Lunch"
        case Teatime = "Brunch"
        case snacks = "Snacks"
    }
}

// MARK: - Dinner
struct DinnerList: Codable {
    var basketID: Int?
    var uri: String?
    var serving: String?
    var data: DinnerData?

    enum CodingKeys: String, CodingKey {
        case basketID = "basket_id"
        case uri, serving, data
    }
}

// MARK: - DinnerData
struct DinnerData: Codable {
    var recipe: Recipe?
    var links: Links?

    enum CodingKeys: String, CodingKey {
        case recipe
        case links = "_links"
    }
}
 
