//
//  StateMangerModelClass.swift
//  My Kai
//
//  Created by YES IT Labs on 05/06/25.
//

import Foundation

class StateMangerModelClass {
    static let shared = StateMangerModelClass()
    
    var onboardingSelectedData = OnboardingSelectedDataModelClass()
     
    var ReffCode = ""
    var ProviderName = ""
    var ProviderImg = ""
    var SearchClickFromPopup = false

    // on home Screen
    var tg: String = ""
    var subs: String = ""
    var subscriptionApiTimer: Timer?
//
    
    var isCardAdded:Bool = false
    
    private init() {} // Prevent direct instantiation
    //
}
