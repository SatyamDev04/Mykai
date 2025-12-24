//
//  RecipeDraftManager.swift
//  My Kai
//  Created by YATIN  KALRA on 17/12/25.
//

import Foundation


final class RecipeDraftManager {

    private static let key = "create_recipe_draft"

    static func save(_ draft: CreateRecipeDraft) {
        if let data = try? JSONEncoder().encode(draft) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }

    static func load() -> CreateRecipeDraft? {
        guard let data = UserDefaults.standard.data(forKey: key) else {
            return nil
        }
        return try? JSONDecoder().decode(CreateRecipeDraft.self, from: data)
    }

    static func clear() {
        UserDefaults.standard.removeObject(forKey: key)
    }
    
    static func hasDraftData() -> Bool {
          guard let draft = load() else { return false }

          return
              !draft.title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
              !draft.description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
              !draft.steps.isEmpty ||
              !draft.ingredients.isEmpty || !draft.ingredients.isEmpty || !draft.cookWareData.isEmpty ||
              draft.imageData != nil
      }
}
