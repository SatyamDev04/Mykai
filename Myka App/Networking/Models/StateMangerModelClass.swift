//
//  StateMangerModelClass.swift
//  My Kai
//
//  Created by YES IT Labs on 05/06/25.
//

import Foundation

final class StateMangerModelClass {

    static let shared = StateMangerModelClass()

    // MARK: - Onboarding Draft (AUTO Save & Restore)
    var onboardingSelectedData: OnboardingSelectedDataModelClass {
        didSet {
            OnboardingDraftManager.shared.save(onboardingSelectedData)
        }
    }

    // MARK: - Other Existing Properties
    var ReffCode = ""
    var ProviderName = ""
    var ProviderImg = ""
    var SearchClickFromPopup = false

    // Home Screen
    var tg: String = ""
    var subs: String = ""
    var subscriptionApiTimer: Timer?

    var isCardAdded: Bool = false

    // MARK: - Init
    private init() {
  
        self.onboardingSelectedData = OnboardingDraftManager.shared.load()
    }
}
extension StateMangerModelClass {

    func ensureMySelfDraftExists() {
        if onboardingSelectedData.MySelfSeldata.isEmpty {
            onboardingSelectedData.MySelfSeldata.append(
                MyselfModelClass(
                    bodyGoals: "",
                    DietaryPreferences: [],
                    FavCuisines: [],
                    DislikeIngredient: [],
                    AllergensIngredients: [],
                    MealRoutine: [],
                    CookingFrequency: "",
                    SpendingOnGroceries: SpendingOnGroceriesModelClass(Amount: "", duration: ""),
                    EatingOut: "",
                    Takeway: ""
                )
            )
        }
    }
}
