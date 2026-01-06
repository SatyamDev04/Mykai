//
//  OnboardingDraftManager.swift
//  My Kai
//
//  Created by YATIN  KALRA on 29/12/25.
//

import Foundation


final class OnboardingDraftManager {

    static let shared = OnboardingDraftManager()
    private init() {}

    private let key = "onboarding_draft_key"

    func save(_ data: OnboardingSelectedDataModelClass) {
        if let encoded = try? JSONEncoder().encode(data) {
            UserDefaults.standard.set(encoded, forKey: key)
        }
    }

    func load() -> OnboardingSelectedDataModelClass {
        guard
            let data = UserDefaults.standard.data(forKey: key),
            let decoded = try? JSONDecoder().decode(OnboardingSelectedDataModelClass.self, from: data)
        else {
            return OnboardingSelectedDataModelClass()
        }
        return decoded
    }

    func clear() {
        UserDefaults.standard.removeObject(forKey: key)
    }
}
