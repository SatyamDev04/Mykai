//
//  PreferencesModelClass.swift
//  Myka App
//
//  Created by YES IT Labs on 02/01/25.
//

import Foundation
struct PreferencesDataModel {
    var title: String
    var isOpen: Bool
    var type: String
}

class PreferencesModelClass: NSObject {
    
    static let shared = PreferencesModelClass()
    private override init() { }
    
    var MyselfListArray: [PreferencesDataModel] = [
        PreferencesDataModel(title: "Body Goals", isOpen: false, type: "Myself"),
        PreferencesDataModel(title: "Dietary Restrictions", isOpen: false, type: "Myself"),
        PreferencesDataModel(title: "Favorite Cuisines", isOpen: false, type: "Myself"),
        PreferencesDataModel(title: "Disliked Ingredient", isOpen: false, type: "Myself"),
        PreferencesDataModel(title: "Allergies", isOpen: false, type: "Myself"),
        PreferencesDataModel(title: "Meal Routine", isOpen: false, type: "Myself"),
        PreferencesDataModel(title: "Cooking Frequency", isOpen: false, type: "Myself"),
        PreferencesDataModel(title: "Spending on Groceries", isOpen: false, type: "Myself"),
        PreferencesDataModel(title: "Eating Out", isOpen: false, type: "Myself"),
        PreferencesDataModel(title: "Reason Take Away", isOpen: false, type: "Myself")
    ]
    
    var PartnersListArray: [PreferencesDataModel] = [
        PreferencesDataModel(title: "Partner Info", isOpen: false, type: "MyPartner"),
        PreferencesDataModel(title: "Body Goals", isOpen: false, type: "MyPartner"),
        PreferencesDataModel(title: "Dietary Restrictions", isOpen: false, type: "MyPartner"),
        PreferencesDataModel(title: "Disliked Ingredient", isOpen: false, type: "MyPartner"),
        PreferencesDataModel(title: "Allergies", isOpen: false, type: "MyPartner"),
        PreferencesDataModel(title: "Favorite Cuisines", isOpen: false, type: "MyPartner"),
        PreferencesDataModel(title: "Meal Prep Days", isOpen: false, type: "MyPartner"),
        PreferencesDataModel(title: "Cooking Frequency", isOpen: false, type: "MyPartner"),
        PreferencesDataModel(title: "Spending on Groceries", isOpen: false, type: "MyPartner"),
        PreferencesDataModel(title: "Eating Out", isOpen: false, type: "MyPartner"),
        PreferencesDataModel(title: "Reason Take Away", isOpen: false, type: "MyPartner")
    ]
    
    var FamilyListArray: [PreferencesDataModel] = [
        PreferencesDataModel(title: "Family Members", isOpen: false, type: "MyFamily"),
        PreferencesDataModel(title: "Body Goals", isOpen: false, type: "MyFamily"),
        PreferencesDataModel(title: "Dietary Restrictions", isOpen: false, type: "MyFamily"),
        PreferencesDataModel(title: "Disliked Ingredient", isOpen: false, type: "MyFamily"),
        PreferencesDataModel(title: "Allergies", isOpen: false, type: "MyFamily"),
        PreferencesDataModel(title: "Favorite Cuisines", isOpen: false, type: "MyFamily"),
        PreferencesDataModel(title: "Family Meal Preferences", isOpen: false, type: "MyFamily"),
        PreferencesDataModel(title: "Cooking Frequency", isOpen: false, type: "MyFamily"),
        PreferencesDataModel(title: "Spending on Groceries", isOpen: false, type: "MyFamily"),
        PreferencesDataModel(title: "Eating Out", isOpen: false, type: "MyFamily"),
        PreferencesDataModel(title: "Reason Take Away", isOpen: false, type: "MyFamily")
    ]
}
