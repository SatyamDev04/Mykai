//
//  ShoppingListResponse.swift
//  My Kai
//
//  Created by YATIN  KALRA on 16/09/25.
//


//
// ShoppingListModels.swift
// Myka App
//
// Created by assistant refactor
//

import Foundation

// MARK: - Models

struct ShoppingListResponse: Codable {
    var recipe: [RecipeItem]?
    var ingredient: [IngredientItem]?
}

struct RecipeItem: Codable {
    var id: String?
    var food_id: String?
    var name: String?
    var quantity: String?
    var serving: String?    // stored as string in original
    var is_checked: Int?    // 0 or 1
    var image: String?
}

struct IngredientItem: Codable {
    var id: String?
    var food_id: String?
    var name: String?
    var quantity: String?
    var sch_id: Int?        // used as count in original code
    var is_checked: Int?    // 0 or 1
    var image: String?
}

// MARK: - Utilities

extension Array {
    /// Stable sort: preserves original order for equal elements
    func stableSorted(by areInIncreasingOrder: (Element, Element) -> Bool) -> [Element] {
        return self.enumerated()
            .sorted { lhs, rhs in
                if areInIncreasingOrder(lhs.element, rhs.element) { return true }
                if areInIncreasingOrder(rhs.element, lhs.element) { return false }
                return lhs.offset < rhs.offset
            }
            .map { $0.element }
    }
}