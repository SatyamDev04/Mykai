//
//  SelectedIngredientPayload.swift
//  My Kai
//
//  Created by YATIN  KALRA on 05/01/26.
//

import Foundation

struct SelectedIngredientPayload: Codable {
    let name: String
    let quantity: String
    let unit: String
}

struct IngredientRequestPayload: Codable {
    let ingredients: [SelectedIngredientPayload]
}
