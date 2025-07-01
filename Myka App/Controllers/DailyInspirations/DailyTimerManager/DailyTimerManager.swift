//
//  DailyTimerManager.swift
//  My-Kai
//
//  Created by YES IT Labs on 17/02/25.
//

import Foundation
import UIKit

class DailyTimerManager {
    static let shared = DailyTimerManager()
    
    private var timer: DispatchSourceTimer?
    private let lastShownKey = "lastShownDailyInspirations"
    
    private init() {}
    
    func startTimer() {
        // If the timer is already running, do nothing
        if timer != nil { return }
        
        // Create a timer
        timer = DispatchSource.makeTimerSource(queue: DispatchQueue.global())
        
        // Schedule the timer to fire every minute
        timer?.schedule(deadline: .now(), repeating: .seconds(60))
        
        timer?.setEventHandler { [weak self] in
            self?.checkAndShowDailyInspirations()
        }
        
        // Start the timer
        timer?.resume()
    }
    
    func stopTimer() {
        timer?.cancel()
        timer = nil
    }
    
    private func checkAndShowDailyInspirations() {
        let currentDate = Date()
        let lastShownDate = UserDefaults.standard.object(forKey: lastShownKey) as? Date
        
        // Check if 24 hours have passed
        if let lastShownDate = lastShownDate {
            let timeInterval = currentDate.timeIntervalSince(lastShownDate)
            let hoursPassed = timeInterval / 3600
            if hoursPassed < 24 {
                return // Do nothing if less than 24 hours
            }
        }
        
        // Save the current date as the last shown date
        UserDefaults.standard.set(currentDate, forKey: lastShownKey)
        
        // Present the DailyInspirationsVC
        DispatchQueue.main.async {
            self.presentDailyInspirationsVC()
        }
    }
    
    private func presentDailyInspirationsVC() {
        guard let topController = UIApplication.topViewController() else { return }
        
        guard UserDetail.shared.getLoginSession() == true else { return }
        
        let storyboard = UIStoryboard(name: "Tabbar", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "DailyInspirationsVC") as? DailyInspirationsVC {
            topController.addChild(vc)
            vc.view.frame = topController.view.frame
            topController.view.addSubview(vc.view)
            topController.view.bringSubviewToFront(vc.view)
            vc.didMove(toParent: topController)
        }
    }
}

