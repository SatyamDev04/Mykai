//
//  HealthSuggestedModelClass.swift
//  My Kai
//
//  Created by YES IT Labs on 11/06/25.
//

import Foundation

struct HealthSuggestedModelClass: Codable {
    let data: HealthSuggestedData?
    let code: Int?
    let message: String?
    let success: Bool?
}

// MARK: - DataClass
struct HealthSuggestedData: Codable {
    var dataPerWeek: [DataPerWeek]?
    var dob: String?
    var macro_options: String?
    var disclaimer: String?
    var profileImg: String?
    var time: Int?
    var valuePerWeek: Double?
    var activityLevel: String?
    var protein, fat, carbs: Int?
    var bio,typeStatus,old_macro: String?
    var name, weightType, gender, email: String?
    var macroPer: MacroPer?
    var startDate: String?
    var macros, height, targetWeight, target: String?
    var heightProtein: String?
    var weight: String?
    var targetWeightType, heightType: String?
    var calories: Int?
    var isCaloriesSliderMoves:Bool? = false
    var isfatSliderMoves:Bool? = false
    var isCarbSliderMoves:Bool? = false
    var isProtienliderMoves:Bool? = false
    var iscarbFatProtienMoves:Bool? = false
        enum CodingKeys: String, CodingKey {
            case dataPerWeek = "data_per_week"
            case dob, macro_options, disclaimer
            case profileImg = "profile_img"
            case valuePerWeek = "value_per_week"
            case time
            case activityLevel = "activity_level"
            case fat, carbs, bio, name
            case weightType = "weight_type"
            case gender, email
            case macroPer = "macro_per"
            case startDate = "start_date"
            case macros, height
            case targetWeight = "target_weight"
            case target
            case heightProtein = "height_protein"
            case weight
            case targetWeightType = "target_weight_type"
            case heightType = "height_type"
            case protein, calories,typeStatus,old_macro,isCaloriesSliderMoves,isfatSliderMoves,isCarbSliderMoves,isProtienliderMoves
        }
    }

struct DataPerWeek: Codable {
    var days: Double?
    var description, name: String?
    var value: Double?
    var isSelected: Int?

    enum CodingKeys: String, CodingKey {
        case days, description, name, value
        case isSelected = "is_selected"
    }
}


    // MARK: - MacroPer
    struct MacroPer: Codable {
        var protein, fat, carbs: Int?
    }
