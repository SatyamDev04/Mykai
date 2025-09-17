//
//  RecipeDataModel.swift
//  My Kai
//
//  Created by YATIN  KALRA on 16/09/25.
//


struct RecipeDataModel{
    var hearder:String?
    var ingredients:[IngredientDataModel]?
    var cookware:[CookwareDataModel]?
    var recipe:[StepsDataModel]?
}
struct IngredientDataModel{
    var name:String?
    var quantity:String?
    var unit:String?
}
struct CookwareDataModel{
    var name:String?
}
struct StepsDataModel{
    var instruction:String?
}
