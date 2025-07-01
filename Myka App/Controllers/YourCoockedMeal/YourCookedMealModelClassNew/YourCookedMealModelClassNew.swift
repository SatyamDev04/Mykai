//
//  YourCookedMealModelClassNew.swift
//  My Kai
//
//  Created by YES IT Labs on 26/05/25.
//

import Foundation

struct YourCookedMealModelClassNew: Codable {
    var success: Bool?
    var code: Int?
    var message: String?
    var data: YourCookedMealModelNew?
}

// MARK: - DataClass
struct YourCookedMealModelNew: Codable {
    var fridgeData, freezerData: FreezerDataClass?
    var fridge, freezer: Int?
    var fatTotal, proteinTotal, carbsTotal, caloriesTotal: Double?
    var date: String?
    var recommended: Recommended?
    var showUserStats, age: Int?
    var height: Double?
   

    enum CodingKeys: String, CodingKey {
        case fridgeData, freezerData, fridge, freezer 
        case fatTotal = "fat_total"
        case proteinTotal = "protein_total"
        case carbsTotal = "carbs_total"
        case caloriesTotal = "calories_total"
        case date, recommended
        case showUserStats = "show_user_stats"
        case age, height
    }
    
    init(fridgeData: FreezerDataClass? = nil,
          freezerData: FreezerDataClass? = nil,
          fridge: Int? = nil,
          freezer: Int? = nil,
          fatTotal: Double? = nil,
          proteinTotal: Double? = nil,
          carbsTotal: Double? = nil,
          caloriesTotal: Double? = nil,
          date: String? = nil,
          recommended: Recommended? = nil,
          showUserStats: Int? = nil,
          age: Int? = nil,
          height: Double? = nil) {
         self.fridgeData = fridgeData
         self.freezerData = freezerData
         self.fridge = fridge
         self.freezer = freezer
         self.fatTotal = fatTotal
         self.proteinTotal = proteinTotal
         self.carbsTotal = carbsTotal
         self.caloriesTotal = caloriesTotal
         self.date = date
         self.recommended = recommended
         self.showUserStats = showUserStats
         self.age = age
         self.height = height
     }
}

// MARK: - FreezerDataClass
struct FreezerDataClass: Codable {
    var breakfast, teatime: [Lunch]?
    var lunch: [Lunch]?
    var snacks, dinner: [Lunch]?

    enum CodingKeys: String, CodingKey {
        case breakfast = "Breakfast"
        case teatime = "Brunch"
        case lunch = "Lunch"
        case snacks = "Snacks"
        case dinner = "Dinner"
    }
}
 
 
 
struct Recommended: Codable {
    let calories, fat, carbs: Int?
    let protein: String?
}
