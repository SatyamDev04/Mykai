//
//  CreateRecipeDraft.swift
//  My Kai
//
//  Created by YATIN  KALRA on 17/12/25.
//

import Foundation

struct CreateRecipeDraft: Codable {
    
    var title: String
    var prepTime: String
    var cookTime: String
    var description: String
    var isPublic: Bool
    var selectedCookBook: String?
    var selectedCookBookId: String?
    var servings: String
    var ingredients: [RecipeDataModel]
    var steps: [RecipeDataModel]
    var cookWareData: [RecipeDataModel]
    var imageData: Data?
    var savedFrom: String?
    
}
