//
//  StatesForWeekModelClass.swift
//  My Kai
//
//  Created by YES IT Labs on 02/05/25.
//

import Foundation


struct StatesForWeekModelClass: Codable {
    var code: Int?
    var success: Bool?
    var data: StatesForWeekModelData?
    var message: String?
}

// MARK: - DataClass
struct StatesForWeekModelData: Codable {
    var totalPrice: Double?
    var orders: [OrderElement]?
    var recipes: RecipesState?
    var userBudget: Double?
    var month: String?

    enum CodingKeys: String, CodingKey {
        case totalPrice = "total_price"
        case orders, recipes
        case userBudget = "user_budget"
        case month
    }
}

// MARK: - OrderElement
struct OrderElement: Codable {
    var storeLogo: String?
    var address, date: String?
    var order: OrderOrder?
    var status: Int?

    enum CodingKeys: String, CodingKey {
        case storeLogo = "store_logo"
        case address, date, order, status
    }
}

// MARK: - OrderOrder
struct OrderOrder: Codable {
    var orderPlaced: Bool?
    var orderID: String?
    var trackingLink: String?
    var isSandbox: Bool?
    var finalQuote: FinalQuote?

    enum CodingKeys: String, CodingKey {
        case orderPlaced = "order_placed"
        case orderID = "order_id"
        case trackingLink = "tracking_link"
        case isSandbox = "is_sandbox"
        case finalQuote = "final_quote"
    }
}



// MARK: - Recipes
struct RecipesState: Codable {
    var dinner: [BreakfastState]?
    var lunch: [BreakfastState]?
    var lunchPrice: Int?
    var dinnerPrice,BrunchPrice ,SnacksPrice, breakfastPrice: Double?
    var breakfast: [BreakfastState]?
    var Teatime, Snack: [BreakfastState]?
    

    enum CodingKeys: String, CodingKey {
        case dinner = "Dinner"
        case lunch = "Lunch"
        case lunchPrice = "Lunch_price"
        case SnacksPrice = "Snacks_price"
        case BrunchPrice = "Brunch_price"
        case dinnerPrice = "Dinner_price"
        case breakfastPrice = "Breakfast_price"
        case breakfast = "Breakfast"
        case Teatime = "Brunch"
        case Snack = "Snacks"
    }
}

// MARK: - Breakfast
struct BreakfastState: Codable {
    var createdAt: String?
    var isLike, status: Int?
    var deletedAt: String?
    var reviewNumber, servings, id: Int?
    var review: Double?
    var type: String?
    var planType: Int?
    var price: Double?
    var uri: String?
    var updatedAt: String?
    var recipe: Recipe?
    var date, day: String?
    var userID: Int?

    enum CodingKeys: String, CodingKey {
        case createdAt = "created_at"
        case isLike = "is_like"
        case status
        case deletedAt = "deleted_at"
        case reviewNumber = "review_number"
        case servings, id, review, type
        case planType = "plan_type"
        case uri
        case price
        case updatedAt = "updated_at"
        case recipe, date, day
        case userID = "user_id"
    }
}

  

 
