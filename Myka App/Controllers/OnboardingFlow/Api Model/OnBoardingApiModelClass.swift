//
//  OnBoardingApiModelClass.swift
//  Myka App
//
//  Created by YES IT Labs on 24/12/24.
//

import Foundation
  
struct OnboardingSelectedDataModelClass: Codable {
    var Username: String = ""
    var UserGender: String = ""
    var Cookingfortype: String = ""
    var MySelfSeldata = [MyselfModelClass]()
    var Partnersname = PartnersnameModelClass()
    var FamilyMembername = FamilyMemberDetailModelClass()
}

struct MyselfModelClass: Codable {
    var bodyGoals: String = ""
    var DietaryPreferences = [String]()
    var FavCuisines = [String]()
    var DislikeIngredient = [String]()
    var AllergensIngredients = [String]()
    var MealRoutine = [String]()
    var CookingFrequency: String = ""
    var SpendingOnGroceries = SpendingOnGroceriesModelClass()
    var EatingOut: String = ""
    var Takeway: String = ""
    var addOtherTxt: String = ""
}

struct PartnersnameModelClass: Codable {
    var Name: String = ""
    var Age: String = ""
    var Gender: String = ""
}

struct FamilyMemberDetailModelClass: Codable {
    var Name: String = ""
    var Age: String = ""
    var ChildFriendlyMeals: Bool = false
}

struct SpendingOnGroceriesModelClass: Codable {
    var Amount: String = ""
    var duration: String = ""
}

